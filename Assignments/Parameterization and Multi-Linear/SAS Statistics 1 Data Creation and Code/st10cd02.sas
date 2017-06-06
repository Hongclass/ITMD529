/*st10cd02.sas*/
proc ttest data=STAT1.German 
           plots(only shownull)=interval h0=0 sides=L;
   class Group;
   var Change;
   title "One-Sided t-Test Comparing Treatment to Control";
run;