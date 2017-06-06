*-------------------------------------------------------------------------------
	Chapter 1 Exercises
-------------------------------------------------------------------------------;


*-------------------------------------------------------------------------------
	1B - Use SGSCATTER to Plot sales versus dispensers.
--------------------------------------------------------------------------------;
title "Scatter Plot of Sasuser.Cafeteria Data Set";
proc sgscatter data=sasuser.cafeteria;
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
proc reg data=sasuser.cafeteria plots (only unpack) = diagnostics ;
 model sales=dispensers;
run;
				 							*ST201s01.sas;

*-------------------------------------------------------------------------------------------
	1D Use a DATA step to create a quadratic term for dispensers. Fit a quadratic model 
	using PROC REG, and request Type I tests and the DIAGNOSTICS panel of plots. Look at 
	the plot of the residuals versus the predicted values, the plot of the observed versus 
	the predicted values and the normal quantile plot for residuals. Use PROC SGPLOT with a 
	REG statement with the option degree=2 to get a scatter plot of the data with a second 
	degree regression overlaid. From the plots, do you think the quadratic model fits your 
	data better than the linear model? 
------------------------------------------------------------------------------------------;
data cafeteria;
   set sasuser.cafeteria;
   dispensers2=dispensers*dispensers;
run; 									

proc reg data=cafeteria plots (only unpack) = diagnostics;
   model sales=dispensers dispensers2 / scorr1(tests);
run;
quit;       

proc sgplot data=sasuser.cafeteria;
 reg y= sales x=dispensers / degree=2;
run;											*ST201s01.sas;

*--------------------------------------------------------------------------------------------
	1E - ADVANCED - You can obtain plots of the residuals versus the regressors
	by adding the RESIDUALS keyword to your plots request. To help in detecting patterns, 
	you can use the SMOOTH= suboption of the RESIDUALS plots request to add smooth curves to 
	these residual plots. Look this up in the online documentation and add the appropriate 
	options to your code. Use two model statements, one for the linear model and another
	for the quadratic model and add the appropriate options to get the RESIDUALS	
    plots with a smooth curve added. Compare the residual plots from the two models. Which
	one fits your data better and why? 
-------------------------------------------------------------------------------------;
proc reg data=cafeteria plots (only label) = (residuals (smooth)) ;
   LINEAR: model sales=dispensers;
   QUADRATIC: model sales=dispensers dispensers2;
run;
quit;
					 							*ST201s01.sas;
	
*------------------------------------------------------------------------------------------
	1F - Use PROC CORR to compute the Pearson correlation coefficient between dispensers 
	and dispensers squared. Use the ODS GRAPHICS statement to enable the default plots for 
	PROC CORR. Examine the tabular and graphical output. What do you conclude?
--------------------------------------------------------------------------------------------;
proc corr data=cafeteria nosimple plots()=matrix;
   var dispensers dispensers2;
run;
					 							*ST201s01.sas;

*------------------------------------------------------------------------------------------
	1G - Use the appropriate options in the MODEL statement in PROC REG to compute the 
	variance inflation factor (VIF) and the collinearity diagnostics statistics. Is there 
	collinearity among the independent variables?
-------------------------------------------------------------------------------------------;
proc reg data=cafeteria;
   model sales=dispensers dispensers2 / vif collin collinoint;
run;
quit; 										*ST201s01.sas;
*--------------------------------------------------------------	
	h.   Use PROC STDIZE to center the variable dispensers. 
	Use a DATA step to create the quadratic form of the 
	centered variable. Fit a quadratic model using these 
	centered variables. Does it appear to have multi-
	collinearity among the independent variables?
---------------------------------------------------------------;
proc stdize data=sasuser.cafeteria method=mean out=cafeteria1;
   var dispensers;
run;

data cafeteria1;
   set cafeteria1;
   mcdispensers = dispensers;
   mcdispensers2 = mcdispensers**2;
run;            

proc reg data=cafeteria1;
   model sales = mcdispensers mcdispensers2 / vif collin collinoint;
   title 'Centered Quadratic Model';
run;
title;
quit;     								*ST201s01.sas;
