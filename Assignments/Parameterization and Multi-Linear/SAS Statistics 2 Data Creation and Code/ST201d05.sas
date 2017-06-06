
title 'Collinearity Diagnosis for the Cubic Model';

*--------------------------------------------------------------------
 	Examine pairwise correlations between predictors
--------------------------------------------------------------------;

proc corr data=d_paper nosimple plots=matrix;
   var &_GLSMOD;
run;

*--------------------------------------------------------------------
 	Use PROC REG to obtain VIFs and condition index diagnostics
--------------------------------------------------------------------;
proc reg data=d_paper plots=none;
   model strength=&_GLSMOD / vif collin collinoint;
run;
quit;
title;              			 *ST201d05.sas;                   



										
