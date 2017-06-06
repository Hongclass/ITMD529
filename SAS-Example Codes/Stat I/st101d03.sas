/*st101d03.sas*/
proc means data=sasuser.testscores maxdec=2
           n mean std stderr clm;
    var SATScore;
    title '95% Confidence Interval for SAT';
run;


