proc sort data=orion.order_summary out=work.sumsort;
  by Customer_ID;
run;
 
data work.customers;
  set work.sumsort;
  by Customer_ID;
  if first.Customer_ID then Total_Sales=0;
  Total_Sales+Sale_Amt;
  if last.Customer_ID;
  keep Customer_ID Total_Sales;
run;

title 'Total Sales to each Customer';
proc print data=work.customers;
  format Total_Sales dollar11.2;
run;
title;
