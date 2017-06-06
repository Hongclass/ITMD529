data work.fast work.slow work.veryslow;
   set orion.orders;
   where Order_Type in (2,3);
   ShipDays=Delivery_Date-Order_Date;
   if ShipDays<3 then output work.fast;
   else if 5<=ShipDays<=7 then output work.slow;
   else if ShipDays>7 then output work.veryslow;
   drop Employee_ID;
run;

title 'Orders taking more than 7 days to deliver';
proc print data=work.veryslow;
run;
title;
