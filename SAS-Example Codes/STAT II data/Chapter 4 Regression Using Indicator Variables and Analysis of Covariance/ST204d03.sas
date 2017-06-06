ods html  style=htmlbluecml;
ods listing close;
proc reg data=trials plots=all;
   model bpchange=A N baselinebp AByBBP NByBBP / influence vif collin 
         collinoint spec;
run;
quit;  
			                             *ST204d03.sas;
proc stdize data=sasuser.trials method=mean 
            out=trials2c (rename=(baselinebp=baselinebpc));
   var baselinebp; run;

data trials2c;
   set trials2c;
   A=(treatment='Approved Drug');
   N=(treatment='New Drug');
   AByBBPC=A*baselinebpc;
   NByBBPC=N*baselinebpc;
run;										*ST204d03.sas;
