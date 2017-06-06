/*st101s02.sas*/  /*Part a*/

proc univariate data=sasuser.NormTemp noprint;
    var BodyTemp;
    histogram BodyTemp / normal(mu=est sigma=est noprint) kernel;
    inset min max skewness kurtosis / position=ne;
    probplot BodyTemp / normal(mu=est sigma=est);
    inset min max skewness kurtosis;
    title 'Descriptive Statistics Using PROC UNIVARIATE';
run;

/*st101s02.sas*/  /*Part b*/

proc sgplot data=sasuser.NormTemp;
    vbox BodyTemp / datalabel=ID;
    format ID 3.;
    refline 98.6 / label axis=y;
    title "Box and Whisker Plots of Body Temp";
run;

