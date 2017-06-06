%let d1=fjc.sczz06s;
%let d2=fjc.sczz06s;
%let d3=fjc.sczz06s;
%let c1=x3(1);
%let c2=x4(1);
%let c3=x7(1);
%let b1=x3;
%let b2=x4;
%let b3=x7;
%let a1=x2 x10;
%let a2=x2 x10;
%let a3=x2 x10;
%let e1=x2 x3 x4 x7 x10;
%let e2=x2 x3 x4 x7 x10;
%let e3=x2 x3 x4 x7 x10;
%let p1=14;
%let p2=12;
%let p3=14;
%let q1=2;
%let q2=4;
%let q3=2;
%let t1=qtr;
%let t2=qtr;
%let t3=qtr;

%macro arima;
%do i=1 %to 3;
title "&&d&i to=&&t&i out=out&i";
proc expand data=&&d&i out=out&i to=&&t&i;
convert &&e&i/observed=average;
id date;
proc print data=out&i;
run;
%let k=1;
%let n=%scan(&&p&i,&k);
%do %while(&n ne);
title "arima &&d&i to=&&t&i var=&&c&i p=&n q=&&q&i";
proc arima data=out&i;
identify var=&&c&i nlag=18 crosscorr=(&&a&i);
estimate p=&n q=&&q&i method=cls plot;
forecast id=date out=a&i interval=&&t&i lead=12;
run;
proc print data=a&i(keep=date &&b&i forecast l95 u95 residual);
run;
proc gplot data=a&i;
plot &&b&i*date=1 forecast*date=2 l95*date=3 u95*date=3 /overlay cframe=pink;
symbol1 v=dot i=none c=red;
symbol2 v=plus i=join c=green;
symbol3 v=none i=join c=blue;
run;
 %let k=%eval(&k+1);
 %let n=%scan(&&p&i,&k);
%end;
%end;
%mend;

%arima;

