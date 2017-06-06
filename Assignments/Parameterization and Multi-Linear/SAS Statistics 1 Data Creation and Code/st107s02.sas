/*st107s02.sas*/
ods graphics on;
proc logistic data=STAT1.safety plots(only)=(effect oddsratio);
    model Unsafe(event='1')=Weight / clodds=pl;
    title 'LOGISTIC MODEL (1):Unsafe=Weight';
run;

