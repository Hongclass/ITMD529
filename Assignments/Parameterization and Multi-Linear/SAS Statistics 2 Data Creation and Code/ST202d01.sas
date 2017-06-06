
*---------------------------------------------------------------------------------------- 
	Evaluate the model fit for the STAT2.CARS data set. Assume you are using the model 
	with three variables: hwympg, hwympg^2 and horsepower. Check for violations of the 
	assumptions, model fit and collinearity, and identify observations that may be 
	influential.
*---------------------------------------------------------------------------------------;
ods graphics / imagemap=on;
ods html style=analysis;
proc glmselect data=STAT2.cars outdesign(addinputvars)=d_carfinal;
   effect q_hwympg = polynomial(hwympg / degree=2 standardize(method=moments)=center);
   model price = q_hwympg horsepower / selection=none;
run;

proc reg data=d_carfinal plots(unpack label)=all;
   model price = &_GLSMOD / vif collin collinoint influence spec partial;
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
run;                                    *ST202d01.sas;
