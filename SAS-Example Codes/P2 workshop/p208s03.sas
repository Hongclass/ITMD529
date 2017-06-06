data customer_orders;
	set orion.order_summary;
	retain Month1-Month12;
	array Month{12};
	by Customer_ID;
	if first.Customer_ID then call missing(of Month{*});
	Month{Order_month}=Sale_Amt;
	if last.Customer_ID;
	drop Order_Month Sale_Amt;
run;

options ls=120;
proc print data=customer_orders noobs;
run;
