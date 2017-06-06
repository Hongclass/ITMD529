  /* use OBS= and FIRSTOBS= with a WHERE statment*/

proc print data=orion.employee_addresses 
           (firstobs=1 obs=10);
   where Country='AU';
   var Employee_Name City Country;
run;
