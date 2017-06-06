/*st105d03.sas*/
ods graphics off;
proc freq data=sasuser.exact;
   tables A*B / chisq expected cellchi2 nocol nopercent;
   title "Exact P-Values";
run;

ods graphics on;
