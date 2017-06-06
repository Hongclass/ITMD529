/*st10bd03.sas*/
proc format;
    value vstfmt 
        0='staff only'
        1='physician';
    value spcfmt 
        1='oncologist'
        2='internal med'
        3='family prac'
        4='pulmonolgist'
        5='other special';
run;

proc print data= sasuser.hosp (obs=10);
    var visit code diffbys3;
    format visit vstfmt. code spcfmt.;
run;

proc univariate data=sasuser.hosp;
    class code;
    var diffbys3;
    histogram diffbys3 / normal kernel ncols=3;
    inset mean std skewness kurtosis 
          normal(adpval="Anderson-Darling P" 
                 cvmpval="Cramer von Mises P"
                 ksdpval="Komogorov-Smirnov P");
    probplot  diffbys3 / normal ncols=3;
    inset mean std skewness kurtosis;
    title 'Descriptive Statistics for Hospice Data';
    format code spcfmt.;
run;

proc sgplot data=sasuser.hosp;
    vbox diffbys3 / category = code;
    format code spcfmt.;
run;

proc npar1way data=sasuser.hosp wilcoxon median;
    class code;
    var diffbys3;
    format code spcfmt.;
run;
