title 'Collinearity Diagnosis for the Cubic Model';

proc corr data=paper nosimple plots=matrix;
   var amount amount2 amount3;
run;

proc reg data=paper;
   model strength=amount amount2 amount3 / vif collin collinoint;
run;
quit;
title;              			 *ST201d05.sas;                   



										
