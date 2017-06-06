data work.freqcustomers;
   set orion.orders_midyear;
   if n(of month1-month6) >= 5;
   /* Alternative: if nmiss(of month1-month6) <= 1; */
   Month_Median=median(of month1-month6);
   Month_Highest=largest(1,of month1-month6);
   Month_2ndHighest=largest(2,of month1-month6);
run;

title 'Month Statistics on Frequent Customers';
proc print data=work.freqcustomers noobs;
run;
title;
