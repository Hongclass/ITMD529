title; 
proc glm data=sasuser.trials;
   class treatment;
   model bpchange = treatment baselinebp treatment*baselinebp / solution;
run;
quit;           
								*ST204d05.sas;
