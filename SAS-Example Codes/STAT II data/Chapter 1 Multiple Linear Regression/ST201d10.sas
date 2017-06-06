*--------------------------------------------------------------
	Center variables appearing to have polynomial relationship
	with PRICE to reduce multicollinearity. Create higher-order
	terms
---------------------------------------------------------------;

proc stdize data=sasuser.cars method=mean out=sasuser.cars2;
   var citympg hwympg fueltank weight;
run;

data sasuser.cars2;
   set sasuser.cars2;
   citympg2 = citympg*citympg;
   hwympg2 = hwympg*hwympg;
   fueltank2=fueltank*fueltank;
   fueltank3=fueltank2*fueltank;
run;                                 *ST201d10.sas;

