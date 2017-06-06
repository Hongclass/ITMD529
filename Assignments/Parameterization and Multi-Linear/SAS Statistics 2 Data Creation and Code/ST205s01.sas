
title;
proc sgplot data=STAT2.earinfection;
 histogram infections;
 density infections;
 density infections / type=kernel;
run; 							

ods select moments basicmeasures goodnessoffit;
proc univariate data=STAT2.earinfection normal;
 var infections;
 histogram /  normal;
run; 									*ST205s01.sas;

proc genmod data=STAT2.earinfection;
   class swimmer location gender;
   model infections=swimmer location age gender 
      / dist=poisson link=log type3;
run;									*ST205s01.sas;

*d.   Use the GENMOD procedure to fit a negative binomial 
regression model to this data. What factors are now significant?;

proc genmod data=STAT2.earinfection;
   class swimmer location gender;
   model infections=swimmer location age gender
      / dist=negbin link=log type3;
run;  									*ST205s01.sas;
*e. use PSCALE option w/Poisson model;
proc genmod data=STAT2.earinfection;
   class swimmer location gender;
   model infections=swimmer location age gender 
      / dist=poisson link=log type3 pscale;
run;									*ST205s01.sas;
