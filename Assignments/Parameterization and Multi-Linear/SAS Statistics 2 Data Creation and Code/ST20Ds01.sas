

*4a;
proc means data=STAT2.catalog nway noprint;
   class design size;
   var requests;
   output out=transform mean=Mean var=Variance n=N;
run;

data transform;
   set transform;
   Sqrt_Transform=variance/mean;
   Log_Transform=variance/(mean**2);
   Inverse_Transform=variance/(mean**4);
run;

proc print data=transform;
   var design size n mean variance sqrt_transform
       log_transform inverse_transform;
run; 								*ST20Ds01.sas;

*----------------------------------------------------
	Alternatively, use PROC SQL to compare the
	ratios
----------------------------------------------------------;

proc sql;
 select max(sqrt_transform)/min(sqrt_transform) as SqrtRatio,
		max(log_transform)/min(log_transform) as LogRatio,
		max(inverse_transform)/min(inverse_transform) as InverseRatio
 from transform;
quit;									*ST20Ds01.sas;

*4b;
data catalog;
   set STAT2.catalog;
   LogRequests=log(requests);
run;

proc glm data=catalog plots(unpack)=diagnostics;
   class design size;
   model logrequests=design|size;
   title 'Log Transformation';
run;
quit; 			
										*ST20Ds01.sas;

data catalog;
   set catalog;
   Group=compress(design||size);
run;

proc glm data=catalog;
   class group;
   model logrequests=group;
   means group/hovtest;
run;
title;
quit;									*ST20Ds01.sas;
