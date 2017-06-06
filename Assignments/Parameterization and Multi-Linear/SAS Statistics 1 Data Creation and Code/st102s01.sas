/*st102s01.sas*/  /*Part A*/
proc means data=STAT1.Garlic; 
   var BulbWt;
   class Fertilizer;
   title 'Descriptive Statistics of BulbWt by Fertilizer';
run;

proc sgplot data=STAT1.Garlic;
    vbox BulbWt / category=Fertilizer 
                  connect=mean;
    title "Bulb Weight Differences across Fertilizers";
run;

title;

/*st102s01.sas*/  /*Part B*/
ods graphics;

proc glm data=STAT1.Garlic plots=diagnostics;
    class Fertilizer;
    model BulbWt=Fertilizer;
    means Fertilizer / hovtest=levene;
    title "One-Way ANOVA with Fertilizer as Predictor";
run;
quit;

title;

