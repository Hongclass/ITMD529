
title;
ods html close; ods listing;
options formdlim="_";
*1a;
proc glm data=STAT2.disks;
   class technician brand;
   model time = technician|brand;
   contrast 'Bob Brand 2 vs Justin Brand 2' 
             technician 0 1 -1 0 
             technician*brand 0 0 0 0 1 0 0 -1 0 0 0 0 / E;
run;
quit; 						*ST203s03.sas;

*1b;
proc glm data=STAT2.disks;
   class technician brand;
   model time=technician|brand;
   estimate 'Lowest (Angela Brand 2) vs. Highest (Karen Brand 3)' 
      technician 1 0 0 -1
	  brand 0 1 - 1
	  technician*brand 0 1 0   0 0 0  0 0 0  0 0 -1 / E;
run;
quit;
ods listing close; ods html;	*ST203s03.sas;

