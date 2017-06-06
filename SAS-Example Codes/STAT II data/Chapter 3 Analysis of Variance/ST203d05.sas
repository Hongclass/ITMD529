proc freq data=sasuser.school;
   tables gender*school*semesters / nocol norow nopercent;
run;                                 	*ST203d05.sas;

proc glm data=sasuser.school;
   class gender semesters school;
   model reading3=gender|semesters|school / ss1 ss2 ss3 ss4;
run;
quit;                                 	*ST203d05.sas;

proc glm data=sasuser.school;
   class gender semesters school;
   model reading3 = gender|semesters|school @2
         / ss1 ss2 ss3 ss4;
run;
quit;                           		*ST203d05.sas;

proc glm data=sasuser.school;
   class gender semesters school;
   model reading3 = gender semesters school    
                    gender*semesters gender*school;
run;
quit;                                   *ST203d05.sas;

proc glm data=sasuser.school;
   class gender semesters school;
   model reading3 = gender semesters school gender*school;
run;
quit;                                   *ST203d05.sas;

proc glm data=sasuser.school;
   class gender semesters school;
   model reading3 = gender semesters school gender*school;
   means semesters;
   lsmeans semesters gender*school / pdiff adjust=tukey cl;
run;
quit;                                    *ST203d05.sas;
