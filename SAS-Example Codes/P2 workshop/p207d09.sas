proc print data=orion.banks;
   format rate 6.4;
run;

data invest(drop=Quarter Year);
   set orion.banks;
   Capital=0;
   do Year=1 to 5;
      Capital+5000;
      do Quarter=1 to 4;
         Capital+(Capital*(Rate/4));
      end;
   end;
run;

proc print data=invest noobs;
run;
