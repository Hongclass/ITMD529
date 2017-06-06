
ods html style=listing;
proc glm data=STAT2.trials;
   class treatment;
   model bpchange = treatment baselinebp treatment*baselinebp / solution;
title 'Analysis of Covariance';
run;
quit;      
						*ST204d01.sas;
