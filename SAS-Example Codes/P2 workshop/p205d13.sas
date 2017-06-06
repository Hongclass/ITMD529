data donation_stats;
   set orion.employee_donations;
   keep Employee_ID Total AvgQT NumQT;
   Total = sum(of Qtr1-Qtr4);
   AvgQT = round(Mean(of Qtr1-Qtr4));
   NumQt = n(of Qtr1-Qtr4);
run;

proc print data=donation_stats noobs;
   var Employee_ID Total AvgQt NumQt;
run;
