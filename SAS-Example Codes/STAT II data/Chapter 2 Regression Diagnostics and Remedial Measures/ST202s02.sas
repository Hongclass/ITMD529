***********************************
Chapter 2 Exercise 2
**********************************;
proc reg data=sasuser.cars3;  
   model logprice = citympg citympg2 enginesize horsepower 
	  horsepower2 weight;
   output out=out p=pred r=resid;
   ods output ANOVA=ANOVATable;
run; 							*ST202s02.sas;

data _null_;
   set ANOVATable;
   if source='Error' then call symput('var', MS);
run;

data out;
   set out;
   Estimate=exp(pred + &var/2);
   Difference = price - estimate;
run; 							*ST202s02.sas;
 
proc print data=out;
   var manufacturer model citympg horsepower enginesize price estimate difference;
run;

proc sgplot data=out;
 scatter y=difference x=estimate;
 xaxis min=0 max=55;
 yaxis min=-20 max=20;
 refline 0;
run;							*ST202s02.sas;

proc sgplot data=out;
 scatter y=difference x=estimate / datalabel=model;
 xaxis min=0 max=55;
 yaxis min=-20 max=20;
 refline 0;
 title 'DATALABEL=MODEL';
run;							*ST202s02.sas;

proc sgplot data=out;
 scatter y=difference x=estimate / datalabel=citympg;
 xaxis min=0 max=55;
 yaxis min=-20 max=20;
 refline 0;
 title 'DATALABEL=CITYMPG';
run;							*ST202s02.sas;

proc sgplot data=out;
 scatter y=difference x=estimate / datalabel=price;
 xaxis min=0 max=55;
 yaxis min=-20 max=20;
 refline 0;
 title 'DATALABEL=PRICE';
run;							*ST202s02.sas;


proc sgplot data=out;
 scatter y=difference x=estimate / datalabel=enginesize;
 xaxis min=0 max=55;
 yaxis min=-20 max=20;
 refline 0;
 title 'DATALABEL=ENGINESIZE';
run;							*ST202s02.sas;





