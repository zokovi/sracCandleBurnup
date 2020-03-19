#!/bin/csh
#
#===============================================================================
#
#  <<  run SRAC  >>
#
#===============================================================================
#  
#          
#            
#  
#===============================================================================
#    
# Fortran logical unit usage (allocate if you need)
#
#       The meaning of each file depends on sub-programs used in SRAC.
#       [ ]:important files for users. 
# 
#   1   binary (ANISN,TWOTRAN,CIATION)
#   2   binary (ANISN,CITATION), scratch
#   3   binary (SRAC,ANISN,TWOTRAN,CITATION), scratch
#   4   binary (PIJ,ANISN,TWOTRAN), scratch
# [ 5]  text:80 standard input
# [ 6]  text:137 standard output, monitoring message
#   8   binary (ANISN,TWOTRAN), angular flux in TWOTRAN
#   9   binary (TWOTRAN,CITATION)
#               flux map in CITATION, angular flux in TWOTRAN
#  10   binary (ANISN,TWOTRAN,CITATION), scratch
#  11   binary (TWOTRAN,CITATION), Sn constants in TWOTRAN
#  12   binary (TWOTRAN), restart file for TWOTRAN
#  13   binary (TWOTRAN,CITATION), restart file for TWOTRAN & CITATION
#  14   binary (TWOTRAN,CITATION), scratch
#  15   binary (CITATION), scratch (fast I/O device may be effective)
#  16   binary (CITATION), scratch
#  17   binary (CITATION), fixed source in CITATION
#  18   binary (CITATION), scratch
#  19   binary (CITATION), scratch 
#  20   binary (CITATION), scratch
#  21   binary (PIJ), scratch
#  22   binary (PIJ,CITATION), scratch
#  26   binary (CITATION), scratch
#  28   binary (CITATION), scratch
#  31   text:80 (SRAC-CVMACT,CITATION), macro-XS interface for CITATION
#  32   binary (PIJ,ANISN,TWOTRAN,TUD,CITATION)
#               fixed source for TWOTRAN, power density map in CITATION 
#  33   binary (PIJ,TWOTRAN,TUD), total flux in TWOTRAN & TUD
#  49   device internally used to access PDS file
# [50]  text:80 burnup chain library (SRAC-BURNUP) 
#  52   binary (SRAC-BURNUP), scratch
#  81   binary (PIJ), scratch
#  82   binary (PIJ), scratch
#  83   binary (PIJ), scratch
#  84   binary (PIJ), scratch
#  85   binary data table (PIJ), always required in PIJ
# [89]  plot file : PostScript (SRAC-PEACO,PIJ)
#  91   text:80 (CITATION), scratch
#  92   binary (CITATION), scratch
#  93   text:80 (SRAC-BURNUP), scratch
#  95   text:80 (SRAC-DTLIST), scratch
#  96   binary (SRAC-PEACO), scratch
#  97   binary (SRAC-BURNUP), scratch
# [98]  text:137 (SRAC-BURNUP) summary of burnup results
# [99]  text:137 calculated results
#
#===============================================================================
#
   alias   mkdir mkdir
   alias   cat   cat
   alias   cd    cd
   alias   rm    rm
#
#============= Set by user =====================================================
#
#  LMN    : executable command of SRAC (SRAC/bin/*)
#  BRN    : burnup chain data          (SRAC/lib/burnlibT/*)
#  ODR    : directory in which output data will be stored
#  CASE   : case name which is refered as name of output files and PDS directory
#  WKDR   : working directory in which scratch files will be made and deleted
#  PDSD   : top directory name of PDS file
#

   set SRAC_DIR = $HOME/SRAC
   set LMN  = SRAC.100m
   set BRN  = u4cm6fp50bp16F
   set ODR  = /mnt/d/TA/hasilSrac
   set CASE = TAiterCopy
   set PDSD = $SRAC_DIR/tmp
   set DATE = `date +%Y.%m.%d.%H.%M.%S`

