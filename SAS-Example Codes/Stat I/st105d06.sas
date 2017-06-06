/*st105d06.sas*/
proc logistic data=sasuser.Titanic plots(only)=(effect oddsratio);
    class Gender(ref='male') Class(ref='3') / param=ref;
    model Survived(event='1')=Age Gender Class / clodds=pl;
    units age=10;
    title1 'LOGISTIC MODEL (2):Survived=Age Gender Class';
run;
