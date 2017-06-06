/*st102d04.sas*/
proc glm data=sasuser.MGGarlic_Block plots(only)=diagnostics;
     class Fertilizer Sector;
     model BulbWt=Fertilizer Sector;
     title 'ANOVA for Randomized Block Design';
run;
quit;
