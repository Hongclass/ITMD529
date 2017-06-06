proc transpose data=orion.order_summary
               out=annual_orders;
run;

proc print data=annual_orders noobs;
run;
