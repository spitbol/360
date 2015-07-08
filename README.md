# 360

SPITBOL 360 is an implementation of the SNOBOL4 programming language for use on IBM 360 compatible computers. 

SPITBOL 360 was the first true compiler for SNOBOL4 and is an incredibly clever work of assembly language.
It was written by Robert B. K. Dewar and Kenneth E. Belcher while both were
at the Illinois Institute of Technology.

## SPITBOL 360 README FILE

*  7/7/2015   Packaged files in git repository,
created README.md from Bob Goldberg's readme.txt (Dave Shields)

* 11/08/2001  Updated for Hercules AWS installation (Bob Goldberg)

*  8/20/2001  Initial Version (Bob Goldberg)


## Readme Contents

* What is SPITBOL 360?
* Provided files
* Installation Overview
* General Installation
* Hercules AWS Intallation
* Reassembling the Compiler
* Acknowledgments


## What is SPITBOL 360? 

SPITBOL 360 [*]  is an implementation of the SNOBOL4 programming language 
for use on IBM 360 compatible computers. SPITBOL is considerably 
smaller than the original implementation of SNOBOL4 and has 
execution speeds up to ten times faster. For certain programs, 
notably those with in-line patterns, the gain in speed may be even 
greater.

Unlike SIL SNOBOL4[**], which is an interpreter, SPITBOL is a true 
compiler which generates executable machine code. Of course, the 
complexity of the SNOBOL4 language dictates that system subroutines
be used for many common functions.

SPITBOL can be run as an 'in-core' 'load-and-go' system like 
WATFIV, where programs are executed as soon as they are compiled. 
Alternately, the compiler can generate object modules that can be 
linked with a run-time library to create load modules for later 
execution.

SPITBOL 360 was originally distributed under license, for a fee.[***] 
Effective November, 2001, SPITBOL 360 is  distributed under the 
General Public License (GPL) v2, for no fee.


[*] SPITBOL = SPeedy ImplemenTation of SNOBOL4

[**] The original SNOBOL4 implementation from Bell Telephone 
Laboratories was developed by R. E. Griswold and I. Polonsky, the 
designers of the SNOBOL4 programming language. Thus, this reference
implementation is often referred to as BTL SNOBOL4. In the early 
1970s, after Griswold left BTL for The University of Arizona and 
continued SNOBOL4 distribution from there, this implementation 
gained another name: SIL SNOBOL4. (SIL = SNOBOL4 Implementation 
Language)

[***] SPITBOL 360 was distributed from 1971 until 1984 when it was
superseded by SPITBOL 370.


## Provided files


The directory ./dist contains the following files:

* spitbol_360.tar.gz 
SPITBOL 360 EBCDIC files, for installation on IBM 360 compatible computer

* spitbol_360.zip
SPITBOL 360 EBCDIC files, for installation on IBM 360 compatible computer

* spitbol_360_aws.tar.gz
AWS tape file for easy Herculer installation.

* spitbol_360_aws.zip
AWS tape file for easy Herculer installation.

* spitbol_360_source.tar.gz 
SPITBOL 360 source files only

* spitbol_360_source.zip
SPITBOL 360 source files only

The files in the main directory include the source files, 
the manual, and the SPITBOL Newsletters.



## Installation Overview

The next two sections describe the installation procedures for 
SPITBOL 360. The first section, "General Installation," describes 
an installation procedure that can be used on both "real" mainframes 
as well as Hercules emulated mainframes. A simplified Hercules 
installation, based on an AWS tape file, is described in the 
"Hercules AWS Installation" section. Users following the Hercules 
AWS installation procedure should still read the "General 
Installation" section for perspective.



## General Installation

Take care when using a file transfer programs to transfer these 
distribution files between machines! You MUST use a binary transfer 
mode to move each of the EBCDIC files. For example, if using FTP, 
set mode to Binary.

Below is a list of the files contained in the distribution ZIP/TAR
file. All files are EBCDIC except for the first two files which are
provided in ASCII as a convenience to users.


