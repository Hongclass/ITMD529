title;
proc means data=sasuser.school mean;
   var reading3;
   where words1 is not missing;
run;                                        *ST20Cd02.sas;

proc reg data=sasuser.school;
   model reading3 = words1;
   plot reading3*words1 / vref=49.24;
run; 
quit;                                       *ST20Cd02.sas;

options symbolgen;
proc sql noprint;
   select avg(reading3)
      into :mean
   from sasuser.school
   where words1 is not missing;
quit;

proc reg data=sasuser.school;
   model reading3 = words1;
   plot reading3*words1 / vref=&mean;
run;
quit;    								  	*ST20Cd02.sas;

