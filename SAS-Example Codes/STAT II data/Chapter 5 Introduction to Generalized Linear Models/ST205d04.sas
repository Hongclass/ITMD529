ods select 'Panel 1' 'Parameter Estimates' 'Goodness of Fit';
proc univariate data=sasuser.cars2;
   var price;
   histogram /gamma(alpha=est sigma=est theta=est color=blue w=2)
             vaxis=0 to 14 by 2 midpoints=8 to 50 by 2;
   title 'Testing Gamma Distributions';
run;                              *ST205d04.sas;

*Cars2 data - gamma model with log link;
ods  output obstats=check1;
ods listing;
proc genmod data=sasuser.cars2 plots=stdreschi(xbeta);
   model price = hwympg hwympg2 horsepower / dist=gamma link=log obstats id=model;
   title 'Cars Data Set - Gamma Distribution with Log Link';
run;	                            *ST205d04.sas;

proc print data=check1;
   where streschi ge 2 | streschi le -2;
   var model streschi price pred hwympg horsepower;
title2 'Outlying Standardized Residuals';
run;
ods listing close;				*ST205d04.sas;    

*Cars2 data - gamma model with identity link;
ods output obstats=check2;
proc genmod data=sasuser.cars2 plots=stdreschi(xbeta) ;
   model price = hwympg hwympg2 horsepower / dist=gamma link=identity obstats id=model;
   title 'Cars Data Set - Gamma Distribution with Identity Link';
run;                                                        

proc print data=check2;
   where streschi ge 2 | streschi le -2;
   var model streschi price pred hwympg horsepower;
title2 'Outlying Standardized Residuals';
run;	
title1;   title2; 						*ST205d04.sas;      
