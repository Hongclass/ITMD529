options formdlim="_";
title;
proc sgplot data = sasuser.school;
reg x=words1 y=reading3 / group=gender ; 
run; 						*ST204s01.sas;

proc freq data=sasuser.school;
   tables gender;
run; 						*ST204s01.sas;

data school;
   set sasuser.school;
   Female=(gender='F');
   FemaleByWords1=female*words1;
run; 						*ST204s01.sas;

proc reg data=school;
   model reading3=words1 female femaleByWords1;
run;
quit; 						*ST204s01.sas;

**Advanced exercise;
proc reg data=school;
   model reading3=words1 female femalebywords1 / vif collin collinoint;
run; 	
quit;						*ST204s01.sas;