#
#=============  mkdir for PDS  =================================================
#
#  PDS_DIR : directory name of PDS files
#  PDS file names must be identical with those in input data
#
   set PDS_DIR = $PDSD/$CASE.$DATE
   mkdir $PDS_DIR
   mkdir $PDS_DIR/UFAST
   mkdir $PDS_DIR/UTHERMAL
   mkdir $PDS_DIR/UMCROSS
   mkdir $PDS_DIR/MACROWRK
   mkdir $PDS_DIR/MACRO
   mkdir $PDS_DIR/FLUX
   mkdir $PDS_DIR/MICREF
#  
#=============  Change if you like =============================================
#
   set LM       = $SRAC_DIR/bin/$LMN
   set WKDR     = $HOME/SRACtmp.$CASE.$DATE
   mkdir $WKDR
#
#-- File allocation
#  fu89 is used in any plot options, fu98 is used in the burnup option
#  Add other units if you would like to keep necessary files.
   setenv  fu50  $SRAC_DIR/lib/burnlibT/$BRN
   setenv  fu85  $SRAC_DIR/lib/kintab.dat
#  setenv  fu89  $ODR/SFT/$CASE.SFT89.$DATE
   setenv  fu98  $ODR/SFT/$CASE.$DATE.SFT98.txt
   setenv  fu99  $ODR/SFT/$CASE.$DATE.SFT99.txt
   set OUTLST =  $ODR/SFT/$CASE.$DATE.SFT06.txt
   set PWRL = 675.0  #POWER LEVEL CITATION
   set REFLSIZE = "10 50.00000"
   set BPWRLVL1 = `sed -n 1p $ODR/zBRNPWRLVL`
   set BPWRLVL2 = `sed -n 2p $ODR/zBRNPWRLVL`
   set BPWRLVL3 = `sed -n 3p $ODR/zBRNPWRLVL`
   set BPWRLVL4 = `sed -n 4p $ODR/zBRNPWRLVL`
   set BPWRLVL5 = `sed -n 5p $ODR/zBRNPWRLVL`
   set BPWRLVL6 = `sed -n 6p $ODR/zBRNPWRLVL`
   set BPWRLVL7 = `sed -n 7p $ODR/zBRNPWRLVL`
   set BPWRLVL8 = `sed -n 8p $ODR/zBRNPWRLVL`
   set BPWRLVL9 = `sed -n 9p $ODR/zBRNPWRLVL`
   set BPWRLVL10 = `sed -n 10p $ODR/zBRNPWRLVL`
#
#=============  Exec SRAC code with the following input data ===================
#
cd $WKDR
cat - << END_DATA | $LM >& $OUTLST
FUL1
Pb-Bi FBR 
1 1 1 0 2   1 4 3 -2 1   0 0 0 0 1   0 1 0 0 1 / SRAC CONTROL
*1 0 1 0 0   0 0 3 -2 0   0 1 1 0 1   0 1 0 0 1 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
*- PDS files ------2---------3---------4---------5---------6---------7--
* Note : All input line must be written in 72 columns except comments
*        even when environmental variables are expanded.
$HOME/SRACLIB-JDL40/pds/pfast   Old  File
$HOME/SRACLIB-JDL40/pds/pthml   O    F
$HOME/SRACLIB-JDL40/pds/pmcrs   O    F
$PDS_DIR/UFAST      S        Core
$PDS_DIR/UTHERMAL   S        C
$PDS_DIR/UMCROSS    S        C
$PDS_DIR/MACROWRK   S        C
$PDS_DIR/MACRO      S        C
$PDS_DIR/FLUX       S        C
$PDS_DIR/MICREF     S        C
************************************************************************
64 0  8 0 /  F T =>  F T 
64(1)      /  FAST
8  8  8  8  8  8  8  8  / Fast  group
***** Enter one blank line after input for energy group structure

