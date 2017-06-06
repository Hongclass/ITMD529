
title;
*a;
proc print data=STAT2.softdrinks;
title 'Softdrink Data';
run;

proc sgplot data=STAT2.softdrinks;
   histogram time;
   density time;
   density time / type=kernel;
   title1 'Softdrink Data';
   title2 'Original Scale';
run; 								*ST205s02.sas;
*b;
proc sgplot data=STAT2.softdrinks;
   histogram logtime;
   density logtime;
   density logtime / type=kernel;
   title2 'Log Scale';
run; 								*ST205s02.sas;

*c - model on original scale w/log link in GLIMMIX;
proc glimmix data=STAT2.softdrinks;
   model time= cases cases*cases distance distance*distance /
      dist=gamma link=log solution;
title1 'Softdrink Data - Gamma Regression with Log Link';
run; 								*ST205s02.sas;

*d - remove distance*distance;
ods graphics / imagemap=on;
proc glimmix data=STAT2.softdrinks plots=studentpanel(unpack);
   model time= cases cases*cases distance  / dist=gamma link=log solution;
   output out=gamma_predicted pred(ilink)=pred;
title1 'Softdrink Data - Final Model';
run;
			 						*ST205s02.sas;

*Plot the predicted times against the observed times;
title 'Softdrink Data - Gamma Regression with Log link - Final Model';
proc sgplot data=gamma_predicted noautolegend;
   scatter y=pred  x=time;
   reg y=pred x=time /datalabel=distance;
   title2 'Predicted Time versus Observed Time';
run; 									*ST205s02.sas;
