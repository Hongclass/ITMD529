data shipping_notes;
  set orion.shipped;
  length Comment $ 21;
  Comment = cat('Shipped on ',put(Ship_Date,mmddyy10.));
  Total = Quantity * input(Price,comma7.2);
run;

proc print data=shipping_notes noobs;
  format Total dollar7.2;
run;
