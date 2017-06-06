
ods html style=listing;
proc glm data=STAT2.trials;
   class treatment;
   model bpchange = treatment|baselinebp;
   lsmeans treatment / pdiff adjust=tukey;
   lsmeans treatment / at baselinebp=90 pdiff adjust=tukey;
   lsmeans treatment / at baselinebp=100 pdiff adjust=tukey;
title 'Least Squares Means for ANCOVA Model';
run;
quit;
									   *ST204d02.sas;
