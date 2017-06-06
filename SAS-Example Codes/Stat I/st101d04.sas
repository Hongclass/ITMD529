/*st101d04.sas*/  /*Part A*/
ods graphics off;
proc univariate data=sasuser.testscores mu0=1200;
    var SATScore;
    title 'Testing Whether the Mean of SAT Scores = 1200';
run;
ods graphics on;

/*st101d04.sas*/  /*Part B*/
proc ttest data=sasuser.testscores h0=1200
           plots(shownull)=interval;
    var SATScore;
    title 'Testing Whether the Mean of SAT Scores = 1200 '
          'Using PROC TTEST';
run;
