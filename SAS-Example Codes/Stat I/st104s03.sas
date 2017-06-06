/*st104s03.sas*/  /*Part A*/
ods graphics off;
proc reg data=sasuser.BodyFat;
    FULLMODL: model PctBodyFat2
                  = Age Weight Height
                    Neck Chest Abdomen Hip Thigh
                    Knee Ankle Biceps Forearm Wrist
                  / vif;
    title 'Collinearity -- Full Model';
run;
quit;

ods graphics on;

/*st104s03.sas*/  /*Part B*/
ods graphics off;
proc reg data=sasuser.BodyFat;
    NOWT: model PctBodyFat2
              = Age Height
                Neck Chest Abdomen Hip Thigh
                Knee Ankle Biceps Forearm Wrist
              / vif;
    title 'Collinearity -- No Weight';
run;
quit;

ods graphics on;
