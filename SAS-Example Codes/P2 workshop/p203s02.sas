  /* part a */
data work.typetotals;
  set orion.order_fact (obs=10);
  where year(Order_Date)=2005;
  /* There are equivalent WHERE statements that would work */
  if Order_Type=1 then TotalRetail+Quantity;
  else if Order_Type=2 then TotalCatalog+Quantity;
  else if Order_Type=3 then TotalInternet+Quantity;
run;

   /* part b */
proc print data=work.typetotals;
run;

   /* part c */
data work.typetotals;
  set orion.order_fact;
  where year(Order_Date)=2005;
  /* There are equivalent WHERE statements that would work */
  if Order_Type=1 then TotalRetail+Quantity;
  else if Order_Type=2 then TotalCatalog+Quantity;
  else if Order_Type=3 then TotalInternet+Quantity;
  keep Order_ID Order_Date TotalRetail 
      TotalCatalog TotalInternet;
run;

title '2005 Accumulating Totals for Each Type of Order';
proc print data=work.typetotals;
run;
title;
