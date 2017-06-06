  /* Part A */
data work.sales (keep=Employee_ID Job_Title Manager_ID)
     work.exec (keep=Employee_ID Job_Title);
   set orion.employee_organization;
   if Department='Sales' then output work.sales;
   else if Department='Executives' then output work.exec;
run;


  /* Part B */
title 'Sales Employees';
proc print data=work.sales (obs=6);
run;
title;


  /* Part C */
title 'Executives';
proc print data=work.exec (firstobs=2 obs=3);
run;
title;
