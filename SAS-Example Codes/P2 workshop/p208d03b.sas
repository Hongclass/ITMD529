
  /* The VAR statement specifies the variables to transpose. */
  /* It has no effect here because there are no other numeric variables. */
proc transpose 
     data=orion.employee_donations
     out=rotate2;
   by Employee_ID;
   var Qtr1-Qtr4;
run;
proc print data=rotate2 noobs;
run;
