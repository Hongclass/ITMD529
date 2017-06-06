ods html close;
ods rtf file="BoxPlots.rtf" style=journal;
ods rtf select BoxCoxFPlot BoxCoxLogLikePlot RMSEPlot;

proc transreg data=sasuser.cars2 ss2 test cl nomiss 
	plots=boxcox (rmse unpack);
   model boxcox(price / convenient)=identity(hwympg hwympg2 horsepower);
run;
quit;                                                
ods rtf close;		
			 							*ST202d03.sas;
ods listing;
proc transreg data=sasuser.cars2 ss2 test cl nomiss plots=none;
   model boxcox(price / convenient)=identity(hwympg hwympg2 horsepower);
run;
quit; 									*ST202d03.sas;

