/*st10cd05.sas*/  /*Part A*/
proc reg data=STAT1.SAT
         plots(only)=fitplot(nolimits stats=none);
    model CombinedSAT2013 = Spend2011;
    title 'Simple Regression';
run;
quit;

/*st10cd05.sas*/  /*Part B*/
proc reg data=STAT1.SAT
         plots(only)=partial(unpack);
    model CombinedSAT2013 = Spend2011 Participation2013 / partial;
    title 'Parital Regression Plots';
run;
quit;