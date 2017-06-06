/*st101d02.sas*/  /*Part A*/
proc univariate data=sasuser.testscores;
    var SATScore;
    histogram SATScore / normal(mu=est sigma=est) kernel;
    inset skewness kurtosis / position=ne;
    probplot SATScore / normal(mu=est sigma=est);
    inset skewness kurtosis;
    title 'Descriptive Statistics Using PROC UNIVARIATE';
run;

/*st101d02.sas*/  /*Part B*/
proc sgplot data=sasuser.testscores;
    vbox SATScore / datalabel=IDNumber;
    format IDNumber 8.;
    refline 1200 / axis=y label;
    title "Box-and-Whisker Plots of SAT Scores";
run;
