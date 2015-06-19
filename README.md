## MERIS atmospheric correction effects using SeaDAS

This tutorial builds upon the SeaDAS NASA project. More context information is available from the [project web page](http://seadas.gsfc.nasa.gov).

### Getting started

The Getting started guide to implement a "MERIS Level 1 to Level 2 atmospheric correction effects using SeaDAS" application on Terradue's Developer Cloud Sandbox platform, a set of Cloud services to develop, test and exploit scalable, distributed Earth Science processors.

To run this application, you will need a Developer Cloud Sandbox that can be requested from [Terradue's Portal](http://www.terradue.com/partners), provided user registration approval. 

#### Installation

Log on the developer sandbox and run these commands in a shell:

* Install **Java 7**

```bash
sudo yum install -y java-1.7.0-openjdk
```

* Select Java 7

```bash
sudo /usr/sbin/alternatives --config java
```
This will show on the terminal window:

```
There are 3 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
 + 1           /usr/java/jdk1.6.0_35/jre/bin/java
   2           /usr/lib/jvm/jre-1.5.0-gcj/bin/java
*  3           /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java

Enter to keep the current selection[+], or type selection number:
```

Select java 1.7 out of the menu options by typing the correct number (here it's *3*).

* Install the application from github

```bash
cd
git clone git@github.com:ocean-color-ac-challenge/Participant-D.git
cd Participant-D
mvn install
```

* Install the application from rpm

```bash
curl -L -O https://github.com/ocean-color-ac-challenge/Participant-D/releases/download/v1.0/Participant-D-1.0-ciop.noarch.rpm
sudo yum -y install Participant-D-1.0-ciop.noarch.rpm
```

### <a name="submit"></a>Submitting the workflow

* Via the Sandbox shell 

Run this command in a shell:

```bash
ciop-run
```

* Via the Web Processing Service dashboard tab

Use your browser to go to the Sandbox dashboard tab at the address http://<sandbox ip>/dashboard

Click on the _Invoke_ tab

Below the "Process List" click on _Participant D_

Fill the parameters and click submit. 

### <a name="test"></a>Test the application

##### Test Participant-D-01

* Test Procedure

Invoke the application via the Dashboard with the parameters listed in the test inputs specification

* Inputs specification 

| Parameter   | Value |
|-------------|---------------------------------------------------------------------------------------------------------|
| Data Package URL      | https://challenges.esa.int/eceo/datapackage/RRPAR/description?key=9d79148d-3e17-414b-9983-e4cef9e88ec6 |
| Start Time   | 2002-03-01T00:00:00Z |
| End Time     | 2012-05-09T23:59:59Z |
| Bounding Box | -180,90,180,-90 |
| List of POI for reflectance extraction |BOUS,43.367,7.9\|AAOT,45.314,12.508\|MOBY,20.828,-157.193 |
| Flag to trigger the publishing of Level 2 products generated | true |
| Flag to extract POI reflectances | false |

* Outputs specification

| Output                                                             | Size |
|--------------------------------------------------------------------|------|
MER_RR__1PNACR20060730_093546_000021432049_00480_23079_0000.L2.tgz|140.11 MB|
MER_RR__1PNACR20060730_093546_000021432049_00480_23079_0000.png|2.01 MB|
MER_RR__1PRACR20030306_201313_000026082014_00243_05307_0000.L2.tgz|218.92 MB|
MER_RR__1PRACR20030306_201313_000026082014_00243_05307_0000.png|5.65 MB|
MER_RR__1PRACR20040903_201756_000026282030_00057_13137_0000.L2.tgz|228.18 MB|
MER_RR__1PRACR20040903_201756_000026282030_00057_13137_0000.png|6.18 MB|
MER_RR__1PRACR20050504_093419_000026382037_00022_16609_0000.L2.tgz|177.24 MB|
MER_RR__1PRACR20050504_093419_000026382037_00022_16609_0000.png|2.91 MB|
MER_RR__1PRACR20070920_092716_000026302061_00437_29048_0000.L2.tgz|162.08 MB|
MER_RR__1PRACR20070920_092716_000026302061_00437_29048_0000.png|2.33 MB|
MER_RR__1PRACR20080816_092020_000026302071_00165_33786_0000.L2.tgz|165.45 MB|
MER_RR__1PRACR20080816_092020_000026302071_00165_33786_0000.png|2.3 MB|

* Test pass/fail criteria

All products listed in test outputs specification are generated

##### Test Participant-D-02

* Test Procedure

Invoke the application via the Dashboard with the parameters listed in the test inputs specification

* Inputs specification 

| Parameter   | Value |
|-------------|---------------------------------------------------------------------------------------------------------|
| Data Package URL      | https://challenges.esa.int/eceo/datapackage/FRSPAR/description?key=495f181f-47d3-4668-b717-d36d4a560837 |
| Start Time   | 2002-03-01T00:00:00Z |
| End Time     | 2012-05-09T23:59:59Z |
| Bounding Box | -180,90,180,-90 |
| List of POI for reflectance extraction |BOUS,43.367,7.9\|AAOT,45.314,12.508\|MOBY,20.828,-157.193 |
| List of POI for reflectance extraction |CHINA,27,122\|CHINA2,30,124\|CHINA3,22,126 |
| Flag to trigger the publishing of Level 2 products generated | true |
| Flag to extract POI reflectances | false |

* Outputs specification

| Output                                                             | Size |
|--------------------------------------------------------------------|------|
MER_FRS_1PPEPA20040711_020449_000002422028_00275_12353_1787.L2.tgz|448.06 MB|
MER_FRS_1PPEPA20040711_020449_000002422028_00275_12353_1787.png|18.24 MB|
MER_FRS_1PPEPA20040717_021529_000002642028_00361_12439_1968.L2.tgz|339.09 MB|
MER_FRS_1PPEPA20040717_021529_000002642028_00361_12439_1968.png|13.37 MB|

* Test pass/fail criteria

All products listed in test outputs specification are generated

##### Test Participant-D-03

* Test Procedure

Invoke the application via the Dashboard with the parameters listed in the test inputs specification

* Inputs specification 

| Parameter   | Value |
|-------------|---------------------------------------------------------------------------------------------------------|
| Data Package URL      | https://challenges.esa.int/eceo/datapackage/RRPAR/description?key=9d79148d-3e17-414b-9983-e4cef9e88ec6 |
| Start Time   | 2002-03-01T00:00:00Z |
| End Time     | 2012-05-09T23:59:59Z |
| Bounding Box | -180,90,180,-90 |
| List of POI for reflectance extraction |BOUS,43.367,7.9\|AAOT,45.314,12.508\|MOBY,20.828,-157.193 |
| Flag to trigger the publishing of Level 2 products generated | false |
| Flag to extract POI reflectances | true |

* Outputs specification

| Output                                                             | Size |
|--------------------------------------------------------------------|------|
MER_RR__1PNACR20060730_093546_000021432049_00480_23079_0000.dim.txt|2.04 KB|
MER_RR__1PRACR20030306_201313_000026082014_00243_05307_0000.dim.txt|1.51 KB|
MER_RR__1PRACR20040903_201756_000026282030_00057_13137_0000.dim.txt|1.5 KB|
MER_RR__1PRACR20050504_093419_000026382037_00022_16609_0000.dim.txt|1.94 KB|
MER_RR__1PRACR20070920_092716_000026302061_00437_29048_0000.dim.txt|2.04 KB|
MER_RR__1PRACR20080816_092020_000026302071_00165_33786_0000.dim.txt|1.78 KB|

* Test pass/fail criteria

All products listed in test outputs specification are generated

##### Test Participant-D-04

* Test Procedure

Invoke the application via the Dashboard with the parameters listed in the test inputs specification

* Inputs specification 

| Parameter   | Value |
|-------------|---------------------------------------------------------------------------------------------------------|
| Data Package URL      | https://challenges.esa.int/eceo/datapackage/FRSPAR/description?key=495f181f-47d3-4668-b717-d36d4a560837 |
| Start Time   | 2002-03-01T00:00:00Z |
| End Time     | 2012-05-09T23:59:59Z |
| Bounding Box | -180,90,180,-90 |
| List of POI for reflectance extraction |CHINA,27,122\|CHINA2,30,124\|CHINA3,22,126 |
| Flag to trigger the publishing of Level 2 products generated | false |
| Flag to extract POI reflectances | true |

* Outputs specification

| Output                                                             | Size |
|--------------------------------------------------------------------|------|
MER_FRS_1PPEPA20040711_020449_000002422028_00275_12353_1787.dim.txt|2.04 KB|
MER_FRS_1PPEPA20040717_021529_000002642028_00361_12439_1968.dim.txt|1.74 KB|

* Test pass/fail criteria

All products listed in test outputs specification are generated

### Community and Documentation

To learn more and find information go to 

* [Developer Cloud Sandbox](http://docs.terradue.com/developer-sandbox) service 

### Authors (alphabetically)

* Fabrice Brito
* Fabio D'Andria
* Samantha Lavender 
 
### License

Copyright 2015 Terradue Srl

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
