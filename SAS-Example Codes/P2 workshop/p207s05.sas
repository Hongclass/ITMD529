data special_offer;
   set orion.orders_midyear;
   array mon{*} month1-month3;
   keep Total_Sales Projected_Sales Difference;
   Total_Sales=sum(of month1-month6);
   do i=1 to 3;
      mon{i} = mon{i} *.90;
   end;
   Projected_Sales=sum(of month1-month6);
   Difference=Total_Sales-Projected_Sales;
run;

options nodate nonumber;
title 'Total Sales with 10% Discount in First Three Months';
proc print data=special_offer noobs;
   format total_sales projected_sales difference dollar10.2;
   sum difference;
run;
title;
