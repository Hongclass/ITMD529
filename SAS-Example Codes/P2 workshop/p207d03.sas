data invest;
   do Year=2008 to 2010;
      Capital+5000;
      Capital+(Capital*.045);
   end;
run;
proc print data=invest noobs;
run;
