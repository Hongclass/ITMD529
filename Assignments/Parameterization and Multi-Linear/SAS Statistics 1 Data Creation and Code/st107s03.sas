/*st107s03.sas*/
ods graphics on;
proc logistic data=STAT1.safety plots(only)=(effect oddsratio);
    class Region (param=ref ref='Asia')
          Size (param=ref ref='3');
    model Unsafe(event='1')=Weight Region Size / clodds=pl;
    title 'LOGISTIC MODEL (2):Unsafe=Weight Region Size';
run;
