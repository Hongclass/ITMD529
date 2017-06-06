
title;
*-----------------------------------------------------------------------------
	Initial graphical data exploration for STAT2.cars data set
-------------------------------------------------------------------------------;
proc sgscatter data=STAT2.cars;
   plot price*(citympg hwympg cylinders enginesize horsepower fueltank
	    luggage weight); 
run;									*ST201d07.sas;

*------------------------------------------------------
	Add spline to plots where curvature is suspected
	Use HTML destination and turn on TOOLTIPS
-------------------------------------------------------;
ods graphics  / imagemap=on;

ods html style=statistical;
proc sgscatter data=STAT2.cars;
 	plot price*(citympg hwympg fueltank weight) / pbspline;
run;
				  						*ST201d07.sas;

