/*st102d03.sas*/  /*Part A*/
proc glm data=sasuser.MGGarlic;
     class Fertilizer;
     model BulbWt=Fertilizer;
     title 'Testing for Equality of Means with PROC GLM';
run;
quit;

/*st102d03.sas*/  /*Part B*/
proc glm data=sasuser.MGGarlic plots(only)=diagnostics;
     class Fertilizer;
     model BulbWt=Fertilizer;
     means Fertilizer / hovtest;
     title 'Testing for Equality of Means with PROC GLM';
run;
quit;
