data sales_staff2;
   infile 'sales2.dat'; *PC and Unix;
   *infile '.workshop.rawdata(sales2)'; *Z/OS Mainframe;
   input  @1 Employee_ID 6.
         @21 Last_Name $18. /
          @1 Job_Title $20.
         @22 Hire_Date mmddyy10.
         @33 Salary dollar8. /;
run;

  /* Alternate */
data sales_staff2;
   infile 'sales2.dat'; *PC and Unix;
   *infile '.workshop.rawdata(sales2)'; *Z/OS Mainframe;
   input  @1 Employee_ID 6.
         @21 Last_Name $18.;
   input  @1 Job_Title $20.
         @22 Hire_Date mmddyy10.
         @33 Salary dollar8.;
   input;
run;

  /* Alternate */
data sales_staff2;
   infile 'sales2.dat'; *PC and Unix;
   *infile '.workshop.rawdata(sales2)'; *Z/OS Mainframe;
   input  @1 Employee_ID 6.
         @21 Last_Name $18. 
    #2    @1 Job_Title $20.
         @22 Hire_Date mmddyy10.
         @33 Salary dollar8.
    #3    ;
run;

title 'Australian and US Sales Staff';
proc print data=sales_staff2 noobs;
run;
title;
