
*-------------------------------------------------------------------------------------
	ST201s02.sas
	Exercise #2 - Generating Candidate Models
		In the STAT2.CARS4 data set the dependent variable is LOGPRICE. The 
		independent variables are the same as the ones in the STAT2.CARS data set.
		Complete the following exercise to generate candidate models.	
-------------------------------------------------------------------------------------;

*---------------------------------------------------------------------------------------
	#2A
		Use SGSCATTER to genrate plots of LOGPRICE versus
		all the other predictor variables. 	Based on these plots, which variables 
		appear to have a curvilinear relationships with logprice? Create new scatter 
		plots of these variables using PROC SGSCATTER with the PBSPLINE option. 
		Which variables  might need polynomial terms in a regression model?
--------------------------------------------------------------------------------------=;
proc sgscatter data=STAT2.cars4;
  plot logprice*(citympg hwympg cylinders enginesize horsepower 
       fueltank luggage weight);
 run; 									*ST201s02.sas;

proc sgscatter data=STAT2.cars4;
  plot logprice*(citympg hwympg enginesize horsepower) / pbspline;
run;									*ST201s02.sas;

*--------------------------------------------------------------------------------------------
	#2B
	Use these model selection methods shown below to generate candidate models with Logprice 
	as the dependent variable. Add the code: PLOTS =CRITERIA to the PROC GLMSELECT
	statement to request the selection criteria panel of plots: 
1)  Backward elimination method using p-values
2)  Stepwise selection using AICC
3)  Forward selection with adjusted R^2
----------------------------------------------------------------------------------------------;

%macro e_poly;

effect p_city=polynomial(citympg / degree=2 standardize(method=moments)=center);
effect p_hwy=polynomial(hwympg / degree=2 standardize(method=moments)=center);
effect p_engine=polynomial(enginesize / degree=2 standardize(method=moments)=center);
effect p_hp=polynomial(horsepower / degree=2 standardize(method=moments)=center);

%mend;

proc glmselect data=STAT2.cars4 plots= criteria;
   title 'Backward elimination using p-values';
   %e_poly;
   model logprice=p_city p_hwy cylinders p_engine p_hp
         fueltank luggage weight / selection=backward select=sl hierarchy=single;
run;

proc glmselect data=STAT2.cars4 plots= criteria;
   title 'Stepwise selection using AICC';
   %e_poly;
   model logprice=p_city p_hwy cylinders p_engine p_hp
         fueltank luggage weight / selection=stepwise select=aicc hierarchy=single;
run;

proc glmselect data=STAT2.cars4 plots= criteria;
   title 'Forward selection using adjusted R-squared';
   %e_poly;
   model logprice=p_city p_hwy cylinders p_engine p_hp
         fueltank luggage weight / selection=forward select=adjrsq hierarchy=single;
run;                              *ST201s02.sas;
					

*--------------------------------------------------------------------------------------------
	#2D - OPTIONAL
	Optional (advanced). The plot of enginesize may indicate a more complex 
	relationship than a quadratic one and may be over fitting the data. 
    Add NKNOTS=5 to the PBSPLINE option What happens to the graph?
-------------------------------------------------------------------------------------------;
proc sgscatter data=STAT2.cars4;
  plot logprice*enginesize / pbspline = (nknots=5);
run; 									*ST201s02.sas;								
