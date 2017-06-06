/*st103s04.sas*/  /*Part A*/
ods graphics / imagemap=on;

proc reg data=sasuser.BodyFat2 plots(only)=(cp);
    model PctBodyFat2 = Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist
         / selection=cp best=60;
    title "Using Mallows Cp for Model Selection";
run;
quit;


/*st103s04.sas*/  /*Part B*/

proc reg data=sasuser.BodyFat2 plots(only)=adjrsq;
    FORWARD:  model PctBodyFat2 = Age Weight Height
              Neck Chest Abdomen Hip Thigh
              Knee Ankle Biceps Forearm Wrist
              / selection=forward;
    BACKWARD: model PctBodyFat2 = Age Weight Height
              Neck Chest Abdomen Hip Thigh
              Knee Ankle Biceps Forearm Wrist
              / selection=backward;
    STEPWISE: model PctBodyFat2 = Age Weight Height
              Neck Chest Abdomen Hip Thigh
              Knee Ankle Biceps Forearm Wrist
              / selection=stepwise;
    title "Using Stepwise Methods for Model Selection";
run;
quit;

/*st103s04.sas*/  /*Part C*/

proc reg data=sasuser.BodyFat2 plots(only)=adjrsq;
    FORWARD05:model PctBodyFat2 = Age Weight Height
              Neck Chest Abdomen Hip Thigh
              Knee Ankle Biceps Forearm Wrist
              / selection=forward slentry=0.05;
    title "Using Forward Stepwise with SLENTRY=0.05";
run;
quit;
