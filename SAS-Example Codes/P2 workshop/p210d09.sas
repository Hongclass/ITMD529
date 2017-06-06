options symbolgen;
%let year=2006;
proc means data=orion.order_fact mean;
   where year(order_date)=&year;
   class order_type;
   var total_retail_price;
   title "Average Retail Prices for &year Orders";
   title2 "by Order_Type";
run;
title;

