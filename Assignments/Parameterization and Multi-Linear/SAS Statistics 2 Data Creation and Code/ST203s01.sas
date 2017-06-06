*----------------------------------------------
	Chapter 3 (ANOVA) Exercises
-----------------------------------------------;
*1a and 1b;
ods html close;
ods listing style=statistical;
proc glm data=STAT2.disks;
   class technician brand;
   model time=technician|brand;
run;
quit; 						*ST203s01.sas;

*1d;
proc glm data=STAT2.disks;
   class technician brand;
   model time=technician|brand;
   lsmeans technician*brand / slice=brand slice=technician;
run;
quit; 		
ods listing close;
ods html;			*ST203s01.sas;

