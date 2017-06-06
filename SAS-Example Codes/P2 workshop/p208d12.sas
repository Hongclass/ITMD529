proc transpose data=orion.order_summary
               out=annual_orders(drop=_name_)
               prefix=Month;
   by Customer_ID;
   id Order_Month;
run;
  /* Use a DATA step to re-order variables */
data annual_orders;
	retain Customer_ID Month1-Month12;
	set annual_orders;
run;
proc contents data=annual_orders varnum;
run;
proc print data=annual_orders;
run;
