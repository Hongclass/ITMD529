/*st103s01.sas*/  /*Part A*/

proc corr data=sasuser.BodyFat2 rank
          plots(only)=scatter(nvar=all ellipse=none);
    var Age Weight Height;
    with PctBodyFat2;
    title "Correlations and Scatter Plots with Body Fat %";
run;

proc corr data=sasuser.BodyFat2 rank
          plots(only)=scatter(nvar=all ellipse=none);
    var Neck Chest Abdomen Hip Thigh
          Knee Ankle Biceps Forearm Wrist;
    with PctBodyFat2;
    title "Correlations and Scatter Plots with Body Fat %";
run;

/*st103s01.sas*/  /*Part B*/

proc corr data=sasuser.BodyFat2 nosimple 
          plots=matrix(nvar=all histogram);
    var Age Weight Height;
    title "Correlations and Scatter Plot Matrix of Basic Measures";
run;

proc corr data=sasuser.BodyFat2 nosimple 
          plots(maxpoints=30000)=matrix(nvar=all histogram);
    var Neck Chest Abdomen Hip Thigh
          Knee Ankle Biceps Forearm Wrist;
    title "Correlations and Scatter Plot Matrix of Circumferences";
run;

proc corr data=sasuser.BodyFat2 nosimple 
          plots(maxpoints=30000)=matrix(nvar=all histogram);
    var Neck Chest Abdomen Hip Thigh
          Knee Ankle Biceps Forearm Wrist;
    with Age Weight Height;
    title "Correlations and Scatter Plot Matrix of Circumferences";
run;
