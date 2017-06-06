proc glm data=sasuser.school;
   class school gender;
   model reading3 = school|gender;
   lsmeans school*gender / slice=gender slice=school;
run;
quit;                                     *ST203d03.sas;
