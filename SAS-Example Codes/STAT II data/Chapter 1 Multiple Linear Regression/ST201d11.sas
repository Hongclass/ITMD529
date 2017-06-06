
*-----------------------------------------------------------------------
	Use automatic selection options to generate candidate models
-----------------------------------------------------------------------;
ods graphics / reset=all;

title 'Model Selection Cars2 Data Set';
proc reg data=sasuser.cars2 plots(only) = criteria ;
   backward: 
   model price = citympg citympg2 hwympg hwympg2 cylinders
                 enginesize horsepower fueltank fueltank2 fueltank3
                 luggage weight
                 / selection=backward slstay=0.1;
   forward:
   model price = citympg citympg2 hwympg hwympg2 cylinders
                 enginesize horsepower fueltank fueltank2 fueltank3
                 luggage weight
                 / selection=forward slentry=0.1;
   Rsquared:
   model price = citympg citympg2 hwympg hwympg2 cylinders
                 enginesize horsepower fueltank fueltank2 fueltank3
                 luggage weight
                 / selection=rsquare adjrsq cp sbc aic best=3;
   plot cp.*np. / vaxis=0 to 30 by 5 haxis=0 to 12 by 1 
                  cmallows=red nostat nomodel;
   symbol v=circle w=4 h=1;
   Adjusted_R2:
   model price = citympg citympg2 hwympg hwympg2 cylinders
                 enginesize horsepower fueltank fueltank2 fueltank3
                 luggage weight 
                 / selection=adjrsq rsquare cp sbc aic best=10;
run;
quit;                                                 *ST201d11.sas;                                                    
title;

