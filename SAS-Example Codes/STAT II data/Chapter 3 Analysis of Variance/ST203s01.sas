*----------------------------------------------
	Chapter 3 (ANOVA) Exercises
-----------------------------------------------;
*1a and 1b;
proc glm data=sasuser.disks;
   class technician brand;
   model time=technician|brand;
run;
quit; 						*ST203s01.sas;

*1d;
proc glm data=sasuser.disks;
   class technician brand;
   model time=technician|brand;
   lsmeans technician*brand / slice=brand slice=technician;
run;
quit; 						*ST203s01.sas;

