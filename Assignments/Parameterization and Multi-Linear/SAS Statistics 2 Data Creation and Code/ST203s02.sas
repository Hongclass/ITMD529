
title;
*2a;
ods html close;
proc glm data=STAT2.disks;
   class technician brand;
   model time = technician|brand;
   store out=STAT2.diskstore;
run;
ods html;  
proc plm restore=STAT2.diskstore;
   lsmestimate technician*brand 
               'Bob Brand 2 vs Justin Brand 2' 
                0 0 0 0 1 0 0 -1 0 0 0 0 / elsm;
run;
quit; 						*ST203s02.sas;

*2b;
proc plm restore=STAT2.diskstore;
   lsmestimate technician*brand 
               'Lowest (Angela Brand 2) vs. Highest (Karen Brand 3)' 
    	        0 1 0   0 0 0  0 0 0  0 0 -1 / elsm;
run;
quit;								*ST203s02.sas;

