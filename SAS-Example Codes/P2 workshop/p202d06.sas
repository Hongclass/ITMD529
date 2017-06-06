  /* Use DROP= data set option to control variable output */

data usa (drop=Street_ID Country)
     australia (drop=Street_ID State Country)
     other;
   set orion.employee_addresses;
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;
