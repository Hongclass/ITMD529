/*st103d01.sas*/  /*Part A*/
ods graphics / reset=all imagemap;
proc corr data=sasuser.fitness rank
          plots(only)=scatter(nvar=all ellipse=none);
    var RunTime Age Weight Run_Pulse
        Rest_Pulse Maximum_Pulse Performance;
    with Oxygen_Consumption;
    id name;
    title "Correlations and Scatter Plots with Oxygen_Consumption";
run;

/*st103d01.sas*/  /*Part B*/
ods graphics / reset=all;
proc corr data=sasuser.fitness nosimple 
          plots=matrix(nvar=all histogram);
    var RunTime Age Weight Run_Pulse
         Rest_Pulse Maximum_Pulse Performance;
    title "Correlations and Scatter Plot Matrix of Fitness Predictors";
run;
