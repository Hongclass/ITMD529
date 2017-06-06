 /* Part A */

%let location=DE;
title "Customers in &location";
proc print data=orion.customer;
	var customer_id customer_name gender; 
	where country="&location";
run;
title;


 /*Part B */

%let location=ZA;
title "Customers in &location";
proc print data=orion.customer;
	var customer_id customer_name gender; 
	where country="&location";
run;
title;

