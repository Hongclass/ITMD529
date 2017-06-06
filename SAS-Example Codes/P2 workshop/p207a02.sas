data invest;
   do until(Capital>1000000);
      Year+1;
      Capital+5000;
      Capital+(Capital*.045);
   end;
run;

proc print data=invest noobs;
   format capital dollar14.2;
run;
