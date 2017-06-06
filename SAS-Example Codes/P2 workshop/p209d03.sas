*** Step 1 ******************************************************;
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
   keep Customer_ID Customer_Name Quantity 
        Total_Retail_Price Product_ID;
run;

*** Step 2 ******************************************************;
proc sort data=CustOrd;
   by Product_ID;
run;

data CustOrdProd;
   merge CustOrd(in=ord) 
         orion.product_dim(in=prod);
   by Product_ID;
   if ord=1 and prod=1;
   Supplier=catx(' ',Supplier_Country,Supplier_ID);
   keep Customer_Name Quantity 
        Total_Retail_Price Product_Name Supplier;
run; 

proc print data=CustOrdProd(obs=15) noobs;
   var Customer_Name Quantity Total_Retail_Price 
       Product_Name Supplier;
run;

