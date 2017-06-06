%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom ;

/*st104d03.sas*/ /*Part A*/
ods graphics on;
proc reg data=STAT1.ameshousing3 plots(only)=(rsquare adjrsq cp);
	ALLPOSS: model SalePrice = &interval / selection=rsquare adjrsq cp;
	title "All Possible Model Selection for SalePrice";
run;
quit;

/*st104d03.sas*/ /*Part B*/
proc reg data=STAT1.ameshousing3 plots(only)=(cp);
	ALLPOSS: model SalePrice = &interval / selection=cp rsquare adjrsq best=20;
	title "Best Models Using All Possible Selection for SalePrice";
run;
quit;
