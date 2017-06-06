ods html style=htmlbluecml;
ods listing close;
proc sgplot data = sasuser.trials;
reg x=baselinebp y=bpchange / group=treatment ; 
run; 						*ST204d01.sas;
