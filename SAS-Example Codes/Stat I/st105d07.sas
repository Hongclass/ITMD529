/*st105d07.sas*/  /*Part A*/
proc logistic data=sasuser.Titanic plots(only)=(effect oddsratio);
    class Gender(ref='male') Class(ref='3') / param=ref;
    model Survived(event='1')=Age|Gender|Class @2 / 
          selection=backward clodds=pl slstay=0.01;
    units age=10;
    title1 'LOGISTIC MODEL (3): Backward Elimination '
           'Survived=Age|Gender|Class';
run;

/*st105d07.sas*/  /*Part B*/
proc logistic data=sasuser.Titanic 
              plots(only)=oddsratio(range=clip);
    class Gender(ref='male') Class(ref='3') / param=ref;
    model Survived(event='1')=Age Gender|Class;
    units age=10;
    oddsratio Gender / at (Class=ALL) cl=pl;
    oddsratio Class / at (Gender=ALL) cl=pl;
    oddsratio Age / cl=pl;
    title1 'LOGISTIC MODEL (3.1): Survived=Age Gender|Class';
run;

