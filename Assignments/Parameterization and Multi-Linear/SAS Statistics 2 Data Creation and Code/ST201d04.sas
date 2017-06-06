
*-------------------------------------------------------------------
	Perform diagnostics on cubic polynomial model
----------------------------------------------------------------------;
proc reg data=d_paper plots (unpack) =(diagnostics (stats=none)); 
   Cubic_Model: model strength=&_GLSMOD / lackfit;       
   title "Paper Data Set: 3rd Degree Polynomial Model";   
run;
quit;                      *ST201d04.sas;

