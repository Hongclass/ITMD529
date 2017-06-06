
ods html close;
proc glm data=STAT2.school;
   class school gender;
   model reading3 = school|gender;
   store out=STAT2.schoolstore;
run;
quit;
ods html;
proc plm restore=STAT2.schoolstore;
   lsmestimate school*gender  'Female Cottonwood&Dogwood vs. Female Maple&Pine'
     .5 0 .5 0 -.5 0 -.5 0 / elsm;
   lsmestimate school 'Cottonwood vs. Dogwood, Maple and Pine'
                       1 -0.333333 -0.333333 -0.333333;
   lsmestimate school  'Cottonwood vs. Dogwood, Maple and Pine'
                       3 -1 -1 -1 / divisor=3;
run;								
								*ST203d04.sas;
