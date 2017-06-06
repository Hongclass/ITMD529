/*st104d01.sas*/  /*Part A*/

proc reg data=sasuser.fitness;
    PREDICT: model Oxygen_Consumption 
                  = RunTime Age Run_Pulse Maximum_pulse;
    id Name;
    title 'PREDICT Model - Plots of Diagnostic Statistics';
run;
quit;

/*st104d01.sas*/  /*Part B*/

proc reg data=sasuser.fitness 
         plots(only)=(QQ RESIDUALBYPREDICTED RESIDUALS);
    PREDICT: model Oxygen_Consumption 
                  = RunTime Age Run_Pulse Maximum_pulse;
    id Name;
    title 'PREDICT Model - Plots of Diagnostic Statistics';
run;
quit;

