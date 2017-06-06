options ls=121;

proc sql;
   select customer_id, customer_name,
          customer.country, country_name
   from orion.customer, 
	   orion.country
   where 
	;
quit;
options ls=95;
