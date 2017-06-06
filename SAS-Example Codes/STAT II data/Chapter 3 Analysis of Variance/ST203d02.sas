proc glm data=sasuser.school;
   class school gender;
   model reading3 = school|gender;
   lsmeans school*gender / pdiff adjust=tukey cl;
run;
quit;                       *ST203d02.sas;

**---------------------------------------------------------------------
 Comparisons of differences between Cottonwood and Dogwood girls,
 versus the difference between Cottonwood and Dogwood boys discussed
 in the text.
-----------------------------------------------------------------------;
proc glm data=sasuser.school;
   class school gender;
   model reading3 = school|gender;
   estimate 'CGirls vs DGirls' school 1 -1 0 0 school*gender 1 0 -1 0 0 0 0 0 ;
   estimate 'CBoys vs DBoys' school   1 -1 0 0 school*gender 0 1 0 -1 0 0 0 0;
run;
quit;
