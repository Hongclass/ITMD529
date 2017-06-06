*--------------------------------------------------------------------
	Continue data exploration for sasuser.cars data set with PROC
	CORR and scatter plots of the predictor variables
-----------------------------------------------------------------------;

proc corr data=sasuser.cars nosimple;
   var price citympg hwympg cylinders enginesize horsepower fueltank luggage weight;
run;         
				 					*ST201d09.sas;
ods listing  style=analysis;
proc sgscatter data=sasuser.cars;
  matrix  citympg hwympg cylinders enginesize horsepower fueltank luggage weight;
run; 								*ST201d09.sas;

