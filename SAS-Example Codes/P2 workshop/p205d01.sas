  /* without a variable list */
data contrib;
   set orion.employee_donations;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
   if Total ge 50;
   run;

proc print data=contrib noobs;
   title 'Contributions $50 and Over';
   var Employee_ID Qtr1 Qtr2 Qtr3 Qtr4 Total;
run;

title;

  /* Using a variable list */
data contrib;
   set orion.employee_donations;
   Total=sum(of Qtr1-Qtr4);
   if Total ge 50;
run;

proc print data=contrib noobs;
   title 'Contributions $50 and Over';
   var Employee_ID Qtr1-Qtr4 Total;
run;

title;
