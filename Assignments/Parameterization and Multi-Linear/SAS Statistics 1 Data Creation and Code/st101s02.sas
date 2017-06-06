/*st101s02.sas*/
ods graphics;
proc ttest data=STAT1.German plots(shownull)=interval;
   class Group;
   var Change;
   title "German Grammar Training, Comparing Treatment to Control";
run;

title;
