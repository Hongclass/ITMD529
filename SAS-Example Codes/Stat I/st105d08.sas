/*st105d08.sas*/  /*Part A*/
proc means data=sasuser.Titanic noprint nway;
    class Class;
    var Survived;
    output out=bins sum(Survived)=NEvent n(Survived)=NCases;
run;

data bins;
    set bins;
    Logit=log((NEvent+1)/(NCases-NEvent+1));
run;

proc sgplot data=bins;
    reg Y=Logit X=Class / 
         markerattrs=(symbol=asterisk color=blue size=15);
    pbspline Y=Logit X=Class / nomarkers;
    xaxis integer;
    title "Estimated Logit Plot of Passenger Class";
run;
quit;

/*st105d08.sas*/  /*Part B*/
proc rank data=sasuser.Titanic groups=50 out=Ranks;
    var Age;
    ranks Rank;
run;

proc means data=Ranks noprint nway;
    class Rank;
    var Survived Age;
    output out=Bins sum(Survived)=NEvent n(Survived)=NCases
           mean(Age)=Age;
run;

data bins;
    set bins;
    Logit=log((NEvent+1)/(NCases-NEvent+1));
run;

proc sgplot data=bins;
    reg Y=Logit X=Age / 
         markerattrs=(symbol=asterisk color=blue size=15);
    pbspline Y=Logit X=Age / nomarkers;
    title "Estimated Logit Plot of Passenger's Age";
run;
quit;
