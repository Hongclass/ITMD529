
title;
*a;
ods html;
ods listing close;
options formdlim="_" nodate linesize=125;

proc print data=STAT2.school(obs=25);
run;						*ST206s01.sas;

proc freq data=STAT2.school;
   tables school*gender / nocol norow nopercent;
run;						*ST206s01.sas;
*b;
title1 "Distribution of Scores by School and Gender";
proc sgpanel data=STAT2.school;
  where reading3 is not missing 
        and teacher is not missing 
        and school is not missing
        and gender is not missing;
  panelby school gender / layout=lattice;
  vbox reading3;
run; 						*ST206s01.sas;

*d;
title;
proc glimmix data=STAT2.school;
   class school gender teacher;
   model reading3=school gender school*gender;
   random teacher(school);
run;     					*ST206s01.sas;
*e;
proc glimmix data=STAT2.school ;
   class school gender teacher;
   model reading3=school gender school*gender;
   random teacher(school) ;
   lsmestimate school*gender 'Cottonwood Girls vs. All Others' 
               5 -1  -1 -1 -1 -1 -1 -1 /divisor=5 elsm;
run;

*f;
proc glimmix data=STAT2.school;
   class school gender teacher;
   model reading3=school gender school*gender teacher(school);
   output out=checkvar variance=ResidualVariance; 
run;
proc print data=checkvar(obs=1);
   var ResidualVariance;
title 'Check Residual Variance';
run;
title;
	
