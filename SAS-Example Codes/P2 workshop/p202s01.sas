data work.price_increase;
   set orion.prices;
   Year=1;
   Unit_Price=Unit_Price * Factor;
   output;
   Year=2;
   Unit_Price=Unit_Price * Factor;
   output;
   Year=3;
   Unit_Price=Unit_Price * Factor;
   output;
run;
proc print data=work.price_increase;
   var Product_ID Unit_Price Year;
run;
