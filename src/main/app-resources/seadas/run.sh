#!/bin/bash

# source the ciop functions (e.g. ciop-log)
source ${ciop_job_include}
export LC_ALL="en_US.UTF-8"

# define the exit codes
SUCCESS=0
ERR_NOINPUT=5
ERR_SEADAS=10
ERR_PCONVERT=20
ERR_TAR=30
ERR_JAVAVERSION=15

# add a trap to exit gracefully
function cleanExit ()
{
  local retval=$?
  local msg=""
  case "${retval}" in
    ${SUCCESS})   msg="Processing successfully concluded";;
    ${ERR_NOINPUT})  msg="Input not retrieved to local node";;
    ${ERR_SEADAS})  msg="seaDAS l2gen returned an error";;
    ${ERR_PCONVERT})  msg="Conversion to BEAM-DIMAP failed";;
    ${ERR_TAR})  msg="Compression of BEAM-DIMAP failed";;
    ${ERR_JAVAVERSION}) msg="The version of the JVM must be at least 1.7";;
    *)    msg="Unknown error";;
  esac

  [ ${retval} -ne "0" ] && ciop-log "ERROR" "Error ${retval} - ${msg}, processing aborted" || ciop-log "INFO" "${msg}"

  exit ${retval}
}

trap cleanExit EXIT

export PATH_TO_SEADAS=/usr/local/seadas-7.1/
source ${PATH_TO_SEADAS}/ocssw/OCSSW_bash.env
export OCDATAROOT=${PATH_TO_SEADAS}/ocssw/run/data/
export DISPLAY=:99

ciop-log "INFO" "Checking Java version"
${PATH_TO_SEADAS}/bin/detect_java.sh
[ "$?" == "0" ] || exit $ERR_JAVAVERSION

myInput="${TMPDIR}/input"
myOutput="${TMPDIR}/output"
mkdir -p ${myInput} ${myOutput}

pixex="$( ciop-getparam pixex )"
par="$( ciop-getparam par )"
publish_l2="$( ciop-getparam publish_l2 )"

while read input
do
  #getting the input
  ciop-log "INFO" "Working with MERIS product ${input}"

  case "${input:0:4}" in
    "file"|"s3:/")
      n1input="$( echo "${input}" | ciop-copy -o "${myInput}" - )"
    ;;
    "http")
      n1input="$( opensearch-client "$input" enclosure | ciop-copy -o ${myInput} - )"
    ;;
    *)
      exit $ERR_NOINPUT
    ;;
  esac

  [ $? -ne 0 ] && exit ${ERR_NOINPUT}
  
  #preparing the processor run
  l2output="${myOutput}/$( basename ${n1input} | sed 's#\.N1$#.L2#g' )"
  seadaspar="${myOutput}/$( basename ${n1input} | sed 's#\.N1$#.par#g' )"

cat >> ${seadaspar} << EOF
# PRIMARY INPUT OUTPUT FIELDS
ifile=${n1input}
ofile=${l2output}

${par}
EOF
  
  ciop-log "INFO" "Starting seaDAS processor"
  ${PATH_TO_SEADAS}/ocssw/run/bin/l2gen par="${seadaspar}"
  [ $? -ne 0 ] && exit ${ERR_SEADAS}

  ciop-log "INFO" "Conversion to BEAM-DIMAP format"
  ${PATH_TO_SEADAS}/bin/pconvert.sh --outdir ${myOutput} ${l2output} 
  [ $? -ne 0 ] && exit ${ERR_PCONVERT}

  [ "${pixex}" == "true" ] && {
    # get the POIs
    echo -e "Name\tLatitude\tLongitude" > ${TMPDIR}/poi.csv
    echo "$( ciop-getparam poi | tr ',' '\t' | tr '|' '\n' )" >> ${TMPDIR}/poi.csv

    # get the window size
    window="$( ciop-getparam window )"
    aggregation="$( ciop-getparam aggregation )"

    # invoke pixex
    l2b="$( basename ${l2output} | sed 's#\.L2$#.dim#g')"
    prddate="${l2b:20:2}/${l2b:18:2}/${l2b:14:4}"
    ciop-log "INFO" "Apply BEAM PixEx Operator to ${l2b}"
    prd_orbit=$( echo ${l2b:49:5} | sed 's/^0*//' )
    run=${CIOP_WF_RUN_ID}

    # apply PixEx BEAM operator
    ${PATH_TO_SEADAS}/bin/gpt.sh \
      -Pvariable=${l2b} \
      -Pvariable_path=${myOutput} \
      -Poutput_path=${myOutput} \
      -Pprefix=${run} \
      -Pcoordinates=${TMPDIR}/poi.csv \
      -PwindowSize=${window} \
      -PaggregatorStrategyType="${aggregation}" \
      ${_CIOP_APPLICATION_PATH}/pixex/libexec/PixEx.xml 1>&2
        
    res=$?
    [ ${res} -ne 0 ] && exit ${ERR_BEAM_PIXEX}

    result="$( find ${myOutput} -name "${run}*measurements.txt" )"

    [ -n "${result}" ] && {
      skip_lines=$( cat "${result}" | grep -n "ProdID" | cut -d ":" -f 1 )

      cat "${result}" |  tail -n +${skip_lines} | tr "\t" "," | awk -f ${_CIOP_APPLICATION_PATH}/pixex/libexec/tidy.awk -v run=${run} -v date=${prddate} -v orbit=${prd_orbit} - > "${myOutput}/${l2b}.txt"

      ciop-log "INFO" "Publishing extracted pixel values"
      ciop-publish -m "${myOutput}/${l2b}.txt"
      rm -f "${myOutput}/${l2b}.txt"
    }
  }

  [ "${publish_l2}" == "true" ] && {
    # create RGB quicklook
    outputname=$( basename ${l2output} | sed 's#\.L2##g' )
    ${PATH_TO_SEADAS}/bin/pconvert.sh \
      -f png \
      -p ${_CIOP_APPLICATION_PATH}/seadas/etc/profile.rgb \
      -o ${myOutput} \
      ${myOutput}/${outputname}.dim

    ciop-log "INFO" "Publishing png"
    ciop-publish -m ${myOutput}/${outputname}.png

    ciop-log "INFO" "Compressing results"
    tar -C ${myOutput} -cvzf ${myOutput}/$( basename ${l2output} ).tgz \
      $( basename "${l2output}" | sed 's#\.L2$#.dim#g' ) \
      $( basename "${l2output}" | sed 's#\.L2$#.data#g' )
    [ $? -ne 0 ] && exit ${ERR_TAR}

    #publishing the output
    ciop-log "INFO" "Publishing $( basename ${l2output} ).tgz"
    ciop-publish -m ${myOutput}/$( basename ${l2output} ).tgz
  }

  rm -rf ${myInput}/*
  rm -rf ${myOutput}/*
done
