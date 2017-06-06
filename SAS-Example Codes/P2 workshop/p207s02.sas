data expenses;
   Income= 50000000;
   Expenses = 38750000;
   do Year=1 to 30 until (Expenses > Income);
      income+(income * .01);
      expenses+(expenses * .02);
   end;
run;
proc print data=expenses;
   format income expenses dollar15.2; 
run;

