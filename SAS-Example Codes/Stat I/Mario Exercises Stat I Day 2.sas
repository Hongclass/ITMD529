*#########################################;
*#####  SAS STAT I, Day 2 Exercises  #####;
*#########################################;


*###### EXERCISE 3.1 ######;
proc corr data=sasuser.bodyfat2 rank
     plots(only)=scatter(nvar=all ellipse=none);
var age weight height;
with pctbodyfat2;
id case;
title 'Body Fat Correlations';
run;

proc corr data=sasuser.bodyfat2 rank
     plots(only)=scatter(nvar=all ellipse=none);
var Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
with pctbodyfat2;
id case;
title 'Body Fat Correlations';
run;

 

proc corr data=sasuser.bodyfat2 rank
     plots(only maxpoints=30000)=matrix(nvar=all histogram );
var age weight height Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
title 'Body Fat Cross-Correlations';
run;


*###### EXERCISE 3.2 ######;
proc reg data=sasuser.bodyfat2 outest=mybetas;
mymodel: model pctbodyfat2 = weight;
run;
quit;
 
data input;
input weight;
datalines;
125
150
175
200
225
;
run;

proc print; run;

proc score data=input score=mybetas out=myscored type=parms;
var weight;
run;

proc sgplot data=myscored;
series x=weight y=mymodel / markers;
run;


*###### EXERCISE 3.3  ######;
proc reg data=sasuser.bodyfat2 outest=mybetasa;
mymodela: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
run;
quit;



*###### EXERCISE 3.4  ######;
proc reg data=sasuser.bodyfat2 outest=mybetasb tableout;
mymodela: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
mymodelb: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip Thigh  Ankle Biceps Forearm Wrist;
run;
quit;

proc sort data=mybetasb;
by _type_;
run;


*###### EXERCISE 3.5  ######;

proc reg data=sasuser.bodyfat2 outest=mybetasc tableout;
mymodela: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
mymodelb: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip Thigh  Ankle Biceps Forearm Wrist;
mymodelc: model pctbodyfat2 = age weight height Neck  Abdomen Hip Thigh  Ankle Biceps Forearm Wrist;
run;
quit;

proc sort data=mybetasc;
by _type_;
run;

data mybetasc;
set mybetasc;
format age weight height Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist comma20.5;
run;

*###### EXERCISE 3.6  ######;

proc reg data=sasuser.bodyfat2 outest=fat_all_1 tableout plots(only)=(cp);
all: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip 
                    Thigh Knee Ankle Biceps Forearm Wrist / selection=cp adjrsq best=60;
fw: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip 
                    Thigh Knee Ankle Biceps Forearm Wrist / selection=f;
bw: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip 
                    Thigh Knee Ankle Biceps Forearm Wrist / selection=backward;
sw: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip 
                    Thigh Knee Ankle Biceps Forearm Wrist / selection=stepwise;
title 'All body fat models new';
run;

/*proc reg data=sasuser.bodyfat2 outest=fat_all tableout plots(only)=(cp);*/
fw1: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip 
                    Thigh Knee Ankle Biceps Forearm Wrist / selection=f sls=.05;
title 'fw body fat models sle=.05';
run;
quit;

*I liked this dumping of data to get all your output, and have it together;

*###### EXERCISE 4.1  ######;

   *rerun the model as I erased it;

proc reg data=sasuser.bodyfat2 outest=fat_all_1 tableout plots(only)=(cp);
fw: model pctbodyfat2 = age weight height Neck Chest Abdomen Hip 
                    Thigh Knee Ankle Biceps Forearm Wrist / selection=f;
run;
quit;


proc reg data=sasuser.bodyfat2 outest=f_final tableout;
fw_final: model pctbodyfat2 =  age weight Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
run; quit;

*###### EXERCISE 4.2  ######;
*a;
ods output RSTUDENTBYPREDICTED=Rstud1 
           COOKSDPLOT=Cook1
           DFFITSPLOT=Dffits1 
           DFBETASPANEL=Dfbs1;

proc reg data=sasuser.bodyfat2 
         plots(only label)=
              (RSTUDENTBYPREDICTED 
               COOKSD 
               DFFITS 
               DFBETAS);
    PREDICT_BF2: model pctbodyfat2 = 
                   abdomen weight wrist forearm;
    id case;
    title 'PREDICT Model - Plots of Diagnostic Statistics Body Fat2';
run;
quit;

data influential_bf2;
/*  Merge datasets from above.*/
    merge Rstud1
          Cook1 
          Dffits1
		  Dfbs1;
    by observation;

/*  Flag observations that have exceeded at least one cutpoint;*/
    if (Rstudent>3) or (Cooksdlabel ne ' ') or Dffitsout then flag=1;
    array dfbetas{*} _dfbetasout: ;
    do i=2 to dim(dfbetas);
         if dfbetas{i} then flag=1;
    end;

/*  Set to missing values of influence statistics for those*/
/*  who have not exceeded cutpoints;*/
    if Rstudent<=3 then RStudent=.;
    if Cooksdlabel eq ' ' then CooksD=.;

/*  Subset only observations that have been flagged.*/
    if flag=1;
    drop i flag;
run;

proc print data=influential_bf2;
    id id1 ;
    var Rstudent CooksD Dffitsout _dfbetasout:; 
run;


*###### EXERCISE 4.3  ######;

proc reg data=sasuser.bodyfat2  ;
all_bf2: model pctbodyfat2 = Density Age Weight Height Adioposity FatFreeWt 
                             Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist / vif;
run;

proc contents data=sasuser.bodyfat2 varnum short;
run;

proc reg data=sasuser.bodyfat2  ;
nowgt: model pctbodyfat2 = Density Age  Height Adioposity FatFreeWt 
                             Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist / vif;
run;
