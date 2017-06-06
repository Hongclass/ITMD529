data sales_staff;
   infile 'sales1.dat';  *PC and Unix;
   *infile '.workshop.rawdata(sales1)';  *Z/OS Mainframe;
   input  @1 Employee_ID 6.
         @21 Last_Name $18.
         @43 Job_Title $20.
         @64 Salary Dollar8.
         @87 Hire_Date mmddyy10.;
run;

title 'Australian and US Sales Staff';
proc print data=sales_staff noobs;
run;
title;
