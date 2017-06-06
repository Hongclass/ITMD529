/*st103s03.sas*/  /*Part A*/
proc reg data=sasuser.BodyFat2;
    model PctBodyFat2 = Age Weight Height
          Neck Chest Abdomen Hip Thigh
          Knee Ankle Biceps Forearm Wrist;
   title 'Regression of PctBodyFat2 on All '
         'Predictors';
run;
quit;

/*st103s03.sas*/  /*Part B*/
proc reg data=sasuser.BodyFat2;
    model PctBodyFat2 = Age Weight Height
          Neck Chest Abdomen Hip Thigh
          Ankle Biceps Forearm Wrist;
   title 'Remove Knee';
run;
quit;

/*st103s03.sas*/  /*Part C*/
proc reg data=sasuser.BodyFat2;
    model PctBodyFat2 = Age Weight Height
          Neck Abdomen Hip Thigh
          Ankle Biceps Forearm Wrist;
   title 'Remove Knee and Chest';
run;
quit;
