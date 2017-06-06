title;
*a;
ods html close;
ods listing;
proc print data=sasuser.school;
run;						*ST206s01.sas;

proc freq data=sasuser.school;
   tables school*gender / nocol norow nopercent;
run;						*ST206s01.sas;
*b;
goptions reset=all;
title1 "Distribution of Scores by School and Gender";
proc sgpanel data=sasuser.school;
  where reading3 is not missing 
        and teacher is not missing 
        and school is not missing
        and gender is not missing;
  panelby school gender / layout=lattice;
  vbox reading3;
run; 						*ST206s01.sas;

*d;
title;
proc mixed data=sasuser.school;
   class school gender teacher;
   model reading3=school gender school*gender;
   random teacher(school);
run;     					*ST206s01.sas;

*e;
proc mixed data=sasuser.school;
   class school gender teacher;
   model reading3=school gender school*gender teacher(school);
run;

*f;
proc mixed data=sasuser.school ;
   class school gender teacher;
   model reading3=school gender school*gender;
   random teacher(school) ;
   estimate 'Cottonwood vs. Maple' school 1 -1 0;
run;						*ST206s01.sas;
*g;
title 'EMS for Correct Model';
proc mixed data=sasuser.school method=type3;
   class school gender teacher;
   model reading3=school gender school*gender;
   random teacher(school);
run;     					*ST206s01.sas;
title 'EMS for Incorrect Model';
proc mixed data=sasuser.school method=type3;
   class school gender teacher;
   model reading3=school gender school*gender teacher(school);
run;  
ods listing close;
ods html;						*ST206s01.sas;
