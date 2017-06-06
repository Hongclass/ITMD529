data usa australia other;
   set orion.employee_addresses;
   if Country='AU' then output australia;
   else if Country='US' then output usa;
   else output other;
run;

  /* alternate solution */
data usa australia other;
   set orion.employee_addresses;
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;
