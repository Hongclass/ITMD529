
ods html;
ods listing close;
proc reg data=STAT2.cars2;
   model price=hwympg hwympg2 horsepower / stb;
run;
quit;  						*ST2D0d09.sas;                              
