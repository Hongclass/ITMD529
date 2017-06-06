options formdlim="_";
proc glm data=sasuser.school plots(unpack)=diagnostics;
   class gender semesters school;
   model reading3 = gender semesters school gender*school;
   output out=check r=residuals p=predicted;
run;
quit;
								*ST203d06.sas;
goptions reset=all;
ods select moments 
           BasicMeasures
		   GoodnessOfFit
		   ;
proc univariate data=check;
   var residuals;
   histogram / normal;
run;

data school;
   set sasuser.school;
   Group=compress(gender||school||semesters);
run;

proc glm data=school;
   class group;
   model reading3=group;
   means group / hovtest;
run;
quit;                        		*ST203d06.sas;



