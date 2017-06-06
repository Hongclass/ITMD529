
ods html close;
ods html style=htmlblue;
proc glm data=STAT2.school;
   class gender;
   model reading3=gender|words1;
   lsmeans gender / pdiff adjust=tukey;
   lsmeans gender / at words1=40 pdiff adjust=tukey;
   lsmeans gender / at words1=60 pdiff adjust=tukey;
title 'L-S Means';
run;
quit;					*ST204s02.sas;
