proc reg data=trials2c;
   model bpchange=A N baselinebpc ABybbpc NBybbpc / vif 
         collin collinoint;
   title 'Diagnostics on Centered BaselineBP Model';
run;
quit;								*ST204d04.sas;
 
proc reg data=trials2c;
   model bpchange=A N baselinebpc ABybbpc NBybbpc;
   Both:test A-N=0, AByBBPC-NByBBPC=0;
run;
quit;                               *ST204d04.sas; 

proc reg data=trials2c;
   model bpchange=A N baselinebpc ABybbpc NBybbpc;
   Intercepts:test A-N=0;
   Slopes: test AByBBPC-NByBBPC=0;
run;
quit;                               *ST204d04.sas; 

title 'Tests on Original Data';
proc reg data=trials;
   model bpchange=A N baselinebp AByBBP NByBBP;
   Both:test A-N=0, AByBBP-NByBBP=0;
   Intercepts: test A=N;
   Slopes: test AByBBP=NByBBP;
run;
quit;                               *ST204d04.sas; 
