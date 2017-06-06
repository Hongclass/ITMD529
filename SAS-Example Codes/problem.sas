data a;
input group1 value;
datalines;
1 3
2 12
13 56
22 57
0 9
-1 8
-2 10
;
run;


data a;
set a;
original = group1;
format group1 a.;
run;



proc format;
value a low-<0 = 'negative'
        0 = 'zero'
		0<-10 = 'Up to 10'
		10-<20 = '10 to 20'
		20-high = 'over 20';
run;



proc tabulate data=a;
class original;
var value;
table original,value*sum;
format original a.;
run;

proc tabulate data=a;
class group1;
var value;
table group1,value*sum;
run;


proc gchart data=a;
vbar group1 / discrete sum sumvar=value ;
run;

proc gchart data=a;
vbar original / discrete sum sumvar=value;
format original a.;
run;

Title1 'Total Lifetime Value (Mar 2012)';
axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Average Amount")   split=" "  ;
axis2 split=" " value=(h=9pt f="Arial/Bold") ;
axis3 split=" " value=(h=9pt f="Arial/Bold")  label=none value=none;
proc gchart data=wip.clv3;
where   teal_flag ne '';
vbar teal_flag / type=sum sumvar=hh_pctsum_10  group=clv_total subgroup=teal_flag 
     raxis = axis1 maxis=axis3 gaxis=axis2 nozeros noframe outside=sum ;
run;

Title1 'Total Lifetime Value (Mar 2012)';
axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Average Amount")   split=" "  ;
axis2 split=" " value=(h=9pt f="Arial/Bold") ;
axis3 split=" " value=(h=9pt f="Arial/Bold")  label=none value=none;
proc gchart data=wip.clv3;
where   teal_flag ne '';
vbar clv_total / discrete type=percent freq=hh_pctsum_10  group=clv_total  inside=SUBPCT g100 subgroup=teal_flag 
     raxis = axis1 maxis=axis3 gaxis=axis2 nozeros noframe outside=sum  ;

run;
