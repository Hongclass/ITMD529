/*st101d01.sas*/  /*Part A*/
proc print data=sasuser.testscores (obs=10);
    title 'Listing of the SAT Data Set';
run;

/*st101d01.sas*/  /*Part B*/
proc means data=sasuser.testscores;
    var SATScore;
    title 'Descriptive Statistics Using PROC MEANS';
run;

/*st101d01.sas*/  /*Part C*/
proc means data=sasuser.testscores 
           maxdec=2 
           n mean median std q1 q3 qrange;
    var SATScore;
    title 'Selected Descriptive Statistics for SAT Scores';
run;
