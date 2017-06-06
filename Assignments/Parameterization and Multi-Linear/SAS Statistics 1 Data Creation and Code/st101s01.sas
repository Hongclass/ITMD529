/*st101s01.sas*/  /*Part A*/
%let interval=BodyTemp HeartRate;

ods graphics;
ods select histogram;
proc univariate data=STAT1.NormTemp noprint;
    var &interval;
    histogram &interval / normal kernel;
    inset n mean std / position=ne;
    title "Interval Variable Distribution Analysis";
run;
title;

/*st101s01.sas*/  /*Part B*/
proc ttest data=STAT1.NormTemp h0=98.6
           plots(only shownull)=interval;
   var BodyTemp;
   title 'Testing Whether the Mean Body Temperature = 98.6';
run;
title;
