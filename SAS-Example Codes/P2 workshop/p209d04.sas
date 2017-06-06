  /* This program will only execute on the Windows platform */
proc sort data=orion.Customer_Orders out=CustOrdProd;
   by Supplier;
run;

libname bonus 'BonusGift.xls';

data CustOrdProdGift;
   merge CustOrdProd(in=c) 
         bonus.'Supplier$'n(in=s
            rename=(SuppID=Supplier
                    Quantity=Minimum));
   by Supplier;
   if c=1 and s=1 and Quantity > Minimum;
run;

libname bonus clear;

proc sort data=CustOrdProdGift;
   by Customer_Name;
run;

proc print data=CustOrdProdGift noobs;
   var Customer_Name Gift;
run;

