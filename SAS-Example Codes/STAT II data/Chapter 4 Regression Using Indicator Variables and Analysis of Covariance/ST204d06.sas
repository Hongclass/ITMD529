proc glm data=sasuser.trials;
   class treatment;
   model bpchange = treatment|baselinebp;
   lsmeans treatment / pdiff adjust=tukey;
   lsmeans treatment / at baselinebp=90 pdiff adjust=tukey;
   lsmeans treatment / at baselinebp=100 pdiff adjust=tukey;
run;
quit;
									   *ST204d06.sas;
