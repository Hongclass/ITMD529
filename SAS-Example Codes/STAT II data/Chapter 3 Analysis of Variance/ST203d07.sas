title;
proc transreg data=sasuser.school  nomiss plots=none;
   model boxcox(reading3 / parameter=0.0000001 )=class(gender semesters school gender*school);
run;
quit;      							*ST203d07.sas;   

data school_t;
   set sasuser.school;
   IDReading3=reading3;
   BoxCoxReading3=(reading3**.25 -1)/ .25;
   LogReading3=log(reading3);
   SqrtReading3=sqrt(reading3);		*ST203d07.sas;   
run; 

*---------------------------------------------------------------
 Clear all graphics from S:\ drive before running the macro
---------------------------------------------------------------;

%macro transform (trans);
title "&trans.Residuals";
ods select ResidualHistogram QQPlot ResidualByPredicted;
proc glm data=school_t plots(unpack)=diagnostics;
   class gender semesters school;
   model &trans.reading3 = gender semesters school gender*school ;
   output out=&trans.check r=&trans._Residuals;
run;
quit;
	
ods select TestsForNormality;
ods output moments=&trans.moments;
proc univariate data=&trans.check normal;
   var &trans._residuals;
   histogram / normal;
run;							                         

%mend transform;
%transform (ID);
%transform (BoxCox);
%transform (Log);
%transform (Sqrt); 				*ST203d07.sas;   
title;

data compare (keep=varname Skewness Kurtosis);
   length varname $20;
   set  idmoments boxcoxmoments logmoments sqrtmoments;
   Skewness=cvalue1;
   Kurtosis=cvalue2;
   where label1= 'Skewness';
run;

proc print data=compare;
title 'Compare Skewness and Kurtosis for the Transformations';
run;	
title; 							*ST203d07.sas; 
