/*st105s02.sas*/
proc logistic data=sasuser.safety plots(only)=(effect oddsratio);
    model Unsafe(event='1')=Weight / clodds=pl;
    title1 'LOGISTIC MODEL (1):Unsafe=Weight';
run;