***** Input for PIJ (Collision Probability Method)
*IGT NZ  NR NRR  NXR  IBOUND NX NY  NTPIN   NAPIN  NCELL  12  13  NDA  NDPIN IDIVP   IBETM  IPLOT
4 6 6 3 1  1 6 0 0 0   5 0 6 15 0   0 45 0 / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  /
1 1 1 2 3 3    /  R-S
3(1)           /  X-R
1 2 3          /  M-R
0.0 0.3251 0.4512 0.5782 0.6356 0.6452 0.6616   / RX
****** Input for material specification
4 / NMAT
FUELF01X  0 3  900.0  1.1564  0.0  / 1 : UN fuel
XU050000  2 0  2.4332E-4      /1
XU080000  2 0  3.3979E-2      /2
XN050000  2 0  3.4222E-2  
CLADF02X  0 4  600.0  0.2192   0.0  / 2 : Clad SS
XCRN0000  0 0  1.4166E-2      /1
XNIN0000  0 0  1.1286E-2      /2
XMON0000  0 0  3.8436E-3      /3
XFEN0000  0 0  5.6005E-2      /4
COOLF03X  0 2  600.0  0.36388  0.0  / 3 : COOLANT Pb-Bi
XPBN0000  0 0  1.2813E-2      /1
XBI90000  0 0  1.6118E-2      /2
REFLF0DX  0 2  600.0  1.3232   0.0  / 4 : Reflector Pb-Bi
XPBN0000  0 0  1.2813E-2      /1
XBI90000  0 0  1.6118E-2      /2
****** Input for cell burn-up calculation (when IC20=1)
  50 4 1 0 0  0 0 0 0 0  10(0)   / IBC
********** Power level every period (MWt/cm)*************
$BPWRLVL1
$BPWRLVL2
$BPWRLVL3
$BPWRLVL4
$BPWRLVL5
$BPWRLVL6
$BPWRLVL7
$BPWRLVL8
$BPWRLVL9
$BPWRLVL10
********** Power level every period (MWt/cm)**************
* burnup step material name step
* 0 1 2 3 4
* 5 6 7 8 9
* A B C D E
* F G H I J
* K L M N O
* P Q R S T
* U V W X Y 
* Z a b c d 
* e f g h i
* j k l m n
50(730.0) /  period days interval (IBC2)
****** Input for PEACO option
0 / no plot
COR1
CITATION R-Z YEAR STEP 1
0 0 0 0 0  0 0 0 0 1  0 5 0 0 1  0 1 0 0 0 / SRAC CONTROL
1.0000E-20 / BUCKLING (NOT EFFECTIVE)
11 0 -1 / JUMLAHZONE NXR ID   
1 1 / IXKY IDELAY (CALCULATE KINETICS PARAMETERS)
=====================================  / Comment
======================================  / comment
001
  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0  0
  1  0  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0  0  0  0  0  0  0  1
500
  0.          0.1
003
  0  0  0  0  7  0  0  0  0  0  1  0  0  0  0  0  0  1  0  0  0  0  0  0
  0.0001    0.00001
  0.0       0.0          $PWRL     1.0         0.5000
004
 22 110.0000 $REFLSIZE  0
 $REFLSIZE  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 
  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 $REFLSIZE
  0
005
 11 11
  1 11
 10 11
  9 11
  8 11
  7 11
  6 11
  5 11
  4 11
  3 11
  2 11
 11 11
008
 -2  1  1
999

1 2 3 4 5 6 7 8 9 10 11 /
11  / NMAT
FUL1F010  0 0    0.0  0.0  0.0   / region1
FUL1F510  0 0    0.0  0.0  0.0   / region2 
FUL1FA10  0 0    0.0  0.0  0.0   / region3
FUL1FF10  0 0    0.0  0.0  0.0   / region4
FUL1FK10  0 0    0.0  0.0  0.0   / region5
FUL1FP10  0 0    0.0  0.0  0.0   / region6
FUL1FU10  0 0    0.0  0.0  0.0   / region7
FUL1FZ10  0 0    0.0  0.0  0.0   / region8
FUL1Fe10  0 0    0.0  0.0  0.0   / region9
FUL1Fj10  0 0    0.0  0.0  0.0   / region10
REFLF0D0  0 0    0.0  0.0  0.0   / Reflector 
COR2
CITATION R-Z YEAR STEP 1
0 0 0 0 0  0 0 0 0 1  0 5 0 0 1  0 1 0 0 0 / SRAC CONTROL
1.0000E-20 / BUCKLING (NOT EFFECTIVE)
11 0 -1 / JUMLAHZONE NXR ID   
1 1 / IXKY IDELAY (CALCULATE KINETICS PARAMETERS)
=====================================  / Comment
======================================  / comment
001
  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0  0
  1  0  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0  0  0  0  0  0  0  1
500
  0.          0.1
