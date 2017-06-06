proc transpose
     data=orion.employee_donations
     out=rotate2(rename=(col1=Amount)
                 where=(Amount ne .))
   name=Period;
   by employee_id;
run;
proc print data=rotate2 noobs;
run;
proc freq data=rotate2;
   tables Period/nocum nopct;
   label Period=" ";
run;
