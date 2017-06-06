
ods graphics / imagemap=on;
ods select modelanova overallanova QQPlot ResidualHistogram boxplot HOVFTest;
proc glm data=STAT2.pressure2 plots (unpack)=all;
   class drug;
   model bpchange=drug;
   means drug / hovtest;
   id drug;
run;
quit;

proc glimmix data=STAT2.pressure2;
   class drug;
   model bpchange=drug;
   random _residual_ / group=drug;
   covtest 'common variance' homogeneity;
run;
    					*ST203d07.sas;
