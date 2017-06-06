/*st101d02.sas*/
ods graphics;

proc ttest data=STAT1.ameshousing3 
           plots(shownull)=interval
           H0=135000;
    var SalePrice;
    title "One-Sample t-test testing whether mean SalePrice=$135,000";
run;

title;

