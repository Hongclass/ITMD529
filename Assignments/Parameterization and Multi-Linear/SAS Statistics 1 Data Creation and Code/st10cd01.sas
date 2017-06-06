/*st10cd01.sas*/  /*Part A*/
proc print data=STAT1.market (obs=20);
    title;
run;

/*st10cd01.sas*/  /*Part B*/
proc ttest data= STAT1.market plots(showh0)=interval;
    paired post*pre;
    title 'Testing the Difference Before and After a Sales Campaign';
run;
