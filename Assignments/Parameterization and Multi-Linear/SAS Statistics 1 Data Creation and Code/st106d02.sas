/*st106d02.sas*/  /*Part A*/

proc plm restore=STAT1.amesstore;
    score data=STAT1.ameshousing4 out=scored;
    code file="&homefolder\scoring.sas";
run;

data scored2;
    set STAT1.ameshousing4;
    %include "&homefolder\scoring.sas";
run;

proc compare base=scored compare=scored2 criterion=0.0001;
    var Predicted;
    with P_SalePrice;
run;



