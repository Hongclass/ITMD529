/*st101s03.sas*/
proc means data=sasuser.NormTemp maxdec=2
           n mean std stderr clm;
    var BodyTemp;
    title '95% Confidence Interval for Body Temp';
run;