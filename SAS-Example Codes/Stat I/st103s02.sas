/*st103s02.sas*/  /*Part A*/
ods graphics off;
proc reg data=sasuser.BodyFat2;
    model PctBodyFat2=Weight;
    title "Regression of % Body Fat on Weight";
run;
quit;

ods graphics on;

/*st103s02.sas*/  /*Part B*/
ods graphics off;
proc reg data=sasuser.BodyFat2 outest=Betas;
    PredBodyFat: model PctBodyFat2=Weight;
    title "Regression of % Body Fat on Weight";
run;
quit;

data ToScore;
    input Weight @@;
    datalines;
125 150 175 200 225
;
run;

proc score data=ToScore score=Betas
           out=Scored type=parms;
    var Weight;
run;

proc print data=Scored;
    title "Predicted % Body Fat from Weight 125 150 175 200 225";
run;

ods graphics on;
