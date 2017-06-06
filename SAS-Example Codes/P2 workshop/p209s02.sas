data web_converted(drop=nProduct_ID);
   length Product_ID $ 12;
   set orion.web_products2(rename=(Product_ID=nProduct_ID));
   Product_ID=put(nProduct_ID,12.);
run;

data revenue
   NotSold(keep=Price Product_ID Product_Name)
   InValidCode(Keep=Product_ID Quantity Customer);
   merge web_converted(in=InConv rename=(Name=Product_Name)) 
         orion.web_orders2(in=InOrders rename=(Name=Customer));
   by Product_ID;
   if InConv and InOrders then do; 
      Revenue = Quantity * Price; 
      output revenue;
   end;
   else if InConv and not InOrders then output notsold;
   else if not InConv and InOrders then output invalidcode;
run;

title 'Revenue from Orders';
proc print data=revenue noobs;
run;

title 'Products Not Ordered';
proc print data=notsold noobs;
run;

title 'Invalid Orders';
proc print data=invalidcode noobs;
run;
title;
