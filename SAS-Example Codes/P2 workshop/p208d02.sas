proc transpose 
     data=orion.employee_donations
     out=rotate2;
run;
proc print data=rotate2 noobs;
run;
