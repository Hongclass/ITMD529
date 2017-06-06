*---------------------------------------------------------------------
	Scatter plots and regression analysis on Sasuser.school dataset
----------------------------------------------------------------------;
proc sgscatter data=sasuser.school;
 compare y=reading3
 	     x=(words1 letters1 phonics1);
 title 'Scatter Plots of READING3 by WORDS1 LETTERS1 and PHONICS1';
run; 								*ST201d1.sas;

options formdlim="_";
proc reg data=sasuser.school 
	plots (only)=diagnostics (unpack);
   	model reading3 = words1 letters1 phonics1;
	output out=out r=residuals;
title 'School Data: Regression and Diagnostics';
run;
quit;                                
				 					*ST201d1.sas;
proc univariate data=out normal;
  var residuals;
run;
									*ST201d1.sas;

