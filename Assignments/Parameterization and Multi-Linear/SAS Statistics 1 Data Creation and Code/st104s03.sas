/*st104s03.sas*/  /*Part A*/
ods graphics / imagemap=on;

proc reg data=STAT1.BodyFat2 plots(only)=(cp);
   model PctBodyFat2=Age Weight Height
         Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist
         / selection=cp best=60;
   title "Using Mallows Cp for Model Selection";
run;
quit;
