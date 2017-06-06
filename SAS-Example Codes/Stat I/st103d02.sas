/*st103d02.sas*/

proc reg data=sasuser.fitness;
    model Oxygen_Consumption = RunTime;
    title 'Predicting Oxygen_Consumption from RunTime';
run;
quit;
