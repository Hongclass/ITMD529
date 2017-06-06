  /* Program with a logic error */
  /* Display TotSales and Sale_Amt */

data customers;
  set orion.order_summary;
  by Customer_ID;
  if first.Customer_ID=1 then TotSales=0;
  putlog TotSales= Sale_Amt=;
  Total_Sales+Sale_Amt;
  if last.Customer_ID=1;
  keep Customer_ID Total_Sales;
run;


  /* Display Total_Sales */

data customers;
  set orion.order_summary;
  by Customer_ID;
  if first.Customer_ID=1 then TotSales=0;
  putlog TotSales= Sale_Amt=;
  Total_Sales+Sale_Amt;
  putlog Total_Sales=;
  if last.Customer_ID=1;
  keep Customer_ID Total_Sales;
run;


  /* Correct the error and remove the PUTLOG statements */

data customers;
  set orion.order_summary;
  by Customer_ID;
  if first.Customer_ID=1 then Total_Sales=0;
  Total_Sales+Sale_Amt;
  if last.Customer_ID=1;
  keep Customer_ID Total_Sales;
run;
  /* Print the output data set */

proc print data=customers;
run;
