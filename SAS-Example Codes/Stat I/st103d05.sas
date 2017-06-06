/*st103d05.sas*/  /*Part A*/
ods graphics / imagemap=on;

proc reg data=sasuser.fitness plots(only)=(rsquare adjrsq cp);
    ALL_REG: model oxygen_consumption 
                    = Performance RunTime Age Weight
                      Run_Pulse Rest_Pulse Maximum_Pulse
            / selection=rsquare adjrsq cp;
    title 'Best Models Using All-Regression Option';
run;
quit;


/*st103d05.sas*/  /*Part B*/
ods graphics / imagemap=on;

proc reg data=sasuser.fitness plots(only)=(cp);
    ALL_REG: model oxygen_consumption 
                    = Performance RunTime Age Weight
                      Run_Pulse Rest_Pulse Maximum_Pulse
            / selection=cp rsquare adjrsq best=20;
    title 'Best Models Using All-Regression Option';
run;
quit;

