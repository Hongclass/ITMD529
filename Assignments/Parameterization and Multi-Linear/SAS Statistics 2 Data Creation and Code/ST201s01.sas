
*-------------------------------------------------------------------------------
	Chapter 1 Exercises
-------------------------------------------------------------------------------;


*-------------------------------------------------------------------------------
	1B - Use SGSCATTER to Plot sales versus dispensers.
--------------------------------------------------------------------------------;
title "Scatter Plot of Cafeteria Data Set";
proc sgscatter data=STAT2.cafeteria;
   plot sales * dispensers;
run;
quit;										*ST201s01.sas;

*-------------------------------------------------------------------------------------
	1c.   Use PROC REG to fit a simple linear regression model to the data. 
	Use the statement ODS GRAPHICS ON and add the PLOTS (ONLY UNPACK) = DIAGNOSTICS 
	options on the PROC REG statement to get the diagnostics panel of plots. 
	Examine the plot of the residuals versus the predicted values the plot of the 
	observed versus the predicted values.  Does your model seem to fit the data well?
------------------------------------------------------------------------------------;
proc reg data=STAT2.cafeteria plots (only unpack) = diagnostics ;
   model sales=dispensers;
run;
				 							*ST201s01.sas;

*-------------------------------------------------------------------------------------------
	1D Fit a quadratic model by specifying an EFFECT statement in PROC GLMSELECT. Output
    the design matrix to a dataset using the OUTDESIGN option, then use PROC REG with the 
	&_GLSMOD macro variable to request Type I tests and the DIAGNOSTICS panel of plots. Look at 
	the plot of the residuals versus the predicted values, the plot of the observed versus 
	the predicted values and the normal quantile plot for residuals. Use PROC SGPLOT with a 
	REG statement with the option degree=2 to get a scatter plot of the data with a second 
	degree regression overlaid. From the plots, do you think the quadratic model fits your 
	data better than the linear model? 
------------------------------------------------------------------------------------------;
 									
proc glmselect data=STAT2.cafeteria outdesign=d_disp;
	effect q_disp=polynomial(dispensers / degree=2);
	model sales = q_disp / selection=none;
run;

proc reg data=d_disp plots (only unpack) = diagnostics;
   model sales=&_GLSMOD / scorr1(tests);
run;
quit;       

proc sgplot data=STAT2.cafeteria;
 reg y= sales x=dispensers / degree=2;
run;											*ST201s01.sas;

*--------------------------------------------------------------------------------------------
	1E - ADVANCED - You can obtain plots of the residuals versus the regressors
	by adding the RESIDUALS keyword to your plots request in PROC REG. To help in detecting patterns, 
	you can use the SMOOTH= suboption of the RESIDUALS plots request to add smooth curves to 
	these residual plots. Look this up in the online documentation and add the appropriate 
	options to your code. Use two model statements, one for the linear model and another
	for the quadratic model and add the appropriate options to get the RESIDUALS	
    plots with a smooth curve added. Compare the residual plots from the two models. Which
	one fits your data better and why? 
-------------------------------------------------------------------------------------;
proc reg data=d_disp plots (only label) = (residuals (smooth)) ;
   LINEAR: model sales=dispensers;
   QUADRATIC: model sales=&_GLSMOD;
run;
quit;
					 							*ST201s01.sas;
	
*------------------------------------------------------------------------------------------
	1F - Use PROC CORR to compute the Pearson correlation coefficient between dispensers 
	and dispensers squared. Use the ODS GRAPHICS statement to enable the default plots for 
	PROC CORR. Examine the tabular and graphical output. What do you conclude?
--------------------------------------------------------------------------------------------;
proc corr data=d_disp nosimple plots()=matrix;
   var &_GLSMOD;
run;
					 							*ST201s01.sas;

*------------------------------------------------------------------------------------------
	1G - Use the appropriate options in the MODEL statement in PROC REG to compute the 
	variance inflation factor (VIF) and the collinearity diagnostics statistics. Is there 
	collinearity among the independent variables?
-------------------------------------------------------------------------------------------;
proc reg data=d_disp;
   model sales=&_GLSMOD / vif collin collinoint;
run;
quit; 										*ST201s01.sas;

*--------------------------------------------------------------	
	h.  Use PROC GLMSELECT with an EFFECT statement to create a new centered quadratic
        effect for dispensers and fit a model with the centered polynomial terms. Use 
        the OUTDESIGN option to create a new model design dataset. Using the new design 
        dataset, obtain collinearity diagnostics from PROC REG. Does the centered model
        appear to have multicollinearity among the independent variables?
---------------------------------------------------------------;
proc glmselect data=STAT2.cafeteria outdesign=d_dispc;
	effect q_dispc=polynomial(dispensers / degree=2 standardize(method=moments)=center);
	model sales = q_dispc / selection=none;
run;           


ods html;
ods html select ParameterEstimates CollinDiag CollinDiagNoInt;
proc reg data=d_dispc;
   model sales = &_GLSMOD / vif collin collinoint;
   title 'Centered Quadratic Model';
run;
title;
quit;     								*ST201s01.sas;
