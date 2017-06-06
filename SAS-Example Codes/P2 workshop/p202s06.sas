data work.fast work.slow work.veryslow;
  set orion.orders;
  where Order_Type in (2,3);
  ShipDays=Delivery_Date-Order_Date;
  select;
	when (ShipDays<3) output work.fast;
    when (5<=ShipDays<=7)  output work.slow;
    when (ShipDays>7) output work.veryslow;
	otherwise;
  end;
  drop Employee_ID;
run;

title 'Orders taking more than 7 days to deliver';
proc print data=work.veryslow;
run;
title;
