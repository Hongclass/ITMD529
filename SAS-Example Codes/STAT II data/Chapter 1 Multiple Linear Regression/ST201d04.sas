*-------------------------------------------------------------------
	Reduce to 3rd degree polonomial model and test for 
	lack-of-fit
----------------------------------------------------------------------;
proc reg data=paper plots (unpack) =(diagnostics (stats=none)); 
   Cubic_Model: model strength=amount amount2 amount3 / lackfit 
   scorr1(tests);
title "Paper Data Set: 3rd Degree Polynomial";   
run;
quit;
							                     *ST201d04.sas;

