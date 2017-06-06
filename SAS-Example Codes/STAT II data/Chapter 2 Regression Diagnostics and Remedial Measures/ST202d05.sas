proc reg data=sasuser.cars2;
   model price = hwympg hwympg2 horsepower  / hcc hccmethod=3;
run;
quit; 							*ST202d05.sas;
 
