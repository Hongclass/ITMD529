/*st105d05.sas*/
proc logistic data=sasuser.Titanic
              plots(only)=(effect oddsratio);
    model Survived(event='1')=Age / clodds=pl;
    title1 'LOGISTIC MODEL (1):Survived=Age';
run;
