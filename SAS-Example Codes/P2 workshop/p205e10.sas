data shipping_notes;
  set orion.shipped;
  length Comment $ 21;
  Comment = cat('Shipped on ',Ship_Date);
  Total = Quantity * Price;
run;

proc print data=shipping_notes noobs;
  format Total dollar7.2;
run;
