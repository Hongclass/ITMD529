data usa australia(drop=State) other;
   set orion.employee_addresses 
       (drop=Street_ID Employee_ID);
   drop Country;
   if Country='US' then output usa;
   else if Country='AU' then output australia;
   else output other;
run;
