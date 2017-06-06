/*st10bd01.sas*/
proc print data=sasuser.market (obs=20);
    title;
run;          

proc ttest data= sasuser.market;
    paired post*pre;
    title 'Testing the Difference Before and After a Sales Campaign';
run;          
