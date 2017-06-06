data discount_sales;
   set orion.orders_midyear;
   array mon{*} month1-month6;
   drop i;
   do i=1 to 6;
      mon{i} = mon{i} *.95;
   end;
run;

title 'Monthly Sales with 5% Discount';
proc print data=discount_sales noobs;
   format month1-month6 dollar10.2;
run;
title;
