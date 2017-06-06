
proc sgplot data=STAT2.enso;
   scatter y=pressure x=month;
   title 'Data for the First 36 Months';
run;						*ST20Dd02.sas;

title;
proc loess data=STAT2.enso plots=all;
   model Pressure = Month;
run;
	 						*ST20Dd02.sas;

proc loess data=STAT2.enso plots(unpack) =all ;
   model Pressure=Month /  r select=aicc(global) 
						   details(tree fitpoints statout) ;
run;
				 			*ST20Dd02.sas;
proc loess data=STAT2.enso plots=fitplot;
   model pressure = month / smooth=0.05655 clm alpha=0.01;
run;	
							*ST20Dd02.sas;

data test;
   do Month=10 to 160 by 10;
   output;
   end;
run;

proc loess data=STAT2.enso;
   model pressure = month / smooth=0.05655;
   score data=test / print;
run;	
 							*ST20Dd02.sas;


