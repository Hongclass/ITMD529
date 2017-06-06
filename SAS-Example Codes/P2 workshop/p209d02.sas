*** Output Statement ********************************************;
proc sort data=orion.order_fact
          out=work.order_fact;
   by Customer_ID;
   where year(Order_Date)=2007;
run;

data orders
     noorders;
   merge orion.customer
         work.order_fact(in=order);
   by Customer_ID;
   if order=1 then output orders;
   else output noorders;
run;

proc print data=noorders noobs;
run;

proc print data=orders noobs;
run;

*** KEEP= Option ************************************************;
proc sort data=orion.order_fact
          out=work.order_fact;
   by Customer_ID;
   where year(Order_Date)=2007;
run;

data orders(keep=Customer_Name Quantity 
              Product_ID Total_Retail_Price) 
     noorders(keep=Customer_Name Birth_Date);
   merge orion.customer
         work.order_fact(in=order);
   by Customer_ID;
   if order=1 then output orders;
   else output noorders;
run;

proc print data=noorders noobs;
run;

proc print data=orders noobs;
run;

*** First. and Last. Variables and Sum Statement ****************;
proc sort data=orion.order_fact
          out=work.order_fact;
   by Customer_ID;
   where year(Order_Date)=2007;
run;

data orders(keep=Customer_Name Quantity 
              Product_ID Total_Retail_Price) 
     noorders(keep=Customer_Name Birth_Date)
     summary(keep=Customer_Name NumberOrders);
   merge orion.customer
         work.order_fact(in=order);
   by Customer_ID;
   if order=1 then do;
      output orders;
      if first.Customer_ID then NumberOrders=0;
	   NumberOrders+1;
      if last.Customer_ID then output summary;
   end;
   else output noorders;
run;

Title "Customers That Haven't Placed an Order";
proc print data=noorders noobs;
run;

Title "Order Details";
proc print data=orders noobs;
run;

Title "Summary of Customer Orders";
proc print data=summary noobs;
run;
Title;
