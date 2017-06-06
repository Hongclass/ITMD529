options formdlim="_";
title;
proc sgplot data=sasuser.earinfection;
 histogram infections;
 density infections;
 density infections / type=kernel;
run; 							

ods listing;
ods select moments basicmeasures goodnessoffit;
proc univariate data=sasuser.earinfection;
 var infections;
 histogram /  normal;
run; 									*ST205s01.sas;

proc genmod data=sasuser.earinfection;
   class swimmer location gender;
   model infections=swimmer location age gender 
      / dist=poisson link=log type3;
run;									*ST205s01.sas;

*d.   Use the GENMOD procedure to fit a negative binomial 
regression model to this data. What factors are now significant?;

proc genmod data=sasuser.earinfection;
   class swimmer location gender;
   model infections=swimmer location age gender
      / dist=negbin link=log type3;
run;  									*ST205s01.sas;
*e. use PSCALE option w/Poisson model;
proc genmod data=sasuser.earinfection;
   class swimmer location gender;
   model infections=swimmer location age gender 
      / dist=poisson link=log type3 pscale;
run;									*ST205s01.sas;
