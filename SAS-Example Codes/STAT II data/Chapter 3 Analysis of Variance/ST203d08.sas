options formdlim="_";
ods graphics / reset=all;

proc glm data=sasuser.pressure2 plots (unpack)=all;
   class drug;
   model bpchange=drug;
   means drug / hovtest;
run;
quit;


proc glm data=sasuser.pressure2;
   class drug;
   model bpchange=drug;
   means drug / welch;
run;
quit;              					*ST203d08.sas;
