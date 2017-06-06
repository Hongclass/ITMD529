proc freq data=sasuser.trials;
   tables treatment;
run;

data trials;
   set sasuser.trials;
   A=(treatment='Approved Drug');
   N=(treatment='New Drug');
   AByBBP=A*baselinebp;
   NByBBP=N*baselinebp;
run;

proc reg data=trials;
   model bpchange=A N baselinebp AByBBp NByBBP;
run; 
quit;                              *ST204d02.sas;
