data revenue
   NotSold(keep=Price Product_ID Product_Name)
   InValidCode(Keep=Product_ID Quantity Customer);
   merge orion.web_products(in=InProduct) orion.web_orders(in=InOrders);
   by Product_ID;
   if InProduct and InOrders then do; 
      Revenue = Quantity * Price; 
      output revenue;
   end;
   else if InProduct and not InOrders then output notsold;
   else if not InProduct and InOrders then output invalidcode;
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
