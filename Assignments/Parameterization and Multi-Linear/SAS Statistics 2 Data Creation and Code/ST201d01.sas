

*---------------------------------------------------------------------
	Scatter plots and regression analysis on STAT2.school dataset
----------------------------------------------------------------------;
proc sgscatter data=STAT2.school;
 compare y=reading3
 	     x=(words1 letters1 phonics1);
 title 'Scatter Plots of READING3 by WORDS1 LETTERS1 and PHONICS1';
run;

title 'School Data: Regression and Diagnostics';
proc glmselect data=STAT2.school;
	model reading3 = words1 letters1 phonics1 / selection=none;
	output out=out r=residuals;
run;

proc univariate data=out;
  var residuals;
  histogram residuals / normal kernel;
  qqplot residuals / normal(mu=est sigma=est);
run;
title;
									*ST201d01.sas;

