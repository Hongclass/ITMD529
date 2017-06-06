/*st101s04.sas*/  /*PROC UNIVARIATE*/
proc univariate data=sasuser.NormTemp mu0=98.6;
    var BodyTemp; 
    title 'Testing Whether the Mean Body Temperature = 98.6 '
          'Using PROC UNIVARIATE';
run;

/*st101s04.sas*/  /*PROC TTEST*/
proc ttest data=sasuser.NormTemp h0=98.6
           plots(shownull)=interval;
    var BodyTemp;
    title 'Testing Whether the Mean Body Temperature = 98.6 '
          'Using PROC TTEST';
run;


