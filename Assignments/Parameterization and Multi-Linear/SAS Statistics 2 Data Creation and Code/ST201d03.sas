
*--------------------------------------------------------------------
 	Fit degree=4 polynomial model for PAPER dataset
--------------------------------------------------------------------;
title;
title2;

proc glmselect data=STAT2.paper outdesign=d_paper;
	effect p_amount=polynomial(amount / degree=4);
	model strength = p_amount / selection=none;
	title "Paper Data Set: 4th Degree Polynomial";   
run;                    *ST201d03.sas;

*--------------------------------------------------------------------
 	Use model selection to reduce the model
--------------------------------------------------------------------;
proc glmselect data=STAT2.paper outdesign=d_paper;
	effect p_amount=polynomial(amount / degree=4);
	model strength = p_amount / selection=backward select=sl slstay=0.05 
        hierarchy=single showpvalues;
	title "Paper Data Set: Model Selection";   
run;                    *ST201d03.sas;










