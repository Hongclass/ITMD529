ods html newfile=proc style=htmlblue;
proc genmod data=sasuser.skin;
   class city age;
   model cases= city age / offset=log_pop dist=poi link=log type3;
   title 'Poisson Regression Model for Skin Cancer Rates';
run;
title;                                    *ST205d03.sas;

