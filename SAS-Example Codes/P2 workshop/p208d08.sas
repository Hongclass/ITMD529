  /* Add an ID statement */
proc transpose data=orion.order_summary
               out=annual_orders;
   by Customer_ID;
   id Order_Month;
run;

proc print data=annual_orders noobs;
run;

