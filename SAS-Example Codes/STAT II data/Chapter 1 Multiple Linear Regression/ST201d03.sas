*--------------------------------------------------------------------
 	Creater higher-order terms for sasuser.paper data set and
	run polynomial regression - degree=4
--------------------------------------------------------------------;
title;
title2;

data paper;
   set sasuser.paper;
   amount2 = amount**2;
   amount3 = amount**3;
   amount4 = amount**4;
run;

proc reg data=paper ;
   model strength= amount amount2 amount3 amount4 / scorr1(tests);
title "Paper Data Set: 4th Degree Polynomial";
run;
quit;                               *ST201d03.sas;

