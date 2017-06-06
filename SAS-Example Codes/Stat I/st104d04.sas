/*st104d04.sas*/  /*Part A*/
ods graphics off;
proc reg data=sasuser.fitness;
    FULLMODL: model Oxygen_Consumption
                  = Performance RunTime Age Weight
                    Run_Pulse Rest_Pulse Maximum_Pulse
                    / vif;
    title 'Collinearity -- Full Model';
run;
quit;

ods graphics on;

/*st104d04.sas*/  /*Part B*/
ods graphics off;
proc reg data=sasuser.fitness;
    NOPERF: model Oxygen_Consumption
                = RunTime Age Weight
                  Run_Pulse Rest_Pulse Maximum_Pulse
                  / vif;
    title 'Dealing with Collinearity';
run;
quit;

ods graphics on;

/*st104d04.sas*/  /*Part C*/
ods graphics off;
proc reg data=sasuser.fitness;
    NOPRFMAX: model Oxygen_Consumption
                  = RunTime Age Weight
                    Run_Pulse Rest_Pulse 
                    / vif;
    title 'Dealing with Collinearity';
run;
quit;

ods graphics on;
