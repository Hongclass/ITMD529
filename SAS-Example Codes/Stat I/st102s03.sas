/*st102s03.sas*/

proc glm data=sasuser.Ads1 plots(only)=diagnostics;
    class Ad Area;
    model Sales=Ad Area;
    title 'ANOVA for Randomized Block Design';
run;
quit;
