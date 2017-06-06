
*---------------------------------------------------------------------------------------- 
	Evaluate the model fit for the SASUSER.CARS data set. Assume you are using the model 
	with three variables: hwympg, hwmpg2 and horsepower. Check for violations of the 
	assumptions, model fit and collinearity, and identify observations that may be 
	influential
*---------------------------------------------------------------------------------------;
ods graphics / imagemap=on;
ods listing close;
ods html style=analysis;
proc reg data=sasuser.cars2  plots (label)=all;
   model price = hwympg hwympg2 horsepower
     / vif collin collinoint influence spec partial;
   id model;
   output out=check r=residual p=pred rstudent=rstudent h=leverage;
run;
quit;  									*ST202d01.sas;


data check;
   set check;
   abserror=abs(residual);
run;

proc corr data=check spearman nosimple;
   var abserror pred;
run;                                      *ST202d01.sas;
