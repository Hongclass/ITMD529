  /* Add a BY statement */
proc transpose data=orion.order_summary
               out=annual_orders;
   by Customer_ID;
run;

proc print data=annual_orders noobs;
run;
