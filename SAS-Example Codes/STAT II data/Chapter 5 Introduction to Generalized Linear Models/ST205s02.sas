title;
*a;
proc print data=sasuser.softdrinks;
title 'Softdrink Data';
run;

proc sgplot data=sasuser.softdrinks;
   histogram time;
   density time;
   density time / type=kernel;
   title1 'Softdrink Data';
   title2 'Original Scale';
run; 								*ST205s02.sas;
*b;
proc sgplot data=sasuser.softdrinks;
   histogram logtime;
   density logtime;
   density logtime / type=kernel;
   title2 'Log Scale';
run; 								*ST205s02.sas;

*c - model on original scale w/log link in GENMOD;
proc genmod data=sasuser.softdrinks;
   model time= cases cases cases*cases distance distance*distance /
      dist=gamma link=log type3;
title1 'Softdrink Data - Gamma Regression with Log Link';
run; 								*ST205s02.sas;

*d - remove distance*distance;
ods graphics / imagemap=on;
ods output obstats=gamma_predicted;
proc genmod data=sasuser.softdrinks plots(unpack)=stdreschi(xbeta);
   model time= cases cases*cases distance  /
      dist=gamma link=log type3 obstats;
title1 'Softdrink Data - Final Model';
run;
			 						*ST205s02.sas;

*Plot the predicted times against the observed times;
title 'Softdrink Data - Gamma Regression with Log link - Final Model';
proc sgplot data=gamma_predicted;
   reg y=pred  x=time / datalabel =distance;
   title2 'Predicted Time versus Observed Time';
run; 									*ST205s02.sas;
