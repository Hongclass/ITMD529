  /* Use an iterative do with DO UNTIL */

data invest;
   do Year=1 to 30 until(Capital>250000);
      Capital+5000;
      Capital+(Capital*.045);
   end;
run;
proc print data=invest noobs;
   format capital dollar14.2;
run;

  /* Use an iterative do with DO WHILE */

data invest;
   do Year=1 to 30 while(Capital<=250000);
      Capital+5000;
      Capital+(Capital*.045);
   end;
run;
proc print data=invest noobs;
   format capital dollar14.2;
run;

