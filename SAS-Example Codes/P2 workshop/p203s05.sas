proc sort data=orion.order_qtrsum out=work.custsort;
  by Customer_ID Order_Qtr;
run;

data work.qtrcustomers;
  set work.custsort;
  by Customer_ID Order_Qtr;
  if first.Order_Qtr=1 then do;
    Total_Sales=0;
	Num_Months=0;
  end;
  Total_Sales+Sale_Amt;
  Num_Months+1;
  if last.Order_Qtr=1;
  keep Customer_ID Order_Qtr Total_Sales Num_Months;
run;

title 'Total Sales to each Customer for each Quarter';
proc print data=work.qtrcustomers;
  format Total_Sales dollar11.2;
run;
title;
