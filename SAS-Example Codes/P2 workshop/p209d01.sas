*** Basic Match-Merge *******************************************;
proc sort data=orion.order_fact
          out=work.order_fact;
   by Customer_ID;
   where year(Order_Date)=2007;
run;

data CustOrd;
   merge orion.customer
         work.order_fact;
   by Customer_ID;
run;

proc print data=CustOrd;
   var Customer_Name Gender Quantity Total_Retail_Price;
run;

*** Match-Merge with IN= ****************************************;
proc sort data=orion.order_fact
          out=work.order_fact;
   by Customer_ID;
   where year(Order_Date)=2007;
run;

data CustOrd;
   merge orion.customer(in=cust)
         work.order_fact(in=order);
   by Customer_ID;
   if cust=1 and order=1;
run;

proc print data=CustOrd;
   var Customer_Name Gender Quantity Total_Retail_Price;
run;



