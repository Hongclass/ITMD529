*-------------------------------------------------------
  Use PROC REG for multicollinearity diagnostics. 
  First create design variables with PROC GLMSELECT
-------------------------------------------------------;
ods select none;
proc glmselect data=STAT2.school outdesign=design;
   class gender;
   model reading3=gender|words1 / selection=none;
run;
%put &_GLSMOD;

ods select ParameterEstimates;
proc reg data=design;
   model reading3=&_GLSMOD / vif;
title 'Check Collinearity on ANCOVA Model';
run;
quit;				*ST204s03.sas;
