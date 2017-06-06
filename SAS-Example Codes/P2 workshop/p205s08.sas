data work.sale_stats;
   set orion.orders_midyear;
   MonthAvg=round(mean(of month1-month6));
   MonthMax=max(of month1-month6);
   MonthSum=sum(of month1-month6);
run;

title 'Statistics on Months in which the Customer Placed an Order';
proc print data=work.sale_stats noobs;
   var Customer_ID MonthAvg MonthMax MonthSum;
run;
title;
