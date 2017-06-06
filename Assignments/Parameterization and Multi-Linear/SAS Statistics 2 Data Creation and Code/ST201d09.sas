
*-----------------------------------------------------------------------
	Use automatic selection options to generate candidate models
-----------------------------------------------------------------------;
ods graphics / reset=all;

title 'Model Selection with Cars Dataset';

/* Create macro to store code for polynomial effects */
%macro p_eff;

effect p_city = polynomial(citympg /degree=2 standardize(method=moments)=center);
effect p_hwy = polynomial(hwympg /degree=2 standardize(method=moments)=center);
effect p_fuel = polynomial(fueltank /degree=3 standardize(method=moments)=center);

%mend;

proc glmselect data=STAT2.cars2 plots=criteria;
   title2 'Backward elimination with significance levels';
   %p_eff;
   model price = p_city p_hwy cylinders enginesize horsepower p_fuel
                 luggage weight 
                 / selection=backward select=sl slstay=0.05 hierarchy=single;
run;

proc glmselect data=STAT2.cars2;
   title2 'Forward selection with significance levels';
   %p_eff;
   model price = p_city p_hwy cylinders enginesize horsepower p_fuel
                 luggage weight 
                 / selection=forward select=sl slentry=0.1 hierarchy=single;
run;

proc glmselect data=STAT2.cars2;
   title2 'Backward elimination using SBC';
   %p_eff;
   model price = p_city p_hwy cylinders enginesize horsepower p_fuel
                 luggage weight 
                 / selection=backward select=sbc hierarchy=single;
run;

proc glmselect data=STAT2.cars2 plots=criteria;
   title2 'Backward elimination using adjusted R-square';
   %p_eff;
   model price = p_city p_hwy cylinders enginesize horsepower p_fuel
                 luggage weight 
                 / selection=backward select=adjrsq hierarchy=single;
run;
title;                    *ST201d09.sas


