  /* Part A */
data work.instore (keep=Order_ID Customer_ID Order_Date)
     work.delivery (keep=Order_ID Customer_ID Order_Date ShipDays);
  set orion.orders (obs=30);
  where Order_Type=1;
  ShipDays=Delivery_Date-Order_Date;
  if ShipDays=0 then output work.instore;
  else if ShipDays>0 then output work.delivery;
run;

  /* Part B */
data work.instore (keep=Order_ID Customer_ID Order_Date)
     work.delivery (keep=Order_ID Customer_ID Order_Date ShipDays);
  set orion.orders;
  where Order_Type=1;
  ShipDays=Delivery_Date-Order_Date;
  if ShipDays=0 then output work.instore;
  else if ShipDays>0 then output work.delivery;
run;

title 'Deliveries from In-store Purchases';
proc print data=work.delivery;
run;
title;

  /* Part C */
title 'In-stock Store Purchases, By Year';
proc freq data=work.instore;
  tables Order_Date;
  format Order_Date year.;
run;
title;
