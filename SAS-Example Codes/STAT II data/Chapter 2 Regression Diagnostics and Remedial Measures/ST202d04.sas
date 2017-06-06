title;

data sasuser.logcars2;
 set sasuser.cars2;
 LogPrice=log(price);
run;

proc reg data=sasuser.logcars2;
   model logprice = hwympg hwympg2 horsepower;
   ods output ANOVA=ANOVATable; 
   output out=out p=Pred r=Resid;
run;
quit;

data out;
   set out;
   abserror=abs(resid);
run;

proc corr data=out spearman nosimple;
   var abserror pred;
run;                                  *ST202d04.sas;

data _null_;
   set ANOVATable;
   if source='Error' then call symput('Var', MS);
run;

data out;
   set out;
   Estimate = exp(pred + &var/2);
   Difference = price - estimate;
run;

proc print data=out;
   var manufacturer model hwympg horsepower price estimate difference;
run;                                    

proc sgplot data=out;
   scatter x=estimate y=difference;
   xaxis min=0 max=60;
   yaxis min=-30 max=25;
   refline 0;
run;
quit;
									*ST202d04.sas;
proc sgplot data=out;
   scatter x=estimate y=difference /datalabel=model;
   xaxis min=0 max=60;
   yaxis min=-30 max=25;
   refline 0;
run;
quit;

				 					*ST202d04.sas;
