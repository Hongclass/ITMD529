/*st103d04.sas*/
ods graphics off;
proc reg data=sasuser.fitness;
    model Oxygen_Consumption=Performance RunTime;
    title 'Multiple Linear Regression for Fitness Data';
run;
quit;

ods graphics on;
