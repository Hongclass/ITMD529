
*--------------------------------------------------------------------
	Continue data exploration for STAT2.cars data set with PROC
	CORR and scatterplots of the predictor variables
-----------------------------------------------------------------------;

proc corr data=STAT2.cars nosimple;
   var price citympg hwympg cylinders enginesize horsepower fueltank luggage weight;
run;         

proc sgscatter data=STAT2.cars;
   matrix citympg hwympg cylinders enginesize horsepower fueltank luggage weight;
run; 								*ST201d08.sas;

