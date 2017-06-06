  /* Use the DEBUG option on the DATA statement */

data customers /debug;
  set orion.order_summary;
  by Customer_ID;
  if first.Customer_ID=1 then TotSales=0;
  Total_Sales+Sale_Amt;
  if last.Customer_ID=1;
  keep Customer_ID Total_Sales;
run;

  /* Correct the error and remove the DEBUG option */
 
data customers;
  set orion.order_summary;
  by Customer_ID;
  if first.Customer_ID=1 then Total_Sales=0;
  Total_Sales+Sale_Amt;
  if last.Customer_ID=1;
  keep Customer_ID Total_Sales;
run;
proc print data=customers;
run;