003
  0  0  0  0  7  0  0  0  0  0  1  0  0  0  0  0  0  1  0  0  0  0  0  0
  0.0001    0.00001
  0.0       0.0          $PWRL     1.0         0.5000
004
 22 110.0000 $REFLSIZE  0
 $REFLSIZE  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 
  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 $REFLSIZE
  0
005
 11 11
  1 11
 10 11
  9 11
  8 11
  7 11
  6 11
  5 11
  4 11
  3 11
  2 11
 11 11
008
 -2  1  1
999

1 2 3 4 5 6 7 8 9 10 11 /
11  / NMAT
FUL1F110  0 0    0.0  0.0  0.0   / region1
FUL1F610  0 0    0.0  0.0  0.0   / region2 
FUL1FB10  0 0    0.0  0.0  0.0   / region3
FUL1FG10  0 0    0.0  0.0  0.0   / region4
FUL1FL10  0 0    0.0  0.0  0.0   / region5
FUL1FQ10  0 0    0.0  0.0  0.0   / region6
FUL1FV10  0 0    0.0  0.0  0.0   / region7
FUL1Fa10  0 0    0.0  0.0  0.0   / region8
FUL1Ff10  0 0    0.0  0.0  0.0   / region9
FUL1Fk10  0 0    0.0  0.0  0.0   / region10
REFLF0D0  0 0    0.0  0.0  0.0   / Reflector 
COR3
CITATION R-Z YEAR STEP 2
0 0 0 0 0  0 0 0 0 1  0 5 0 0 1  0 1 0 0 0 / SRAC CONTROL
1.0000E-20 / BUCKLING (NOT EFFECTIVE)
11 0 -1 / JUMLAHZONE NXR ID   
1 1 / IXKY IDELAY (CALCULATE KINETICS PARAMETERS)
=====================================  / Comment
======================================  / comment
001
  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0  0
  1  0  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0  0  0  0  0  0  0  1
500
  0.          0.1
003
  0  0  0  0  7  0  0  0  0  0  1  0  0  0  0  0  0  1  0  0  0  0  0  0
  0.0001    0.00001
  0.0       0.0          $PWRL     1.0         0.5000
004
 22 110.0000 $REFLSIZE  0
 $REFLSIZE  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 
  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 $REFLSIZE
  0
005
 11 11
  1 11
 10 11
  9 11
  8 11
  7 11
  6 11
  5 11
  4 11
  3 11
  2 11
 11 11
008
 -2  1  1
999

1 2 3 4 5 6 7 8 9 10 11 /
11  / NMAT
FUL1F210  0 0    0.0  0.0  0.0   / region1
FUL1F710  0 0    0.0  0.0  0.0   / region2 
FUL1FC10  0 0    0.0  0.0  0.0   / region3
FUL1FH10  0 0    0.0  0.0  0.0   / region4
FUL1FM10  0 0    0.0  0.0  0.0   / region5
FUL1FR10  0 0    0.0  0.0  0.0   / region6
FUL1FW10  0 0    0.0  0.0  0.0   / region7
FUL1Fb10  0 0    0.0  0.0  0.0   / region8
FUL1Fg10  0 0    0.0  0.0  0.0   / region9
FUL1Fl10  0 0    0.0  0.0  0.0   / region10
REFLF0D0  0 0    0.0  0.0  0.0   / Reflector 
COR4
CITATION R-Z YEAR STEP 3
0 0 0 0 0  0 0 0 0 1  0 5 0 0 1  0 1 0 0 0 / SRAC CONTROL
1.0000E-20 / BUCKLING (NOT EFFECTIVE)
11 0 -1 / JUMLAHZONE NXR ID   
1 1 / IXKY IDELAY (CALCULATE KINETICS PARAMETERS)
=====================================  / Comment
======================================  / comment
001
  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0  0
  1  0  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0  0  0  0  0  0  0  1
500
  0.          0.1
003
  0  0  0  0  7  0  0  0  0  0  1  0  0  0  0  0  0  1  0  0  0  0  0  0
  0.0001    0.00001
  0.0       0.0          $PWRL     1.0         0.5000
004
 22 110.0000 $REFLSIZE  0
 $REFLSIZE  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 
  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 $REFLSIZE
  0
