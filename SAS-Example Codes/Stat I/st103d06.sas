/*st103d06.sas*/
ods graphics off;
proc reg data=sasuser.fitness;
   PREDICT: model Oxygen_Consumption 
                  = RunTime Age Run_Pulse Maximum_Pulse;
   EXPLAIN: model Oxygen_Consumption 
                  = RunTime Age Weight Run_Pulse Maximum_Pulse;
   title 'Check "Best" Two Candidate Models';
run;
quit;

ods graphics on;
