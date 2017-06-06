options ls=121;

proc sql;
   select customer_id, customer_name,
          customer.country, country_name
   from orion.customer, 
	   orion.country
   where customer.country=country.country
	;
quit;

options ls=95;
