
*-----------------------------------------------------------------------------
  Fit model with centered amount variables in PROC GLMSELECT
------------------------------------------------------------------------------;
proc glmselect data=STAT2.paper outdesign=dc_paper;
	effect qc_amount=polynomial(amount / degree=3 standardize(method=moments)=center);
	model strength = qc_amount / selection=none;
	title "Paper Data Set: Centered Cubic Model";   
run;                         *ST201d06.sas;

*-----------------------------------------------------------------------------
  Check collinearity diagnostics for centered model
------------------------------------------------------------------------------;
ods select ParameterEstimates CollinDiag CollinDiagNoInt;
proc reg data=dc_paper;
   model strength = &_GLSMOD / vif collin collinoint;
   title 'Diagnostics for Centered Cubic Model';
run;
title;
quit;                        *ST201d06.sas;


*-----------------------------------------------------------------------------
Alternatively, PROC STDIZE or PROC SQL + a DATA step to center the variable
before fitting the model. The centered variables can then be used to create
higher-order terms in a DATA step before model fitting.
------------------------------------------------------------------------------;

proc stdize data=STAT2.paper method=mean out=paper1(rename=(amount=mcamount));
   var amount;
run;

data paper1;
   set paper1;
   mcamount2 = mcamount**2;
   mcamount3 = mcamount**3;
run;  

proc sql;
   select mean(amount) into: mamount
   from STAT2.paper;
run;

data paper2;
   set STAT2.paper;
   mcamount=amount-&mamount;
   mcamount2 = mcamount**2;
   mcamount3 = mcamount**3;
run;      						*ST201d06.sas;             


	
										

