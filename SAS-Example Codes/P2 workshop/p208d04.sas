  /* Add the PROC TRANSPOSE NAME= option */
proc transpose 
     data=orion.employee_donations 
     out=rotate2 
     name=Period;
   by employee_id;
run;

proc print data=rotate2 noobs;
run;

  /* Add the RENAME= data set option */
proc transpose 
     data=orion.employee_donations 
     out=rotate2 (rename=(col1=Amount))
     name=Period;
   by employee_id;
run;

proc print data=rotate2 noobs;
run;

  /* PROC FREQ to analyze the resulting data set */

proc freq data=rotate2;
   tables Period/nocum nopct;
run;
