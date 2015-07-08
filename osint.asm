         TITLE 'OSINT -- OS INTERFACE -- DESCRIPTION'                   00001000
*                                                                       00002000
*        O    S    I    N    T                                          00003000
*        ---------------------                                          00004000
*                                                                       00005000
*        GENERAL INTERFACE FOR OS/360                                   00006000
*                                                                       00006010
*        VERSION 2.3                                                    00006020
*                                                                       00007000
*        ROBERT B. K. DEWAR                                             00008000
*        KENNETH E. BELCHER                                             00009000
*        ILLINOIS INSTITUTE OF TECHNOLOGY                               00010000
*                                                                       00011000
*    COPYRIGHT (C) 1971, 2001 ROBERT B. K. DEWAR AND KENNETH E. BELCHER 00011010
*                                                                       00011020
*        NEITHER AUTHOR IS CURRENTLY ASSOCIATED WITH ILLINOIS           00011030
*        INSTITUTE OF TECHNOLOGY. FOR CURRENT INFORMATION ABOUT         00011040
*        ABOUT SPITBOL 360 VISIT HTTP://WWW.SNOBOL4.COM                 00011050
*        -------------------------------------------------------------- 00011060
*                                                                       00011070
*                                                                       00011080
*        THIS FILE IS PART OF SPITBOL 360                               00011090
*                                                                       00011100
*        SPITBOL 360 IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR   00011110
*        MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE    00011120
*        AS PUBLISHED BY THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 00011130
*        OF THE LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.         00011140
*                                                                       00011150
*        SPITBOL 360 IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, 00011160
*        BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF 00011170
*        MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  SEE THE  00011180
*        GNU GENERAL PUBLIC LICENSE FOR MORE DETAILS.                   00011190
*                                                                       00011200
*        YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC      00011210
*        LICENSE ALONG WITH SPITBOL 360; IF NOT, WRITE TO THE FREE      00011220
*        SOFTWARE FOUNDATION, INC., 59 TEMPLE PLACE, SUITE 330,         00011230
*        BOSTON, MA  02111-1307  USA                                    00011240
*                                                                       00011250
*        -------------------------------------------------------------  00011260
*                                                                       00011270
*                                                                       00011280
*        CHANGE LOG:                                                    00011290
*                                                                       00011300
*        2.3   8/14/2001 BOB GOLDBERG                                   00011310
*                                                                       00011320
*              PREPARED SOURCE FOR GPL DISTRIBUTION:                    00011330
*              - UPDATED COMMENTS                                       00011340
*              - APPLIED TFS 1 TO 6 TO SOURCE (OS MACROS PRODUCE        00011350
*                DIFFERENT CODE NOW THAN IN '71; OFFSETS CHANGED)       00011360
*              - FIXED CONDITIONAL BRANCHES USED TO ABORT EXECUTION     00011370
*                AFTER EXPIRATION OF TRIAL VERSION (1999 = Y2K-1 BUG)   00011380
*        -------------------------------------------------------------- 00011390
*                                                                       00011400
*                                                                       00012000
*        THIS PROGRAM PROVIDES A RANGE OF EASILY USEABLE ENTRY          00013000
*        POINTS FOR SYSTEM FUNCTIONS AND ALLOWS A PROGRAM TO BE         00014000
*        WRITTEN IN AN ESSENTIALLY SYSTEM INDEPENDENT MANNER.           00015000
*        IT WAS ORIGINALLY WRITTEN FOR USE WITH SPITBOL/360 BUT         00016000
*        NO PART DEPENDS ON THIS USE, SO OTHER USES ARE POSSIBLE        00017000
*                                                                       00018000
*        THE FOLLOWING PAGES DESCRIBE THE REQUIREMENTS FOR              00019000
*        OPERATING UNDER CONTROL OF THE INTERFACE. NOTE THE GENERAL     00020000
*        REQUIREMENT THAT NO SYSTEM MACRO CALLS ARE TO BE USED.         00021000
         TITLE 'OSINT -- OS INTERFACE -- SYSTEM PARAMETERS'             00022000
*                                                                       00023000
*        ON ENTRY TO OSINT FROM THE CONTROL PROGRAM, A PARAMETER        00024000
*        FIELD MAY BE PROVIDED. THE PARAMETER FIELD IS OF THE FORM --   00025000
*                                                                       00026000
*        'X=NNN,X=NNN,X=NNN,...'                                        00027000
*                                                                       00028000
*        WHERE X ARE THE CHARACTERS INDICATING THE PARAMETER TYPE       00029000
*        AND NNN ARE THE ASSIGNED VALUES. NNN IS EITHER AN UNSIGED      00030000
*        OR AN UNSIGNED INTEGER FOLLOWED BY K TO INDICATE               00031000
*        MULTIPLICATION BY 1024. THE FOLLOWING IS A LIST OF PARAMETERS  00032000
*                                                                       00033000
*        NAME  DEFAULT            MEANING                               00034000
*        ----  -------            -------                               00035000
*                                                                       00036000
*        R     8K                 MEMORY TO BE RESERVED TO SYSTEM       00037000
*        L     16K                MINIMUM ACCEPTABLE DATA AREA SIZE     00038000
*        H     1000K              MAXIMUM DATA AREA TO BE ALLOCATED     00039000
*        T     55                 TIME LIMIT IN SECONDS                 00040000
*        P     100000             PAGE LIMIT (1 PAGE = N LINE RECORDS)  00041000
*        C     100000             CARD LIMIT (SYSPUNCH)                 00042000
*        D     10                 MAX NUMBER OF OSINT DUMPS             00043000
*        N     58                 NUMBER OF LINES PER PAGE              00044000
*        I     0                  0/1 FOR PRECISE/IMPRECISE INTERRUPTS  00045000
*                                                                       00046000
*        THE DEFAULT VALUE IS USED IF THE PARAMETER IS NOT SUPPLIED.    00047000
*                                                                       00048000
*        T,P,L LIMITS ARE ENFORCED SEPARATELY FOR EACH JOB IN A BATCH.  00049000
*                                                                       00050000
*        THE VALUE OF D IS DECREMENTED FOR EVERY CALL TO SYSABEND.      00051000
*        IF THE VALUE IS ZERO ON ENTRY TO SYSABEND, A STANDARD SYSTEM   00052000
*        ABEND DUMP IS GIVEN.                                           00053000
         TITLE 'OSINT -- OS INTERFACE -- MAIN PROGRAM ENTRY POINTS'     00054000
*                                                                       00055000
*        THE FOLLOWING ENTRY POINTS MUST BE PROVIDED IN THE MAIN PROGRM 00056000
*                                                                       00057000
*        SYSSTART                                                       00058000
*        --------                                                       00059000
*                                                                       00060000
*        THIS IS THE ENTRY POINT TO THE MAIN PROGRAM. OSINT PASSES      00061000
*        CONTROL TO SYSSTART AS FOLLOWS AFTER INITIALIZATION            00062000
*                                                                       00063000
*        (8)                      POINTS TO THE ALLOCATED DATA AREA     00064000
*                                                                       00065000
*        (15)                     ADDRESS OF SYSSTART                   00066000
*                                                                       00067000
*        (REMAINING REGISTERS)    NOT USED, MAY BE DESTROYED            00068000
*                                                                       00069000
*        NOTE THAT OSINT RECOGNIZES THE SYMBOLS ./* IN COLUMNS 1-3      00070000
*        OF A SYSIN IMAGE TO REPRESENT AN END OF FILE SEPARATING JOBS   00071000
*        WHICH ARE BATCHED TOGETHER. IF THE MAIN PROGRAM IS NOT         00072000
*        REUSABLE, IT MUST RECOGNIZE SUBSEQUENT ENTRIES AFTER THE       00073000
*        FIRST AND RETURN WITHOUT ANY PROCESSING.                       00074000
*                                                                       00075000
*        THE ALLOCATED DATA AREA IS TO BE USED TO MEET ALL VOLATILE     00076000
*        STORAGE REQUIREMENTS OF THE MAIN PROGRAM. FOR A DESCRIPTION    00077000
*        OF THE FORMAT OF THE DATA AREA, SEE THE DATA DSECT AT THE END  00078000
*        OF THE LISTING. THE LARGEST AVAILABLE CONTINGUOUS AREA OF      00079000
*        STORAGE (NOT EXCEEDING THE H PARAMETER) IS USED, RESERVING     00080000
*        ONLY THAT SPECIFIED BY THE R PARAMETER FOR OTHER USES.         00081000
*        THE MAIN PROGRAM IS EXPECTED TO DO ITS OWN STORAGE             00082000
*        MANAGEMENT WITHIN THIS AREA (GETMAIN,FREEMAIN MAY NOT BE USED) 00083000
*                                                                       00084000
*        SYSHEAD                                                        00085000
*        -------                                                        00086000
*                                                                       00087000
*        THE DATA AT THE ENTRY POINT SYSHEAD SPECIFIES THE HEADING      00088000
*        TO BE PRINTED BY OSINT AT THE START OF A RUN. IT CONSISTS OF   00089000
*        A SERIES OF LINES STARTING WITH AN ASA CONTROL CHARACTER.      00090000
*        EACH LINE IS PRECEEDED BY A ONE BYTE COUNT GIVING THE ACTUAL   00091000
*        LENGTH OF THE LINE. A BYTE OF ZEROS (X'00') ENDS THE LIST      00092000
*                                                                       00093000
*        THE FOLLOWING IS AN EXAMPLE OF A TYPICAL HEADING               00094000
*                                                                       00095000
*        ENTRY SYSHEAD                                                  00096000
*SYSHEAD DC    AL1(L'HED1)                                              00097000
*HED1    DC    C'1DOODLETRAN VERSION 9.9'                               00098000
*        DC    AL1(L'HED1)                                              00099000
*        DC    C'+______________________'                               00100000
*        DC    AL1(0)                                                   00101000
*                                                                       00102000
*        SYSBATCH                                                       00103000
*        --------                                                       00104000
*                                                                       00105000
*        A SINGLE BYTE WHICH IS SET TO 1 IF THE MODULE PERMITS SYSIN    00106000
*        BATCHING (VIA ./*) OR ZERO IF NO BATCHING IS PERMITTED         00107000
         EJECT                                                          00108000
*                                                                       00109000
*        SYSINTR                                                        00110000
*        -------                                                        00111000
*                                                                       00112000
*        THIS ENTRY POINT RECEIVES CONTROL AS FOLLOWS AFTER THE         00113000
*        OCCURENCE OF A PROGRAM CHECK.                                  00114000
*                                                                       00115000
*        (15)                     POINTS TO SYSINTR                     00116000
*                                                                       00117000
*        (8)                      POINTS TO ALLOCATED DATA AREA         00118000
*                                 SYSPSW,SYSREGS STORED                 00119000
*                                                                       00120000
*        (REMAINING REGS)         UNPREDICTABLE                         00121000
*                                                                       00122000
*        SYSINTR CAN DETERMINE THE CAUSE OF THE INTERRUPT BY EXAMINING  00123000
*        THE INTERRUPT PSW AND REGISTER VALUES STORED IN THE DATA AREA  00124000
*        (AT SYSPSW AND SYSSTART). IT THEN TAKES APPROPRIATE ACTION.    00125000
*                                                                       00126000
*        NOTES.                                                         00127000
*                                                                       00128000
*        SYSINTR RECEIVES CONTROL AFTER LEAVING TRAP STATE, THUS THERE  00129000
*        IS NO PROVISION FOR 'RETURNING' VIA THE SYSTEM.                00130000
*                                                                       00131000
*        IF THE INTERRUPT IS AN ERROR, THEN SYSINTR SHOULD PRINT        00132000
*        AN APPROPRIATE MESSAGE AND EXIT VIA SYSABEND. NOTE THAT THE    00133000
*        PSW AND REG VALUES ARE IN THE DATA AREA AND WILL BE DUMPED.    00134000
*                                                                       00135000
*        REGISTER 8 IS SET CORRECTLY TO POINT TO THE DATA AREA EVEN IF  00136000
*        IT WAS NOT SO SET AT THE TIME OF THE INTERRUPT.                00137000
         EJECT                                                          00138000
*                                                                       00139000
*        SYSOVTM                                                        00140000
*        -------                                                        00141000
*                                                                       00142000
*                                                                       00143000
*        THIS ENTRY POINT RECEIVES CONTROL ON AN OVERTIME TRAP          00144000
*        (I.E. T PARAMETER EXCEEDED) AS FOLLOWS --                      00145000
*                                                                       00146000
*        (15)                     ADDRESS OF SYSOVTM                    00147000
*                                                                       00148000
*        (8)                      POINTER TO ALLOCATED DATA AREA        00149000
*                                                                       00150000
*        (14)                     RETURN POINT TO INTERFACE             00151000
*                                                                       00152000
*        (REMAINING REGS)         UNPREDICTABLE, NEED NOT BE SAVED      00153000
*                                                                       00154000
*        UNLIKE SYSINTR, THIS ROUTINE RECEIVES CONTROL WITHIN TRAP      00155000
*        STATE AND MUST RETURN CONTROL VIA REGISTER 14. THUS THE        00156000
*        ROUTINE SHOULD SET FLAGS ETC. WHICH THE MAIN STREAM ROUTINE    00157000
*        RECOGNIZES AS SIGNIFYING THAT AN OVERTIME TRAP HAS OCCUED.     00158000
*                                                                       00159000
*        NOTE THAT THE GENERAL REGISTERS DO NOT CONTAIN USEABLE         00160000
*        VALUES SINCE THE INTERRUPT MAY OCCUR DURING EXECUTION OF       00161000
*        A ROUTINE WITHIN THE SYSTEM INTERFACE. HOWEVER, THE            00162000
*        FLOATING POINT REG VALUES ARE UNCHANGED AND MAY BE MODIFIED.   00163000
         TITLE 'OSINT -- OS INTERFACE -- INTERFACE ENTRY POINTS'        00164000
*                                                                       00165000
*        THE INTERFACE PROVIDES A SERIES OF ENTRY POINTS FOR PERFORMING 00166000
*        VARIOUS SYSTEM DEPENDENT FUNCTIONS. A COMMON CALLING           00167000
*        SEQUENCE IS USED AS FOLLOWS --                                 00168000
*                                                                       00169000
*        (8)                      POINTS TO THE ALLOCATED DATA AREA     00170000
*                                                                       00171000
*        (2)                      ADDRESS OF SYSTEM INTERFACE ROUTINE   00172000
*                                 LOADED VIA A VCON                     00173000
*                                                                       00174000
*        (1)                      RETURN POINT TO MAIN PROGRAM          00175000
*                                                                       00176000
*        (0,4,5,6,7)              PARAMETER VALUES AS REQUIRED BY       00177000
*                                 THE PARTICULAR CALL                   00178000
*                                                                       00179000
*        (REMAINING REGS)         NOT RELEVANT                          00180000
*                                                                       00181000
*        ON RETURN, ALL REGISTERS, WITH THE POSSIBLE EXCEPTION          00182000
*        OF (0) ARE RESTORED. IF AN ERROR OCCURED, AN ERROR CODE        00183000
*        IS POSTED IN REGISTER (0) AND CONTROL IS RETURNED TO 0(1).     00184000
*        IF THE CALL IS SUCCESSFUL, CONTROL RETURNS TO 4(1). IN SOME    00185000
*        CASES, A RESULT IS RETURNED IN REGISTER (0).                   00186000
*                                                                       00187000
*        NORMAL PRACTICE IS TO KEEP REGISTER (8) POINTING TO THE        00188000
*        ALLOCATED DATA AREA AT ALL TIMES, ALTHOUGH THE VALUE IS        00189000
*        ONLY REQUIRED TO BE LOADED WHEN AN INTERFACE CALL IS MADE.     00190000
*        THUS A TYPICAL CALL TO AN OSINT ENTRY POINT IS AS FOLLOWS      00191000
*                                                                       00192000
*        L     2,=V(SYSXXX)                                             00193000
*        LA    0,PARAM                                                  00194000
*        BALR  1,2                                                      00195000
*        B     ERROR                                                    00196000
*        -->   NORMAL RETURN                                            00197000
*                                                                       00198000
*        NOTE THAT THE SPACE FOR THE ERROR RETURN MUST BE PROVIDED EVEN 00199000
*        FOR CALLS WHICH CANNOT GIVE AN ERROR RETURN.                   00200000
         EJECT                                                          00201000
*                                                                       00202000
*        SYSABEND                                                       00203000
*        --------                                                       00204000
*                                                                       00205000
*        PURPOSE:                 TERMINATE EXECUTION WITH AN ERROR     00206000
*                                 INDICATION. A SYSTEM DUMP OR AN OSINT 00207000
*                                 DUMP IS GIVEN DEPENDING ON THE        00208000
*                                 SETTING OF THE D PARAMETER. THE OSINT 00209000
*                                 DUMP INCLUDES THE ALLOCATED DATA      00210000
*                                 AREA, DCB'S AND INTERFACE WORK AREA.  00211000
*                                 AFTER AN OSINT DUMP, AN ATTEMPT       00212000
*                                 IS MADE TO INITIATE THE NEXT JOB      00213000
*                                 IN A BATCH.                           00214000
*                                                                       00215000
*        ENTRY PARAMETERS:        NONE                                  00216000
*                                                                       00217000
*        RESULT RETURNED:         NONE (DOES NOT RETURN)                00218000
*                                                                       00219000
*                                                                       00220000
*        SYSCLOSE                                                       00221000
*        --------                                                       00222000
*                                                                       00223000
*        PURPOSE:                 CLOSE FILE AND RELEASE ITS ASSOCIATED 00224000
*                                 STORAGE (BUFFER POOLS ETC.)           00225000
*                                 SYSDCB MUST BE CALLED BEFORE ANY      00226000
*                                 FURTHER OPERATIONS ARE PERFORMED      00227000
*                                 ON THE FILE. SYSTEM FILES (SYSPUNCH,  00228000
*                                 SYSIN, SYSPRINT) CANNOT BE CLOSED.    00229000
*                                                                       00230000
*        ENTRY PARAMETERS:        (0)       POINTER TO DCB FOR FILE     00231000
*                                                                       00232000
*        RESULT RETURNED:         ZERO                                  00233000
*                                                                       00234000
*                                                                       00235000
*        SYSDATE                                                        00236000
*        -------                                                        00237000
*                                                                       00238000
*        PURPOSE:                 OBTAIN CURRENT DATE (MM/DD/YY)        00239000
*                                                                       00240000
*        ENTRY PARAMETERS:        NONE                                  00241000
*                                                                       00242000
*        RESULT RETURNED:         POINTER TO 8 CHAR DATE (MM/DD/YY)     00243000
*                                                                       00244000
*                                                                       00245000
*        SYSSETP                                                        00246000
*        -------                                                        00247000
*                                                                       00248000
*        PURPOSE:                 TO INFORM THE INTERFACE THAT THE      00249000
*                                 DATA AREA POINTER HAS BEEN CHANGED    00250000
*                                                                       00251000
*        ENTRY PARAMETERS         NONE (REG 8 POINTS TO NEW DATA AREA)  00252000
*                                                                       00253000
*        RESULT RETURNED:         NONE                                  00254000
         EJECT                                                          00255000
*                                                                       00256000
*        SYSDCB                                                         00257000
*        ------                                                         00258000
*                                                                       00259000
*        PURPOSE:                 TO OBTAIN A DCB POINTER FOR A FILE    00260000
*                                 FROM A FILENAME FOR USE IN            00261000
*                                 SUBSEQUENT CALLS. SEE SEPARATE        00262000
*                                 SECTION FOR DISCUSSION OF FILENAMES   00263000
*                                                                       00264000
*        ENTRY PARAMETERS:        (4)       ADDRESS OF FILE NAME        00265000
*                                 (5)       NUMBER OF CHARS IN FILENAME 00266000
*                                                                       00267000
*        RESULT RETURNED:         POINTER TO DCB. NOTE THAT THE USER    00268000
*                                 MUST NOT USE THIS POINTER EXCEPT      00269000
*                                 FOR INTERFACE COMMUNICATION. THIS IS  00270000
*                                 TO ENSURE COMPATABILITY WITH          00271000
*                                 OTHER SYSTEMS SUCH AS DOS.            00272000
*                                 THE POINTER IS VALID UNTIL THE FILE   00273000
*                                 IS CLOSED USING SYSCLOSE.             00274000
*                                                                       00275000
*                                                                       00276000
*        SYSDUMP                                                        00277000
*        -------                                                        00278000
*                                                                       00279000
*        PURPOSE:                 PROVIDE A SPECIAL DUMP OF THE         00280000
*                                 ALLOCATED DATA AREA, DCB'S AND THE    00281000
*                                 INTERFACE WORK AREA. THE DUMP GIVES   00282000
*                                 BOTH ABSOLUTE AND RELATIVE ADDRESSES  00283000
*                                 IN EACH AREA. NOTE THAT THE REGISTER  00284000
*                                 VALUES ARE NOT DUMPED AND MUST        00285000
*                                 THEREFORE BE STORED IN THE DATA AREA  00286000
*                                 PRIOR TO THE SYSDUMP CALL.            00287000
*                                                                       00288000
*        ENTRY PARAMETERS:        NONE                                  00289000
*                                                                       00290000
*        RESULT RETURNED:         NONE                                  00291000
*                                                                       00292000
*                                                                       00293000
*        SYSEOJ                                                         00294000
*        ------                                                         00295000
*                                                                       00296000
*        PURPOSE:                 NORMAL TERMINATION OF EXECUTION       00297000
*                                 IF ON READING SYSIN, A ./* IS         00298000
*                                 ENCOUNTERED, OSINT STARTS A NEW JOB   00299000
*                                 BY REINITIALIZING AND PASSING         00300000
*                                 CONTROL TO SYSSTART.                  00301000
*                                                                       00302000
*        ENTRY PARAMETERS:        (0)       SYSTEM RETURN CODE          00303000
*                                           LAST JOB IN A BATCH ONLY    00304000
*                                                                       00305000
*        RESULT RETURNED:         NONE (DOES NOT RETURN)                00306000
         EJECT                                                          00307000
*                                                                       00308000
*        SYSLOAD                                                        00309000
*        -------                                                        00310000
*                                                                       00311000
*        PURPOSE:                 LOAD AN EXTERNAL MODULE               00312000
*                                                                       00313000
*        ENTRY PARAMETERS:        (4)       ADDRESS OF MODULE NAME      00314000
*                                 (5)       NUMBER OF CHARS IN NAME     00315000
*                                                                       00316000
*        RESULT RETURNED:         STARTING ADDRESS OF LOADED MODULE     00317000
*                                                                       00318000
*                                                                       00319000
*        SYSMAXL                                                        00320000
*        -------                                                        00321000
*                                                                       00322000
*        PURPOSE:                 TO DETERMINE THE MAXIMUM POSSIBLE     00323000
*                                 LENGTH OF AN INPUT RECORD FROM A FILE 00324000
*                                 SO THAT THE CALLER CAN PROVIDE A      00325000
*                                 SUITABLE BUFFER FOR A SYSREAD CALL    00326000
*                                                                       00327000
*        ENTRY PARAMETERS:        (0)       POINTER TO DCB FOR FILE     00328000
*                                                                       00329000
*        RESULT RETURNED:         MAX RECORD LENGTH IN BYTES            00330000
*                                                                       00331000
*                                                                       00332000
*        SYSPHASE                                                       00333000
*        --------                                                       00334000
*                                                                       00335000
*        PURPOSE:                 LOAD A PHASE IN A MULTIPHASE PROGRAM  00336000
*                                 NOTE THAT THE INTERFACE MUST BE IN    00337000
*                                 THE ROOT PHASE.                       00338000
*                                                                       00339000
*        ENTRY PARAMETERS:        (0)       VCON OF PHASE TO BE LOADED  00340000
*                                 (4)       ADDR OF 8 CHR PHASE NAME    00341000
*                                                                       00342000
*        RESULT RETURNED:         NONE                                  00343000
*                                                                       00344000
*                                                                       00345000
*        SYSREAD                                                        00346000
*        -------                                                        00347000
*                                                                       00348000
*        PURPOSE:                 READ A RECORD FROM A FILE             00349000
*                                                                       00350000
*        ENTRY PARAMETERS:        (0)       POINTER TO DCB FOR FILE     00351000
*                                 (4)       ADDRESS OF BUFFER           00352000
*                                                                       00353000
*        RESULT RETURNED:         LENGTH OF RECORD READ                 00354000
*                                 SET NEGATIVE ON END OF FILE           00355000
*                                                                       00356000
         EJECT                                                          00357000
*        SYSRWIND                                                       00358000
*        --------                                                       00359000
*                                                                       00360000
*        PURPOSE:                 REWIND A FILE, I.E. CLOSE FILE AND    00361000
*                                 REPOSITION AT START OF FILE. SYSTEM   00362000
*                                 FILES (SYSPUNCH, SYSIN, SYSPRINT)     00363000
*                                 CANNOT BE REWOUND. THE STORAGE        00364000
*                                 (BUFFER POOLS ETC.) IS NOT RELEASED.  00365000
*                                                                       00366000
*        ENTRY PARAMETERS:        (0)       POINTER TO DCB FOR FILE     00367000
*                                                                       00368000
*        RESULT RETURNED:         NONE                                  00369000
*                                                                       00370000
*                                                                       00371000
*        SYSTIME                                                        00372000
*        -------                                                        00373000
*                                                                       00374000
*        PURPOSE:                 GET CURRENT TIMER VALUE               00375000
*                                                                       00376000
*        ENTRY PARAMETERS:        NONE                                  00377000
*                                                                       00378000
*        RESULT RETURNED:         TIME IN MILLISECONDS SINCE            00379000
*                                 SYSSTART RECEIVED CONTROL             00380000
*                                                                       00381000
*                                                                       00382000
*        SYSUNLOD                                                       00383000
*        --------                                                       00384000
*                                                                       00385000
*        PURPOSE:                 UNLOAD AN EXTERNAL MODULE             00386000
*                                 (I.E. RELEASE CONTROL)                00387000
*                                                                       00388000
*        ENTRY PARAMETERS         (4)       ADDRESS OF MODULE NAME      00389000
*                                 (5)       NUMBER OF CHARS IN NAME     00390000
*                                                                       00391000
*        RESULT RETURNED:         NONE                                  00392000
*                                                                       00393000
*                                                                       00394000
*        SYSWRITE                                                       00395000
*        --------                                                       00396000
*                                                                       00397000
*        PURPOSE:                 WRITE A RECORD TO A FILE              00398000
*                                                                       00399000
*        ENTRY PARAMETERS:        (0)       POINTER TO DCB FOR FILE     00400000
*                                 (4)       ADDRESS OF RECORD           00401000
*                                 (5)       LENGTH OF RECORD (BYTES)    00402000
*                                 (6)       ADDRESS OF FORMAT STRING    00403000
*                                 (7)       LENGTH OF FORMAT (0 = NONE) 00404000
*                                                                       00405000
*        RESULT RETURNED:         ZERO IF TOO MANY RECORDS WRITTEN      00406000
*                                 ELSE UNCHANGED DCB POINTER            00407000
         TITLE 'OSINT -- OS INTERFACE -- NOTES ON I/O'                  00408000
*                                                                       00409000
*        ALL I/O IS DONE USING QSAM. ALL RECORD FORMATS ARE SUPPORTED.  00410000
*                                                                       00411000
*        A FILE IS OPENED WHEN THE FIRST READ OR WRITE OPERATION IS     00412000
*        PERFORMED (I.E. CALL TO SYSREAD OR SYSWRITE).                  00413000
*                                                                       00414000
*        IT IS NOT PERMISSIBLE TO SWITCH FROM READING TO WRITING OR     00415000
*        VICE VERSA WITHOUT FIRST REWINDING OR CLOSING THE FILE.        00416000
*                                                                       00417000
*        RECORDS EXCEEDING THE LRECL VALUE ARE SUBDIVIDED AS REQUIRED.  00418000
*        IN THE CASE OF FIXED LENGTH RECORDS, TRAILING BLANKS ARE       00419000
*        SUPPLIED AS REQUIRED.                                          00420000
*                                                                       00421000
*        ZERO LENGTH RECORDS MAY BE WRITTEN AND ARE HANDELED AS FOLLOWS 00422000
*        FIXED LENGTH             A BLANK RECORD IS WRITTEN             00423000
*        VARIABLE,UNDEFINED       A ONE BYTE RECORD X'00' IS WRITTEN    00424000
*                                                                       00425000
*        THE FOLLOWING POSSIBILITIES ARE RECOGNIZED FOR FILENAMES       00426000
*                                                                       00427000
*        DDNAME                   REFERS TO FILE WITH DDNAME GIVEN      00428000
*                                                                       00429000
*        INTEGER NN               REFERS TO FILE WITH DDNAME FTNNF001   00430000
*                                 WITH THE FOLLOWING SPECIAL EXCEPTIONS 00431000
*                                 05 -> SYSIN IF FT05F001 NOT GIVEN     00432000
*                                 06 -> SYSPRINT IF FT06F001 NOT GIVEN  00433000
*                                 07 -> SYSPUNCH IF FT07F001 NOT GIVEN  00434000
*                                                                       00435000
*        DDNAME(ELNAME)           FOR A PARTIONED DATASET, ELNAME IS A  00436000
*                                 MEMBER NAME. FOR A TAPE FILE, ELNAME  00437000
*                                 IS A SEQUENCE (FILE) NUMBER.          00438000
         TITLE 'OSINT -- OS INTERFACE -- MACRO DEFINITIONS'             00439000
*                                                                       00440000
*        MACRO TO IMPLEMENT ONE CHARACTER PARAMETERS (NUMERIC)          00441000
*        FIRST ARGUMENT = PARAMETER CHARACTER                           00442000
*        SECOND ARGUMENT IS ADDRESS WHERE VALUE IS TO BE STORED         00443000
*                                                                       00444000
         MACRO                                                          00445000
&LBL     PARAM &LTR,&ADDR                                               00446000
         CNOP  0,4                                                      00447000
&LBL     DC    C'&LTR',AL3(&ADDR-WORK)                                  00448000
         MEND                                                           00449000
*                                                                       00450000
*        COMMON ENTRY MACRO                                             00451000
*                                                                       00452000
         MACRO                                                          00453000
&NAME    ENTER                                                          00454000
         ENTRY &NAME                                                    00455000
&NAME    DS    0H                                                       00456000
         USING *,2                                                      00457000
         DROP  11,12                                                    00458000
         STM   0,15,SAVE1                                               00459000
         LM    11,12,=A(OSINT,OSINT+4096)                               00460000
         USING OSINT,11,12                                              00461000
         L     13,WORKLOC                                               00462000
         DROP  2                                                        00463000
         MEND                                                           00464000
*                                                                       00465000
*        XERR -- DEFINE ERROR CODE                                      00466000
*                                                                       00467000
         MACRO                                                          00468000
&NAME    XERR                                                           00469000
         GBLA  &ERRC                                                    00470000
&ERRC    SETA  &ERRC+1                                                  00471000
&NAME    BCTR  12,0                                                     00472000
         MEND                                                           00473000
         EJECT                                                          00474000
*                                                                       00475000
*        MACRO TO GENERATE MESSAGE LINES                                00476000
*                                                                       00477000
         MACRO                                                          00478000
&NAME    MSG   &TEXT                                                    00479000
         LCLA  &K                                                       00480000
&NAME    EQU   *                                                        00481000
&K       SETA  K'&TEXT-2                                                00482000
         DC    AL1(&K)                                                  00483000
         DC    C&TEXT                                                   00484000
         MEND                                                           00485000
*                                                                       00486000
*        MACRO TO PRINT A LINE GENERATE BY THE ABOVE MSG CALL           00487000
*                                                                       00488000
         MACRO                                                          00489000
&LABEL   PRT   &MESSAGE                                                 00490000
&LABEL   MVC   BUFR(70),&MESSAGE                                        00491000
         BAL   5,PRNTLNB                                                00492000
         MEND                                                           00493000
*                                                                       00494000
         GBLA  &ERRC              COUNT OF ERROR CODES                  00495000
&ERRC    SETA  0                  INITIALIZE ERROR COUNT                00496000
         PRINT NOGEN              NO GARBAGE PLEASE                     00497000
         TITLE 'OSINT -- OS INTERFACE -- DEFINITIONS'                   00498000
DEFS     DSECT ,                  START OF DEFINITIONS                  00499000
*                                                                       00500000
*        DEFINITIONS FOR RR BRANCH MENOMONICS                           00501000
*                                                                       00502000
E        EQU   8                  EUQAL                                 00503000
Z        EQU   8                  ZERO, ZEROS                           00504000
NE       EQU   7                  NOT EQUAL                             00505000
NZ       EQU   8                  NOT ZERO, NOT ZEROS                   00506000
O        EQU   1                  OVERFLOW, ONES                        00507000
NO       EQU   14                 NO OVERFLOW, NOT ONES                 00508000
P        EQU   2                  POSITIVE                              00509000
H        EQU   2                  HIGH                                  00510000
NP       EQU   13                 NOT POSITIVE                          00511000
NH       EQU   13                 NOT HIGH                              00512000
M        EQU   4                  MINUS                                 00513000
L        EQU   4                  LOW                                   00514000
NM       EQU   11                 NOT MINUS                             00515000
NL       EQU   11                 NOT LOW                               00516000
         TITLE 'OSINT -- OS INTERFACE -- INITIALIZATION'                00517000
*                                                                       00518000
*        ENTRY POINT FROM CONTROL PROGRAM                               00519000
*                                                                       00520000
OSINT    CSECT ,                  START OF INTERFACE                    00521000
         SAVE  (14,12)            SAVE ENTRY REGISTERS                  00522000
         USING OSINT,15           INITIAL BASE SET BY SYSTEM            00523000
         LM    11,12,=A(OSINT,OSINT+4096)   SET BASE REGS               00524000
         DROP  15                 DROP TEMPORARY BASE                   00525000
         USING OSINT,11,12        STANDARD BASE REG FOR INTERFACE       00526000
         L     4,0(,1)            GET ADDRESS OF EXEC PARAMETERS        00527000
         GETMAIN   R,LV=LWORK     GET SPACE FOR INTERFACE WORK AREA     00528000
         USING WORK,1             TEMPORARY BASE FOR WORK AREA          00529000
         XC    WORK(256),WORK               ZERO INTERFACE WORK AREA    00530000
         MVC   WORK+256(LWORK-256),WORK     . . . .                     00531000
         LA    5,FSTAKEND         GET END OF STACK ADDESS FOR FORMATS   00532000
         LA    6,FORMSTAK-4       BOTTOM OF STACK ADDRESS               00533000
         STM   5,6,FSTAKEND       INITIALIZE FORMAT STACK INFORMATION   00534000
         MVC   LIMS(LLIMS),LIMSINIT         SET INITIAL VALUE OF LIMITS 00535000
         ST    1,8(,13)           SET SAVE AREA FORWARD PTR             00536000
         OI    8+3(13),1          SET OUR SPECIAL SAVE AREA FLAG BIT    00537000
         ST    13,ENT13SV         SAVE POINTER TO PREVIOUS SAVE AREA    00538000
         LR    13,1               SET WORK ADDRESS IN CORRECT REGISTER  00539000
         USING WORK,13            TELL ASSEMBLER                        00540000
         USING IHADCB,10          REG TO POINT TO DCB'S                 00541000
         DROP  1                  DROP      TEMPORARY BASE              00542000
         EXTRN SYSSTART           MAIN PROGRAM ENTRY POINT              00543000
         MVC   STARTLOC,=A(SYSSTART)        SET IN WORK AREA FOR DUMPS  00544000
*                                                                       00545000
*        PROCESS PARAMETER FIELD                                        00546000
*                                                                       00547000
         LH    2,0(,4)            GET LENGTH OF PARAMETER FIELD         00548000
         LA    1,2(,4)            POINT TO FIRST PARAMETER CHARACTER    00549000
*                                                                       00550000
*        LOOP THROUGH PARAMETERS                                        00551000
*                                                                       00552000
PARLOOP  CH    2,=H'3'            INSIST ON AT LEAST THREE CHARACTERS   00553000
         BL    NOPARMS            IGNORE FIELD IF NOT THAT BIG          00554000
         MVC   PTYPE(1),0(1)      MOVE PARAMETER NAME                   00555000
         CLI   1(1),C'='          NEXT CHARACTER MUST BE =              00556000
         BNE   NOPARMS            IGNORE REST IF NOT                    00557000
         LA    1,2(,1)            POINT TO START OF NUMBER              00558000
         LR    3,1                COPY STARTING ADDRESS                 00559000
         SR    0,0                INITIALIZE RESULT TO ZERO             00560000
         SH    2,=H'2'            DECR COUNT OF CHARS LEFT FOR X=       00561000
*                                                                       00562000
*        LOOP TO CONVERT NUMBER                                         00563000
*                                                                       00564000
PARLOOP1 CLI   0(1),C','          COMMA FOR END OF PARAMETER?           00565000
         BE    PARFND             B IF END OF FIELD                     00566000
         CLI   0(1),C'K'          K FOR *1024 ?                         00567000
         BNE   PARLOOPN           SKIP IF NOT                           00568000
         SLL   0,10               ELSE MULTIPLY WHAT WE HAVE BY 1024    00569000
         B     PARLOOPE           JUMP TO END OF LOOP                   00570000
         EJECT                                                          00571000
*                                                                       00572000
*        HERE TO CHECK FOR A DIGIT                                      00573000
*                                                                       00574000
PARLOOPN CLI   0(1),C'0'          CHECK FOR NUMERIC                     00575000
         BL    NOPARMS            SKIP IF TOO LOW                       00576000
         MH    0,=H'10'           SHIFT PREVIOUS TOTAL                  00577000
         IC    9,0(,1)            LOAD DIGIT                            00578000
         N     9,=X'0000000F'     MASK DIGIT VALUE                      00579000
         AR    0,9                ADD TO WHAT WE HAVE ALREADY           00580000
*                                                                       00581000
*        HERE AT END OF LOOP                                            00582000
*                                                                       00583000
PARLOOPE LA    1,1(,1)            BUMP POINTER                          00584000
         BCT   2,PARLOOP1         DECR COUNT, LOOP IF MORE TO GO        00585000
*                                                                       00586000
*        COME HERE WITH PARAMETER VALUE CONVERTED IN (0)                00587000
*                                                                       00588000
PARFND   LA    9,PARMNO           GET NUMBER OF PARAMETERS IN TABLE     00589000
         LA    8,FSTPARM          GET START OF TABLE                    00590000
*                                                                       00591000
*        LOOP TO FIND PROPER PARAMETER                                  00592000
*                                                                       00593000
PELOOP   CLC   PTYPE,0(8)         IS THIS THE PARAMETER?                00594000
         BE    PENTRY             B IF FOUND                            00595000
         LA    8,4(,8)            POINT TO NEXT ENTRY                   00596000
         BCT   9,PELOOP           LOOP TO CHECK NEXT ENTRY              00597000
         B     NEXTPRM            IF NO MATCH, IGNORE THIS PARAMETER    00598000
*                                                                       00599000
*        HERE WE HAVE FOUND THE APPROPRIATE PARAMETER                   00600000
*                                                                       00601000
PENTRY   L     9,0(,8)            LOAD ADDRESS OFFSET OF PARAM VALUE    00602000
         ST    0,WORK(9)          STORE PARAMETER VALUE                 00603000
*                                                                       00604000
*        HERE TO MOVE TO NEXT PARAMETER                                 00605000
*                                                                       00606000
NEXTPRM  LA    1,1(,1)            SKIP PAST COMMA                       00607000
         BCT   2,PARLOOP          LOOP BACK IF WE HAD A COMMA           00608000
*                                                                       00609000
*        HERE AFTER PROCESSING PARAMS, ALLOCATE DYNAMIC MEMORY          00610000
*                                                                       00611000
NOPARMS  L     0,RESERV           MEMORY TO BE RESERVED TO SYSTEM       00612000
         GETMAIN R,LV=(0)         RESERVE SYSTEM SPACE                  00613000
         ST    1,RESERV0          SAVE ADDRESS OF AREA                  00614000
         MVC   MLIST(LGETLIST),GETLIST      MOVE GETMAIN LIST           00615000
         GETMAIN   LA=DYNALLOC,A=ALLOC,     ATTEMPT TO ALLOCATE IN LCS X00616000
               HIARCHY=1,MF=(E,MLIST)       . . . .                     00617000
         LTR   15,15              TEST RETURN CODE                      00618000
         BZ    ALLOCGO            SKIP IF LCS OBTAINED                  00619000
         GETMAIN   HIARCHY=0,MF=(E,MLIST)   IF NO LCS, GET NORMAL MEMRY 00620000
         EJECT                                                          00621000
*                                                                       00622000
*        COME HERE WITH MEMORY OBTAINED                                 00623000
*                                                                       00624000
ALLOCGO  LM    0,1,RESERV         GET LENGTH/ADDRESS OF SYSTEM AREA     00625000
         FREEMAIN  R,LV=(0),A=(1) FREE SYSTEM AREA                      00626000
         GETMAIN   R,LV=140       GET WORK BUFFER (ENOUGH FOR SYSPRINT) 00627000
         ST    1,OUTWBF           STORE POINTER TO BUFFER OBTAINED      00628000
         LA    1,140              GET LENGTH                            00629000
         STH   1,OUTWBFLN         STORE LENGTH OF WORK BUFFER           00630000
         LM    1,2,ALLOC          GET ADDRESS AND LENGTH ALLOCATED      00631000
         LR    8,1                COPY ADDRESS                          00632000
         USING DATA,8             TELL ASSEMBLER                        00633000
         ST    8,DATAPTR          STORE PTR TO DATA AREA IN OUR AREA    00634000
         ST    2,DATASIZE         STORE ALLOCATED LENGTH                00635000
         ST    13,WORKLOC         STORE PTR TO INTERFACE WORK AREA      00636000
*                                                                       00637000
*        NOW WE BUILD DCB'S FOR ALL DATASETS DEFINED BY DD CARDS        00638000
*                                                                       00639000
         MVC   MLIST(LEXTLIST),EXTLIST      MOVE EXTRACT LIST           00640000
         EXTRACT   TIOTLOC,MF=(E,MLIST)     GET TIOT ADDRESS            00641000
         SR    5,5                GET A ZERO                            00642000
         ST    5,PTRDCB           SET INITIAL DCB POINTER = 0           00643000
         L     6,TIOTLOC          POINT TO START OF TIOT                00644000
         USING TIOT,6             TELL ASSEMBLER                        00645000
*                                                                       00646000
*        LOOP THROUGH ENTRIES IN TIOT                                   00647000
*                                                                       00648000
TIOTLOOP C     5,TIOENTRY         IS THIS THE END OF THE LIST?          00649000
         BZ    ENDTIOTL           SKIP IF END OF LOOP                   00650000
         CLC   TIOEDDNM,=CL8' '   IS DDNAME BLANK (CONCATENATION)?      00651000
         BE    TIOTSKP            IF SO, DO NOT BOTHER TO BUILD DCB     00652000
         GETMAIN   R,LV=LMODDCB   ALLOCATE MEMORY FOR DCB               00653000
         LR    10,1               COPY POINTER                          00654000
         MVC   0(LMODDCB,10),MODDCB         MOVE MODEL DCB INTO PLACE   00655000
         MVC   DCBDDNAM,TIOEDDNM  COPY DDNAME INTO DCB                  00656000
         MVC   DDNAME,TIOEDDNM    SET OUR COPY OF DDNAME                00657000
         MVC   FILENAME(8),TIOEDDNM         SET DDNAME AS FILENAME      00658000
         L     1,PTRDCB           LOAD CURRENT CHAIN POINTER            00659000
         ST    1,DCBNEXT          STORE AS FORWARD POINTER              00660000
         ST    10,PTRDCB          STORE NEW HEADER PTR (THIS DCB)       00661000
*                                                                       00662000
*        HERE AFTER BUILDING DCB IF REQUIRED                            00663000
*                                                                       00664000
TIOTSKP  SR    0,0                CLEAR FOR IC                          00665000
         IC    0,TIOELNOH         LOAD LENGTH OF TIOT ENTRY             00666000
         AR    6,0                POINT TO NEXT ENTRY                   00667000
         B     TIOTLOOP           AND LOOP BACK                         00668000
         DROP  6                  DROP TIOT BASE REG                    00669000
         EJECT                                                          00670000
*                                                                       00671000
*        ALL DCBS ARE NOW BUILT, FIND SYSPRINT DCB AND FIX IT UP        00672000
*                                                                       00673000
ENDTIOTL LA    2,SYSDCB           POINT TO SYSTEM DCB LOCATE ROUTINE    00674000
         LA    4,=C'SYSPRINT'     POINT TO NAME OF PRINT FILE           00675000
         LA    5,8                NAME LENGTH = 8 CHARACTERS            00676000
         BALR  1,2                CALL ROUTINE TO LOCATE SYSPRINT DCB   00677000
         B     DDBOMB             ERROR IF NO SYSPRINT FILE             00678000
         LR    10,0               MOVE DCB PTR TO STANDARD REGISTER     00679000
         MVI   OFLAGS,PRINTER     SET SPECIAL FLAG FOR SYSPRINT         00680000
         MVC   DCBEXLST+1(3),=AL3(EXLPRT)   SET PROPER EXIT LIST ADDR   00681000
         ST    10,PRINTDCB        STORE ADDRESS OF DCB                  00682000
*                                                                       00683000
*        FIND SYSPUNCH DCB AND FIX IT UP                                00684000
*                                                                       00685000
         LA    4,=C'SYSPUNCH'     SET SYSPUNCH NAME (LENGTH IS SET)     00686000
         BALR  1,2                CALL ROUTINE TO LOCATE SYSPUNCH DCB   00687000
         B     DDBOMB             ERROR IF DD CARD MISSING              00688000
         LR    10,0               ELSE MOVE DCB PTR TO STANDARD REG     00689000
         MVI   OFLAGS,PUNCHER     SET SPECIAL SYSPUNCH FLAG             00690000
         MVC   DCBEXLST+1(3),=AL3(EXLPCH)   SET PROPER EXIT LIST ADDR   00691000
         ST    10,PUNCHDCB        STORE ADDRESS OF PUNCH DCB            00692000
*                                                                       00693000
*        FIND SYSIN DCB AND FIX IT UP                                   00694000
*                                                                       00695000
         LA    4,=CL8'SYSIN'      POINT TO SYSIN NAME (LENGTH = 8 SET)  00696000
         BALR  1,2                CALL ROUTINE TO LOCATE SYSIN DCB      00697000
         B     DDBOMB             ERROR IF MISSING DD CARD              00698000
         LR    10,0               SET DCB PTR IN STANDARD REG           00699000
         MVI   OFLAGS,READER      SET SPECIAL SYSIN FLAG                00700000
         MVC   DCBEXLST+1(3),=AL3(EXLRDR)   SET PROPER EXIT LIST ADDR   00701000
         ST    10,READDCB         STORE ADDRESS OF READER DCB           00702000
*                                                                       00703000
*        IF SYSOBJ FILE IS GIVEN, FIX IT UP                             00704000
*                                                                       00705000
         LA    4,=CL8'SYSOBJ'     POINT TO NAME (LENGTH=8 IS SET)       00706000
         BALR  1,2                CALL ROUTINE TO GET SYSOBJ DCB        00707000
         B     SETPCEX            SKIP IF FILE NOT GIVEN                00708000
         LR    10,0               ELSE SET DCB PTR IN STANDARD REG      00709000
         MVC   DCBEXLST+1(3),=AL3(EXLOBJ)   SET PROPER EXIT LIST ADDR   00710000
         EJECT                                                          00711000
*                                                                       00712000
*        SET PROPER PSW AND INTERRUPT INTERCEPT                         00713000
*                                                                       00714000
SETPCEX  SPIE  PCEXIT,((1,15))    GET CONTROL ON ALL INTERRUPTS         00715000
         SR    0,0                GET 0                                 00716000
         SPM   0                  MASK MASKABLE PC'S                    00717000
         ST    1,PICASAV          SAVE CALLER'S PICA ADDRESS            00718000
*                                                                       00719000
*        PRINT HEADING AND OTHER INFORMATION                            00720000
*                                                                       00721000
         EXTRN SYSHEAD            GAIN ACCESS TO HEADER                 00722000
         L     9,=A(SYSHEAD)      POINT TO HEADING                      00723000
*                                                                       00724000
*        LOOP TO PRINT SUPPLIED HEADING                                 00725000
*                                                                       00726000
HEADL    SR    6,6                CLEAR FOR IC                          00727000
         IC    6,0(,9)            LOAD LINE LENGTH                      00728000
         LTR   6,6                CHECK FOR END OF HEADERS              00729000
         BZ    HEAD2              SKIP IF END OF HEADERS                00730000
         EX    6,HEADMVC          MOVE HEADER TO PRINT BUFFER           00731000
         BAL   5,PRNTLNB          PRINT HEADING LINE FROM BUFFER        00732000
         LA    9,1(6,9)           POINT TO NEXT HEADER LINE             00733000
         B     HEADL              LOOP BACK                             00734000
*                                                                       00735000
HEADMVC  MVC   BUFR(*-*),0(9)     MOVE HEADER LINE TO BUFFER            00736000
*                                                                       00737000
*        HERE WHEN LINES OF HEADER HAVE BEEN PRINTED                    00738000
*                                                                       00739000
HEAD2    PRT   OSMSG              IDENTIFY SYSTEM AS OS                 00740000
         PRT   BLANKL             PRINT AN EXTRA BLANK LINE             00741000
         PRT   PARMHEAD           PRINT HEADER FOR PARAMS               00742000
         PRT   BLANKL             PRINT A BLANK LINE                    00743000
         LA    9,PARMNO           NUMBER OF PARAMETERS                  00744000
         LA    6,FSTPARM          POINT TO PARAMETER TABLE              00745000
         MVC   BUFR(28),PARMPRT   MOVE MODEL TO BUFFER                  00746000
*                                                                       00747000
*        LOOP TO PRINT PARAMETER VALUES                                 00748000
*                                                                       00749000
PARMPL   MVC   BUFR+2(1),0(6)     MOVE CHARACTER NAME                   00750000
         L     3,0(,6)            WORK OFFSET OF PARAM ADDRESS VALUE    00751000
         L     3,WORK(3)          LOAD PARAMETER VALUE                  00752000
         LA    2,BUFR+6           POINT TO CONVERT LOCATION             00753000
         BAL   7,CONVOUT          CONVERT NUMBER FOR OUTPUT             00754000
         BAL   5,PRNTLNB          PRINT BUFFER                          00755000
         LA    6,4(,6)            PUSH TO NEXT PARAMETER                00756000
         BCT   9,PARMPL           LOOP UNTIL ALL PARAMETERS PRINTED     00757000
         EJECT                                                          00758000
*                                                                       00759000
*        PRINT LENGTH OF MEMORY OBTAINED                                00760000
*                                                                       00761000
         PRT   BLANKL             PRINT A BLANK LINE                    00762000
         L     3,ALLOC+4          LENGTH ALLOCATED                      00763000
         MVC   BUFR(50),PRTMEM    MOVE MESSAGE TO BUFFER                00764000
         LA    2,BUFR+29          POINT TO CONVERT LOCATION             00765000
         BAL   7,CONVOUT          CONVERT IT                            00766000
         BAL   5,PRNTLNB          PRINT ALLOCATED MEMORY                00767000
         PRT   BLANKL             PRINT A BLANK LINE                    00768000
*                                                                       00769000
*        ACQUIRE BYTE FOR ALLOWING BATCHING (SYSBATCH)                  00770000
*                                                                       00771000
         EXTRN SYSBATCH           FLAG BYTE IS IN MAIN MODULE           00772000
         L     1,=A(SYSBATCH)     LOAD ADDRESS OF BYTE                  00773000
         MVC   BATCHFLG,0(1)      MOVE FLAG BYTE TO INTERFACE WORK AREA 00774000
*                                                                       00775000
*        CONVERT TIME LIMIT TO TIMER UNITS                              00776000
*                                                                       00777000
         L     1,TLIMIT           LOAD TIME LIMIT IN SECONDS            00778000
         M     0,=F'38400'        CONVERT TO TIMER UNITS           V2.3 00779000
         ST    1,TLIMIT           STORE BACK IN TIME LIMIT              00781000
*                                                                       00782000
*        NOW MAKE SURE WE HAVE ENOUGH ROOM                              00783000
*                                                                       00784000
         C     3,DYNAMIN          IS IT ENOUGH?                         00785000
         BNL   TFIXCHK            SKIP IF WE HAVE ROOM                  00786000
*                                                                       00787000
*        HERE IF WE HAVE INSUFFICIENT MEMORY                            00788000
*                                                                       00789000
         PRT   DYNAMSG            PRINT COMPLAINT                       00790000
         ABEND 200,DUMP           GIVE PROPER ABEND                     00791000
*                                                                       00792000
*        HERE IF WE ARE MISSING A DD CARD FOR A STANDARD SYSTEM FILE    00793000
*                                                                       00794000
DDBOMB   ABEND 400,DUMP           GIVE PROPER ABEND                     00795000
         EJECT                                                          00796000
*                                                                       00797000
*        HERE WE CHECK FOR POSSIBLE TF'S (TEMPORARY FIXES)              00798000
*                                                                       00799000
TFIXCHK  PRT   BLANKL             PRINT A BLANK LINE                    00800000
         SR    6,6                INITIALIZE OFFSET INTO TFIXES LIST    00801000
         LA    9,NFIXES           SET MAX POSSIBLE NUMBER OF FIXES      00802000
*                                                                       00803000
*        LOOP TO CHECK FOR FIXES                                        00804000
*                                                                       00805000
FIXLOOP  LH    3,TFIXES(6)        LOAD POSSIBLE TF NUMBER               00806000
         LTR   3,3                IS THIS ONE IN USE (APPLIED)?         00807000
         BZ    EFIXL              SKIP IF NOT                           00808000
         MVC   BUFR(39),TFIXMSG   IF SO, MOVE MESSAGE TO BUFFER         00809000
         LA    2,BUFR+17          POINT TO LOCATION FOR CONVERT         00810000
         BAL   7,CONVOUT          CONVERT CODE NUMBER                   00811000
         BAL   5,PRNTLNB          PRINT MESSAGE FROM BUFFER             00812000
*                                                                       00813000
*        HERE TO LOOP TO THE NEXT ONE                                   00814000
*                                                                       00815000
EFIXL    LA    6,2(,6)            BUMP POINTER                          00816000
         BCT   9,FIXLOOP          LOOP BACK IF MORE TO GO               00817000
         EJECT                                                          00818000
*                                                                       00819000
*        NOW CHECK FOR PAST CUTOFF DATE                                 00820000
*                                                                       00821000
         PACK  BUFR(3),DATECUT    PACK CUTOFF DATE                      00822000
         LA    2,0                GET ZERO                              00823000
         L     2,16(,2)           LOAD ADDRESS OF CVT                   00824000
         CP    56+1(3,2),BUFR(3)  COMPARE DATES                         00825000
         B     DATECK             SKIP IF OK           ALWAYS OK - V2.3 00826000
*                                                                       00827000
*        HERE WE HAVE EXCEEDED THE CUTOFF DATE -- TELL HIM              00828000
*                                                                       00829000
         PRT   EXPIRE             PRINT EXPIRATION MESSAGE              00830000
         ABEND 111                GIVE A FUNNY ABEND                    00831000
*                                                                       00832000
*        HERE WE RECOMPUTE THE DATE CHECK DIGIT                         00833000
*                                                                       00834000
DATECK   SR    0,0                CLEAR ACCUMULATOR                     00835000
         IC    1,DATECUT          FIRST DIGIT                           00836000
         AR    0,1                ADD IT IN                             00837000
         IC    1,DATECUT+1        SECOND DIGIT                          00838000
         AR    0,1                ADD IT IN                             00839000
         IC    1,DATECUT+2        THIRD DIGIT                           00840000
         AR    0,1                ADD IT IN                             00841000
         IC    1,DATECUT+3        FOURTH DIGIT                          00842000
         AR    0,1                ADD IT IN                             00843000
         IC    1,DATECUT+4        FIFTH DIGIT                           00844000
         AR    0,1                ADD IT IN                             00845000
         STC   0,CKDIGITC         STORE FOR LATER CHECK                 00846000
         B     NEWJOB             JUMP TO START NEW JOB                 00847000
         EJECT                                                          00848000
*                                                                       00849000
*        CONVOUT                  CONVERT NUMBER FOR OUTPUT             00850000
*                                                                       00851000
*        (2)                      OUTPUT LOCATION                       00852000
*        (3)                      NUMBER TO CONVERT                     00853000
*        BAL   7,CONVOUT                                                00854000
*                                                                       00855000
CONVOUT  MVC   0(11,2),=X'2020202020202020202120' SET EDIT PATTERN      00856000
         CVD   3,SAVE2            CONVERT ARGUMENT TO DECIMAL           00857000
         LA    1,10(,2)           PRESET REGISTER 1 IN CASE NO SIGCHR   00858000
         EDMK  0(11,2),SAVE2+2    EDIT TO CHARACTERS                    00859000
         BNM   *+10               SKIP IF NON-NEGATIVE                  00860000
         BCTR  1,0                POINT BEHIND CONVERTED NUMBER         00861000
         MVI   0(1),C'-'          AND SET NEGATIVE SIGN                 00862000
         MVC   0(11,2),0(1)       LEFT JUSTIFY                          00863000
         BR    7                  RETURN TO CALLER                      00864000
*                                                                       00865000
*        ROUTINE TO PRINT A LINE FROM THE PRINT BUFFER                  00866000
*                                                                       00867000
*        BUFR                     ONE BYTE COUNT OF DATA CHARS          00868000
*        BUFR+1 -- BUFR+N         DATA CHARACTERS FOR PRINT LINE        00869000
*        BAL   5,PRNTLNB          CALL TO PRINT LINE                    00870000
*                                                                       00871000
PRNTLNB  STM   5,7,PRNSAVE        SAVE WORK REGS                        00872000
         SR    5,5                CLEAR FOR IC                          00873000
         IC    5,BUFR             LOAD LENGTH OF IMAGE                  00874000
         LA    4,BUFR+1           POINT TO DATA CHARACTERS              00875000
         SR    7,7                SET FORMAT LENGTH = 0 (UNFORMATTED)   00876000
         L     0,PRINTDCB         LOAD POINTER TO PRINTER DCB           00877000
         LA    2,SYSWRITE         POINT TO SYSTEM WRITE ROUTINE         00878000
         BALR  1,2                CALL SYSTEM OUTPUT ROUTINE            00879000
         NOP   0                  ERROR RETURN ON SYSPRINT NOT ALLOWED  00880000
         LM    5,7,PRNSAVE        RESTORE REGS                          00881000
         BR    5                  RETURN TO CALLER                      00882000
*                                                                       00883000
*        TABLE OF PARAMETERS                                            00884000
*                                                                       00885000
FSTPARM  PARAM L,DYNAMIN          MINIMUM DYNAMIC CORE                  00886000
         PARAM H,DYNAMAX          MAXIMUM DYNAMIC CORE                  00887000
         PARAM R,RESERV           RESERVED DYNAMIC CORE                 00888000
         PARAM C,CLIMIT           CARD LIMIT                            00889000
         PARAM P,PLIMIT           PAGE LIMIT                            00890000
         PARAM T,TLIMIT           TIME LIMIT                            00891000
         PARAM D,DLIMIT           DUMP LIMIT                            00892000
         PARAM N,PAGEDPTH         NUMBER OF LINES PER PAGE              00893000
         PARAM I,INTVAL           INTERRUPT TYPE INDICATOR              00894000
PARMNO   EQU   (*-FSTPARM)/4      CALC NUMBER OF PARAMETERS IN TABLE    00895000
         EJECT                                                          00896000
*                                                                       00897000
*        MESSAGES                                                       00898000
*                                                                       00899000
OSMSG    MSG   '0SYSTEM = OS/360'                                       00900000
PARMHEAD MSG   '0PARAMETER VALUES FOR THIS RUN'                         00901000
PARMPRT  MSG   ' X = XXXXXXXXXXX          '                             00902000
PRTMEM   MSG   '0DYNAMIC MEMORY AVAILABLE = XXXXXXXXXXX         '       00903000
DYNAMSG  MSG   '0INADEQUATE DYNAMIC MEMORY -- RUN TERMINATED'           00904000
TFIXMSG  MSG   ' TF APPLIED 2.3.XXXXXXXXXXX            '           V2.3 00905000
         ORG   TFIXMSG                                             V2.3 00905010
         DC    X'14'                                               V2.3 00905020
         ORG   ,                                                   V2.3 00905030
BLANKL   MSG   ' '                                                      00906000
HEDM0    MSG   '1INTERNAL SYSTEM ERROR ABORT'                           00907000
HEDM1    MSG   '0DUMP OF INTERFACE WORK AREA'                           00908000
HEDM2    MSG   '1DUMP OF ALLOCATED DATA AREA'                           00909000
EXPIRE   MSG   '0TRIAL PERIOD OVER, RETURN SYSTEM TO AUTHOR'            00910000
*                                                                       00911000
         LTORG ,                  LITERALS FOR INITIALIZATION CIRCUIT   00912000
         TITLE 'OSINT -- OS INTERFACE -- INITIATE NEW JOB'              00913000
*                                                                       00914000
*        COME HERE TO INITIATE NEW JOB                                  00915000
*                                                                       00916000
NEWJOB   MVI   EOFLAG,0           RESET EOF FLAGS, SET NO DATA READ YET 00917000
         L     10,READDCB         LOAD POINTER TO SYSIN DCB             00918000
         NI    OFLAGS,X'FF'-EOFE  CLEAR POSSIBLE END OF FILE FLAG       00919000
         MVC   PGDEPTH,PAGEDPTH   MOVE PAGE DEPTH TO DATA AREA          00920000
         MVC   INTFLAG,INTVAL     MOVE INTERRUPT FLAG TO DATA AREA      00921000
         L     10,PRINTDCB        POINT TO SYSPRINT DCB                 00922000
         L     1,PLIMIT           GET PAGE LIMIT                        00923000
         M     0,PAGEDPTH         CONVERT TO LINE (RECORD) LIMIT        00924000
         ST    1,MAXRECW          STORE IN SYSPRINT DCB                 00925000
         L     10,PUNCHDCB        POINT TO SYSPUNCH DCB                 00926000
         MVC   MAXRECW,CLIMIT     SET LIMIT ON CARDS IN SYSPUNCH DCB    00927000
         MVC   TSTART,TLIMIT      SAVE INITIAL TIME (SEE SYSTIME)       00928000
*                                                                       00929000
*        CLEAR ALLOCATED DATA AREA TO ZEROS                             00930000
*                                                                       00931000
         SDR   0,0                GET DOUBLE WORD ZERO                  00932000
         LA    2,USERD            POINT TO USER SECTION OF DATA AREA    00933000
         L     3,DATASIZE         LENGTH OF AREA                        00934000
         SH    3,=Y(USERD-DATA)   ADJUST FOR OUR STUFF AT START         00935000
         LA    4,USERD-24(3)      POINT TO LAST 24 BYTES OF AREA        00936000
         XC    0(24,4),0(4)       ZERO LAST 24 BYTES                    00937000
         SRL   3,5                /32 = NUMBER OF LOOPS                 00938000
*                                                                       00939000
*        LOOP TO CLEAR 32 BYTES AT A TIME                               00940000
*                                                                       00941000
CLEARC   STD   0,0(,2)            CLEAR 32 BYTES WITH FAST STD          00942000
         STD   0,8(,2)            . . . .                               00943000
         STD   0,16(,2)           . . . .                               00944000
         STD   0,24(,2)           . . . .                               00945000
         LA    2,32(,2)           PUSH ADDRESS                          00946000
         BCT   3,CLEARC           LOOP BACK TILL ALL CLEARED            00947000
*                                                                       00948000
*        NOW SET TIMER AND INITIATE RUN                                 00949000
*                                                                       00950000
         STIMER TASK,OVERTIME,TUINTVL=TLIMIT SET PROPER TIME LIMIT      00951000
         L     15,=V(SYSSTART)    POINT TO MAIN PROGRAM ENTRY POINT     00952000
         ST    15,STARTADR        STORE ADDRESS OF SYSSTART             00953000
         CLC   CKDIGIT,CKDIGITC   CHECK DATE CHECK DIGIT                00954000
         BR    15                 OFF TO EXECUTE IF OK   ALWAYS OK V2.3 00955000
*                                                                       00956000
*        HERE HE HAS FIDDLED WITH THE DATE, GIVE A NASTY BOMB           00957000
*                                                                       00958000
         LM    0,15,2000(8)       CLEAR ALL REGS TO ZEROS               00959000
         BR    15                 JUMP TO LOCATION ZERO                 00960000
         TITLE 'OSINT -- OS INTERFACE -- SYSDATE'                       00961000
*                                                                       00962000
*        OBTAIN DATE IN MM/DD/YY FORMAT                                 00963000
*                                                                       00964000
*        ENTRY CONDITIONS                                               00965000
*                                                                       00966000
*        NO PARAMETERS PASSED                                           00967000
*                                                                       00968000
*        EXIT CONDITIONS                                                00969000
*                                                                       00970000
*        (0)                      POINTER TO DATE MM/DD/YY              00971000
*                                                                       00972000
*        ERROR CODES RETURNED                                           00973000
*                                                                       00974000
*        NONE                                                           00975000
*                                                                       00976000
SYSDATE  ENTER ,                  ENTRY POINT                           00977000
         TIME  ,                  GET DATE IN YY/DDD FORM               00978000
         ST    1,SAVE2+8          SAVE VALUE TO WORK WITH IT            00979000
         ZAP   SAVE2(8),SAVE2+10(2)         MOVE IN DDD+SIGN, CLEAR     00980000
         CVB   0,SAVE2            BINARY DAY TO (0)                     00981000
         SRL   1,4*3              RIGHT JUSTIFY YY + GARBAGE DIGIT      00982000
         ST    1,SAVE2+4          STORE YY                              00983000
         OI    SAVE2+7,X'0F'      MAKE GARBAGE DIGIT A PLUS SIGN        00984000
         CVB   1,SAVE2            BINARY YEARS TO (1)                   00985000
         LR    3,1                SAVE YEAR FOR LATER                   00986000
         L     5,=X'CEEFBB00'     LOAD BIT MASK FOR MONTH LENGTHS       00987000
         N     1,=X'00000003'     GET 4'S RESIDUE FOR LEAP YEAR TEST    00988000
         BNZ   *+8                SKIP IF NOT LEAP YEAR                 00989000
         O     5,=X'10000000'     SET FEB DAYS = 29 IN MONTH MASK       00990000
         SR    2,2                INITIALIZE MONTHS REGISTER            00991000
*                                                                       00992000
*        NOW LOOP THROUGH MONTHS -- IN THE BIT MASK, EACH MONTH HAS     00993000
*        TWO BITS -- ADDING THESE BITS TO 28 GIVES THE LENGTH           00994000
*                                                                       00995000
MONTHL   LA    2,1(,2)            BUMP COUNT OF MONTHS                  00996000
         SR    4,4                CLEAR DAYS IN MONTH REGISTER          00997000
         SLDL  4,2                SHIFT IN ADJUSTING BITS               00998000
         LA    4,28(,4)           ADD STANDARD BASE                     00999000
         SR    0,4                CRANK DAYS DOWN                       01000000
         BP    MONTHL             AND LOOP BACK IF MORE TO GO           01001000
         AR    0,4                ELSE REPAIR DAYS COUNT & MERGE        01002000
*                                                                       01003000
*        EXIT POINT -- HERE WE ARE ALL SET WITH MONTH IN (2) DAY IN (0) 01004000
*                                                                       01005000
         MH    2,=H'100'          MM*100                                01006000
         AR    2,0                MM*100+DD                             01007000
         MH    2,=H'100'          MM*10000+DD*100                       01008000
         AR    2,3                MM*10000+DD*100+YY                    01009000
         CVD   2,SAVE2            CONVERT TO DECIMAL                    01010000
         MVC   DATE,DATEPAT       MOVE DATE EDIT PATTERN INTO PLACE     01011000
         ED    DATE,SAVE2+4       EDIT TO MM/DD/YY FORM                 01012000
         LA    0,DATE+2           POINT TO DATE                         01013000
         B     EXIT0              EXIT PRESERVING (0) = ADDRESS OF DATE 01014000
*                                                                       01015000
DATEPAT  DC    X'F0212020612020612020'      EDIT PATTERN FOR DATE       01016000
         TITLE 'OSINT -- OS INTERFACE -- SYSLOAD'                       01017000
*                                                                       01018000
*        LOAD A MODULE                                                  01019000
*                                                                       01020000
*        ENTRY CONDITIONS                                               01021000
*                                                                       01022000
*        (4)                      ADDRESS OF MODULE NAME                01023000
*                                                                       01024000
*        (5)                      LENGTH OF MODULE NAME                 01025000
*                                                                       01026000
*        EXIT CONDITIONS                                                01027000
*                                                                       01028000
*        (0)                      ADDRESS OF LOADED CODE                01029000
*                                                                       01030000
*        ERROR CODES RETURNED                                           01031000
*                                                                       01032000
*        E$MODN                   MODULE NAME LONGER THAN 8 CHARS       01033000
*        E$LIOE                   I/O ERROR DURING LOAD                 01034000
*        E$LNFN                   ENTRY NOT FOUND                       01035000
*                                                                       01036000
SYSLOAD  ENTER ,                  ENTRY POINT                           01037000
         LA    7,E$MODN           SET PROPER ERROR IN CASE > 8 CHARS    01038000
         BAL   2,GETNAME          MOVE MODULE NAME TO 'NAME'            01039000
         MVC   BLDLIST(4),=X'0001003A'      SET 1 ENTRY, LENGTH = 58    01040000
         LR    3,0                COPY PARAMETER ADDRESS                01041000
         BLDL  0,BLDLIST          SEARCH DIRECTORY                      01042000
         SH    15,=H'4'           TEST RETURN CODE                      01043000
*                                                                       01044000
*        CHECK HERE FOR ERROR                                           01045000
*                                                                       01046000
         BZ    E$LNFN             B IF NOT FOUND                        01047000
         BP    E$LIOE             ELSE I/O ERROR                        01048000
*                                                                       01049000
*        HERE IF WE FOUND THE ENTRY                                     01050000
*                                                                       01051000
LODER1   LOAD  DE=NAME            LOAD THE MODULE                       01052000
         B     EXIT0              EXIT PRESERVING (0) = CODE ADDRESS    01053000
         TITLE 'OSINT -- OS INTERFACE -- SYSUNLOD'                      01054000
*                                                                       01055000
*        UNLOAD A LOAD MODULE                                           01056000
*                                                                       01057000
*        ENTRY CONDITIONS                                               01058000
*                                                                       01059000
*        (4)                      POINTER TO MODULE NAME                01060000
*                                                                       01061000
*        (5)                      LENGTH OF MODULE NAME                 01062000
*                                                                       01063000
*        EXIT CONDITIONS                                                01064000
*                                                                       01065000
*        NO RESULTS RETURNED                                            01066000
*                                                                       01067000
*        ERROR CODES RETURNED                                           01068000
*                                                                       01069000
*        E$DELE                   MODULE NOT CURRENTLY LOADED           01070000
*        E$MODN                   MODULE NAME LONGER THAN 8 CHARS       01071000
*                                                                       01072000
SYSUNLOD ENTER ,                  ENTRY POINT                           01073000
         LA    7,E$MODN           SET MESSAGE IN CASE NAME LENGTH > 8   01074000
         BAL   2,GETNAME          ACQUIRE NAME                          01075000
         DELETE EPLOC=NAME        RELEASE THE MODULE                    01076000
         LTR   15,15              TEST RETURN CODE                      01077000
         BZ    EXIT               SUCCESS RETURN IF OK                  01078000
         B     E$DELE             ELSE ERROR RETURN                     01079000
         TITLE 'OSINT -- OS INTERFACE -- SYSPHASE'                      01080000
*                                                                       01081000
*        LOAD A PHASE IN A MULTIPHASE ENVIRONMENT                       01082000
*                                                                       01083000
*        ENTRY CONDITIONS                                               01084000
*                                                                       01085000
*        (0)                      CONTAINS VCON FOR PHASE               01086000
*                                                                       01087000
*        (4)                      POINTS TO 8 CHARACTER PHASE NAME      01088000
*                                                                       01089000
*        EXIT CONDITIONS                                                01090000
*                                                                       01091000
*        REQUESTED PHASE LOADED                                         01092000
*                                                                       01093000
*        ERROR CODES RETURNED                                           01094000
*                                                                       01095000
*        NONE                                                           01096000
*                                                                       01097000
*        THE PHASE NAME IS NOT REQUIRED IN OS. IT IS INCLUDED IN THE    01098000
*        CALLING SEQUENCE FOR USE IN OTHER SYSTEMS (E.G. DOS/360)       01099000
*                                                                       01100000
SYSPHASE ENTER ,                  ENTRY POINT                           01101000
         LR    1,0                COPY VCON TO OS PARAMETER REGISTER    01102000
         LA    0,1                INDICATE SEGWT                        01103000
         SVC   37                 ISSUE SEGWT SVC                       01104000
         B     EXIT               RETURN TO CALLER                      01105000
         TITLE 'OSINT -- OS INTERFACE -- SYSSETP'                       01106000
*                                                                       01107000
*        INFORM INTERFACE OF CHANGE IN DATA AREA POINTER                01108000
*                                                                       01109000
*        ENTRY CONDITIONS                                               01110000
*                                                                       01111000
*        (8)                      POINTS TO NEW DATA AREA               01112000
*                                                                       01113000
*        EXIT CONDITIONS                                                01114000
*                                                                       01115000
*        NO RESULTS RETURNED                                            01116000
*                                                                       01117000
*        ERROR CODES RETURNED                                           01118000
*                                                                       01119000
*        NONE                                                           01120000
*                                                                       01121000
*        THIS ENTRY POINT IS USED IF THE EXECUTING PROGRAM WISHES TO    01122000
*        REGARD SOME OTHER AREA THAN THE ALLOCATED DYNAMIC AREA AS      01123000
*        THE DATA REGION USED FOR COMMUNICATION WITH THE INTERFACE.     01124000
*        BEFORE THIS ROUTINE IS CALLED. THE CALLER MUST COPY ALL THE    01125000
*        STANDARD INFORMATION FROM THE START OF THE ORIGINAL DATA       01126000
*        AREA ALLOCATED BY THE INTERFACE INTO THE NEW AREA.             01127000
*                                                                       01128000
SYSSETP  ENTER ,                  ENTRY POINT                           01129000
         ST    8,DATAPTR          STORE NEW DATA AREA POINTER           01130000
         B     EXIT               RETURN TO CALLER                      01131000
         TITLE 'OSINT -- OS INTERFACE -- SYSDCB'                        01132000
*                                                                       01133000
*        LOCATE DCB FOR GIVEN FILENAME                                  01134000
*                                                                       01135000
*        ENTRY CONDITIONS                                               01136000
*                                                                       01137000
*        (4)                      POINTER TO FILENAME                   01138000
*        (5)                      LENGTH OF FILENAME                    01139000
*                                                                       01140000
*        EXIT CONDITIONS                                                01141000
*                                                                       01142000
*        (0)                      POINTER TO DCB                        01143000
*                                                                       01144000
*        ERROR CODES RETURNED                                           01145000
*                                                                       01146000
*        E$MSDD                   MISSING DD CARD                       01147000
*        E$FILG                   ILLEGAL FILENAME                      01148000
*                                                                       01149000
SYSDCB   ENTER ,                  ENTRY POINT                           01150000
         LA    7,E$FILG           SET ERROR MESSAGE IF BAD NAME         01151000
         BAL   2,GETNAME          ASSEMBLE FILENAME                     01152000
         L     10,PTRDCB          POINT TO FIRST DCB                    01153000
*                                                                       01154000
*        LOOP TO CHECK FOR DCB WITH MATCHING NAME                       01155000
*                                                                       01156000
SYSDCBL  LTR   0,10               COPY AND TEST POINTER                 01157000
         BZ    E$MSDD             MISSING DD CARD IF AT END OF CHAIN    01158000
         CLC   NAME(8),FILENAME   ELSE COMPARE NAMES                    01159000
         BE    EXIT0              EXIT WITH DCB PTR SET IF MATCH        01160000
         L     10,DCBNEXT         ELSE POINT TO NEXT DCB ON CHAIN       01161000
         B     SYSDCBL            AND LOOP BACK TO CHECK NEXT           01162000
         TITLE 'OSINT -- OS INTERFACE -- SYSMAXL'                       01163000
*                                                                       01164000
*        GET MAXIMUM RECORD LENGTH FOR INPUT RECORD                     01165000
*                                                                       01166000
*        ENTRY CONDITIONS                                               01167000
*                                                                       01168000
*        (0)                      POINTER TO DCB                        01169000
*                                                                       01170000
*        EXIT CONDITIONS                                                01171000
*                                                                       01172000
*        (0)                      MAXIMUM LENGTH OF DATA RECORD         01173000
*                                                                       01174000
*        ERROR CODES RETURNED                                           01175000
*                                                                       01176000
*        NONE                                                           01177000
*                                                                       01178000
SYSMAXL  ENTER ,                  ENTRY POINT                           01179000
         LR    10,0               COPY DCB POINTER                      01180000
         LH    0,MAXRECL          LOAD MAX DATA RECORD LENGTH           01181000
         TM    OFLAGS,OPENI       MAKE SURE WE ARE OPEN FOR INPUT       01182000
         BO    EXIT0              RETURN WITH RESULT IN (0) IF SO       01183000
*                                                                       01184000
*        IF NOT OPEN FOR INPUT WE MUST OPEN THE FILE FIRST              01185000
*                                                                       01186000
         TM    OFLAGS,OPENO       ARE WE OPEN FOR OUTPUT?               01187000
         BO    E$READ             GIVE ERROR RETURN IF SO               01188000
         MVC   MLIST(LOPNLIST),OPNLIST      MOVE LIST INTO PLACE        01189000
         OPEN  ((10),INPUT),MF=(E,MLIST)    EXECUTE OPEN                01190000
         TM    DCBOFLGS,OPENOK    WAS OPEN SUCESSFUL?                   01191000
         BZ    E$OPNI             GIVE ERROR IF NOT                     01192000
         OI    OFLAGS,OPENI       ELSE SET OPEN FOR INPUT FLAG          01193000
         LH    0,MAXRECL          LOAD MAX DATA RECORD LENGTH           01194000
         B     EXIT0              RETURN RESULT IN REG (0)              01195000
         TITLE 'OSINT -- OS INTERFACE -- SYSREAD'                       01196000
*                                                                       01197000
*        READ A RECORD                                                  01198000
*                                                                       01199000
*        CALLING CONDITIONS                                             01200000
*                                                                       01201000
*        (0)                      POINTER TO SPITBOL DCB                01202000
*        (4)                      POINTER TO BUFFER TO RECEIVE RECORD   01203000
*                                                                       01204000
*        EXIT CONDITIONS                                                01205000
*                                                                       01206000
*        (0)                      LENGTH OF RECORD ACTUALLY READ        01207000
*                                 SET TO ZERO FOR A NULL RECORD         01208000
*                                 SET NEGATIVE FOR END OF FILE          01209000
*                                                                       01210000
*        ERROR CODES RETURNED                                           01211000
*                                                                       01212000
*        E$READ                   FILE OPENED FOR OUTPUT                01213000
*        E$EOFR                   PREVIOUS END OF FILE ENCOUNTERED      01214000
*        E$IERR                   PERMANENT INPUT ERROR                 01215000
*        E$NOIN                   ATTEMPTED READ FROM WRITE ONLY FILE   01216000
*        E$OPNI                   ERROR IN OPENING FILE FOR INPUT       01217000
*                                                                       01218000
SYSREAD  ENTER ,                  ENTRY POINT                           01219000
         LR    10,0               COPY POINTER TO DCB INTO PROPER REG   01220000
         TM    OFLAGS,OPENI       ARE WE OPEN FOR INPUT?                01221000
         BO    SYSREAD2           SKIP IF SO                            01222000
         TM    OFLAGS,OPENO       ARE WE OPEN FOR OUTPUT?               01223000
         BO    E$READ             GIVE ERROR IF FILE OPENED FOR OUTPUT  01224000
*                                                                       01225000
*        HERE TO OPEN FILE FOR INPUT                                    01226000
*                                                                       01227000
SYSREAD1 MVC   MLIST(LOPNLIST),OPNLIST      MOVE LIST INTO PLACE        01228000
         OPEN  ((10),INPUT),MF=(E,MLIST)    EXECUTE OPEN                01229000
         TM    DCBOFLGS,OPENOK    WAS OPEN SUCCESSFUL?                  01230000
         BZ    E$OPNI             GIVE ERROR IF NOT                     01231000
         OI    OFLAGS,OPENI       SET OPEN FOR INPUT FLAG               01232000
*                                                                       01233000
*        HERE WITH FILE OPEN FOR INPUT                                  01234000
*                                                                       01235000
SYSREAD2 TM    OFLAGS,EOFE        PREVIOUS END OF FILE                  01236000
         BO    E$EOFR             GIVE ERROR MSG IF SO                  01237000
*                                                                       01238000
*        HERE TO MOVE THE RECORD                                        01239000
*                                                                       01240000
SYSREAD3 MVI   REREAD,0           RESET FLAG FOR REREAD                 01241000
         TM    DCBRECFM,F         CHECK RECORD FORMAT                   01242000
         BZ    SYSREADV           SKIP IF RECORD IS VARIABLE LENGTH     01243000
         GET   (10),(4)           TRANSMIT RECORD                       01244000
         CLI   REREAD,0           MUST WE REREAD                        01245000
         BNZ   SYSREAD3           LOOP BACK IF SO                       01246000
         EJECT                                                          01247000
*                                                                       01248000
*        HERE FOR F AND U TYPE RECORDS                                  01249000
*                                                                       01250000
         LH    0,DCBLRECL         LOAD RECORD LENGTH                    01251000
*                                                                       01252000
*        HERE TO EXIT WITH CHECK FOR ./* EOF ON SYSIN                   01253000
*                                                                       01254000
SYSREADX TM    OFLAGS,READER      STANDARD READ FILE?                   01255000
         BNO   SYSREADZ           SKIP IF NOT                           01256000
         CH    0,=H'80'           CHECK FOR RECORD TOO LONG ON SYSIN    01257000
         BH    E$SSIN             GIVE ERROR IF SO                      01258000
         CLI   BATCHFLG,0         IS BATCHING ALLOWED?                  01259000
         BE    SYSREADZ           SKIP IF NOT                           01260000
         CLC   0(3,4),=C'./*'     ELSE TEST FOR TEMPORARY EOF ON READER 01261000
         BNE   SYSREADZ           SKIP IF NOT                           01262000
         OI    EOFLAG,TEMPEOF     IF SO, SET FLAG                       01263000
         TM    EOFLAG,DATAIN      DID WE READ ANYTHING?                 01264000
         BNO   NEWJOB             IF NOT, SKIP TO IGNORE NULL PROGRAM   01265000
         B     EOF1               AND MERGE WITH EOF CIRCUIT            01266000
*                                                                       01267000
*        HERE FOR VARIABLE LENGTH RECORD                                01268000
*                                                                       01269000
SYSREADV SH    4,=H'4'            POINT 4 BYTES BEHIND RECORD           01270000
         MVC   SAVEBF,0(4)        SAVE CHARS THERE NOW                  01271000
         GET   (10),(4)           TRANSMIT V TYPE RECORD                01272000
         MVC   SAVE2(2),0(4)      MOVE RECORD LENGTH                    01273000
         MVC   0(4,4),SAVEBF      RESTORE 4 BYTES BEFORE BUFFER         01274000
         LA    4,4(,4)            POINT TO DATA                         01275000
         CLI   REREAD,0           MUST WE REREAD?                       01276000
         BNZ   SYSREAD3           LOOP BACK IF SO                       01277000
         LH    0,SAVE2            LOAD RECORD LENGTH                    01278000
         SH    0,=H'4'            GET LENGTH OF DATA BYTES              01279000
         CH    0,=H'1'            CHECK FOR ONE CHARACTER RECORD        01280000
         BH    SYSREADX           JUMP IF NOT 1 CHAR RECORD             01281000
         CLI   0(4),X'00'         IF SO, IS IT HEX ZERO RECORD?         01282000
         BNE   SYSREADZ           SKIP IF NOT                           01283000
         SR    0,0                ELSE TREAT 1 CHAR X'00' AS NULL       01284000
*                                                                       01285000
*        HERE TO RETURN TO CALLER                                       01286000
*                                                                       01287000
SYSREADZ OI    EOFLAG,DATAIN      RECORD SOME DATA HAS BEEN READ        01288000
         B     EXIT0              EXIT TO CALLER                        01289000
         TITLE 'OSINT -- OSINTERFACE -- SYSWRITE'                       01290000
*                                                                       01291000
*        WRITE A RECORD                                                 01292000
*                                                                       01293000
*        CALLING CONDITIONS --                                          01294000
*                                                                       01295000
*        (0)                      POINTER TO SPITBOL DCB                01296000
*        (4)   SADR               ADDRESS OF STRING TO BE WRITTEN       01297000
*        (5)   SLEN               LENGTH OF STRING TO BE WRITTEN        01298000
*        (6)   FADR               ADDRESS OF FORMAT (UNUSED IF FLEN=0)  01299000
*        (7)   FLEN               LENGTH OF FORMAT STRING               01300000
*                                                                       01301000
*        ERROR CODE RETURNED                                            01302000
*                                                                       01303000
*        E$WRIT                   FILE OPENED FOR INPUT                 01304000
*        E$OERR                   PERMANENT OUTPUT ERROR                01305000
*        E$NOUT                   ATTEMPTED WRITE TO READ ONLY FILE     01306000
*        E$OPNO                   ERROR IN OPENING FILE FOR OUTPUT      01307000
*                                                                       01308000
SYSWRITE ENTER ,                  ENTRY POINT                           01309000
         LR    10,0               COPY DCB POINTER                      01310000
         TM    OFLAGS,OPENO       ARE WE OPEN FOR OUTPUT?               01311000
         BO    SYSWRIT1           SKIP IF SO                            01312000
         TM    OFLAGS,OPENI       ARE WE OPEN FOR INPUT?                01313000
         BO    E$WRIT             GIVE ERROR MESSAGE IF SO              01314000
*                                                                       01315000
*        HERE TO OPEN FILE FOR OUTPUT                                   01316000
*                                                                       01317000
SYSWRIT0 MVC   MLIST(LOPNLIST),OPNLIST      MOVE OPEN PARAMETER LIST    01318000
         OPEN  ((10),OUTPUT),MF=(E,MLIST)   EXECUTE OPEN                01319000
         TM    DCBOFLGS,OPENOK    WAS OPEN SUCCESSFUL?                  01320000
         BZ    E$OPNO             GIVE ERROR IF NOT                     01321000
         OI    OFLAGS,OPENO       SET OPEN FOR OUTPUT FLAG              01322000
*                                                                       01323000
*        HERE TO PERFORM THE OUTPUT                                     01324000
*                                                                       01325000
SYSWRIT1 LTR   SLEN,SLEN          TEST STRING LENGTH                    01326000
         BNZ   SYSWRIT2           JUMP IF NON-NULL                      01327000
*                                                                       01328000
*        HERE FOR A NULL STRING, WRITE AS 1 CHAR X'00'                  01329000
*                                                                       01330000
         LA    SADR,=X'00'        POINT TO DUMMY RECORD                 01331000
         LA    SLEN,1             SET DUMMY RECORD LENGTH = 1           01332000
         TM    DCBRECFM,V         TEST RECORD FORMAT TYPE               01333000
         BZ    SYSWRITG           IF NOT V RECORD WRITE BLANK REC  V2.3 01334000
         TM    DCBRECFM,A         IF V WITH ASA WRITE BLANK REC    V2.3 01334010
         BZ    SYSWRIT2           ELSE V NO ASA WRITE X'00' REC    V2.3 01334020
SYSWRITG LA    SADR,=C' '         ELSE SET TO WRITE A BLANK RECORD V2.3 01335000
*                                                                       01336000
*        HERE AFTER TAKING CARE OF NULL POSSIBILITY                     01337000
*                                                                       01338000
SYSWRIT2 CH    FLEN,=H'1'         CHECK FORMAT LENGTH                   01339000
         BNH   SYSWRITS           SKIP IF NOT FORTRAN FORMAT            01340000
         EJECT                                                          01341000
*                                                                       01342000
*        HERE FOR CASE OF FORTRAN FORMAT                                01343000
*                                                                       01344000
         BAL   3,FORMAT           CALL FORMAT PROCESSING ROUTINE        01345000
         B     EXIT               ALL DONE                              01346000
*                                                                       01347000
*        HERE FOR UNFORMATTED OR SINGLE CHAR FORMAT (CONTROL CHAR)      01348000
*                                                                       01349000
SYSWRITS LTR   FLEN,FLEN          CHECK FOR FORMAT (CONTROL CHAR)       01350000
         BNZ   SYSWRITM           SKIP IF FORMATTED                     01351000
         LA    FADR,SAVE2         ELSE SET GARBAGE LOC FOR CHAR RESTORE 01352000
         B     SYSWRITL           AND JUMP TO CALL WRITREC              01353000
*                                                                       01354000
*        COME HERE FOR FORMATTED RECORD                                 01355000
*                                                                       01356000
SYSWRITM BCTR  SADR,0             POINT TO CHAR BEHIND RECORD           01357000
         LA    SLEN,1(,SLEN)      ADJUST LENGTH FOR CONTROL CHARACTER   01358000
         MVC   SAVCHR,0(SADR)     SAVE CURRENT BYTE BEHIND RECORD       01359000
         MVC   0(1,SADR),0(FADR)  SET CONTROL CHARACTER                 01360000
         LR    FADR,SADR          SAVE LOC TO REPLACE CHAR              01361000
*                                                                       01362000
*        MERGE HERE FOR UNFORMATTED RECORDS                             01363000
*                                                                       01364000
SYSWRITL LH    R1,MAXRECL         LOAD MAX RECORD LENGTH                01365000
         LR    R2,SADR            POINT TO THIS RECORD                  01366000
         CR    R1,SLEN            WILL THIS BE A FULL RECORD?           01367000
         BNH   *+6                SKIP IF SO                            01368000
         LR    R1,SLEN            ELSE SET TO WRITE REST                01369000
         AR    SADR,R1            BUMP STRING POINTER                   01370000
         SR    SLEN,R1            DECREMENT COUNT LEFT                  01371000
         BAL   LINK1,WRITREC      OUTPUT RECORD                         01372000
         MVC   0(1,FADR),SAVCHR   REPLACE SAVED CHAR BEHIND RECORD      01373000
*                                 NOTE: HARMLESS STORE IN SAVE2         01374000
*                                 IF UNFORMATTED                        01375000
         LTR   SLEN,SLEN          MORE TO GO?                           01376000
         BNP   EXIT               IF NOT, JUMP TO EXIT                  01377000
         TM    DCBRECFM,A         ASA CONTROL CHARACTERS?               01378000
         BNO   SYSWRITL           IF NOT, BACK TO TREAT AS UNFORMATTED  01379000
         LA    FADR,=C' '         FOR ASA CONTROL CHARS, POINT TO BLANK 01380000
         B     SYSWRITM           AND BACK TO TREAT AS FORMATTED        01381000
         EJECT                                                          01382000
*                                                                       01383000
*        LOCATE                   OBTAIN A BLANK BUFFER                 01384000
*                                                                       01385000
*        BAL   LINK1,LOCATE                                             01386000
*        (BADR)                   POINTS TO BUFFER                      01387000
*        BUFSTART                 POINTS TO BUFFER                      01388000
*        (BLEN)                   MAX RECORD LENGTH                     01389000
*                                                                       01390000
LOCATE   LH    R2,MAXRECL         GET MAXIMUM RECORD LENGTH             01391000
         LR    BLEN,R2            SAVE FOR RETURN                       01392000
         AH    R2,=H'4'           BUMP POINTER FOR EXTRA STUFF          01393000
         CH    R2,OUTWBFLN        IS CURRENT WORK BUFFER LONG ENOUGH?   01394000
         BNH   LOCATE1            SKIP IF SO                            01395000
*                                                                       01396000
*        HERE IF WE MUST GET A NEW LARGER WORK BUFFER                   01397000
*                                                                       01398000
         LH    R0,OUTWBFLN        LOAD OLD BUFFER LENGTH                01399000
         FREEMAIN  R,LV=(0),A=OUTWBF        FREE OLD AREA               01400000
         LR    R0,R2              COPY NEW LENGTH REQUIRED              01401000
         GETMAIN   R,LV=(0)       ALLOCATE NEW AREA                     01402000
         ST    R1,OUTWBF          STORE BUFFER POINTER                  01403000
         STH   R2,OUTWBFLN        STORE NEW LENGTH                      01404000
*                                                                       01405000
*        MERGE HERE TO CLEAR BUFFER OBTAINED                            01406000
*                                                                       01407000
LOCATE1  L     BADR,OUTWBF        POINT TO BUFFER                       01408000
         AH    BADR,=H'4'         ALLOW 4 EXTRA BYTES AT START          01409000
         LA    R0,256+1           CONSTANT TO CLEAR                     01410000
         LR    R1,BADR            COPY STARTING ADDRESS                 01411000
         LR    R2,BLEN            GET NUMBER OF CHARACTERS TO BLANK     01412000
*                                                                       01413000
*        LOOP TO CLEAR 257 CHARACTERS AT A TIME                         01414000
*                                                                       01415000
LOCATEL  MVI   0(R1),C' '         SET BLANK AT START                    01416000
         CR    R2,R0              HOW MANY CHARS LEFT?                  01417000
         BNH   LOCATEX            JUMP IF ONLY ONE CHUNK LEFT           01418000
         MVC   1(256,R1),0(R1)    ELSE BLANK 256 CHARS (+ 1 = 257)      01419000
         AR    R1,R0              PUSH POINTER                          01420000
         SR    R2,R0              DECREMENT COUNT OF CHARS LEFT         01421000
         B     LOCATEL            LOOP BACK                             01422000
*                                                                       01423000
*        HERE FOR LAST CHUNK                                            01424000
*                                                                       01425000
LOCATEX  BCTR  R2,0               ADJUST COUNT FOR 360                  01426000
         BCTR  R2,0               -1 FOR BLANK INSERTED                 01427000
         EX    R2,LOCATEM         CLEAR REMAINING CHARACTERS            01428000
         ST    BADR,BUFSTART      SAVE LOC OF START OF BUFFER           01429000
         BR    LINK1              RETURN TO CALLER                      01430000
*                                                                       01431000
LOCATEM  MVC   1(*-*,R1),0(R1)    BLANK LAST CHARACTERS                 01432000
         EJECT                                                          01433000
*                                                                       01434000
*        WRITREC                  SUBROUTINE TO WRITE A RECORD          01435000
*                                                                       01436000
*        (R1)                     RECORD LENGTH IN CHARACTERS           01437000
*        (R2)                     STARTING ADDRESS OF RECORD            01438000
*        BAL   LINK1,WRITREC                                            01439000
*        THIS ROUTINE DESTROYES REGISTERS 3,9                           01440000
*                                                                       01441000
*                                                                       01442000
WRITREC  ST    LINK1,WRITRECS     SAVE LINKAGE                          01443000
         CH    R1,=H'1'           ONE CHARACTER RECORD?                 01444000
         BH    WRITREC2           SKIP IF NOT                           01445000
*                                                                       01446000
*        HERE WE HAVE A ONE CHARACTER RECORD. THIS CAUSES TROUBLE ON    01447000
*        PRINTERS WITH ASA CONTROL, SO PAD AN EXTRA BLANK IF ASA CNTRL  01448000
*                                                                       01449000
         TM    DCBRECFM,A         ASA CONTROL CHARACTERS?               01450000
         BNO   WRITREC2           SKIP IF NOT                           01451000
         MVC   BUFR+10(1),0(2)    ELSE MOVE THE ONE CHAR TO BUFFER      01452000
         MVI   BUFR+11,C' '       SUPPLY A BLANK PAD CHARACTER          01453000
         LA    R1,2               SET NEW RECORD LENGTH TWO CHARACTERS  01454000
         LA    R2,BUFR+10         POINT TO NEW RECORD                   01455000
*                                                                       01456000
*        MERGE HERE AFTER DEALING WITH ONE CHARACTER RECORDS            01457000
*                                                                       01458000
WRITREC2 TM    DCBRECFM,V         CHECK RECORD FORMAT                   01459000
         BZ    WRITRECF           SKIP IF FIXED LENGTH RECORDS          01460000
         TM    DCBRECFM,U         FURTHER CHECK                         01461000
         BO    WRITRECU           SKIP IF UNDEFINED RECORDS             01462000
*                                                                       01463000
*        HERE FOR VARIABLE LENGTH RECORDS                               01464000
*                                                                       01465000
         SH    R2,=H'4'           POINT FOUR BYTES BEHIND BUFFER        01466000
         MVC   SAVEBF,0(R2)       SAVE THE FOUR BYTES THERE             01467000
         LA    R1,4(,R1)          ADD IN LENGTH OF CONTROL FIELD        01468000
         SLL   R1,16              LEFT JUSTIFY RECORD LENGTH            01469000
         ST    R1,SAVE2           STORE RECORD LENGTH + 2 ZERO BYTES    01470000
         MVC   0(4,R2),SAVE2      SET AS HEADER FOR V TYPE RECORD       01471000
         B     WRITRECM           JUMP TO MERGE POINT                   01472000
*                                                                       01473000
*        HERE FOR UNDEFINED RECORDS                                     01474000
*                                                                       01475000
WRITRECU STH   R1,DCBLRECL        STORE ACTUAL LENGTH IN DCB            01476000
         B     WRITRECM           MERGE                                 01477000
         EJECT                                                          01478000
*                                                                       01479000
*        WRITREC (CONTINUED)                                            01480000
*                                                                       01481000
*        HERE FOR FIXED LENGTH RECORDS                                  01482000
*                                                                       01483000
WRITRECF CH    R1,DCBLRECL        DO WE NEED BLANK PADDING?             01484000
         BE    WRITRECM           IF NOT, JUMP TO MERGE                 01485000
*                                                                       01486000
*        HERE IF WE MUST BLANK PAD A FIXED LENGTH RECORD                01487000
*                                                                       01488000
         STM   R1,R2,SAVE2        SAVE REGS                             01489000
         BAL   LINK1,LOCATE       GET A BLANK BUFFER                    01490000
         LM    R1,R2,SAVE2        RESTORE REGS                          01491000
         BAL   LINK1,FORMMOVE     MOVE PARTIAL RECORD TO THIS BUFFER    01492000
         L     R2,BUFSTART        POINT TO START OF BUFFER, MERGE       01493000
*                                                                       01494000
*        MERGE HERE TO MOVE RECORD TO SYSTEM BUFFERS                    01495000
*                                                                       01496000
WRITRECM L     0,MAXRECW          FIRST GET OUTPUT RECORD COUNTER       01497000
         SH    0,=H'1'            DECREMENT                             01498000
         ST    0,MAXRECW          STORE DECREMENTED COUNT               01499000
         BZ    EXIT0              IMMEDIATE EXIT IF TOO MANY RECORDS    01500000
         PUT   (10),(2)           ELSE MOVE RECORD TO SYSTEM BUFFERS    01501000
         L     LINK1,WRITRECS     RESTORE WRITREC LINKAGE               01502000
         TM    DCBRECFM,F         CHECK RECORD FORMAT                   01503000
         BCR   1,LINK1            ALL DONE UNLESS V TYPE RECORD         01504000
         MVC   0(4,R2),SAVEBF     ELSE RESTORE 4 BYTES BEFORE V RECORD  01505000
         BR    LINK1              AND THEN RETURN TO CALLER             01506000
         TITLE 'OSINT -- OS INTERFACE -- FORTRAN FORMAT PROCESSOR'      01507000
*                                                                       01508000
*        THIS ROUTINE PROCESSES FORTRAN FORMATS CONTAINING ANY OF       01509000
*        THE FOLLOWING FORMAT TYPES A,X,H,',T,/,(). THE LOCATE ROUTINE  01510000
*        IS USED TO FIND WHERE THE CONVERTED RECORD IS TO BE MOVED      01511000
*                                                                       01512000
*        CALLING SEQUENCE                                               01513000
*                                                                       01514000
*        (4)                      POINTER TO STRING TO BE OUTPUT        01515000
*        (5)                      REAL LENGTH OF OUTPUT STRING          01516000
*        (6)                      POINTER TO OUTPUT FORMAT              01517000
*        (7)                      REAL LENGTH OF FORMAT                 01518000
*        BAL   3,FORMAT                                                 01519000
*                                                                       01520000
*        REGISTER DEFINITIONS FOR FORMAT ROUTINE                        01521000
*                                                                       01522000
R0       EQU   0                  SCRATCH                               01523000
R1       EQU   1                  SCRATCH                               01524000
R2       EQU   2                  SCRATCH                               01525000
SADR     EQU   4                  ADDRESS OF NEXT CHARACTER IN STRING   01526000
SLEN     EQU   5                  NUMBER OF CHARACTERS LEFT IN STRING   01527000
FADR     EQU   6                  ADDRESS OF NEXT CHARACTER IN FORMAT   01528000
FLEN     EQU   7                  NUMBER OF CHARACTERS LEFT IN FORMAT   01529000
BADR     EQU   3                  ADDRESS OF NEXT AVAILABLE LOC IN BUFR 01530000
BLEN     EQU   9                  NUMBER OF POSITIONS LEFT IN BUFFER    01531000
LINK1    EQU   14                 INTERNAL CALLING REGISTER             01532000
*                                                                       01533000
*        ENTRY POINT                                                    01534000
*                                                                       01535000
FORMAT   MVC   FSTAKADR,FSTAKBOT  INITIALIZE STACK ADDRESS              01536000
         ST    3,FORMRTN          SAVE RETURN POINT                     01537000
         CLI   0(FADR),C'('       IS FIRST CHARACTER A (?               01538000
         BNE   E$FNLP             ERROR IF NOT                          01539000
         LA    R1,0(FLEN,FADR)    POINT PAST FORMAT                     01540000
         BCTR  R1,0               POINT TO LAST CHARACTER               01541000
         CLI   0(R1),C')'         DOES IT END WITH A )?                 01542000
         BNE   E$FNRP             ERROR IF NOT                          01543000
         BAL   LINK1,LOCATE       POINT TO BUFFER (SET BADR,BLEN)       01544000
         LA    R1,1               SET REPEAT COUNT FOR OUTER LEVEL      01545000
         EJECT                                                          01546000
*                                                                       01547000
*        COME HERE FOR LEFT PAREN -- PUT ENTRY ON STACK                 01548000
*                                                                       01549000
FORMLP   L     R2,FSTAKADR        GET CURRENT STACK LEVEL               01550000
         LA    R2,4(,R2)          PUSH STACK LEVEL                      01551000
         C     R2,FSTAKEND        HAVE WE OVERFLOWED?                   01552000
         BNL   E$FSOV             OFF TO GIVE ERR MSG IF SO             01553000
         ST    R2,FSTAKADR        ELSE STORE PUSHED POINTER             01554000
         ST    FADR,0(,R2)        ELSE STORE PAREN ADDRESS              01555000
         STC   R1,0(,R2)          AND SAVE REPEAT COUNT                 01556000
         ST    FADR,FLASTLP       SAVE FOR FORMAT REPEAT                01557000
*                                                                       01558000
*        COME HERE TO DECREASE FORMAT COUNT AND PUSH FADR               01559000
*                                                                       01560000
FORMLP0  BCTR  FLEN,0             DECREASE NUMBER OF CHARS LEFT         01561000
*                                                                       01562000
*        COME HERE TO JUST PUSH FADR PAST 1 CHAR                        01563000
*                                                                       01564000
FORMLP1  LA    FADR,1(,FADR)      BUMP PAST CHARACTER                   01565000
*                                                                       01566000
*        COME HERE TO EXAMINE NEXT ELEMENT IN FORMAT                    01567000
*                                                                       01568000
FORMLOOP BAL   LINK1,FORMNUM      TRY TO GET A NUMBER                   01569000
         B     FNODIG             TRY SOMETHING ELSE IF NO NUMBER       01570000
         CLI   0(FADR),C'A'       IS THIS AN A TYPE FORMAT?             01571000
         BNE   FORMNOTA           SKIP IF NOT                           01572000
*                                                                       01573000
*        COME HERE TO PROCESS AN A TYPE FORMAT, R1=REPEAT COUNT         01574000
*                                                                       01575000
FORMA    LR    R2,R1              SAVE FOR POSSIBLE NEW NUMBER          01576000
         LA    FADR,1(,FADR)      PUSH PAST THE 'A'                     01577000
         BCTR  FLEN,0             DECREASE REMAINING SIZE               01578000
         BAL   LINK1,FORMNUM      TRY TO GET ANOTHER NUMBER             01579000
         LA    R1,1               SET DEFAULT LENGTH TO 1               01580000
         MR    R0,R2              A FIELD WIDTH IS PRODUCT OF 2 NUMBERS 01581000
         EJECT                                                          01582000
*                                                                       01583000
*        COME HERE WITH 'A' FIELD WIDTH IN (R1)                         01584000
*                                                                       01585000
FORMA1   SR    SLEN,R1            SUB NUMBER OF CHARS TO BE USED        01586000
         BNM   *+10               SKIP IF ENOUGH CHARACTERS             01587000
         AR    R1,SLEN            ELSE SET MOVE AMOUNT TO NO. OF CHARS  01588000
         BZ    FORMA2             SKIP IF NO CHARACTERS TO MOVE         01589000
         LR    R2,SADR            FROM ADDRESS IS START OF STRING       01590000
         AR    SADR,R1            PUSH PAST MOVED CHARACTERS            01591000
         BAL   LINK1,FORMMOVE     AND MOVE THE CHARACTERS               01592000
         LTR   SLEN,SLEN          DID WE HAVE AN UNFILLED A FIELD?      01593000
         BNM   FNODIG             GET NEXT ELEMENT IF NOT               01594000
*                                                                       01595000
*        COME HERE ON END OF FORMAT PROCESSING                          01596000
*                                                                       01597000
FORMA2   BAL   LINK1,RECOUT       OUTPUT RECORD                         01598000
         L     3,FORMRTN          RELOAD RETURN POINT                   01599000
         BR    3                  RETURN TO CALLER                      01600000
*                                                                       01601000
*        COME HERE TO CHECK FOR X TYPE FORMAT                           01602000
*                                                                       01603000
FORMNOTA CLI   0(FADR),C'X'       IS IT X TYPE?                         01604000
         BNE   FORMNOTX           JUMP IF NOT                           01605000
*                                                                       01606000
*        COME HERE FOR 'X' FORMAT WITH COUNT IN (R1)                    01607000
*                                                                       01608000
FORMX    AR    BADR,R1            PUSH BUFFER POINTER                   01609000
         SR    BLEN,R1            DECREMENT COUNT OF CHARS LEFT IN BFR  01610000
         B     FORMLP0            LOOP BACK FOR NEXT ITEM               01611000
*                                                                       01612000
*        COME HERE TO CHECK FOR H TYPE FORMAT                           01613000
*                                                                       01614000
FORMNOTX CLI   0(FADR),C'H'       IS IT H TYPE FORMAT?                  01615000
         BNE   FORMNOTH           SKIP IF NOT                           01616000
         BCTR  FLEN,0             DECREASE COUNT FOR 'H'                01617000
         SR    FLEN,R1            IS THIS A LEGITIMATE NUMBER?          01618000
         BNP   E$FHLN             GIVE ERROR MESSAGE IF NOT             01619000
         LA    R2,1(,FADR)        POINT TO FIRST DATA CHARACTER         01620000
         AR    FADR,R1            SKIP PAST DATA                        01621000
         BAL   LINK1,FORMMOVE     MOVE CHARACTERS                       01622000
         B     FORMLP1            AND PUSH FORMAT ADDRESS WHEN DONE     01623000
*                                                                       01624000
*        COME HERE TO CHECK FOR (                                       01625000
*                                                                       01626000
FORMNOTH CLI   0(FADR),C'('       IS IT LEFT PARENTHESIS?               01627000
         BE    FORMLP             MAKE STACK ENTRY IF SO                01628000
         B     E$FILL             ELSE ILLEGAL FORMAT TYPE              01629000
         EJECT                                                          01630000
*                                                                       01631000
*        COME HERE IF FORMAT TYPE NOT STARTED WITH DIGITS               01632000
*                                                                       01633000
FNODIG   CLI   0(FADR),C' '       IS IT A BLANK?                        01634000
         BE    FORMLP0            SKIP IT AND CONTINUE IF SO            01635000
         CLI   0(FADR),C','       IS IT A COMMA?                        01636000
         BE    FORMLP0            SKIP PAST IT IF SO                    01637000
         LA    R1,1               SET DEFAULT COUNT FOR 'A' OR '('      01638000
         CLI   0(FADR),C'A'       IS IT A TYPE FORMAT?                  01639000
         BE    FORMA              MERGE IF SO                           01640000
         CLI   0(FADR),C'('       IS IT LEFT PARENTHESIS?               01641000
         BE    FORMLP             MAKE STACK ENTRY IF SO                01642000
         CLI   0(FADR),C'X'       CHECK FOR AN X WITH NO COUNT          01643000
         BE    FORMX              JUMP BACK IF SO TO GET ONE SPACE      01644000
         CLI   0(FADR),C')'       IS IT RIGHT PARENTHESIS?              01645000
         BNE   FORMNTRP           SKIP IF NOT                           01646000
*                                                                       01647000
*        HERE FOR ) -- LOOP BACK IF REPEAT COUNT NOT EXHAUSTED          01648000
*                                                                       01649000
         L     R2,FSTAKADR        GET ADDRESS OF CURRENT STACK ENTRY    01650000
         SR    R0,R0              CLEAR FOR IC                          01651000
         IC    R0,0(,R2)          GET REPEAT COUNT                      01652000
         BCT   R0,FORMRP1         DECREMENT AND TEST REPEAT COUNT       01653000
*                                                                       01654000
*        COME HERE IF LOOP DONE                                         01655000
*                                                                       01656000
         SH    R2,=H'4'           UNCONVER PREVIOUS ENTRY               01657000
         ST    R2,FSTAKADR        STORE FOR NEXT REFERENCE              01658000
         C     R2,FSTAKBOT        HAVE WE GONE PAST BOTTOM?             01659000
         BH    FORMLP0            SKIP PAST ) IF NOT                    01660000
*                                                                       01661000
*        COME HERE IN CASE OF TOO MANY )'S OR END OF FORMAT             01662000
*                                                                       01663000
         BCT   FLEN,E$FUBP        TEST FOR END OF FMT, ERROR IF NOT     01664000
         BAL   LINK1,RECOUT       OUTPUT RECORD                         01665000
         LTR   SLEN,SLEN          ARE WE AT END OF STRING?              01666000
         L     3,FORMRTN          RELOAD RETURN POINT IN CASE           01667000
         BCR   Z,3                RETURN IF SO TO CALLER                01668000
         BAL   LINK1,LOCATE       ELSE GET BUFFER PTRS FOR NEXT RECORD  01669000
         LA    R2,FORMSTAK        GET ADDR IF ONLY ONE ENTRY            01670000
         CLC   FLASTLP+1(3),FORMSTAK+1      WERE THERE ANY OTHER LPS?   01671000
         BE    *+8                SKIP IF NOT (LEAVE 1 STACK ENTRY)     01672000
         LA    R2,FORMSTAK+4      INDICATE 2 ENTRIES                    01673000
         ST    R2,FSTAKADR        STORE STACK POINTER                   01674000
         LA    FLEN,1(,FADR)      POINT PAST END OF FORMAT FOR AD CALC  01675000
         L     FADR,FLASTLP       POINT TO PREVIOUS LEFT PAREN          01676000
         SR    FLEN,FADR          CALCULATE NEW LENGTH REMAINING        01677000
         B     FORMLP0            JUMP TO GET NEXT FORMAT CHARACTER     01678000
         EJECT                                                          01679000
*                                                                       01680000
*        COME HERE IF MORE LOOPING TO GO FOR THIS PAREN CASE            01681000
*                                                                       01682000
FORMRP1  STC   R0,0(,R2)          STORE UPDATED REPEAT COUNT            01683000
         AR    FLEN,FADR          POINT OFF STRING                      01684000
         L     FADR,0(,R2)        GET STACK ENTRY                       01685000
         LA    FADR,1(,FADR)      SKIP OVER LP, CLEAR UPPER BYTE        01686000
         SR    FLEN,FADR          CALCULATE CHARACTERS REMAINING        01687000
         B     FORMLOOP           AND OFF TO PROCESS FORMAT LOOP        01688000
*                                                                       01689000
*        COME HERE TO CHECK FOR /                                       01690000
*                                                                       01691000
FORMNTRP CLI   0(FADR),C'/'       IS IT SLASH?                          01692000
         BNE   FORMNSLH           SKIP IF NOT                           01693000
*                                                                       01694000
*        COME HERE TO PROCESS / (NEW RECORD)                            01695000
*                                                                       01696000
FORMSLSH BAL   LINK1,RECOUT       OUTPUT RECORD                         01697000
         BAL   LINK1,LOCATE       GET NEW POINTERS                      01698000
         B     FORMLP0            BACK FOR NEXT FORMAT ITEM             01699000
*                                                                       01700000
*        COME HERE TO TEST FOR LITERAL                                  01701000
*                                                                       01702000
FORMNSLH CLI   0(FADR),C''''      IS IT A QUOTE?                        01703000
         BNE   FORMNTQT           SKIP IF NOT                           01704000
         LA    R2,1(,FADR)        POINT TO FIRST CHAR TO BE MOVED       01705000
*                                                                       01706000
*        COME HERE TO PAST PAST FORMAT ON NEW MOVE CASE                 01707000
*                                                                       01708000
FQUOTE0  AR    FLEN,FADR          POINT PAST FORMAT STRING              01709000
*                                                                       01710000
*        LOOP TO SKIP NON QUOTE CHARACTERS                              01711000
*                                                                       01712000
FQUOTE   LA    FADR,1(,FADR)      SKIP OVER CHARACTER                   01713000
         CLI   0(FADR),C''''      IS NEXT CHARACTER A QUOTE?            01714000
         BNE   FQUOTE             SKIP IT IF NOT                        01715000
         LR    R1,FADR            PREPARE LENGTH CALC                   01716000
         SR    FLEN,FADR          GET REMAINING LENGTH OF FORMAT        01717000
         SR    R1,R2              GET LENGTH TO MOVE                    01718000
         BZ    *+8                SKIP MOVE IF NO CHARACTERS            01719000
         BAL   LINK1,FORMMOVE     MOVE DATA CHARACTERS                  01720000
         CLI   1(FADR),C''''      ARE THER TWO QUOTES?                  01721000
         BNE   FORMLP0            SKIP PAST SINGLE QUOTE IF NOT         01722000
         LA    FADR,1(,FADR)      PUSH PAST FIRST QUOTE                 01723000
         LR    R2,FADR            POINT TO QUOTE TO BE MOVED            01724000
         BCT   FLEN,FQUOTE0       DECREASE SIZE FOR QUOTE AND LOOP      01725000
         EJECT                                                          01726000
*                                                                       01727000
*        COME HERE TO TEST FOR .                                        01728000
*                                                                       01729000
FORMNTQT CLI   0(FADR),C'.'       IS IT POSSIBLE END OF FORMAT?         01730000
         BNE   FORMNDOT           SKIP IF NOT                           01731000
         LTR   SLEN,SLEN          ARE WE AT END OF STRING?              01732000
         BP    FORMLP0            SKIP . IF NOT                         01733000
         B     FORMA2             ELSE MERGE WITH END OF STRING CODE    01734000
*                                                                       01735000
*        COME HERE TO CHECK FOR T TYPE FORMAT                           01736000
*                                                                       01737000
FORMNDOT CLI   0(FADR),C'T'       IS IT T TYPE FORMAT?                  01738000
         BNE   E$FILL             ILLEGAL TYPE IF NOT                   01739000
         LA    FADR,1(,FADR)      SKIP PAST 'T'                         01740000
         BAL   LINK1,FORMNUM      GET THE FOLLOWING NUMBER              01741000
         B     E$FTNM             GIVE ERR IF NOT NUMERIC               01742000
         BCTR  R1,0               GET TAB LOC AS OFFSET                 01743000
         LH    BLEN,MAXRECL       GET MAX RECORD SIZE                   01744000
         SR    BLEN,R1            CHARS LEFT = MAX - TAB                01745000
         A     R1,BUFSTART        TAB TO LOCATION IN BUFFER             01746000
         LR    BADR,R1            COPY NEW BUFFER LOCATION              01747000
         BCT   FLEN,FNODIG        -1 FOR T, CHECK NEXT CASE=¬NUMERIC    01748000
         EJECT                                                          01749000
*                                                                       01750000
*        FORMMOVE                 MOVE CHARACTERS TO BUFFER             01751000
*                                                                       01752000
*        (R1)                     NUMBER OF CHARACTERS TO MOVE          01753000
*        (BADR)                   POINTER TO LOCATION IN BUFFER         01754000
*        (R2)                     POINTER TO DATA TO BE MOVED           01755000
*        BAL   LINK1,FORMMOVE                                           01756000
*        (BADR)                   UPDATED PAST MOVED CHARS              01757000
*        (BLEN)                   LENGTH REMAINING -- DECREMENTED       01758000
*                                                                       01759000
*        ANY CHARACTERS WHICH WOULD FALL BEYOND THE BUFFER ARE IGNORED  01760000
*                                                                       01761000
FORMMOVE LTR   BLEN,BLEN          ARE WE AT END OF RECORD?              01762000
         BCR   13,LINK1           RETURN IF NO ROOM IN BUFFER           01763000
         SR    BLEN,R1            DECREMENT FOR CHARS TO BE MOVED       01764000
         BNM   *+6                SKIP IF ENOUGH ROOM                   01765000
         AR    R1,BLEN            ELSE SET MOVE SIZE TO BUFFER ROOM     01766000
*                                                                       01767000
*        COME HERE WITH REGISTERS SET UP FOR MOVE                       01768000
*                                                                       01769000
FORMMOV1 BCTR  R1,0               GET 360 LENGTH                        01770000
         LA    R0,256             GET VITAL CONSTANT                    01771000
*                                                                       01772000
*        LOOP TO MOVE 256 CHARACTERS AT A TIME                          01773000
*                                                                       01774000
FORMLMOV CR    R1,R0              ARE WE SMALL ENOUGH FOR ONE MOVE?     01775000
         BL    FORMSMOV           SKIP IF SO                            01776000
         MVC   0(256,BADR),0(R2)  MOVE LARGE PIECE                      01777000
         AR    R2,R0              PUSH FROM POINTER                     01778000
         AR    BADR,R0            PUSH TO ADDRESS                       01779000
         SR    R1,R0              BACK UP LENGTH                        01780000
         B     FORMLMOV           CHECK LENGTH AND MOVE REST            01781000
*                                                                       01782000
*        COME HERE TO MOVE <= 256 BYTES                                 01783000
*                                                                       01784000
FORMSMOV EX    R1,FORMMVC         MOVE IN LAST CHARACTERS               01785000
         LA    BADR,1(BADR,R1)    UPDATE BUFFER ADDRESS                 01786000
         BR    LINK1              RETURN TO FORMMOVE CALLER             01787000
*                                                                       01788000
FORMMVC  MVC   0(*-*,BADR),0(R2)  MOVE IN VARIABLE LENGTH PIECE         01789000
         EJECT                                                          01790000
*                                                                       01791000
*        FORMNUM                  SCAN OUT NUMBER                       01792000
*                                                                       01793000
*        (FADR)                   FORMAT POINTER                        01794000
*        (FLEN)                   NUMBER OF CHARS REMAINING IN FORMAT   01795000
*        BAL   LINK1,FORMNUM                                            01796000
*        -->                      RETURN HERE IF NON-NUMERIC            01797000
*        -->                      NORMAL RETURN                         01798000
*        (R1)                     VALUE OF NUMBER IN BINARY             01799000
*        (FADR)                   UPDATED PAST NUMBER                   01800000
*        (FLEN)                   UPDATED PAST NUMBER                   01801000
*                                                                       01802000
*        --> E$FZER               ERROR RETURN FOR ZERO RESULT          01803000
*                                                                       01804000
FORMNUM  CLI   0(FADR),C'0'       IS FIRST CHARACTER A DIGIT?           01805000
         BCR   L,LINK1            RETURN IF NOT                         01806000
         SR    R1,R1              CLEAR RESULT REGISTER                 01807000
*                                                                       01808000
*        LOOP TO PICK UP DIGIT AND COMBINE WITH RESULT                  01809000
*                                                                       01810000
FNUMLOOP IC    R0,0(,FADR)        GET NEXT DIGIT                        01811000
         N     R0,=X'0000000F'    REMOVE ZONE + OTHER GARBAGE           01812000
         MH    R1,=H'10'          SHIFT LEFT CURRENT NUMBER ONE DIGIT   01813000
         AR    R1,R0              AND ADD IN THIS DIGIT                 01814000
         LA    FADR,1(,FADR)      SKIP PAST DIGIT                       01815000
         BCTR  FLEN,0             DECREASE LENGTH REMAINING             01816000
         CLI   0(FADR),C'0'       IS NEXT CHARACTER AT LEAST DIGIT?     01817000
         BNL   FNUMLOOP           LOOP IF DIGIT                         01818000
*                                                                       01819000
*        COME HERE TO CHECK FOR ZERO RESULT                             01820000
*                                                                       01821000
FNUMXIT  LTR   R1,R1              IS RESULT ZERO?                       01822000
         BP    4(,LINK1)          RETURN TO CALLER IF NOT               01823000
         B     E$FZER             ELSE GIVE ERROR MESSAGE               01824000
*                                                                       01825000
*                                                                       01826000
*        RECOUT                   OUTPUT FORMATTED RECORD               01827000
*                                                                       01828000
*        (BADR)                   POINTER PAST LAST CHAR IN BUFFER      01829000
*        BAL   LINK1,RECOUT                                             01830000
*        -->   RETURN WITH RECORD OUTPUT                                01831000
*        (BLEN,BADR,R1,R2)        DESTROYED                             01832000
*                                                                       01833000
RECOUT   L     R2,BUFSTART        POINT TO START OF RECORD              01834000
         LR    R1,BADR            COPY CURRENT POINTER                  01835000
         SR    R1,R2              SUBTRACT TO GET RECORD LENGTH         01836000
         TM    DCBRECFM,V         CHECK RECORD FORMAT                   01837000
         BO    WRITREC            JUMP TO OUTPUT ROUTINE IF U OR V REC  01838000
         LH    R1,DCBLRECL        ELSE SET LENGTH OF FULL REC IF F TYPE 01839000
         B     WRITREC            JUMP TO OUTPUT ROUTINE                01840000
         TITLE 'OSINT -- OS INTERFACE -- SYNCHRONOUS ERROR ROUTINES'    01841000
*                                                                       01842000
*        HERE FOR I/O ERROR (SYNAD ROUTINE)                             01843000
*                                                                       01844000
SYNAD    TM    OFLAGS,READER      IS THIS SYSIN?                        01845000
         BNO   *+8                SKIP IF NOT                           01846000
         OI    EOFLAG,PERMEOF     ELSE SET SPECIAL SYSIN EOF FLAG       01847000
         TM    OFLAGS,OPENI       IS THIS INPUT CASE?                   01848000
         BO    E$IERR             GIVE INPUT ERROR IF SO                01849000
         B     E$OERR             ELSE GIVE OUTPUT ERROR MESSAGE        01850000
*                                                                       01851000
*        ROUTINE ENTERED ON ENCOUNTERING END OF FILE (EODAD ROUTINE)    01852000
*                                                                       01853000
EOF      TM    OFLAGS,READER      IS THIS AN EOF ON SYSIN?              01854000
         BNO   EOF1               SKIP IF NOT                           01855000
         OI    EOFLAG,PERMEOF     ELSE SET SPECIAL SYSIN EOF            01856000
         SR    0,0                SET RETURN CODE = 0 IN CASE OF EOJ    01857000
         TM    EOFLAG,DATAIN      HAS ANY DATA BEEN READ?               01858000
         BNO   SYSEOJM            IF NOT, TREAT AS EOJ, ELSE MERGE      01859000
*                                                                       01860000
*        HERE AFTER SPECIAL PROCESSING FOR SYSIN                        01861000
*                                                                       01862000
EOF1     OI    OFLAGS,EOFE        SET END OF FILE FLAG                  01863000
         LCR   0,11               SET (0) = NEGATIVE = END OF FILE      01864000
         B     EXIT0              JUMP TO EXIT                          01865000
*                                                                       01866000
*        HERE FOR ERROR ON SYSPRINT FILE                                01867000
*                                                                       01868000
PRNERROR WTO   'ERROR ON SYSPRINT FILE'     TELL OPERATOR               01869000
         ABEND 300,DUMP           GIVE ABEND                            01870000
         TITLE 'OSINT -- OS INTERFACE -- SYSTIME'                       01871000
*                                                                       01872000
*        GET TIMER VALUE                                                01873000
*                                                                       01874000
*        NO PARAMETERS                                                  01875000
*                                                                       01876000
*        EXIT CONDITIONS                                                01877000
*                                                                       01878000
*        (0)                      ELAPSED TIME IN MILLISECONDS          01879000
*                                                                       01880000
*        ERROR CODES RETURNED                                           01881000
*                                                                       01882000
*        NONE                                                           01883000
*                                                                       01884000
SYSTIME  ENTER ,                  ENTRY POINT                           01885000
         TTIMER ,                 GET CURRENT TIMER                     01886000
         S     0,TSTART           SUBTRACT STARTING TIME                01887000
         LCR   1,0                MOVE AND COMPLEMENT                   01888000
         M     0,=F'26040'        CONVERT TO NANOSECS                   01889000
         D     0,=F'1000000'      CONVERT TO MILLESECS                  01890000
         LR    0,1                PUT IN PROPER REGISTER                01891000
         B     EXIT0              JUMP TO EXIT                          01892000
         TITLE 'OSINT -- OS INTERFACE -- SYSDUMP'                       01893000
*                                                                       01894000
*        DUMP MEMORY                                                    01895000
*                                                                       01896000
*        NO ENTRY PARAMETERS                                            01897000
*                                                                       01898000
*        NO RESULT RETURNED                                             01899000
*                                                                       01900000
*        ERROR CODES              NONE                                  01901000
*                                                                       01902000
SYSDUMP  ENTER ,                  ENTRY POINT                           01903000
         MVC   SYSREGS(64),SAVE1  SAVE ENTRY REGS & SET FOR DUMP        01904000
         BAL   14,DUMP            CALL DUMP ROUTINE                     01905000
         MVC   SAVE1(64),SYSREGS  RESTORE ENTRY REGS TO ENTRY SAVE AREA 01906000
         B     EXIT               GIVE NORMAL EXIT                      01907000
         TITLE 'OSINT -- OS INTERFACE -- SYSRWIND'                      01908000
*                                                                       01909000
*        REWIND FILE                                                    01910000
*                                                                       01911000
*        CALLING CONDITIONS                                             01912000
*                                                                       01913000
*        (0)                      POINTER TO DCB FOR FILE               01914000
*                                                                       01915000
*        EXIT CONDITIONS                                                01916000
*                                                                       01917000
*        NO RESULTS RETURNED                                            01918000
*                                                                       01919000
*        ERROR CODES RETURNED                                           01920000
*                                                                       01921000
*        E$RSYS                   ATTEMPT TO REWIND SYSTEM FILE         01922000
*                                                                       01923000
SYSRWIND ENTER ,                  ENTRY POINT                           01924000
         LR    10,0               COPY DCB POINTER                      01925000
         TM    OFLAGS,PRINTER+PUNCHER+READER SYSTEM FILE?               01926000
         BNZ   E$RSYS             GIVE ERROR IF SO                      01927000
         TM    OFLAGS,OPENI+OPENO IS FILE ACTUALLY OPEN?                01928000
         BZ    EXIT               IMMEDIATE EXIT IF NOT                 01929000
         MVC   MLIST(LCLSLIST),CLSLIST      MOVE CLOSE PARAMETER LIST   01930000
         CLOSE ((10),REREAD),MF=(E,MLIST)   EXECUTE CLOSE               01931000
         NI    OFLAGS,X'FF'-OPENI-OPENO-EOFE RESET OPEN, EOF FLAGS      01932000
         B     EXIT               EXIT TO CALLER                        01933000
         TITLE 'OSINT -- OS INTERFACE -- SYSCLOSE'                      01934000
*                                                                       01935000
*        CLOSE FILE                                                     01936000
*                                                                       01937000
*        ENTRY CONDITIONS                                               01938000
*                                                                       01939000
*        (0)                      POINTER TO DCB FOR FILE               01940000
*                                                                       01941000
*        EXIT CONDITIONS                                                01942000
*                                                                       01943000
*        NO RESULTS RETURNED                                            01944000
*                                                                       01945000
*                                                                       01946000
*        ERROR CODES RETURNED                                           01947000
*                                                                       01948000
*        NONE                                                           01949000
SYSCLOSE ENTER ,                  ENTRY POINT                           01950000
         LR    10,0               MOVE DCB POINTER TO STANDARD REGISTER 01951000
         TM    OFLAGS,READER+PRINTER+PUNCHER SYSTEM FILE?               01952000
         BNZ   EXIT               IGNORE CALL TO CLOSE SYSTEM FILE      01953000
         BAL   2,CLOSER           ELSE CLOSE FILE                       01954000
         B     EXIT               RETURN TO CALLER                      01955000
*                                                                       01956000
*        UTILITY ROUTINE TO CLOSE A FILE                                01957000
*                                                                       01958000
*        (10)                     POINTS TO DCB                         01959000
*        BAL   2,CLOSER                                                 01960000
*                                                                       01961000
CLOSER   TM    OFLAGS,OPENI+OPENO IS FILE OPEN?                         01962000
         BCR   Z,2                IMMEDIATE RETURN IF NOT               01963000
         MVC   MLIST(LCLSLIST),CLSLIST      MOVE CLOSE PARAMETER LIST   01964000
         CLOSE ((10),DISP),MF=(E,MLIST)     EXECUTE CLOSE               01965000
         FREEPOOL  (10)           FREE BUFFER POOL                      01966000
         NI    OFLAGS,X'FF'-OPENI-OPENO-EOFE RESET OPEN, EOF FLAGS      01967000
         BR    2                  RETURN TO CALLER                      01968000
         TITLE 'OSIN0 -- OS INTERFACE -- DCB EXIT ROUTINES'             01969000
*                                                                       01970000
*        DCB EXIT ROUTINE FOR SYSPRINT                                  01971000
*                                                                       01972000
EXPRT    BAL   2,FILLIN           CALL COMMON ROUTINE                   01973000
         DC    Y(V+B+A)           DEFAULT RECFM=VBA                     01974000
         DC    Y(1782)            DEFAULT BLKSIZE=1782                  01975000
         DC    Y(137)             DEFAULT LRECL=137                     01976000
*                                                                       01977000
*        DCB EXIT ROUTINE FOR SYSPUNCH                                  01978000
*                                                                       01979000
EXPCH    BAL   2,FILLIN           CALL COMMON ROUTINE                   01980000
         DC    Y(V+B)             DEFAULT RECFM=VB                      01981000
         DC    Y(88)              DEFAULT BLKSIZE=88                    01982000
         DC    Y(84)              DEFAULT LRECL=80                      01983000
*                                                                       01984000
*        DCB EXIT ROUTINE FOR SYSIN                                     01985000
*                                                                       01986000
EXRDR    BAL   2,FILLIN           CALL COMMON ROUTINE                   01987000
         DC    Y(F+B)             DEFAULT RECFM=FB                      01988000
         DC    Y(400)             DEFAULT BLKSIZE=400                   01989000
         DC    Y(80)              DEFAULT LRECL=80                      01990000
*                                                                       01991000
*        DCB EXIT ROUTINE FOR SYSOBJ                                    01992000
*                                                                       01993000
EXOBJ    BAL   2,FILLIN           CALL COMMON ROUTINE                   01994000
         DC    Y(F+B)             DEFAULT RECFM=FB                      01995000
         DC    Y(400)             DEFAULT BLKSIZE=400                   01996000
         DC    Y(80)              DEFAULT LRECL=80                      01997000
*                                                                       01998000
*        DCB EXIT ROUTINE FOR NON-SYSTEM FILES                          01999000
*                                                                       02000000
EXALL    BAL   2,FILLIN           CALL COMMON ROUTINE                   02001000
         DC    Y(V+B+S)           DEFAULT RECFM=VBS                     02002000
         DC    Y(1782)            DEFAULT BLKSIZE=1782                  02003000
         DC    Y(2004)            DEFAULT LRECL=2004                    02004000
         EJECT                                                          02005000
*                                                                       02006000
*        COMMON ROUTINE TO FILL IN MISSING FIELDS                       02007000
*                                                                       02008000
FILLIN   LR    10,1               POINT TO DCB                          02009000
         CLI   DCBRECFM,0         WAS RECFM GIVEN?                      02010000
         BNZ   FILLIN1            SKIP IF SO (ASSUME OTHER PARAMS)      02011000
         MVC   DCBRECFM(1),1(2)   ELSE SET PROPER DEFAULT RECFM         02012000
         LH    3,DCBBLKSI         GET BLKSIZE?                          02013000
         LTR   3,3                WAS ONE GIVEN?                        02014000
         BNZ   *+10               SKIP IF SO                            02015000
         MVC   DCBBLKSI,2(2)      ELSE SET PROPER DEFAULT               02016000
         LH    3,DCBLRECL         LOAD LRECL                            02017000
         LTR   3,3                WAS LRECL GIVEN?                      02018000
         BNZ   *+10               SKIP IF SO                            02019000
         MVC   DCBLRECL,4(2)      ELSE SET PROPER DEFAULT               02020000
*                                                                       02021000
*        NOW GET AND SET MAXRECL                                        02022000
*                                                                       02023000
FILLIN1  LH    3,DCBLRECL         GET LRECL                             02024000
         LTR   3,3                DO WE HAVE LRECL GIVEN?               02025000
         BNZ   *+8                SKIP IF SO                            02026000
         LH    3,DCBBLKSI         ELSE GET BLKSIZE                      02027000
         TM    DCBRECFM,F         CHECK RECFM                           02028000
         BO    *+8                SKIP IF F OR U                        02029000
         SH    3,=H'4'            ELSE ADJUST FOR LENGTH OF V RECORD    02030000
         STH   3,MAXRECL          STORE MAX RECORD LENGTH               02031000
         OI    DCBOFLGS,X'08'     SET FOR POSSIBLE CONCATENATION        02032000
         MVI   REREAD,1           SET REREAD FLAG                       02033000
         BR    14                 CONTINUE WITH OPEN PROCESSING         02034000
         TITLE 'OSINT -- OS INTERFACE -- SYSABEND'                      02035000
*                                                                       02036000
*        ABEND TERMINATION                                              02037000
*                                                                       02038000
*        ENTRY CONDITIONS                                               02039000
*                                                                       02040000
*        NONE                                                           02041000
*                                                                       02042000
*        EXIT CONDITIONS                                                02043000
*                                                                       02044000
*        SYSABEND DOES NOT RETURN TO ITS CALLER                         02045000
*                                                                       02046000
*        ERROR CODES                                                    02047000
*                                                                       02048000
*        NONE                                                           02049000
*                                                                       02050000
SYSABEND ENTER ,                  ENTRY POINT                           02051000
         L     1,DLIMIT           LOAD CURRENT VALUE OF D PARAMETER     02052000
         LTR   1,1                TEST IT                               02053000
         BZ    SYSABOMB           JUMP IF HE WANTS SYSTEM BOMB          02054000
*                                                                       02055000
*        HERE WE GIVE AN OSINT DUMP                                     02056000
*                                                                       02057000
         BCTR  1,0                DECREMENT D PARAMETER                 02058000
         ST    1,DLIMIT           STORE DECREMENTED VALUE               02059000
         BAL   14,DUMP            GIVE OSINT DUMP                       02060000
         LA    2,SYSEOJ           POINT TO END OF JOB ROUTINE           02061000
         MVI   BOMBFLG,1          SET FLAG FOR BOMB OCCURED             02062000
         BALR  1,2                JUMP TO END OF JOB ROUTINE            02063000
*                                                                       02064000
*        HERE IF HE WANTS A SYSTEM DUMP                                 02065000
*                                                                       02066000
SYSABOMB ABEND 100,DUMP           GIVE DUMP CODE=U100                   02067000
         TITLE 'OSINT -- OS INTERFACE -- SYSEOJ'                        02068000
*                                                                       02069000
*        END OF JOB                                                     02070000
*                                                                       02071000
*        ENTRY CONDITIONS                                               02072000
*                                                                       02073000
*        (0)                      COMPLETION CODE                       02074000
*                                                                       02075000
*        EXIT CONDITIONS                                                02076000
*                                                                       02077000
*        SYSEOJ DOES NOT RETURN EXCEPT TO INITIATE A NEW JOB IN A       02078000
*        BATCHED RUN (SEE NEWJOB)                                       02079000
*                                                                       02080000
*        ERROR CODES RETURNED                                           02081000
*                                                                       02082000
*        NONE (SYSEOJ DOES NOT RETURN)                                  02083000
*                                                                       02084000
SYSEOJ   ENTER ,                  ENTRY POINT                           02085000
*                                                                       02086000
*        MERGE HERE AFTER NULL JOB (NO INPUT)                           02087000
*                                                                       02088000
SYSEOJM  LR    6,0                SAVE COMPLETION CODE                  02089000
         L     0,PTRDCB           POINT TO FIRST DCB ON CHAIN           02090000
         LA    2,SYSCLOSE         POINT TO CLOSE ROUTINE                02091000
*                                                                       02092000
*        LOOP TO CLOSE ANY FILES LEFT OPEN (EXCEPT SYSTEM FILES)        02093000
*                                                                       02094000
SYSEOJ1  BALR  1,2                CALL CLOSE ROUTINE                    02095000
         NOP   0                  NO ERROR POSSIBLE FROM CLOSE          02096000
         LR    10,0               COPY DCB PTR TO STANDARD REG          02097000
         L     0,DCBNEXT          POINT TO NEXT DCB ON CHAIN            02098000
         LTR   0,0                END OF CHAIN?                         02099000
         BNZ   SYSEOJ1            LOOP BACK IF NOT                      02100000
*                                                                       02101000
*        ALL FILES CLOSED, NOW CHECK FOR POSSIBILITY OF BATCHED JOB     02102000
*                                                                       02103000
         CLI   BATCHFLG,0         TEST FOR BATCHING ALLOWED             02104000
         BE    SYSEOJX            IF NOT, SKIP TO REAL END OF JOB       02105000
*                                                                       02106000
*        HERE TO SEE IF WE HAVE ANOTHER JOB IN THE BATCH                02107000
*                                                                       02108000
SYSEOJ2  TM    EOFLAG,PERMEOF     PERMANENT (SYSTEM) EOF?               02109000
         BO    SYSEOJX            NO NEW JOB IF NO NEW INPUT            02110000
         TM    EOFLAG,TEMPEOF     DID WE READ A ./* ?                   02111000
         BO    NEWJOB             IF SO, JUMP TO INITIATE NEW JOB       02112000
*                                                                       02113000
*        HERE WE READ TO AN EOF (./* OR /*)                             02114000
*                                                                       02115000
         L     4,OUTWBF           POINT TO WORK BUFFER                  02116000
         AH    4,=H'4'            ADJUST FOR POSSIBLE LENGTH FLD        02117000
         LA    2,SYSREAD          POINT TO READ ROUTINE                 02118000
         L     0,READDCB          POINT TO READER DCB                   02119000
         BALR  1,2                READ A CARD                           02120000
         B     SYSEOJX            JUMP TO END OF RUN ON INPUT ERROR     02121000
         B     SYSEOJ2            ELSE BACK TO TEST FOR EOF             02122000
         EJECT                                                          02123000
*                                                                       02124000
*        COME HERE TO TERMINATE, FIRST CLOSE SYSTEM FILES               02125000
*                                                                       02126000
SYSEOJX  L     10,PRINTDCB        POINT TO SYSPRINT DCB                 02127000
         BAL   2,CLOSER           CLOSE IT                              02128000
         L     10,PUNCHDCB        POINT TO SYSPUNCH DCB                 02129000
         BAL   2,CLOSER           CLOSE IT                              02130000
         L     10,READDCB         POINT TO SYSIN DCB                    02131000
         BAL   2,CLOSER           CLOSE IT                              02132000
*                                                                       02133000
*        RELEASE MAIN DYNAMIC STORAGE AREA TO SYSTEM                    02134000
*                                                                       02135000
         LM    1,2,ALLOC          ADDRESS / LENGTH ORIGINALLY OBTAINED  02136000
         LR    0,2                PUT LENGTH IN PROPER REGISTER         02137000
         FREEMAIN  R,LV=(0),A=(1) FREE MAIN DYNAMIC AREA                02138000
         L     10,PTRDCB          LOAD POINTER TO FIRST DCB             02139000
*                                                                       02140000
*        LOOP TO FREE AREAS FOR DCBS                                    02141000
*                                                                       02142000
SYSEOJL  LR    1,10               MOVE DCB ADDRESS TO PROPER REG        02143000
         LA    0,LMODDCB          SET PROPER DCB LENGTH                 02144000
         L     10,DCBNEXT         POINT TO NEXT DCB                     02145000
         FREEMAIN  R,LV=(0),A=(1) FREE AREA FOR DCB                     02146000
         LTR   10,10              END OF CHAIN?                         02147000
         BNZ   SYSEOJL            LOOP TILL ALL FREED                   02148000
*                                                                       02149000
*        NOW WE ARE READY TO RETURN TO THE SYSTEM                       02150000
*                                                                       02151000
         L     5,PICASAV          LOAD POINTER TO CALLER'S PICA         02152000
         SPIE  MF=(E,(5))         RESTORE PICA FOR CALLER, FREE OURS    02153000
         CLI   BOMBFLG,0          DID WE HAVE A BOMB?                   02154000
         BNZ   SYSEOJB            JUMP IF SO TO GIVE ABEND              02155000
         LR    1,13               ELSE SAVE ADDRESS OF WORK AREA        02156000
         L     13,ENT13SV         RELOAD PTR TO CALLERS SAVE AREA       02157000
         FREEMAIN  R,LV=LWORK,A=(1)         FREE WORK AREA              02158000
         LR    15,6               GET RETURN CODE (ITS STILL THERE)     02159000
         RETURN    (14,12),RC=(15)          RETURN TO SYSTEM            02160000
*                                                                       02161000
*        HERE IF WE HAD A BOMB, GIVE A U100 ABEND                       02162000
*                                                                       02163000
SYSEOJB  ABEND 100                GIVE ABEND (NO DUMP)                  02164000
         TITLE 'OSINT -- OS INTERFACE -- EXIT'                          02165000
*                                                                       02166000
*        COME HERE TO EXIT TO INTERFACE CALLER                          02167000
*                                                                       02168000
*        USE THIS ENTRY POINT IF (0) CONTAINS A RESULT TO BE RETURNED   02169000
*                                                                       02170000
EXIT0    ST    0,SAVE1            SAVE RESULT SO WE CAN MERGE           02171000
*                                                                       02172000
*        USE THIS ENTRY POINT IF ALL REGS ARE TO BE RESTORED            02173000
*                                                                       02174000
EXIT     LM    0,15,SAVE1         RESTORE ALL REGS                      02175000
         B     4(,1)              RETURN TO CALLER PAST ERROR RETURN    02176000
*                                                                       02177000
*        CUTOFF DATE -- GETS WRITTEN WHEN TAPES ARE GENERATED           02178000
*                                                                       02179000
         ORG   *                  PUT ON NEW TEXT CARD                  02180000
DATECUT  DC    C'99000'           YYDDD CUTOFF DATE                     02181000
*                                                                       02182000
*        DATE CHECK DIGIT, ALSO SET ON A COPY                           02183000
*                                                                       02184000
CKDIGIT  DC    X'C2'              SEE CHECK CIRCUIT FOR DETAILS         02185000
         TITLE 'OSINT -- OS INTERFACE -- GETNAME'                       02186000
*                                                                       02187000
*        AUXILIARY SUBROUTINE TO CONSTRUCT NAME                         02188000
*                                                                       02189000
*        (4,5)                    STRING NAME (FROM SPITBOL)            02190000
*        (7)                      ADDRESS OF ERROR ROUTINE IF NAME > 8  02191000
*        BAL   2,GETNAME                                                02192000
*        -->   NORMAL RETURN                                            02193000
*        NAME                     CONTAINS NAME RIGHT BLANK PADDED      02194000
*                                                                       02195000
*        IF NAME IS LONGER THAN 8 CHARACTERS AN ERROR RETURN USING      02196000
*        THE ERROR MESSAGE WHOSE ADDRESS IS GIVEN IN (7)                02197000
*                                                                       02198000
GETNAME  BCTR  5,0                GET 360 LENGTH OF NAME                02199000
         CH    5,=H'7'            CHECK FOR TOO LONG                    02200000
         BCR   2,7                GIVE ERROR IF TOO LONG                02201000
         CH    5,=H'1'            IS IT MORE THAN 2 CHARACTER NAME?     02202000
         BH    GETNAME1           SKIP IF YES                           02203000
*                                                                       02204000
*        HERE WE MAY HAVE AN INTEGER, IN WHICH CASE WE USE THE          02205000
*        FORTRAN TYPE NAME FTXXF001 AS THE DDNAME FOR COMPATABILITY     02206000
*                                                                       02207000
         MVC   NAME,=C'FT00F001'  MOVE IN FORTRAN NAME MODEL            02208000
         LA    1,NAME+3           SET UP POINTER IF ONE CHAR NAME       02209000
         SR    1,5                BACK UP IF 2 CHARACTER NAME           02210000
         EX    5,GETNAMBL         MOVE IN POSSIBLE DIGITS               02211000
         CLI   NAME+3,X'F0'       IS SECOND CHARACTER NUMERIC?          02212000
         BL    GETNAME1           SKIP IF NOT (NOT FORTRAN NAME)        02213000
         CLI   NAME+2,X'F0'       ELSE IS FIRST DIGIT NUMERIC?          02214000
         BCR   H,2                EXIT IF YES AND NON-ZERO              02215000
         BE    GETNAMEC           SKIP FOR SPECIAL CHECK IF ZERO        02216000
*                                                                       02217000
*        COME HERE TO USE NAME EXACTLY AS GIVEN                         02218000
*                                                                       02219000
GETNAME1 MVC   NAME+1(7),=C'       '        PREBLANK NAME AREA          02220000
         EX    5,GETNAMEM         MOVE CHARS OF NAME                    02221000
         BR    2                  EXIT TO CALLER                        02222000
*                                                                       02223000
GETNAMEM MVC   NAME(*-*),0(4)     MOVE NAME                             02224000
*                                                                       02225000
GETNAMBL MVC   0(*-*,1),0(4)      TO CONSTRUCT FORTRAN TYPE NAME        02226000
         EJECT                                                          02227000
*                                                                       02228000
*        COME HERE FOR FORTRAN NAME WHERE DATASET REFERENCE NUMBER      02229000
*        IS ONLY ONE DIGIT. IF A SYSTEM FILE IS REFERENCED (5,6,7)      02230000
*        AND THERE IS NO DD CARD WITH THE PROPER DDNAME, THEN THE       02231000
*        STANDARD DDNAME IS SUBSTITUTED, E.G. SYSIN FOR FT05F001        02232000
*                                                                       02233000
GETNAMEC CLI   NAME+3,C'5'        FT05F001?                             02234000
         LA    9,=CL8'SYSIN'      GET SYSIN NAME IN CASE                02235000
         BE    GETNAMET           SKIP IF POSSIBLE SUBSTITUTION         02236000
         CLI   NAME+3,C'6'        FT06F001?                             02237000
         LA    9,=CL8'SYSPRINT'   GET SYSPRINT NAME IN CASE             02238000
         BE    GETNAMET           SKIP IF POSSIBLE SUBSTITUTION         02239000
         CLI   NAME+3,C'7'        FT07F001?                             02240000
         LA    9,=CL8'SYSPUNCH'   GET SYSPUNCH NAME IN CASE             02241000
         BCR   NE,2               IF NONE OF THESE, EXIT (USE FTXXF001) 02242000
*                                                                       02243000
*        HERE IF WE HAVE A POSSIBLE SUBSTITUTION                        02244000
*                                                                       02245000
GETNAMET LR    0,2                SAVE GETNAME LINKAGE                  02246000
         BAL   2,DDCHEK           SEE IF DD CARD WAS ALREADY GIVEN      02247000
         LR    2,0                RESTORE GETNAME LINKAGE               02248000
         BCR   Z,2                IF DD CARD SUPPLIED, EXIT TO USE IT   02249000
         MVC   NAME,0(9)          ELSE USE SUBSTITUTE NAME              02250000
         BR    2                  AND THEN EXIT                         02251000
         TITLE 'OSINT -- OS INTERFACE -- DDCHEK'                        02252000
*                                                                       02253000
*        SUBROUTINE TO CHECK FOR PRESENCE OF A GIVEN DDNAME             02254000
*                                                                       02255000
*        NAME                     DDNAME TO BE SEARCHED FOR             02256000
*        BAL   2,DDCHEK                                                 02257000
*        -->   RETURN HERE WITH CC SET EQUAL IF FOUND, ELSE UNEQUAL     02258000
*                                                                       02259000
*        USES REGISTERS 1,7                                             02260000
*                                                                       02261000
DDCHEK   L     7,TIOTLOC          POINT TO TIOT                         02262000
         USING TIOT,7             TELL ASSEMBLER                        02263000
*                                                                       02264000
*        LOOP TO SEARCH TIOT                                            02265000
*                                                                       02266000
DDCHEKL  CLC   NAME,TIOEDDNM      IS THIS THE ONE?                      02267000
         BCR   E,2                RETURN IF SO WITH CC EQUAL            02268000
         SR    1,1                ELSE CLEAR 1 FOR IC                   02269000
         IC    1,TIOELNOH         LOAD TIOT ENTRY LENGTH                02270000
         LTR   1,1                TEST FOR END OF TIOT (LENGTH = 0)     02271000
         LA    7,0(1,7)           PUSH TO NEXT ENTRY IF IT EXISTS       02272000
         BNZ   DDCHEKL            LOOP BACK IF MORE ENTRIES TO GO       02273000
*                                                                       02274000
*        HERE IF WE DID NOT FIND IT                                     02275000
*                                                                       02276000
         CR    11,12              COMPARE BASE REGS TO GET CC = UNEQUAL 02277000
         BR    2                  RETURN TO CALLER                      02278000
         DROP  7                  DROP TIOT BASE REG                    02279000
         TITLE 'OSINT -- OS INTERFACE -- PATCH SPACE'                   02280000
         DC    20F'0'             INTERFACE PATCH SPACE                 02281000
*                                                                       02282000
*        THE FOLLOWING LOCATIONS ARE PATCHED TO CONTAIN TF NUMBERS      02283000
*        WHENEVER A TF IS APPLIED (HALFWORD CODES)                      02284000
*                                                                       02285000
TFIXES   DC    35H'0'             ASSEMBLE AS ZEROS                V2.3 02286000
*                                                                       02287000
NFIXES   EQU   35                 NUMBER OF POSSIBLE FIXES              02288000
         TITLE 'OSINT -- OS INTERFACE -- INTERVAL TIMER INTERRUPT'      02289000
*                                                                       02290000
*        THIS ROUTINE RECEIVES CONTROL ON A TIMER TRAP                  02291000
*                                                                       02292000
         USING OVERTIME,11        BASE REG FOR OVERTIME ROUTINE         02293000
         DROP  12                 DROP STANDARD BASE REG                02294000
OVERTIME SAVE  (14,12)            SAVE REGISTERS                        02295000
         LR    11,15              SET BASE REGISTER                     02296000
         LR    0,13               SAVE REG 13                           02297000
         L     2,16               POINT TO CVT                          02298000
         L     2,CVTTCBP(,2)      POINT TO TCB POINTERS                 02299000
         L     2,4(,2)            POINT TO CURRENT TCB                  02300000
         L     13,TCBFSA(,2)      POINT TO HIGHEST SAVE AREA            02301000
*                                                                       02302000
*        LOOP TO LOCATE OUR SAVE AREA (LOW ORDER BIT OF FORWARD PTR ON) 02303000
*                                                                       02304000
OVERTIMA TM    8+3(13),1          IS THIS OUR SAVE AREA?                02305000
         L     13,8(,13)          POINT TO NEXT SAVE AREA ANYWAY        02306000
         BNO   OVERTIMA           LOOP BACK IF NOT THE ONE WE WANT      02307000
*                                                                       02308000
*        HERE WHEN WE HAVE FOUND OUR SAVE AREA                          02309000
*                                                                       02310000
OVERTIMB BCTR  13,0               REMOVE GARBAGE LOW ORDER BIT          02311000
         L     8,DATAPTR          LOAD POINTER TO DATA AREA             02312000
         ST    0,SYSREGS          SAVE POINTER TO PREVIOUS SAVE AREA    02313000
         STIMER    TASK,OVERTIME,TUINTVL=TINC  KEEP TIMER GOING         02314000
         L     15,TINC            LOAD INCREMENTAL TIME VALUE           02315000
         A     15,TSTART          ADD TO OLD STARTING VALUE             02316000
         ST    15,TSTART          STORE MODIFIED STARTING VALUE         02317000
         L     15,=V(SYSOVTM)     POINT TO OVERTIME ROUTINE             02318000
         BALR  14,15              PASS CONTROL TO ROUTINE               02319000
         L     13,SYSREGS         RELOAD POINTER TO PREVIOUS SAVE AREA  02320000
         RETURN (14,12)           RETURN VIA CONTROL PROGRAM            02321000
         DROP  11                 DROP TEMPORARY BASE REGISTER          02322000
*                                                                       02323000
TINC     DC    F'999999999'       INCREMENT TO KEEP TIMER GOING         02324000
         TITLE 'OSINT -- OS INTERFACE -- PROGRAM CHECK ROUTINE'         02325000
*                                                                       02326000
*        THIS ROUTINE RECEIVES CONTROL ON ANY PROGRAM INTERRUPT         02327000
*        REGISTER (1) POINTS TO THE PROGRAM INTERRUPTION ELEMENT        02328000
*                                                                       02329000
*        THE MAIN PROGRAM MUST PROVIDE AN ENTRY POINT 'SYSINTR'         02330000
*        WHICH RECEIVES CONTROL AS FOLLOWS                              02331000
*                                                                       02332000
*        (8)                      POINTS TO THE DATA AREA               02333000
*                                 (EVEN IF NOT SET AT INTERRUPT TIME)   02334000
*        (15)                     POINTS TO SYSINTR                     02335000
         BR    15                                                       02336000
*                                                                       02337000
         USING PCEXIT,15          BASE REG SET BY CALLER                02338000
PCEXIT   LR    0,13               SAVE REG 13                           02339000
         L     2,16               POINT TO CVT                          02340000
         L     2,CVTTCBP(,2)      POINT TO TCB POINTERS                 02341000
         L     2,4(,2)            POINT TO CURRENT TCB                  02342000
         L     13,TCBFSA(,2)      POINT TO HIGHEST SAVE AREA            02343000
*                                                                       02344000
*        LOOP TO LOCATE OUR SAVE AREA (LOW ORDER BIT OF PTR ON)         02345000
*                                                                       02346000
PCEXITL  TM    8+3(13),1          IS THIS OUR SAVE AREA?                02347000
         L     13,8(,13)          POINT TO NEXT SAVE AREA ANYWAY        02348000
         BNO   PCEXITL            LOOP BACK IF NOT THE ONE WE WANT      02349000
*                                                                       02350000
*        HERE WHEN WE FIND OUR SAVE AREA                                02351000
*                                                                       02352000
PCEXIT2  BCTR  13,0               REMOVE GARBAGE LOW ORDER BIT          02353000
         LR    2,8                SAVE OLD REG 8 VALUE                  02354000
         L     8,DATAPTR          LOAD POINTER TO ALLOCATED DATA AREA   02355000
         MVC   SYSPSW,4(1)        SAVE INTERRUPT PSW                    02356000
         MVC   SYSREGS(3*4),20(1) SAVE REGS 0,1,2                       02357000
         MVC   SYSREGS+14*4(2*4),12(1)      SAVE REGS 14,15             02358000
         STM   3,12,SYSREGS+3*4   SAVE REGS 3-12                        02359000
         ST    0,SYSREGS+13*4     SAVE REG 13                           02360000
         ST    2,SYSREGS+8*4      SAVE REG 8                            02361000
         STD   0,SYSREGS+16*4     SAVE FR0                              02362000
         STD   2,SYSREGS+16*4+8   SAVE FR2                              02363000
         STD   4,SYSREGS+16*4+16  SAVE FR4                              02364000
         STD   6,SYSREGS+16*4+24  SAVE FR6                              02365000
         EXTRN SYSINTR            INTERRUPT ROUTINE IS EXTERNAL         02366000
         L     15,=A(SYSINTR)     POINT TO INTERRUPT HANDLING ROUTINE   02367000
         ST    15,16(1)           SET TO BE RESTORED AS REG 15          02368000
         ST    15,8(1)            SAVE AS NEW PSW EXIT ADDRESS          02369000
         BR    14                 RETURN TO SYSINTR VIA SYSTEM          02370000
         DROP  15                 DROP PCEXIT BASE REGISTER             02371000
         TITLE 'OSINT -- OS INTERFACE -- DUMP'                          02372000
*                                                                       02373000
*        TO ASSIST IN DEBUGGING, THE INTERFACE PROVIDES THE FOLLOWING   02374000
*        DUMP ROUTINE WHICH DUMPS THE FOLLOWING AREAS --                02375000
*                                                                       02376000
*        1)    INTERFACE SAVE AREA                                      02377000
*        2)    MAIN DATA AREA                                           02378000
*        3)    ACTIVE DCB'S IN FREE CORE                                02379000
*                                                                       02380000
*        EACH BLOCK IS DUMPED 48 BYTES/LINE WITH ABSOLUTE AND           02381000
*        RELATIVE ADDRESSES. ALL ZERO LINES ARE OMITTED FROM THE DUMP   02382000
*                                                                       02383000
*        BAL   14,DUMP                                                  02384000
*                                                                       02385000
         USING OSINT,11,12        STANDARD BASE REGS                    02386000
DUMP     ST    14,DMPRTN          SAVE LINKAGE                          02387000
         PRT   HEDM0              PRINT HEADING FOR DUMP                02388000
         PRT   HEDM1              PRINT TITLE FOR INTERFACE WORK AREA   02389000
         L     15,PAGEDPTH        SET NUMBER OF LINES LEFT ON PAGE      02390000
         LR    6,13               START OF SAVE AREA ADDRESS            02391000
         LA    7,LWORK(,6)        END OF SAVE AREA                      02392000
         BAL   14,DUMPER          DUMP INTERFACE SAVE AREA              02393000
         PRT   HEDM2              PRINT HEADING FOR DATA AREA           02394000
         L     15,PAGEDPTH        SET NUMBER OF LINES LEFT ON PAGE      02395000
         LR    6,8                COPY POINTER TO START OF DATA AREA    02396000
         LR    7,8                ANOTHER COPY                          02397000
         A     7,DATASIZE         POINT TO END OF DATA AREA             02398000
         BAL   14,DUMPER          DUMP DATA AREA                        02399000
         L     10,PTRDCB          LOAD POINTER TO FIRST DCB             02400000
         MVI   BUFR+1,C'1'        FIRST DCB IS ON NEW PAGE              02401000
         L     15,PAGEDPTH        SET NUMBER OF LINES LEFT ON PAGE      02402000
*                                                                       02403000
*        LOOP TO DUMP DCB'S                                             02404000
*                                                                       02405000
DUMP1    L     14,DMPRTN          RELOAD RETURN POINT IN CASE ALL DONE  02406000
         LTR   10,10              DCB'S ALL DUMPED?                     02407000
         BCR   Z,14               RETURN TO DUMP CALLER IF SO           02408000
         MVC   BUFR+2(15),=C'DUMP OF DCB FOR'    SET HEADING            02409000
         MVC   BUFR+18(20),FILENAME         SET PROPER FILE NAME        02410000
         MVI   BUFR,17+20         SET PROPER LENGTH                     02411000
         BAL   5,PRNTLNB          PRINT HEADING                         02412000
         LR    6,10               POINT TO DCB                          02413000
         LA    7,LMODDCB(,6)      POINT TO END OF DCB                   02414000
         BAL   14,DUMPER          DUMP DCB                              02415000
         L     10,DCBNEXT         POINT TO NEXT DCB ON CHAIN            02416000
         MVI   BUFR+1,C'0'        SET FOR NEXT HEADING DOUBLE SPACED    02417000
         B     DUMP1              LOOP BACK TO DUMP IT                  02418000
         EJECT                                                          02419000
*                                                                       02420000
*        SUBROUTINE TO DUMP ONE REGION OF MEMORY                        02421000
*                                                                       02422000
*        (6)                      STARTING ADDRESS                      02423000
*        (7)                      ENDING ADDRESS                        02424000
*        BAL   14,DUMPER                                                02425000
*                                                                       02426000
DUMPER   PRT   BLANKL             PRINT A BLANK LINE                    02427000
         ST    6,DUMPBAS          STORE STARTING ADDRESS                02428000
         MVI   BUFR,132           REMAINING LINES ARE 132 CHARS LONG    02429000
         LA    9,DUMPHEX          POINT TO HEX CONVERSION ROUTINE       02430000
*                                                                       02431000
*        HERE IS THE LOOP THROUGH LINES (48 BYTES/LINE)                 02432000
*                                                                       02433000
DUMPER1  LA    0,48(,6)           POINT 48 BYTES AHEAD                  02434000
         CR    0,7                PAST END?                             02435000
         BH    DUMPERY            FORCE PRINT IF LAST LINE OF DUMP      02436000
         CLI   0(6),X'00'         FIRST BYTE ZERO?                      02437000
         BNZ   DUMPERY            DEFINITELY DUMP IF SO                 02438000
         CLC   1(47,6),0(6)       ELSE IS REST OF LINE ZEROS?           02439000
         BZ    DUMPERL2           SKIP IF SO, DO NOT PRINT IT           02440000
*                                                                       02441000
*        HERE IF WE HAVE AT LEAST A PARTIAL LINE TO BE PRINTED          02442000
*                                                                       02443000
DUMPERY  MVI   BUFR+1,C' '        BLANK BUFFER                          02444000
         MVC   BUFR+2(131),BUFR+1 . . . .                               02445000
         BCT   15,DUMPERL1        SKIP IF ROOM ON THIS PAGE             02446000
         L     15,PAGEDPTH        SET NUMBER OF LINES LEFT ON PAGE      02447000
         MVI   BUFR+1,C'1'        SET FOR NEW PAGE                      02448000
*                                                                       02449000
*        HERE AFTER CLEARING BUFFER AND DEALING WITH LINE COUNT         02450000
*                                                                       02451000
DUMPERL1 LA    2,BUFR+2           POINT TO FIRST LOCATION               02452000
         LR    0,6                COPY POINTER TO DATA                  02453000
         LR    1,6                AND AGAIN                             02454000
         S     1,DUMPBAS          ABSOLUTE ADDR->(0), RELATIVE->(1)     02455000
         STM   0,1,DUMPWRK        STORE ABSOLUTE/RELATIVE ADDRESS       02456000
         LA    3,DUMPWRK          POINT TO ADDRESSES                    02457000
         BALR  1,9                CONVERT ABSOLUTE ADDRESS              02458000
         MVC   BUFR+2(8),BUFR+4   POSITION LAST 6 HEX DIGITS            02459000
         BALR  1,9                CONVERT RELATIVE ADDRESS TO HEX       02460000
         MVC   BUFR+10(9),BUFR+13 POSITION LAST 6 HEX DIGITS            02461000
         EJECT                                                          02462000
*                                                                       02463000
*        HERE WE CONVERT THE ACTUAL DATA (48 BYTES IN 3 GROUPS OF 16)   02464000
*                                                                       02465000
         LA    2,BUFR+20          POINT TO STARTING LOCATION FOR DATA   02466000
         LR    3,6                POINT TO DATA TO BE DUMPED            02467000
         BALR  1,9                DUMP FIRST GROUP OF 16 BYTES          02468000
         BALR  1,9                . . . .                               02469000
         BALR  1,9                . . . .                               02470000
         BALR  1,9                . . . .                               02471000
         CR    3,7                MORE TO GO?                           02472000
         BNL   DUMPERLP           SKIP IF NOT                           02473000
         LA    2,3(,2)            ALLOW 2 EXTRA BLANKS                  02474000
         BALR  1,9                DUMP SECOND GROUP OF 16 BYTES         02475000
         BALR  1,9                . . . .                               02476000
         BALR  1,9                . . . .                               02477000
         BALR  1,9                . . . .                               02478000
         CR    3,7                MORE TO GO?                           02479000
         BNL   DUMPERLP           SKIP IF NOT                           02480000
         LA    2,3(,2)            TWO EXTRA BLANKS                      02481000
         BALR  1,9                DUMP THIRD GROUP OF 16 BYTES          02482000
         BALR  1,9                . . . .                               02483000
         BALR  1,9                . . . .                               02484000
         BALR  1,9                . . . .                               02485000
*                                                                       02486000
*        HERE TO PRINT FORMATTED DUMP LINE                              02487000
*                                                                       02488000
DUMPERLP BAL   5,PRNTLNB          PRINT BUFR CONTAINING LINE            02489000
*                                                                       02490000
*        HERE AFTER DUMPING LINE, MERGE FOR ALL ZERO LINE               02491000
*                                                                       02492000
DUMPERL2 LA    6,3*16(,6)         POINT PAST DATA DUMPED                02493000
         CR    6,7                ALL DONE YET?                         02494000
         BL    DUMPER1            LOOP BACK FOR NEXT LINE IF NOT        02495000
         BR    14                 ELSE RETURN TO DUMPER CALLER          02496000
*                                                                       02497000
*        SUBROUTINE TO CONVERT TO HEX                                   02498000
*                                                                       02499000
*        (2)                      BUFFER POINTER                        02500000
*        (3)                      POINTS TO 4 BYTES OF DATA             02501000
*        BALR  1,9                (9) POINTS TO DUMPHEX                 02502000
*        (2)                      BUMPED PAST 8 HEX DIGS + BLANK        02503000
*        (3)                      BUMPED PAST 4 BYTES DATA              02504000
*                                                                       02505000
DUMPHEX  UNPK  0(8+1,2),0(4+1,3)  SPREAD DIGITS                         02506000
         TR    0(8,2),DUMPTR-C'0' TRANSLATE TO HEX                      02507000
         MVI   8(2),C' '          BLANK LAST GARBAGE DIGIT              02508000
         LA    2,8+1(,2)          BUMP PAST 8 DIGITS + 1 BLANK          02509000
         LA    3,4(,3)            BUMP PAST FOUR BYTES DATA             02510000
         BR    1                  RETURN TO CALLER                      02511000
*                                                                       02512000
DUMPTR   DC    C'0123456789ABCDEF'          TABLE TO TRANSLATE TO HEX   02513000
         TITLE 'OSINT -- OS INTERFACE -- MODEL DCB'                     02514000
*                                                                       02515000
*        MODEL DCB USED TO CONSTRUCT DCBS IN FREE CORE                  02516000
*                                                                       02517000
MODDCB   DCB   DDNAME=XXXXXXXX,DSORG=PS,MACRF=(GM,PM),                 X02518000
               EODAD=EOF,SYNAD=SYNAD,EXLST=EXLALL                       02519000
         DC    CL8' '                       DDNAME                      02520000
         DC    X'0000000000000000'          MEMNAME                     02521000
         DC    CL20' '                      FILENAME                    02522000
         DS    Y                  MAXRECL                               02523000
         DC    X'00'              ALL FLAGS ARE RESET                   02524000
         DC    A(0)               DUMMY CHAIN POINTER                   02525000
         DC    X'7FFFFFFF'        MAX WRITE RECORD COUNT (INFINITE)     02526000
LMODDCB  EQU   *-MODDCB           LENGTH OF MODEL DCB                   02527000
*                                                                       02528000
*                                                                       02529000
*        DCB EXIT LISTS                                                 02530000
*                                                                       02531000
         DS    0F                 ALLIGN                                02532000
EXLPRT   DC    X'85',AL3(EXPRT)   EXIT LIST FOR SYSPRINT                02533000
EXLPCH   DC    X'85',AL3(EXPCH)   EXIT LIST FOR SYSPUNCH                02534000
EXLRDR   DC    X'85',AL3(EXRDR)   EXIT LIST FOR SYSIN                   02535000
EXLOBJ   DC    X'85',AL3(EXOBJ)   EXIT LIST FOR SYSOBJ                  02536000
EXLALL   DC    X'85',AL3(EXALL)   EXIT LIST FOR ALL OTHER FILES         02537000
         TITLE 'OSINT -- OS INTERFACE -- ERROR CODES'                   02538000
*                                                                       02539000
*        THESE ERROR CODES GENERATE A BCTR 12,0. THE ROUTINE AT THE     02540000
*        END COMPUTES THE PROPER ERROR CODE FROM THE VALUE IN (12)      02541000
*                                                                       02542000
E$FILG   XERR  12                 INVALID FILE NAME                     02543000
*                                                                       02544000
E$MSDD   XERR  12                 MISSING DD CARD FOR REFERENCED FILE   02545000
*                                                                       02546000
E$MODN   XERR  12                 MODULE NAME FOR LOAD OR UNLOAD        02547000
*                                 LONGER THAN 8 CHARACTERS              02548000
*                                                                       02549000
E$IERR   XERR  12                 UNCORRECTABLE INPUT ERROR             02550000
*                                                                       02551000
E$OERR   XERR  12                 UNCORRECTABLE OUTPUT ERROR            02552000
*                                                                       02553000
E$EOFR   XERR  12                 ATTEMPT TO READ PAST END OF DATA      02554000
*                                                                       02555000
E$LIOE   XERR  12                 UNCORRECTABLE INPUT ERROR DURING      02556000
*                                 LOADING OF AN EXTERNAL FUNCTION       02557000
*                                                                       02558000
E$LNFN   XERR  12                 MODULE FOR EXTERNAL FUNCTION NOT      02559000
*                                 FOUND IN LIBRARY (POSSIBLE MISSING    02560000
*                                 JOBLIB DD CARD)                       02561000
*                                                                       02562000
E$DELE   XERR  12                 MODULE TO BE UNLOADED IS NOT          02563000
*                                 CURRENTLY LOADED                      02564000
*                                                                       02565000
E$RSYS   XERR  12                 ATTEMPT TO REWIND SYSTEM FILE         02566000
*                                 (DDNAME = SYSPRINT,SYSPUNCH,SYSIN)    02567000
*                                                                       02568000
E$READ   XERR  12                 ATTEMPT TO READ FILE PREVIOUSLY       02569000
*                                 WRITTEN WITHOUT INTERVENING REWIND    02570000
*                                                                       02571000
E$WRIT   XERR  12                 ATTEMPT TO WRITE A FILE PREVIOUSLY    02572000
*                                 READ FROM WITHOUT INTERVENING REWIND  02573000
         EJECT                                                          02574000
*                                                                       02575000
E$FZER   XERR  12                 DUPLICATION FACTOR OR TAB LOCATION    02576000
*                                 IN FORMAT EQUALS ZERO                 02577000
*                                                                       02578000
E$FILL   XERR  12                 ILLEGAL CHARACTER IN OUTPUT FORMAT    02579000
*                                                                       02580000
E$FSOV   XERR  12                 TOO MANY LEVELS OF PARENTHESIS IN     02581000
*                                 FORMAT -- LIMIT IS 10                 02582000
*                                                                       02583000
E$FUBP   XERR  12                 TOO MANY RIGHT PARENTHESIS IN FORMAT  02584000
*                                                                       02585000
E$FTNM   XERR  12                 MISSING NUMBER AFTER T FORMAT         02586000
*                                                                       02587000
E$FHLN   XERR  12                 LENGTH SPECIFIED IN H TYPE FORMAT     02588000
*                                 EXCEEDS LENGTH OF FORMAT              02589000
*                                                                       02590000
*                                                                       02591000
E$FNLP   XERR  12                 FORTRAN TYPE OUTPUT FORMAT IS         02592000
*                                 MISSING AN INITIAL LEFT PARENTHESIS   02593000
*                                                                       02594000
E$FNRP   XERR  12                 A FORTRAN TYPE OUTPUT FORMAT IS       02595000
*                                 MISSING A FINAL RIGHT PARENTHESIS     02596000
*                                                                       02597000
E$SSIN   XERR  12                 A SYSIN RECORD EXCEEDS 80             02598000
*                                 CHARACTERS IN LENGTH                  02599000
*                                                                       02600000
E$OPNO   XERR  12                 ERROR IN OPENING FILE FOR OUTPUT      02601000
*                                                                       02602000
E$OPNI   XERR  12                 ERROR IN OPENING FILE FOR INPUT       02603000
*                                                                       02604000
*        COME HERE TO CALCULATE ERROR CODE                              02605000
*        WE ENTER HERE FROM TABLE OF BCTR 12,0'S AND SUBTRACTED AMOUNT  02606000
*        TELLS US WHICH ERROR MESSAGE WE ARE GIVING                     02607000
*        ERROR CODE = (12)-(11)-4095+&ERRC                              02608000
*                                                                       02609000
         LA    1,4095(,11)        (11)+4095                             02610000
         LA    0,&ERRC.(,12)      (12)+&ERRC                            02611000
         SR    0,1                CALCULATE ERROR CODE                  02612000
         LM    1,15,SAVE1+4       SAVE REGS PRESERVING ERROR CODE       02613000
         BR    1                  GIVE ERROR RETURN                     02614000
         TITLE 'OSINT -- OS INTERFACE -- MACRO CALL PARAMETER LISTS'    02615000
*                                                                       02616000
*        LISTS FOR SYSTEM MACRO CALLS (MOVED TO MLIST FOR USE)          02617000
*                                                                       02618000
GETLIST  GETMAIN   VC,HIARCHY=1,MF=L         GETMAIN LIST               02619000
LGETLIST EQU     *-GETLIST         LENGTH OF LIST                       02620000
*                                                                       02621000
OPNLIST  OPEN    (,),MF=L          OPEN LIST                            02622000
LOPNLIST EQU     *-OPNLIST         LENGTH OF LIST                       02623000
*                                                                       02624000
CLSLIST  CLOSE   (,),MF=L          CLOSE LIST                           02625000
LCLSLIST EQU     *-CLSLIST         LENGTH OF LIST                       02626000
*                                                                       02627000
EXTLIST  EXTRACT   ,'S',FIELDS=(TIOT),MF=L  EXTRACT LIST                02628000
LEXTLIST EQU   *-EXTLIST          LENGTH OF LIST                        02629000
         TITLE 'OSINT -- OS INTERFACE -- INITIAL LIMIT VALUES'          02630000
*                                                                       02631000
*        THIS TABLE OF VALUES IS MOVED TO 'LIMS' IN THE INTERFACE       02632000
*        WORK AREA AFTER OBTAINING THE REQUIRED MEMORY                  02633000
*                                                                       02634000
LIMSINIT DS    0F                 START OF LIMITS                       02635000
         DC    F'55'              TIME LIMIT (DEFAULT = 55 SECONDS)     02636000
         DC    F'100000'          CARD LIMIT = 100000                   02637000
         DC    F'100000'          PAGE LIMIT = 100000                   02638000
         DC    A(8*1024)          SPACE TO RESERVE FOR SYSTEM = 8K      02639000
         DC    F'0'               ADDRESS OF SYSTEM AREA                02640000
         DC    F'8'               MINIMUM MEMORY REQUESTED = 8 BYTES    02641000
         DC    A(1000*1024)       MAX MEMORY REQUIRED AND REQUESTED     02642000
         DC    A(16*1024)         MINIMUM MEMORY REQUIRED               02643000
         DC    2A(0)              ADDRESS LENGTH ACTUALLY ALLOCATED     02644000
         DC    A(10)              DEFAULT NUMBER OF OSINT DUMPS         02645000
         DC    A(58)              DEFAULT IS 58 LINES PER PAGE          02646000
         DC    A(0)               DEFAULT IS PRECISE INTERRUPTS         02647000
         TITLE 'OSINT -- OS INTERFACE -- LITERAL POOL'                  02648000
*                                                                       02649000
*        NOTE THAT IF THE INTERFACE GETS BIGGER, WE MUST WATCH THE      02650000
*        POSITIONING OF THE LITERAL TABLES SINCE THE LITERAL USED TO    02651000
*        LOAD BASE REGISTERS MUST BE WITHIN 4K OF THE FIRST ENTRY POINT 02652000
*                                                                       02653000
         LTORG ,                  PLACE LITERALS HERE                   02654000
         TITLE 'OSINT -- OS INTERFACE -- WORK DSECT'                    02655000
*                                                                       02656000
*        THE WORK DSECT CONTAINS THE GENERAL WORK AREAS FOR THE         02657000
*        INTERFACE. A POINTER TO THIS AREA IS STORED IN THE DATA AREA   02658000
*        AT WORKLOC. THIS ADDRESS IS LOADED INTO REGISTER (13)          02659000
*        ON ENTRY TO ANY OF THE SYSTEM INTERFACE ENTRY POINTS.          02660000
*                                                                       02661000
WORK     DSECT ,                  START OF DSECT, (13) POINTS HERE      02662000
*                                                                       02663000
*        SINCE (13) ALWAYS POINTS TO THIS AREA, THE FIRST 18 WORDS ARE  02664000
*        RESERVED FOR USE AS A SAVE AREA BY THE NEXT LEVEL OF ROUTINES  02665000
*                                                                       02666000
SAVE2    DS    9D                 SAVE AREA FOR NEXT LEVEL              02667000
*                                                                       02668000
*        WORK AREAS FOR DUMP ROUTINE                                    02669000
*                                                                       02670000
DUMPWRK  DS    2F                 SAVE ADDRESSES IN DUMPER              02671000
DMPRTN   DS    F                  RETURN LINKAGE TO DUMP ROUTINE        02672000
DUMPBAS  DS    A                  BASE ADDRESS IN DUMPER                02673000
*                                                                       02674000
*        THE FOLLOWING IS USED TO BUILD DUMP LINES & OTHER MESSAGES     02675000
*                                                                       02676000
BUFR     DS    CL134              132 + CTL CHAR + LENGTH               02677000
*                                                                       02678000
*        THE FOLLOWING LOCATION CONTAINS A POINTER TO THE DATA AREA     02679000
*                                                                       02680000
DATAPTR  DS    F                  POINTER TO ALLOCATED DATA AREA        02681000
*                                                                       02682000
*        THE FOLLOWING LOCATION CONTAINS A POINTER TO THE MAIN PROGRAM  02683000
*                                                                       02684000
STARTLOC DS    A                  POINTER TO SYSSTART                   02685000
*                                                                       02686000
*        REGISTER SAVE AREAS                                            02687000
*                                                                       02688000
ENT13SV  DS    A                  SAVE REG 13 ON ENTRY TO INTERFACE     02689000
SAVEX    DS    8F                 SAVE AREA FOR INTERRUPT ROUTINE       02690000
PRNSAVE  DS    3F                 SAVE REGS IN PRNTLN                   02691000
BOMBSV   DS    2F                 SAVE REGS 0,1 ON A BOMB               02692000
BOMBPSW  DS    F                  SAVE CODE/ADDR FROM PSW ON A BOMB     02693000
WRITRECS DS    A                  SAVE WRITREC LINKAGE                  02694000
FORMSAVE DS    2F                 SAVE REGS FOR FORMMOVE                02695000
*                                                                       02696000
*        AREA TO SAVE POINTER TO PICA FOR CALLER                        02697000
*                                                                       02698000
PICASAV  DS    A                  POINTER TO CALLER'S PICA              02699000
*                                                                       02700000
*        LOCATION USED TO STORE STARTING (INITIAL) TIMER VALUE          02701000
*                                                                       02702000
TSTART   DS    F                  INITIAL TIMER VALUE                   02703000
         EJECT                                                          02704000
*                                                                       02705000
*        LIST FOR BLDL                                                  02706000
*                                                                       02707000
         ORG   SAVEX              OVERLAP UNUSED REG SAVE AREAS         02708000
BLDLIST  DS    H'1'               SET TO 1 FOR ONE ENTRY                02709000
         DS    H'58'              SET TO 58 = LENGTH OF ENTRY           02710000
NAME     DS    CL8                NAME FOR LOAD,UNLOAD,OPEN, ETC.       02711000
         DS    CL50               WORK AREA FOR BLDL                    02712000
         ORG   ,                  REPOSITION                            02713000
*                                                                       02714000
*        AREA TO BUILD PARAMETER LISTS FOR SYSTEM MACRO CALLS           02715000
*                                                                       02716000
MLIST    DS      0D                START OF AREA                        02717000
         GETMAIN   VC,HIARCHY=1,MF=L                                    02718000
         ORG     MLIST                                                  02719000
         OPEN    (,),MF=L                                               02720000
         ORG     MLIST                                                  02721000
         CLOSE   (,),MF=L                                               02722000
         ORG   MLIST                                                    02723000
         EXTRACT   ,'S',FIELDS=(TIOT),MF=L                              02724000
         ORG     ,                 REPOSITION PAST LONGEST LIST         02725000
*                                                                       02726000
*        USER PROGRAM LIMITS (INITIALIZED FROM LIMSINIT)                02727000
*                                                                       02728000
LIMS     DS    0F                 START OF INITIALIZED LIMIT VALUES     02729000
TLIMIT   DS    F                  TIME LIMIT (TIMER UNITS)              02730000
CLIMIT   DS    F                  CARD LIMIT                            02731000
PLIMIT   DS    F                  PAGE LIMIT                            02732000
RESERV   DS    F                  SPACE TO RESERVE TO SYSTEM (BYTES)    02733000
RESERV0  DS    A                  ADDRESS OF AREA TO RESERVE TO SYSTEM  02734000
DYNALLOC DS    A                  MINIMUM MEMORY REQUESTED (BYTES)      02735000
DYNAMAX  DS    A                  MAX MEMORY REQUIRED & REQUESTED       02736000
DYNAMIN  DS    F                  MINIMUM MEMORY REQUIRED               02737000
ALLOC    DS    2A                 ADDRESS/LENGTH ACTUALLY ALLOCATED     02738000
DLIMIT   DS    F                  NUMBER OF OSINT DUMPS ON SYSABEND     02739000
PAGEDPTH DS    F                  NUMBER OF LINES PER PAGE              02740000
INTVAL   DS    F                  INTERRUPT TYPE INDICATOR              02741000
LLIMS    EQU   *-LIMS             LENGTH OF LIMIT VALUES                02742000
         EJECT                                                          02743000
*                                                                       02744000
*        MISCELLANEOUS WORK AREAS                                       02745000
*                                                                       02746000
TIOTLOC  DS    F                  LOCATION OF TIOT FOR THIS TASK        02747000
PTRDCB   DS    A                  ADDRESS OF FIRST DCB ON DCB CHAIN     02748000
SYSTEM   DS    A                  SAVE EXIT ADDRESS IN INTRUP ROUTINE   02749000
OUTWBF   DS    A                  POINTER TO OUTPUT WORK BUFFER         02750000
OUTWBFLN DS    H                  LENGTH OF OUTPUT WORK BUFFER          02751000
REREAD   DS    X                  REREAD FLAG FOR DATASET CONCATENATION 02752000
SAVEBF   DS    CL4                SAVE CHRS BEHIND READ BFR (SYSREAD)   02753000
EOFLAG   DS    X                  END OF FILE FLAG                      02754000
TEMPEOF  EQU   X'80'              FLAG FOR TEMPORARY (./*) EOF          02755000
PERMEOF  EQU   X'40'              FLAG FOR PERMANENT EOF (/*)           02756000
DATAIN   EQU   X'20'              FLAG FOR SOME DATA READ               02757000
PTYPE    DS    C                  OPTION LETTER (PARAMETER SCAN)        02758000
RECFLAG  DS    X                  FLAG FOR UNKNOWN RECLEN (SYSWRITE)    02759000
SAVCHR   DS    C                  SAVE CHAR BEHIND RECORD IN SYSWRITE   02760000
BOMBFLG  DS    X                  SET NONZERO IF ANY SYSABEND CALLS     02761000
DATE     DS    CL10               SPACE TO BUILD DATE (SYSDATE)         02762000
CKDIGITC DS    C                  COMPUTED DATE CHECK DIGIT             02763000
BATCHFLG DS    AL1(*-*)           BATCHING FLAG COPIED FROM SYSBATCH    02764000
*                                                                       02765000
*        WORK AREAS FOR FORMAT PROCESSOR                                02766000
*                                                                       02767000
FORMFLGS DS    C                  FLAG BYTE FOR FORMAT PROCESSOR        02768000
XFORM    EQU   X'80'              FLAG FOR MOVE OF BLANKS               02769000
FBLKCC   EQU   X'40'              FLAG FOR BLANK CTL CHAR REQUIRED      02770000
FSPECL   EQU   X'20'              FLAG FOR NO FORMAT GIVEN              02771000
BUFSTART DS    A                  ADDRESS OF CURRENT BUFFER             02772000
FLASTLP  DS    A                  ADDR AND REPEAT COUNT FOR LAST LP     02773000
FSTAKADR DS    F                  ADDRESS OF CURRENT STACK ENTRY        02774000
FORMSTAK DS    10F                ROOM FOR 10 PAREN LEVELS              02775000
FSTAKEND DS    A(*)               END OF STACK ADDRESS                  02776000
FSTAKBOT DS    A(FORMSTAK-4)      BOTOOM OF LP STACK                    02777000
FORMRTN  DS    F                  SAVE RETURN POINT TO FORMAT PROCESSOR 02778000
LWORK    EQU   *-WORK             LENGTH OF WORK AREA                   02779000
         TITLE 'OSINT -- OS INTERFACE -- DATA DSECT'                    02780000
*                                                                       02781000
*        THE DATA AREA IS ALWAYS POINTED TO BY REGISTER (8). THIS       02782000
*        REGISTER MUST BE SET CORRECTLY ON ALL CALLS TO THE INTERFACE.  02783000
*        THIS AREA IS PRIMARILY FOR THE USE OF THE MAIN PROGRAM.        02784000
*        HOWEVER, THE FIRST FEW LOCATIONS ARE RESERVED TO THE INTERFACE 02785000
*        AS INDICATED BELOW.                                            02786000
*                                                                       02787000
DATA     DSECT ,                  START OF DATA DSECT                   02788000
*                                                                       02789000
         DS    F                  FOUR BYTES UNUSED BY INTERFACE        02790000
WORKLOC  DS    A                  POINTER TO INTERFACE WORK AREA        02791000
SAVE1    DS    18F                SAVE AREA FOR REGS ON ENTRY           02792000
*                                                                       02793000
*        THE FOLLOWING AREAS ARE USED IF A PROGRAM CHECK OCCURS         02794000
*                                                                       02795000
SYSPSW   DS    D                  SAVE INTERRUPT PSW                    02796000
SYSREGS  DS    12D                REG VALS ON INTERRUPT (0-15,FR0-FR6)  02797000
*                                                                       02798000
*        THE FOLLOWING CONSTANTS ARE SET BY THE INTERFACE               02799000
*                                                                       02800000
DATASIZE DS    F                  LENGTH OF DATA AREA ALLOCATED         02801000
PRINTDCB DS    A                  POINTER TO DCB FOR SYSPRINT           02802000
PUNCHDCB DS    A                  POINTER TO DCB FOR PUNCH              02803000
READDCB  DS    A                  POINTER TO SYSIN DCB                  02804000
PGDEPTH  DS    F                  NUMBER OF LINES PER PAGE              02805000
STARTADR DS    A                  ADDRESS OF SYSSTART                   02806000
INTFLAG  DS    F                  INTERRUPT TYPE INDICATOR              02807000
*                                                                       02808000
*        THE REMAINING SECTION OF THE DATA AREA MAY BE USED BY THE MAIN 02809000
*        PROGRAM IN ANY WAY IT DESIRES.                                 02810000
*                                                                       02811000
USERD    DS    0D                 START OF USER AREA                    02812000
         TITLE 'OSINT -- OS INTERFACE -- TIOT DSECT'                    02813000
*                                                                       02814000
*        THIS DSECT DESCRIBES THE FIELDS IN A TIOT ENTRY WHICH ARE      02815000
*        REFERENCED BY THE INTERFACE.                                   02816000
*                                                                       02817000
TIOT     DSECT ,                  START OF DSECT                        02818000
*                                                                       02819000
         DS    CL24               FILLER (JOB/STEP NAMES, UNUSED)       02820000
TIOENTRY DS    0F                 START OF ENTRY (0 = END OF CHAIN)     02821000
TIOELNOH DS    AL1                LENGTH OF ENTRY                       02822000
         DS    CL3                FILLER (UNUSED)                       02823000
TIOEDDNM DS    CL8                DDNAME                                02824000
*                                                                       02825000
*                                                                       02826000
*        ADDITIONAL CONTROL PROGRAM FIELDS REFERENCED                   02827000
*                                                                       02828000
CVTTCBP  EQU   0                  OFFSET TO TCB BLOCK PTR IN CVT        02829000
TCBFSA   EQU   112                OFFSET TO PTR TO 1ST SAVE AREA IN TCB 02830000
         TITLE 'OSINT -- OS INTERFACE -- DCB DSECT'                     02831000
*                                                                       02832000
*        THE FOLLOWING DSECT DESCRIBES THE DCB FORMAT USED BY THIS      02833000
*        INTERFACE, WHICH CONSISTS OF A STANDARD SYSTEM DCB FOLLOWED    02834000
*        BY A SET OF SPECIAL FIELDS                                     02835000
*                                                                       02836000
         DCBD  DSORG=QS,DEVD=DA   PROVIDE SYMBOLIC NAMES FOR DCB        02837000
DDNAME   DS    CL8                DDNAME                                02838000
MEMNAME  DS    CL8                MEMBER NAME (ZERO IF NONE)            02839000
FILENAME DS    CL20               FULL FILE NAME AS SUPPLIED            02840000
MAXRECL  DS    Y                  MAXIMUM INPUT RECORD LENGTH           02841000
OFLAGS   DS    X                  FLAGS AS FOLLOWS                      02842000
OPENI    EQU   1                  DCB IS OPEN FOR INPUT                 02843000
OPENO    EQU   2                  DCB IS OPEN FOR OUTPUT                02844000
EOFE     EQU   4                  END OF FILE HAS BEEN READ             02845000
PRINTER  EQU   8                  FLAG FOR SYSPRINT                     02846000
PUNCHER  EQU   16                 FLAG FOR SYSPUNCH                     02847000
READER   EQU   32                 FLAG FOR SYSIN                        02848000
DCBNEXT  DS    A                  POINTER TO NEXT DCB ON CHAIN          02849000
MAXRECW  DS    F                  MAXIMUM RECORDS TO BE WRITTEN         02850000
*                                                                       02851000
OPENOK   EQU   X'10'              FLAG FOR SUCCESSFUL OPEN IN DCBOFLGS  02852000
*                                                                       02853000
F        EQU   X'80'              FLAG FOR F TYPE RECORDS (ALSO U)      02854000
V        EQU   X'40'              FLAG FOR V TYPE RECORDS (ALSO U)      02855000
U        EQU   F+V                FLAG FOR U TYPE RECORDS               02856000
B        EQU   X'10'              FLAG FOR B (BLOCKED) RECORDS          02857000
S        EQU   X'08'              FLAG FOR S TYPE RECORDS               02858000
A        EQU   X'04'              FLAG FOR A (ASA CTL) TYPE RECORDS     02859000
*                                                                       02860000
         END   OSINT              END OF INTERFACE                      02861000
