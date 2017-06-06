%let d1=fjc.xucpcl1s;
%let d2=fjc.xucpcl1s;
%let d3=fjc.xucpcl1s;
%let d4=fjc.xucpcl1s;
%let d5=fjc.xucpcl1s;
%let d6=fjc.xucpcl1s;
%let d7=fjc.xucpcl1s;
%let c1=x1(1);
%let c2=x2(1);
%let c3=x3(1);
%let c4=x4(1);
%let c5=x5(1);
%let c6=x6(1);
%let c7=x7(1);
%let b1=x1;
%let b2=x2;
%let b3=x3;
%let b4=x4;
%let b5=x5;
%let b6=x6;
%let b7=x7;
%let a1=x2 x3 x4 x5 x6 x7;
%let a2=x1 x3 x4 x5 x6 x7;
%let a3=x1 x2 x4 x5 x6 x7;
%let a4=x1 x2 x3 x5 x6 x7;
%let a5=x1 x2 x3 x4 x6 x7;
%let a6=x1 x2 x3 x4 x5 x7;
%let a7=x1 x2 x3 x4 x5 x6;
%let p1=1;
%let p2=2;
%let p3=3;
%let p4=2;
%let p5=1;
%let p6=2;
%let p7=3;
%let q1=1;
%let q2=1;
%let q3=1;
%let q4=1;
%let q5=1;
%let q6=1;
%let q7=1;


%macro arima(method,cframe);
%do i=1 %to 7;
data f&i;
set &&d&i;
run;
%let k=1;
%let n=%scan(&&p&i,&k);
%do %while(&n ne);
proc arima data=f&i;
title "var=&&c&i p=&n q=&&q&i cross=(&&a&i) method=&method";
identify var=&&c&i nlag=5 crosscorr=(&&a&i);
estimate p=&n q=&&q&i method=&method plot;
forecast out=out lead=3;
run;
data g&i;
merge f&i out;
t=_n_;
run;
proc print data=g&i(keep=date x&i forecast l95 u95 residual);
run;
proc gplot data=g&i;
plot &&b&i*t=1 forecast*t=2 l95*t=3 u95*t=3 /overlay cframe=&cframe;
plot &&b&i*date=1 forecast*date=2 l95*date=3 u95*date=3 /overlay cframe=&cframe;
symbol1 v=dot i=none c=red;
symbol2 v=plus i=join c=green;
symbol3 v=none i=join c=blue;
run;
 %let k=%eval(&k+1);
 %let n=%scan(&&p&i,&k);
%end;
%end;
%mend;

%arima(ml,yellow);
%arima(cls,pink);
%arima(uls,orange);





