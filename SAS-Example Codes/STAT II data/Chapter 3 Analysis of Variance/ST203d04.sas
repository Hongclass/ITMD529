options formdlim="_";
proc glm data=sasuser.school;
   class school gender;
   model reading3 = school|gender;
   contrast 'Female Cottonwood&Dogwood vs. Female Maple&Pine'
      school .5 .5 -.5 -.5
      school*gender .5 0 .5 0 -.5 0 -.5 0 ;
   estimate 'Female Cottonwood&Dogwood vs. Female Maple&Pine'
      school .5 .5 -.5 -.5
      school*gender .5 0 .5 0 -.5 0 -.5 0;
   estimate 'Cottonwood vs. Dogwood, Maple and Pine'
      school 1 -0.333333 -0.333333 -0.333333 / e;
   estimate 'Cottonwood vs. Dogwood, Maple and Pine'
      school 3 -1 -1 -1 / divisor=3;
   contrast 'Cottonwood vs. Maple vs. Pine'
      school 1 0 -1 0,
	  school 1 0 0 -1;
run;
quit;                                      *ST203d04.sas;
