/*st102s03.sas*/  /*Part A*/
%let interval=Age Weight Height Neck Chest Abdomen Hip 
              Thigh Knee Ankle Biceps Forearm Wrist;

ods graphics / reset=all imagemap;
proc corr data=STAT1.BodyFat2 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var &interval;
   with PctBodyFat2;
   id Case;
   title "Correlations and Scatter Plots";
run;

%let interval=Biceps Forearm Wrist;

ods graphics / reset=all imagemap;
ods select scatterplot;
proc corr data=STAT1.BodyFat2 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var &interval;
   with PctBodyFat2;
   id Case;
   title "Correlations and Scatter Plots";
run;

/*st102s03.sas*/  /*Part B*/
ods graphics off;
%let interval=Age Weight Height Neck Chest Abdomen Hip Thigh
              Knee Ankle Biceps Forearm Wrist;

proc corr data=STAT1.BodyFat2 
          nosimple 
          best=5
          out=pearson;
   var &interval;
   title "Correlations of Predictors";
run;

%let big=0.7;
proc format;
    picture correlations &big -< 1 = '009.99' (prefix="*")
                         -1 <- -&big = '009.99' (prefix="*")
                         -&big <-< &big = '009.99';
run;

proc print data=pearson;
    var _NAME_ &interval;
    where _type_="CORR";
    format &interval correlations.;
run;

%let big=0.7;
data bigcorr;
    set pearson;
    array vars{*} &interval;
    do i=1 to dim(vars);
        if abs(vars{i})<&big then vars{i}=.;
    end;
    if _type_="CORR";
    drop i _type_;
run;

proc print data=bigcorr;
    format &interval 5.2;
run;

title;