|  File | Name     |  Contents |
|--:|:-------------|:-----------------------------------------|
|    1| README.TXT  (ASCII) Readme file (translation of README)|
|    2| GPL.TXT     (ASCII) General Public License text (translation of GPL)|
|    3| README      Readme file|
|    4| GPL         General Public License|
|    5| SBOLOBJ     Object files to create SPITBOL compiler|
|    6| LINKSBOL    Sample JCL to link SPITBOL compiler|
|    7| TESTPGMS    Compiler test programs|
|    8| TESTSBOL    Sample JCL to run compiler test programs |
|    9| SLIBOBJ     Object files to create SPITPROG runtime|
|   10| LINKSPRG    Sample JCL to link SPITPROG runtime|
|   11| OSINT       OSINT assembler source|
|   12| SPITBOL     SPITBOL assembler source|
|   13| TFSV23      TFs for SPITBOL and SPITPROG|


ALL EBDCIC distribution files are sequential card image files, with 
DCB attributes RECBM=FB and LRECL=80.


Installation is quite simple: only four files need be loaded onto 
your system, followed by a link edit and test run.


Step 1: Create datasets

Create two datasets:

(1) a SPITBOL.SRC PDS (SOURCE LIB) to receive object files, sample 
      JCL, and test programs

(2) a SPITBOL.LOAD PDS (LOAD LIB) to receive the output of the 
      linkage editor


Step 2: Populate the SPITBOL PDS

Load the following files into your SPITBOL PDS:

|File |Name      |Contents
|---:|:----------|:------------|
|    5|SBOLOBJ   |Object files to create SPITBOL compiler|
|    6|LINKSBOL  |Sample JCL to link SPITBOL compiler|
|    7|TESTPGMS  |Compiler test programs|
|    8|TESTSBOL  |Sample JCL to run compiler test programs |


Step 3: Link SPITBOL Compiler

Member LINKSBOL contains sample JCL to link the SPITBOL compiler.
  Examine, modify, and run.

```
    //.. JOB ....
    // EXEC LKED
    //SYSLMOD   DD  DSN=SPITBOL.LOAD,DISP=SHR
    //OBJS      DD  DSN=SPITBOL.SRC,DISP=SHR
    //SYSIN     DD  *
     INCLUDE OBJS(SBOLOBJ)
     ENTRY OSINT
     NAME SPITBOL(R)
    /*
```

  Step 4: Test compiler

Run the test programs provided with the distribution. Note that you 
  only have to run the compiler once; SPITBOL 360 supports its own 
  batching of jobs. Member TESTSBOL contains sample JCL to run the 
  test programs. Examine, modify and run.

```
    //.. JOB ....
    // EXEC PGM=SPITBOL,REGION=512K
    //STEPLIB   DD  DSN=SPITBOL.LOAD,DISP=SHR
    //SYSPRINT  DD  SYSOUT=A
    //SYSPUNCH  DD  DUMMY
    //SYSIN     DD  DSN=SPITBOL.SRC(TESTPGMS),DISP=SHR
```

SPITBOL 360 is happiest in regions of 192K or more.


You're done! ENJOY!


  Optional Step 5: Link SPITPROG Runtime Library

  This step is optional.

  SPITPROG is needed only if you plan to create load modules from your
  SPITBOL programs. Since SPITBOL 360 is a load-and-go compiler, 
  linking of compiled programs is not required for them to be run.

  Load the following files into your SPITBOL PDS:

|FIle |Name      |Contents
|----:|:---------|:----------|
|    9| SLIBOBJ  | Object files to create SPITPROG runtime|
|  10 |LINKSPRG  |Sample JCL to link SPITPROG runtime|

Member LINKSLIB contains sample JCL to link the SPITBOL runtime 
  library. Examine, modify, and run.

```
    //.. JOB ....
    // EXEC LKED
    //SYSLMOD   DD  DSN=SPITBOL.LOAD,DISP=SHR
    //OBJS      DD  DSN=SPITBOL.SRC,DISP=SHR
    //SYSIN     DD  *
     INCLUDE OBJS(SLIBOBJ)
     ENTRY OSINT
     NAME SPITPROG(R)
    /*

```

  To compile and link a SPITBOL program:

