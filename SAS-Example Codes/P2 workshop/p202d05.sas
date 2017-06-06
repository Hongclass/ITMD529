  /* Display the data portion of employee_addresses data set. */

proc contents data=orion.employee_addresses;
run;

  /* Drop one variable from new data sets. */

data usa australia other;
   drop Street_ID;
   set orion.employee_addresses;
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;
