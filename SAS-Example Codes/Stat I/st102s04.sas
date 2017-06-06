/*st102s04.sas*/  /*Part A*/

proc glm data=sasuser.Ads1 plots(only)=diffplot(center);
    class Ad Area;
    model Sales=Ad Area;
    lsmeans Ad / pdiff=all adjust=tukey;
    title 'Tukey Pairwise Differences for Ad Types on Sales';
run;
quit;

/*st102s04.sas*/  /*Part B*/

proc glm data=sasuser.Ads1 plots(only)=controlplot;
    class Ad Area;
    model Sales=Ad Area;
    lsmeans Ad / pdiff=control('display') adjust=dunnett;
    title 'Dunnett Pairwise Differences for Ad Types on Sales';
run;
quit;
