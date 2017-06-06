/*st10cd06.sas*/
ods graphics off;
proc freq data=STAT1.exact;
    tables A*B / chisq expected cellchi2 nocol nopercent;
    title "Exact P-Values";
run;