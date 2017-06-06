/*st105d01.sas*/
title;
proc format;
    value survfmt 1 = "Survived"
                  0 = "Died"
                  ;
run;

proc freq data=sasuser.Titanic;
    tables Survived Gender Class
           Gender*Survived Class*Survived /
           plots(only)=freqplot(scale=percent);
    format Survived survfmt.;
run;

proc univariate data=sasuser.Titanic noprint;
    class Survived;
    var Age ;
    histogram Age;
    inset mean std median min max / format=5.2 position=ne;
    format Survived survfmt.;
run;
