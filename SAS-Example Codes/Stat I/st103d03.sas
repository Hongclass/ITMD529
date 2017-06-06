/*st103d03.sas*/
data Need_Predictions;
    input RunTime @@;
    datalines;
9 10 11 12 13
;
run;

proc reg data=sasuser.fitness noprint outest=Betas;
    PredOxy: model Oxygen_Consumption=RunTime;
run;
quit;

proc print data=Betas;
    title "OUTEST= Data Set from PROC REG";
run;

proc score data=Need_Predictions score=Betas
           out=Scored type=parms;
    var RunTime;
run;

proc print data=Scored;
    title "Scored New Observations";
run;

/*st103d03.sas*/  /*Self Study*/ 
data Need_Predictions;
    input RunTime @@;
    datalines;
9 10 11 12 13
;
run;

data Predict;
    set Need_Predictions 
        sasuser.fitness;
run;

ods graphics off;

proc reg data=Predict;
    model Oxygen_Consumption=RunTime / p;
    id RunTime;
    title 'Oxygen_Consumption=RunTime with Predicted Values';   
run;
quit;

ods graphics on;

