data hrdata;
   keep GrossPay Bonus;
   set orion.convert;
   Bonus = GrossPay * .10;
run;

proc print data=hrdata noobs;
run;
