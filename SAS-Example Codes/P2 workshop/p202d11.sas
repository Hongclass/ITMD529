  /* use OBS= and FIRSTOBS= options on a PROC step */

proc print data=orion.employee_addresses 
           (firstobs=10 obs=15);
   var Employee_Name City State Country;
run;



