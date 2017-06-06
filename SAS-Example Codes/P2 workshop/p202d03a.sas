  /* Create three data sets based on value of Country */
data usa australia other;
   set orion.employee_addresses;
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;

  /* Display selected variables from each data set */
title 'Employees in the United States';
proc print data=usa;
   	var Employee_ID Employee_Name City State Country;
run;

title 'Employees in Australia';
proc print data=australia;
	var Employee_ID Employee_Name City State Country;
run;

title 'Non US and AU Employees';
proc print data=other;
	var Employee_ID Employee_Name City State Country;
run;
title;

/* Use the upcase function to ignore case for Country values */
data usa australia other;
   set orion.employee_addresses;
   if upcase(Country)='US' then output usa;
   else if upcase(Country)='AU' then output australia;
   else output other;
run;

/* Alternate solution - correct the case of Country */
data usa australia other;
   set orion.employee_addresses;
   Country=upcase(country);
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;


