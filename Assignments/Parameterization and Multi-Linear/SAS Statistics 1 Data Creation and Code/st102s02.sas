/*st102s02.sas*/
ods graphics;

ods select lsmeans diff diffplot controlplot;
proc glm data=STAT1.Garlic 
         plots(only)=(diffplot(center) controlplot);
    class Fertilizer;
    model BulbWt=Fertilizer;
    Tukey: lsmeans Fertilizer / pdiff=all 
                         adjust=tukey;
    Dunnett:lsmeans Fertilizer / pdiff=control('4') 
                         adjust=dunnett;
    No_Adjust: lsmeans Fertilizer / pdiff=all adjust=t;
    title "Post-Hoc Analysis of ANOVA - Fertilizer as Predictor";
run;
quit;

title;

