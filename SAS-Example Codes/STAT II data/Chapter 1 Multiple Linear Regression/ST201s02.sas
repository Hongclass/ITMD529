*-------------------------------------------------------------------------------------
	ST201e02.sas
	Exercise #2 - Generating Candidate Models
		In the SASUSER.CARS4 data set the dependent variable is LOGPRICE. The 
		independent variables are the same as the ones in the SASUSER.CARS data set.
		Complete the following exercise to generate candidate models.	
-------------------------------------------------------------------------------------;

*---------------------------------------------------------------------------------------
	#2A
		Use SGSCATTER with the PBSPLINE option to genrate plots of LOGPRICE versus
		all the other predictor variables. 	Based on these plots, which variables 
		appear to have a curvilinear relationships with logprice? Create new scatter 
		plots of these variables using PROC SGSCATTER with the PBSPLINE option. 
		Which variables  might need to be squared in a regression model?
--------------------------------------------------------------------------------------=;
proc sgscatter data=sasuser.cars4;
  plot logprice*(citympg hwympg cylinders enginesize horsepower 
       fueltank luggage weight);
 run; 										*ST201s02.sas;

proc sgscatter data=sasuser.cars4;
  plot logprice*(citympg hwympg enginesize horsepower) / pbspline;
run;

*------------------------------------------------------------------------------------------------
	#2B
		Use the STDIZE procedure to center the variables Citympg, Hwympg, EngineSize, and 
		Horsepower. Output these variables to a data set named cars3. Use a DATA step to create 
		squared terms for the centered variables.
------------------------------------------------------------------------------------------------;
proc stdize data=sasuser.cars4 method=mean out=cars3;
   var citympg hwympg enginesize horsepower;
run;

data sasuser.cars3;
   set cars3;
   citympg2=citympg*citympg;
   hwympg2=hwympg*hwympg;
   enginesize2=enginesize*enginesize;
   horsepower2=horsepower*horsepower;
run; 										*ST201s02.sas;

*--------------------------------------------------------------------------------------------
	#2C
	Use these model selection methods shown below to generate candidate models with Logprice 
	as the dependent variable. Add the code: PLOTS (ONLY MODELLABEL)=CRITERIA to the PROC REG 
	statement to request the selection criteria panel of plots: 
1)  Backward elimination method
2)  R2 selection method with BEST=3 option. Include a graph of Mallows' Cp versus p in your 
	output.
3)  Adjusted-R2 selection method with BEST=10 option to generate candidate regression models.
----------------------------------------------------------------------------------------------;
proc reg data=sasuser.cars3 plots (only) = criteria;
   backward:
   model logprice=citympg citympg2 hwympg hwympg2 cylinders
         enginesize enginesize2 horsepower horsepower2 fueltank
         luggage weight / selection=backward;
   Rsquared:
   model logprice=citympg citympg2 hwympg hwympg2 cylinders
         enginesize enginesize2 horsepower horsepower2 fueltank
         luggage weight / selection=rsquare adjrsq cp sbc aic best=3;
   plot cp.*np. /
        vaxis=0 to 30 by 5
        haxis=0 to 12 by 1
        cmallows=red
        nostat nomodel;
   symbol v=circle w=4 h=1;
   Adjusted_R2:
   model logprice=citympg citympg2 hwympg hwympg2 cylinders
         enginesize enginesize2 horsepower horsepower2 fueltank
         luggage weight / selection=adjrsq rsquare cp sbc aic best=10;
run;
quit; 		
				 						*ST201s02.sas;
					
*----------------------------------------------------------------------
	D. Based on Mallows' Cp, how many variables would be appropriate 
	in the regression model?
	E. Which variables appear to be appropriate for the regression 
	model?
---------------------------------------------------------------------;

*--------------------------------------------------------------------------------------------
	#2E - OPTIONAL
	Optional (advanced). The plot of enginesize may indicate a more complex 
	relationship than a quadratic one and may be over fitting the data. 
    Add NKNOTS=5 to the PBSPLINE option What happens to the graph?
-------------------------------------------------------------------------------------------;
proc sgscatter data=sasuser.cars4;
  plot logprice*enginesize / pbspline = (nknots=5);
run; 									*ST201s02.sas;								
