*----------------------------------------------
	Multicollinearity diagnostics
-----------------------------------------------;

proc reg data=paper1;
   model strength = mcamount mcamount2 mcamount3 / 
                      vif collin collinoint;
   title 'Centered Cubic Model';
run;
title;
quit;                                          *ST201d07.sas;
