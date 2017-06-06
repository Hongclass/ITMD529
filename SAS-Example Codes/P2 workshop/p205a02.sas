data hrdata;
   set orion.convert;            
   GrossPay=input(GrossPay,comma6.);
run;

proc contents data=hrdata;
run;
