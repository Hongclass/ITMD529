libname census xport '/home/ssidhu20/simrat/brfss_2013_com.xpt';
proc copy inlib=census outlib=SASFILE;
run;

data sasfile.BRFSS_20; 
set sasfile.BRFSS_20; 
keep SLEPTI BPHIGH TOLDHI CVDINF CVDCRH SEX X_IMPR X_SMOK X_RFBM; 
run;
  
/* Creating binary value for ethinicity*/
data census.BRFSS_20;
  set census.BRFSS_20;
  if X_IMPR = 2 OR X_IMPR =3 OR X_IMPR=4 OR X_IMPR =5 OR X_IMPR =6 then ETHIN = 2; 
  else if X_IMPR = 1 then ETHIN =1 ;
  run; 
  
/* Modifying the sleep time variable */
data census.BRFSS_20;
  set census.BRFSS_20;
  if SLEPTI >= 1 AND SLEPTI <=5 then SLEEP = 1; 
  else if SLEPTI > 5 AND SLEPTI <=9 then SLEEP = 2 ;
  else if SLEPTI > 9 AND SLEPTI <=24 then SLEEP = 3 ;
  run; 
  
 /* Modifying the BP variable */
data census.BRFSS_20;
  set census.BRFSS_20;
  if BPHIGH = 1 then BP = 1; 
  else if BPHIGH = 2 OR BPHIGH = 3 OR BPHIGH = 4 then BP = 2 ;
  run; 
  
   /* Modifying the SMOKE variable */
data census.BRFSS_20;
  set census.BRFSS_20;
  if X_SMOK = 1 then SMOKE = 1; 
  else if x_smok = 2 OR x_smoke = 3 OR x_smok = 4 then SMOKE = 2 ;
  run; 
  
  /* Modifying the bmi variable */
data census.BRFSS_20;
  set census.BRFSS_20;
  if X_rfbm = 1 then bmi = 2; 
  else if X_rfbm = 2 then bmi = 1 ;
  run;

