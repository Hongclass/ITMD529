proc sort data=orion.usorders04 out=work.usorders04;
  by Customer_ID Order_Type;
run;

data work.discount1 work.discount2 work.discount3;
  set work.usorders04;
  by Customer_ID Order_Type;
  if first.Order_Type=1 then TotSales=0;
  TotSales+Total_Retail_Price;
  if last.Order_Type=1 and TotSales >= 100 then do;
    if Order_Type=1 then output discount1;
	else if Order_Type=2 then output discount2;
	else if Order_Type=3 then output discount3;
  end;
  keep Customer_ID Customer_Name TotSales;
run;

title 'Customers Spending $100 or more in Retail Sales';
proc print data=work.discount1 noobs;
  format TotSales dollar11.2;
run;
title;
