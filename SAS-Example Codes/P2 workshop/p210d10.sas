%let site=Melbourne;
proc print data=orion.employee_addresses;
   where City="&site";
   var Employee_ID Employee_Name;
   title 'Employees from &site';
run;
title;
