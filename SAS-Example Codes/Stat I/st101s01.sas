/*st101s01.sas*/  /*Parts a and b*/
proc means data=sasuser.NormTemp
           maxdec=2
           n mean std q1 q3 qrange;
    var BodyTemp;
    title 'Selected Descriptive Statistics for Body Temp';
run;

/*st101s01.sas*/  /*Part c*/
proc means data=sasuser.NormTemp
           maxdec=2
           n mean std q1 q3 qrange;
    var BodyTemp;
    class Gender;
    title 'Selected Descriptive Statistics for Body Temp';
run;
