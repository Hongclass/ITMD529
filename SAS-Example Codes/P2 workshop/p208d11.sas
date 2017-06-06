proc transpose data=orion.order_summary
               out=annual_orders(drop=_name_)
               prefix=Month;
   by Customer_ID;
   id Order_Month;
run;
  /* Add a VAR statement */
proc print data=annual_orders noobs;
   var Customer_ID Month1-Month12;
run;
