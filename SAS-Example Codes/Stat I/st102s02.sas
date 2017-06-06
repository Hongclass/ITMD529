/*st102s02.sas*/  /*Part A*/

proc means data=sasuser.Ads printalltypes n mean std skewness 
    kurtosis;
    var Sales;
    class Ad;
    title 'Descriptive Statistics of Sales by Ad Type';
run;


proc sgplot data=sasuser.Ads;
    vbox Sales / category=Ad datalabel=Sales;
    title "Box and Whisker Plots of Sales by Ad Type";
run;

/*st102s02.sas*/  /*Part B*/

proc glm data=sasuser.Ads plots=diagnostics;
    class Ad;
    model Sales=Ad;
    means Ad / hovtest;
    title 'Testing for Equality of Ad Type on Sales';
run;
quit;
