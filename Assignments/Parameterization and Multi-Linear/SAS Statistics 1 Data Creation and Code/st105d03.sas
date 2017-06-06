%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom ;

/*st105d03.sas*/  /* Part A*/
proc sort data=STAT1.ameshousing3;
    by PID;
run;
proc sort data=STAT1.amesaltuse;
    by PID;
run;

data amescombined;
    merge STAT1.ameshousing3 STAT1.amesaltuse;
    by PID;
run;

title;
proc corr data=amescombined nosimple;
    var &interval;
    with score;
run;

/*st105d03.sas*/  /*Part B*/
proc reg data=amescombined;
    model SalePrice = &interval score / vif;
    title 'Collinearity Diagnostics';
run;
quit;

proc reg data=amescombined;
    NOSCORE: model SalePrice = &interval / vif;
    title2 'Removing Score';
run;
quit;

