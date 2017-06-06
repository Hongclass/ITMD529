data work.extended;
   set orion.discount;
   drop unit_sales_price;
   where Start_Date='01dec2007'd;
   Promotion='Happy Holidays';
   Season='Winter';
   output;
   Start_Date='01jul2008'd;
   End_Date='31jul2008'd;
   Season='Summer';
   output;
run;

title 'All discount ranges with the Happy Holidays promotion';
proc print data=work.extended;
run;
title;
