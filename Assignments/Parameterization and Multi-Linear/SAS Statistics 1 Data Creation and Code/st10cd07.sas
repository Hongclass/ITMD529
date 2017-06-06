/*st10cd07.sas*/  /*Part A*/
proc means data=STAT1.ameshousing3 noprint nway;
    class Fireplaces;
    var Bonus;
    output out=bins sum(Bonus)=NEvents n(Bonus)=NCases;
run;

data bins;
    set bins;
    Logit=log((NEvents+0.5)/(NCases-NEvents+0.5));
run;

proc sgplot data=bins;
    scatter Y=Logit X=Fireplaces /
        markerattrs=(symbol=asterisk color=blue size=15);
    xaxis integer;
    title "Estimated Logit Plot of Fireplaces";
run;
quit;

/*st10cd07.sas*/  /*Part B*/
proc rank data=STAT1.ameshousing3 groups=15 out=Ranks;
    var Basement_Area;
    ranks Rank;
run;

proc means data=Ranks noprint nway;
    class Rank;
    var Bonus Basement_Area;
    output out=Bins sum(Bonus)=NEvents n(Bonus)=NCases
        mean(Basement_Area)=Basement_Area;
run;

data bins;
    set bins;
    Logit=log((NEvents+0.5)/(NCases-NEvents+0.5));
run;

proc sgplot data=bins;
    reg Y=Logit X=Basement_Area /
        markerattrs=(symbol=asterisk color=blue size=15);
    loess Y=Logit X=Basement_Area / nomarkers;
    title "Estimated Logit Plot of Basement_Area";
run;
quit;