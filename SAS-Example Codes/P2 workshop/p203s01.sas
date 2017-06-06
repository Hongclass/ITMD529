data work.mid_q4;
  set orion.order_fact;
  where '01nov2004'd <= Order_Date <= '14dec2004'd;
  Sales2Dte+Total_Retail_Price;
  Num_Orders+1;
run;


title 'Orders from 01Nov2004 through 14Dec2004';
proc print data=work.mid_q4;
  format Sales2Dte dollar10.2;
  var Order_ID Order_Date Total_Retail_Price Sales2Dte Num_Orders;
run;
title;
