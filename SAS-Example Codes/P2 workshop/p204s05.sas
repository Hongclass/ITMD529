data AU_sales US_sales;
   drop Country;
   infile 'sales3.dat'; *PC and Unix;
   *infile '.workshop.rawdata(sales3)'; *Z/OS Mainframe;
   input  @1 Employee_ID 6.
         @21 Last_Name $18.
         @43 Job_Title $20.;
   input @10 Country $2. @;
   if Country = 'AU' then do;
      input @1 Salary dollarx8.
           @24 Hire_Date ddmmyy10.;
      output AU_sales;
   end;
   else if Country = 'US' then do;
      input @1 Salary dollar8.
           @24 Hire_Date mmddyy10.;
      output US_sales;
   end;    
run;

title 'Australian Sales Staff';
proc print data=AU_sales noobs;
run;

title 'US Sales Staff';
proc print data=US_sales noobs;
run;
title;

