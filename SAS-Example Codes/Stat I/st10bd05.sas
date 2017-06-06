/*st10bd05.sas*/
proc reg data=sasuser.fitness 
         plots(only)=fitplot(nolimits stats=none);
    RUNTIME: model Oxygen_Consumption 
                 = RunTime;
    title 'Simple Regression';
run;
quit;

proc reg data=sasuser.fitness 
         plots(only)=partial(unpack);
    FULL: model Oxygen_Consumption 
              = Performance RunTime Age Weight 
                Run_Pulse Rest_Pulse Maximum_Pulse 
              / partial;
    title 'Producing Partial Leverage Plots';
run;
quit;
