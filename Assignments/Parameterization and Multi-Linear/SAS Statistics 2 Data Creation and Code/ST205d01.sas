

title;
proc sgplot data=STAT2.crab;
 histogram satellites;
 density satellites;
 density satellites / type=kernel;
run;

ods select moments basicmeasures;
proc univariate data=STAT2.crab;
 var satellites;
 histogram /  normal;
run; 									*ST205d01.sas;

proc genmod data=STAT2.crab;
   class color spine;
   model satellites=width weight color spine 
        / dist=poi link=log type3;
   title 'Poisson Model';
run;										*ST205d01.sas;