```
    //.. JOB ....
    // EXEC PGM=SPITBOL
    //STEPLIB   DD  DSN=SPITBOL.LOAD,DISP=SHR
    //SYSPRINT  DD  SYSOUT=A
    //SYSPUNCH  DD  DUMMY
    //SYSOBJ    DD  DSN=&OBJ,UNIT=...,SPACE=(...),
    //              DCB=(RECFM=FB,LRECL=80,BLKSIZE=1600),DISP=(NEW,PASS)
    //SYSIN     DD  *
    -NOEXECUTE
    <program goes here>
    /*
    // EXEC LKED
    //SYSLMOD   DD  DSN=<your load lib>,DISP=SHR
    //LIB       DD  DSN=SPITBOL.LOAD,DISP=SHR
    //OBJ       DD  DSN=&OBJ,DISP=(OLD,DELETE)
    //SYSIN     DD  *
     INCLUDE LIB(SPITPROG)
     INCLUDE OBJ
     ENTRY OSINT
     NAME FOO
    /*
```

  See SPITBOL Newsletter #1, which is contained in the SPITBOL 360 
  Manual PDF file, for the original instructions circa 1971.

## Hercules AWS Installation

IMPORTANT! You MUST have Hercules 2.14a or later in order to run 
SPITBOL 360. Hercules 2.14a includes a fix to its floating point 
instruction emulation that is required for SPITBOL to execute 
properly.


Below is a list of the files contained in the distribution ZIP/TAR
file.

  File Name          Contents|
|----:|:-------------|:----------------------------------------------|
|   1 |README.TXT    |(ASCII) Readme file|
|   2 |GPL.TXT       |(ASCII) General Public License text|
|   3 |SPT-LOAD.JCL  |(ASCII) JCL to load files from AWS tape file|
|   4 |SPT-LINK.JCL  |(ASCII) JCL to link SPITBOL load module|
|   5 |SPT-TEST.JCL  |(ASCII) JCL to test SPITBOL|
|   6 |SPITBOL.AWS   |AWS file representing unlabelled tape (NL) that contains files 3 to 13, in order, from the standard distribution (see list above)|


Step 1: Load files from AWS tape onto disk

Inspect SPT-LOAD.JCL and modify the JCL statements (dataset names, etc.) as necessary. Mount the AWS tape file and submit SPT-LOAD.JCL to a job reader.  

Step 2: Link SPITBOL compiler

Inspect SPT-LINK.JCL and modify the JCL statements (dataset names, etc.) as necessary. Mount the AWS tape file and submit SPT-LINK.JCL
to a job reader.


Step 3: Test compiler

Inspect SPT-TEST.JCL and modify the JCL statements (dataset names,
  etc.) as necessary. Mount the AWS tape file and submit SPT-TEST.JCL to a job reader.

You're done. Enjoy!


Note about floating point exceptions: When running SPITBOL 360 on
Hercules, Hercules may log a number of floating point exceptions. 
Don't be alarmed! SPITBOL 360 uses these exceptions to control
execution; they are to be expected.

## Reassembling the Compiler

Although complete source for the SPITBOL 360 compiler is provided
as part of this distribution, DON'T reassemble it unless you're 
comfortable handling these issues:

ASCII Conversions. For those who are planning to convert the EBCDIC 
source to ASCII and then back to EBCDIC for reassembly, be advised 
that many EBCDIC to ASCII conversions fail to translate all 
characters properly. For example, the not and vertical bar characters 
are often improperly translated.

Binary Characters. There are instances of binary, non-printing, 
EBCDIC characters in the assembly source.

Compiler/Library Assembly. Be sure to set up the DEFLMOD source 
library member accordingly.

Temporary Fixes (TFs). Modifying instructions or data in the assembly 
source may affect CSECT offsets. If so, you will need to adjust the 
offsets in V23TFS. If you're intent on modifying the compiler's
source, consider obtaining the SPITBOL 370 distribution which does 
not require any patches.

If you do reassemble the compiler or library, you must reapply the 
TFs contained in file V23TFS. These TFs have already been applied 
to the object files provided with the distribution, so this step is
not part of the installation procedure described above.


## Acknowledgments

Thanks to Robert Dewar and Ken Belcher for allowing me to re-release 
SPITBOL 360 under the GPL for all to use and study.

Thanks to Bob Lerche for helping me validate this release on a real
IBM mainframe system.

Thanks to Jay Jaeger and Jay Maynard, both of whom validated this
release on Hercules. Jay Jaeger also created the AWS tape file to
make life simpler for Hercules users.

 Bob Goldberg, 8 Nov 2001

