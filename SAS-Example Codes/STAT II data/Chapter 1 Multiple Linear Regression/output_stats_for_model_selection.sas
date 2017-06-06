/*create fit statistics for chart on slide entitled "Select Candidate Models". 
Forward and backward selection methods don't put some of the necessary statistics
into the output. the OUTEST option outputs them to a data set for printing*/

title 'Backward';
proc reg data=sasuser.cars2 outest=backest noprint;
   backward: 
   model price = citympg citympg2 hwympg hwympg2 cylinders
                 enginesize horsepower fueltank fueltank2 fueltank3
                 luggage weight
                 / selection=backward cp aic sbc adjrsq rsquare slstay=0.1;
run;
proc print data=backest;
   var _rsq_ _adjrsq_ _cp_ _aic_ _sbc_;
run;

title 'Forward';
proc reg data=sasuser.cars2 outest=forwardest noprint;
   forward:
   model price = citympg citympg2 hwympg hwympg2 cylinders
                 enginesize horsepower fueltank fueltank2 fueltank3
                 luggage weight
                 / selection=forward cp aic sbc adjrsq rsquare slentry=0.1;
run;
proc print data=forwardest;
   var _rsq_ _adjrsq_ _cp_ _aic_ _sbc_;
run;
