ods html close;
ods listing;
proc reg data=sasuser.cars2;
   model price=hwympg hwympg2 horsepower / stb;
run;
quit;  						*ST2Dd05.sas;                              
