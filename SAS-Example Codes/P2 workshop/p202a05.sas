  /* Q- What is wrong with this code? */

data usa australia(drop=state) other;
  set orion.employee_addresses
     (drop=Country Street_ID Employee_ID);
  if Country='US' then output usa;
  else if Country='AU' then output australia;
  else output other;
run;
