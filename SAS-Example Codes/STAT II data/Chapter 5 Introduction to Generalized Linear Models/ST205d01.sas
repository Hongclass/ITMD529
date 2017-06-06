title;
proc sgplot data=sasuser.crab;
 histogram satellites;
 density satellites;
 density satellites / type=kernel;
run;

ods select moments basicmeasures goodnessoffit;
proc univariate data=sasuser.crab;
 var satellites;
 histogram /  normal;
run; 									*ST205d01.sas;

proc genmod data=sasuser.crab;
   class color spine;
   model satellites=width weight color spine 
        / dist=poi link=log type3;
   title 'Poisson Model';
run;									*ST205d01.sas;
