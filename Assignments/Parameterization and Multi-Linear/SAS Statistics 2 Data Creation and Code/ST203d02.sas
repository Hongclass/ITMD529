
proc glm data=STAT2.school;
   class school gender;
   model reading3 = school|gender;
   lsmeans school*gender / pdiff adjust=tukey cl;
run;
quit; 						*ST203d02.sas;
