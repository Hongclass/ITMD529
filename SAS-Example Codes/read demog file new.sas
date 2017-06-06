
data temp_demog;
length hhid $ 9;
infile 'C:\Documents and Settings\ewnym5s\My Documents\Demog.txt' dsd dlm='09'x lrecl=4096 firstobs=2 obs=max;
input HHID $ DEM_AGE  CARD_IND $ DWELLING $ EDUCATION $ INCOME $ ETHNIC_CODE $ ETHNIC_ROLLUP $ 
      HOME_EQUITY $ LTV $ HOME_OWNER $ INCOME_ASSETS $ LANGUAG  $ LENGTH_RESID $  MARITAL $   
      OCCUPATION $ POC_10 $ POC_11_15 $  POC_16_17 $ POC $  RELIGION $ VEHICLE $ GENDER $ AGE_HOH  ;
/*if hhid eq '' then delete;*/
run;

options compress=binary;
%SQUEEZE( temp_demog, data.demog_201303 )
options compress=no;


