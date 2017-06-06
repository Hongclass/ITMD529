
ods select Histogram ParameterEstimates GoodnessofFit;
proc univariate data=STAT2.cars2;
   var price;
   histogram /gamma(alpha=est sigma=est theta=est color=blue w=2)
             vaxis=0 to 14 by 2 midpoints=8 to 50 by 2;
   title 'Testing Gamma Distributions';
run;                              *ST205d04.sas;

*Cars2 data - gamma model with log link;
proc glimmix data=STAT2.cars2 plots=studentpanel(unpack);
   model price = hwympg hwympg2 horsepower / dist=gamma link=log solution;
   id model hwympg hwympg2 horsepower price;
   output out=check1 student
          pred(ilink)=Pred stderr(ilink)=Stderr lcl(ilink)=LCL ucl(ilink)=UCL
          pred(noilink)=XB stderr(noilink)=StderrXB lcl(noilink)=LCLXB ucl(noilink)=UCLXB;
   title 'Cars Data Set - Gamma Distribution with Log Link';
run;	                            *ST205d04.sas;

proc print data=check1 (obs=5);
   var Model Hwympg Hwympg2 Horsepower Price pred stderr lcl ucl xb stderrxb lclxb uclxb student; 
title2 'Predicted Values';
run;								*ST205d04.sas;

proc print data=check1;
   where student ge 2 | student le -2;
   var model student price pred hwympg horsepower;
title2 'Outlying Student Residuals';
run;							*ST205d04.sas;    

*Cars2 data - gamma model with identity link;
proc glimmix data=STAT2.cars2 plots=studentpanel (unpack);
   model price = hwympg hwympg2 horsepower / dist=gamma link=id solution;
   id model hwympg hwympg2 horsepower price;
   output out=check2 student=Student pred(ilink)=Pred;
   title 'Cars Data Set - Gamma Distribution with Identity Link';
run;	                            *ST205d04.sas;

proc print data=check2;
   where student ge 2 | student le -2;
   var model student price pred hwympg horsepower;
title2 'Outlying Student Residuals';
run;		
title1;   title2; 						*ST205d04.sas;      
