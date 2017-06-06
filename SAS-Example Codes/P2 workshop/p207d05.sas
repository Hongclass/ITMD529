data forecast;
   set orion.growth;
   do Year=1 to 6;
  	  Total_Employees=Total_Employees*(1+Increase);
  	  output;
   end;
run;
proc print data=forecast noobs;
run;
