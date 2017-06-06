 /* Part A */

data fsp;
   set orion.orders_midyear;
   keep Customer_ID Months_Ordered Total_Order_Amount;
   array amt{*} month:;
   if dim(amt) < 3 then do;
      put 'Insufficient data for Frequent Shopper Program';
      stop;
   end;
   Total_Order_Amount=0;
   Months_Ordered=0;
   do i=1 to dim(amt);
      if amt{i} ne . then Months_Ordered+1;
      Total_Order_Amount+amt{i};
   end;
   if Total_Order_Amount>1000 and Months_Ordered >= (dim(amt))/2;
run;

  /* Part B */
title 'orion.orders_midyear: Frequent Shoppers ';
proc print data=fsp;
   format total_order_amount dollar10.2;
run;
title;

 /* Part C */
data fsp;
   set orion.orders_qtr1;
   keep Customer_ID Months_Ordered Total_Order_Amount;
   array amt{*} month:;
   if dim(amt) < 3 then do;
      put 'Insufficient data for Frequent Shopper Program';
      stop;
   end;
   Total_Order_Amount=0;
   Months_Ordered=0;
   do i=1 to dim(amt);
      if amt{i} ne . then Months_Ordered+1;
      Total_Order_Amount+amt{i};
   end;
   if Total_Order_Amount>1000 and Months_Ordered >= (dim(amt))/2;
run;

title 'orion.orders_qtr1: Frequent Shoppers ';
proc print data=fsp;
   format total_order_amount dollar10.2;
run;
title;

 /* Part D */
data fsp;
   set orion.orders_two_months;
   keep Customer_ID Months_Ordered Total_Order_Amount;
   array amt{*} month:;
   if dim(amt) < 3 then do;
      put 'Insufficient data for Frequent Shopper Program';
      stop;
   end;
   Total_Order_Amount=0;
   Months_Ordered=0;
   do i=1 to dim(amt);
      if amt{i} ne . then Months_Ordered+1;
      Total_Order_Amount+amt{i};
   end;
   if Total_Order_Amount>1000 and Months_Ordered >= (dim(amt))/2;
run;

title 'orion.orders_two_months: Frequent Shoppers ';
proc print data=fsp;
   format total_order_amount dollar10.2;
run;
title;

