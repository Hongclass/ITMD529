
/*WELCH'S ANOVA - Self-study*/
proc glm data=STAT2.pressure2;
   class drug;
   model bpchange=drug;
   means drug / welch;
run;
quit;       		*ST203d08.sas;   
