/*st104d03.sas*/
ods graphics off;
proc reg data=sasuser.fitness;
    PREDICT: model Oxygen_Consumption 
                  = RunTime Age Run_Pulse Maximum_pulse;
    FULLMODL: model Oxygen_Consumption
                  = Performance RunTime Age Weight
                    Run_Pulse Rest_Pulse Maximum_Pulse;
    title 'Collinearity -- Full Model';
run;
quit;

ods graphics on;
