/*st107s01.sas*/  /*Part A*/
ods graphics off;
proc freq data=STAT1.safety;
    tables Unsafe Type Region Size;
    title "Safety Data Frequencies";
run;

ods graphics on;

/*st107s01.sas*/  /*Part B*/
proc format; 
   value safefmt 0='Average or Above'
                 1='Below Average';
run;

proc freq data=STAT1.safety;
    tables Region*Unsafe / expected chisq relrisk;
    format Unsafe safefmt.;
    title "Association between Unsafe and Region";
run;

/*st107s01.sas*/  /*Part C*/
proc freq data=STAT1.safety;
    tables Size*Unsafe / chisq measures cl;
    format Unsafe safefmt.;
    title "Association between Unsafe and Size";
run;
