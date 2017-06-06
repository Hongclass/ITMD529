title 'Customers in DE';
proc print data=orion.customer;
   var customer_id customer_name gender; 
   where country='DE';
run;