005
 11 11
  1 11
 10 11
  9 11
  8 11
  7 11
  6 11
  5 11
  4 11
  3 11
  2 11
 11 11
008
 -2  1  1
999

1 2 3 4 5 6 7 8 9 10 11 /
11  / NMAT
FUL1F310  0 0    0.0  0.0  0.0   / region1
FUL1F810  0 0    0.0  0.0  0.0   / region2 
FUL1FD10  0 0    0.0  0.0  0.0   / region3
FUL1FI10  0 0    0.0  0.0  0.0   / region4
FUL1FN10  0 0    0.0  0.0  0.0   / region5
FUL1FS10  0 0    0.0  0.0  0.0   / region6
FUL1FX10  0 0    0.0  0.0  0.0   / region7
FUL1Fc10  0 0    0.0  0.0  0.0   / region8
FUL1Fh10  0 0    0.0  0.0  0.0   / region9
FUL1Fm10  0 0    0.0  0.0  0.0   / region10
REFLF0D0  0 0    0.0  0.0  0.0   / Reflector  
COR5
CITATION R-Z YEAR STEP 4
0 0 0 0 0  0 0 0 0 1  0 5 0 0 1  0 1 0 0 0 / SRAC CONTROL
1.0000E-20 / BUCKLING (NOT EFFECTIVE)
11 0 -1 / JUMLAHZONE NXR ID   
1 1 / IXKY IDELAY (CALCULATE KINETICS PARAMETERS)
=====================================  / Comment
======================================  / comment
001
  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0  0
  1  0  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0  0  0  0  0  0  0  1
500
  0.          0.1
003
  0  0  0  0  7  0  0  0  0  0  1  0  0  0  0  0  0  1  0  0  0  0  0  0
  0.0001    0.00001
  0.0       0.0          $PWRL     1.0         0.5000
004
 22 110.0000 $REFLSIZE  0
 $REFLSIZE  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 
  3 15.00000  3 15.00000  3 15.00000  3 15.00000  3 15.00000 $REFLSIZE
  0
005
 11 11
  1 11
 10 11
  9 11
  8 11
  7 11
  6 11
  5 11
  4 11
  3 11
  2 11
 11 11
008
 -2  1  1
999

1 2 3 4 5 6 7 8 9 10 11 /
11  / NMAT
FUL1F410  0 0    0.0  0.0  0.0   / region1
FUL1F910  0 0    0.0  0.0  0.0   / region2 
FUL1FE10  0 0    0.0  0.0  0.0   / region3
FUL1FJ10  0 0    0.0  0.0  0.0   / region4
FUL1FO10  0 0    0.0  0.0  0.0   / region5
FUL1FT10  0 0    0.0  0.0  0.0   / region6
FUL1FY10  0 0    0.0  0.0  0.0   / region7
FUL1Fd10  0 0    0.0  0.0  0.0   / region8
FUL1Fi10  0 0    0.0  0.0  0.0   / region9
FUL1Fn10  0 0    0.0  0.0  0.0   / region10
REFLF0D0  0 0    0.0  0.0  0.0   / Reflector 

END_DATA
#
#========  Remove scratch files ================================================
#
   cd $HOME
   rm -r $WKDR
#  

#
#========  Remove PDS files if you don't keep them =============================
#
  rm -r $PDS_DIR
#  rm -r $PDS_DIR/UFAST
#  rm -r $PDS_DIR/UTHERMAL
#  rm -r $PDS_DIR/UMCROSS
#  rm -r $PDS_DIR/MACROWRK
#  rm -r $PDS_DIR/MACRO
#  rm -r $PDS_DIR/FLUX
#  rm -r $PDS_DIR/MICREF

#=================CUSTOM COMMANDS FOR EASIER WORKLOAD=============================

# debugging propouses
#echo "-------------------last line SFT06-------------------------"
#echo  `tail -3 $OUTLST`
#echo
#echo "-------------------SFT99-------------------------"
#echo  `tail -3 $ODR/SFT/$CASE.$DATE.SFT99.txt`
#echo
echo
echo  `grep "K-EFFECTIVE" $ODR/SFT/$CASE.$DATE.SFT99.txt`

python3 $ODR/test.py

#/mnt/d/TA/hasilSrac/TAiter1Copy.sh
