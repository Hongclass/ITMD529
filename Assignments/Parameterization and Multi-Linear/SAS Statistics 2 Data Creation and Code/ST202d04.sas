
proc reg data=d_carfinal;
   model price = &_GLSMOD  / hcc hccmethod=3;
run;
quit; 							*ST202d04.sas;
 
