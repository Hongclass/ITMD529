data work.monthtotals;
  set orion.order_fact;
  where year(Order_Date)=2007;
  retain rmonth;
  if month(Order_Date) ne rmonth then do;
	 MonthSales=0;
     rmonth=month(Order_Date);
  end;
  monthsales+Total_Retail_Price;
  keep Order_ID Order_Date MonthSales Total_Retail_Price;
run;


title 'Accumulating Totals by Month in 2007';
proc print data=work.monthtotals;
  format Total_Retail_Price MonthSales dollar10.2;
run;
title;

