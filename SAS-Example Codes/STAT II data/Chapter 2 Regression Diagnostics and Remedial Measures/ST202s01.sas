
*-------------------------------------------------------------------------------------------
	Chapter 2 - Exercise 1a.
	Use the appropriate options in the MODEL statement to evaluate multicollinearity, 
	influential observations, and constant variance assumption. Generate the necessary plots 
	to check the assumptions of regression. Is multicollinearity a problem for this
	model? Does this model meet the assumptions for linear regression?
*------------------------------------------------------------------------------------;
proc reg data=sasuser.cars3  plots (label)=all;
   model logprice = citympg citympg2 enginesize horsepower horsepower2 weight
     / vif collin collinoint influence spec partial;
   output out=check r=Residual p=Pred rstudent=rstudent h=leverage;
   id model;
run;
quit; 

data check;
 set check;
 AbsError=abs(residual);
run;

proc corr data=check spearman nosimple;
 var abserror pred;
run;  								*ST202s01.sas;

*-------------------------------------------------------------------------------------
	Chapter 2 - Exercise 1b	(uses plots generated from code above)
	To assess the model fit, examine the R-F plot, the plot of the observed values 
	versus the predicted value, and the plots of residuals versus the independent variables. 
	What are your conclusions? 	
----------------------------------------------------------------------------------------;

*------------------------------------------------------------------------------------
	Chapter 2 - Exercise 1c	(uses plots created in 1a and requires additional coding)
	Examine the plots of the Cook's D, DFFITS, and DFBETA statistics, the 
	plot of RSTUDENT versus LEVERAGE and the partial leverage plots to identify any 
	outlying or influential observations.  Output the potentially influential observations
	to a data set. What are your conclusions?
----------------------------------------------------------------------------------------;

%let numparms = 7;  /* # of predictor variables + 1 */ 
%let numobs = 81;   /* # of observations */
%let idvars = manufacturer model price; /* relevant identification variable(s) */

data influence;
 set check;
 absrstud=abs(rstudent);
 if absrstud ge 2 then output;
 else if leverage ge (2*&numparms /&numobs) then output;
run;
proc print data=influence;
 var &idvars;
 run;									 *ST202s01.sas;                                          
			

*--------------------------------------------------------------------------------------------
	1d.   Use the output data set containing the influence statistics that you created in the 
	previous exercise. Use PROC SGPLOT to do a scatter plot of the residuals versus the 
	predicted values. Look up in the documentation for SGPLOT how to use the GROUP option and 
	plot the residuals versus the predicted values. Use the variable Manufacturer as the 
	grouping variable. Do you see any patterns? 
-----------------------------------------------------------------------------------------------;
proc sgplot data=influence;
   scatter y=rstudent x=pred / group=manufacturer;
   refline 0;
run;									*ST202s01.sas;
