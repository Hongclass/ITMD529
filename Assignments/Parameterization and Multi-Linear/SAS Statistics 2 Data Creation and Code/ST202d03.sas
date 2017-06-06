
*------------------------------------------------------------------------
  Use PROC GLIMMIX to fit a lognormal regression model
-------------------------------------------------------------------------;
title 'Lognormal model for CARS dataset';

ods output ParameterEstimates=params;
proc glimmix data=STAT2.cars;
   effect q_hwympg = polynomial(hwympg / degree=2 standardize(method=moments)=center);
   model price = q_hwympg horsepower / dist=lognormal solution;
   output out=out pred=pred resid=resid;
   id model price;
run;
	
data check3;
   set out;
   abserror=abs(resid);
run;

proc corr data=check3 spearman nosimple;
   var abserror pred;
run;						 *ST202d03.sas;

*------------------------------------------------------------------------
  Back-transform predicted values from lognormal model
-------------------------------------------------------------------------;
data _null_;
	set params;
	if Effect='Scale' then call symput('var',Estimate);
run;

data back;
	set check3;
	Estimate = exp(pred + &var/2);
	Difference = Price-Estimate;
run;

proc sgplot data=back;
	scatter x=Estimate y=Difference / datalabel=model;
	xaxis min=0 max=60;
	yaxis min=-30 max=30;
	refline 0;
run;                      *ST202d03.sas;


	
