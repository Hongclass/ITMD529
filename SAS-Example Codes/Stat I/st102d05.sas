/*st102d05.sas*/
proc glm data=sasuser.MGGarlic_Block 
         plots(only)=(controlplot diffplot(center));
    class Fertilizer Sector;
    model BulbWt=Fertilizer Sector;
    lsmeans Fertilizer / pdiff=all adjust=tukey;
    lsmeans Fertilizer / pdiff=control('4') adjust=dunnett;
    lsmeans Fertilizer / pdiff=all adjust=t;
    title 'Garlic Data: Multiple Comparisons';
run;
quit;
