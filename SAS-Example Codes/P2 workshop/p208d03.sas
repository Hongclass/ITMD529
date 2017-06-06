proc transpose 
     data=orion.employee_donations
     out=rotate2;
   by Employee_ID;
run;
proc print data=rotate2 noobs;
run;

