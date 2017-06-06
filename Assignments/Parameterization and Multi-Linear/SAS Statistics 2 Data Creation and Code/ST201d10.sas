*-----------------------------------------------------------------------
	Fit a model with spline effect
-----------------------------------------------------------------------;
title 'Spline Effect with Cars Dataset';

proc glmselect data=STAT2.cars;
    title2 'Cubic polynomial for Fueltank';
	effect p_fuel = polynomial(fueltank /degree=3 standardize(method=moments)=center);
	model price = p_fuel / selection=none;
run;                            *ST201d10.sas;

proc glmselect data=STAT2.cars;
    title2 'Spline for Fueltank';
	effect sp_fuel = spline(fueltank / details);
	model price = sp_fuel / selection=none;
run;							*ST201d10.sas;
