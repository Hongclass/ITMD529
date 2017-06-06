  /* Use DROP= and KEEP= options to control variable output */

data usa (keep=Employee_Name City State Country)
     australia (drop=Street_ID State Country)
     other;
   set orion.employee_addresses;
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;
