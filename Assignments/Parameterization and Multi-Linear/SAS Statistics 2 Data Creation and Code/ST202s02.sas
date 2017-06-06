***********************************
Chapter 2 Exercise 2
**********************************;
ods output ParameterEstimates=params;
proc glimmix data=STAT2.cars; 
   effect p_city=polynomial(citympg / degree=2 standardize(method=moments)=center);
   effect p_hp=polynomial(horsepower / degree=2 standardize(method=moments)=center);
   model price = p_city enginesize p_hp weight / dist=lognormal solution;
   output out=out pred=pred;
   id manufacturer model price citympg enginesize;
run; 							*ST202s02.sas;

data _null_;
   set params;
   if Effect='Scale' then call symput('var', Estimate);
run;

data out;
   set out;
   Estimate=exp(pred + &var/2);
   Difference = price - estimate;
run; 							
 
proc print data=out;
   var model price estimate difference;
run;                           *ST202s02.sas;

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





