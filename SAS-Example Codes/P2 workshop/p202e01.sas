data work.price_increase;
   set orion.prices;
   Year=1;
   Unit_Price=Unit_Price*factor;
   output;
   Year=2;
   Unit_Price=Unit_Price*factor;
   output;
   Year=3;
   Unit_Price=Unit_Price*factor;
   output;
run;
proc print data=work.price_increase;
	var Product_ID Unit_Price Year;
run;

data work.extended;
	set orion.discount;
	where Start_Date='01Dec2007'd;
	Promotion=Unit_Sales_Price*Discount;
	if month(Start_Date)=7 then Season=