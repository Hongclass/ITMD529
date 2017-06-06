/*st105s03.sas*/
proc logistic data=sasuser.safety plots(only)=(effect oddsratio);
    class Region (param=ref ref='Asia')
          Size (param=ref ref='3');
    model Unsafe(event='1')=Weight Region Size / clodds=pl;
    title1 'LOGISTIC MODEL (2):Unsafe=Weight Region Size';
run;
