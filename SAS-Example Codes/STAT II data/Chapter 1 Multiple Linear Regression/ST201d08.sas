*-----------------------------------------------------------------------------
	Initial graphical data exploration for sasuser.cars data set
	Use HTML destination and turn on TOOLTIPS
-------------------------------------------------------------------------------;
proc sgscatter data=sasuser.cars;
   plot price*(citympg hwympg cylinders enginesize horsepower fueltank
	    luggage weight); 
run;									*ST201d08.sas;

*------------------------------------------------------
	Add spline to plots where curvature is suspected
-------------------------------------------------------;
ods graphics  / imagemap=on;
ods listing close;
ods html style=statistical;
proc sgscatter data=sasuser.cars;
 plot price*(citympg hwympg fueltank weight) / pbspline;
run;
ods html close;
ods listing;
				  						*ST201d08.sas;

