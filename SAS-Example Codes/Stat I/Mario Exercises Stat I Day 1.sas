*Exercises for Stat I course SAS;

*################################################################;
*Exercise 1.1;
proc means data=sasuser.normtemp maxdec=2 n mean median std q1 q3 p50 qrange;
var bodytemp;
/*class gender ;*/
run;

proc means data=sasuser.normtemp maxdec=2 n mean median std q1 q3 p50 qrange;
var bodytemp;
class gender ;
ways  1 0 ;
run;

*ways 0 does total, ways 1 does groups, ways 0 1 does both;


*################################################################;
*Exercise 1.2;
ods html style=analysis;
proc univariate data=sasuser.normtemp;
var bodytemp;
histogram bodytemp / normal(mu=est sigma=est) kernel;
inset skewness kurtosis;
probplot bodytemp / normal(mu=est sigma=est);
inset  skewness kurtosis;
/*class gender ;*/
run;


proc sgplot data=sasuser.normtemp;
vbox bodytemp / datalabel=ID;
refline 98.6 / axis=y label;
run;

proc sgplot data=sasuser.normtemp;
vbox bodytemp / datalabel=ID category=gender notches;
refline 98.6 / axis=y label;
run;

*################################################################;
*Exercise 1.3;

proc means data=sasuser.normtemp maxdec=2
              n mean std stderr clm alpha=.05;
var bodytemp;
class gender;
ways 0 1;
run;

*################################################################;
*Exercise 1.4;
proc sort data=sasuser.normtemp;
by gender;
run;

proc ttest data=sasuser.normtemp  h0=98.6
            plots(shownull)=interval alpha=.05;
var bodytemp;
by gender;
run;


*################################################################;
*Exercise 2.1;
proc ttest data=sasuser.german plots(shownull)=interval;;
class gender;
var change;
title 'T-test of effect of teaching method in German Scores';
run;


*################################################################;
*Exercise 2.2;

proc sgplot data=sasuser.ads;
    vbox sales / category=ad ;
    title "Box and Whisker Plots of Ads";
run;

proc glm data=sasuser.ads plots(only)=diagnostics;
class ad;
model sales=ad;
means ad / hovtest;
title "ANOVA test for Ads";
run;

proc glm data=sasuser.ads ;
class ad;
model sales=ad;
means ad / hovtest;
title "ANOVA test for Ads New";
run;

*################################################################;
*Exercise 2.3;


proc glm data=sasuser.ads1 plots(only)=diagnostics;
class area ad;
model sales=ad area;
means ad/ hovtest;
title 'anova test for Ads1';
run;

*################################################################;
*Exercise 2.4;

proc glm data=sasuser.ads1 
         plots(only)=(controlplot diffplot(center));
    class ad area;
    model sales=ad area;
    lsmeans ad / pdiff=all adjust=tukey;
    lsmeans ad / pdiff=control('display') adjust=dunnett;
	lsmeans ad / pdiff=all  adjust=t;
    title 'Add data: Multiple Comparisons';
run;
quit;

*################################################################;
*Exercise 2.5;

proc means data=sasuser.concrete  mean var std nway;
class additive brand;
var strength;
output out=data mean=strength_mean;
run;

proc sgplot data=data;
series x=brand y=strength_mean / group=additive markers;
title 'line plots of concrete';
run;

proc sgplot data=data;
series x=additive y=strength_mean / group=brand markers;
title 'line plots of concrete';
run;

proc glm data=sasuser.concrete order=internal;
    class additive brand ;
    model strength=additive brand additive*brand;
	lsmeans brand / pdiff=all adjust=tukey;
	lsmeans additive / pdiff=all adjust=tukey;
    title 'Analyze the Effects ofAdditive and Brand on concrete strength';
    title2 'Including Interaction';
run;
quit;

  *no interaction;
proc glm data=sasuser.concrete order=internal;
    class additive brand ;
    model strength=additive brand ;
	lsmeans brand / pdiff=all adjust=tukey;
    title 'Analyze the Effects ofAdditive and Brand on concrete strength';
    title2 'Including Interaction';
run;
quit;

