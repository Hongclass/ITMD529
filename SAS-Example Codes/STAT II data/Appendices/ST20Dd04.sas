proc reg data=sasuser.cars2;
   model price=hwympg hwympg2 horsepower;
   output out=out p=pred;
   title 'Ordinary Least Squares Model';
run;
quit;

data out;
   set out;
   w=1/(pred*pred);
run;

proc reg data=out plots(unpack)=all;
   model price=hwympg hwympg2 horsepower;
   weight w;
   output out=wout p=wpred r=residual;
   title 'Weighted Least Squares Model';
run;
quit;  
								*ST2Dd04.sas;                             

data wcars2;
   set out;
   Sqrtwgt=sqrt(w);
   WPrice=price*sqrtwgt;
   WHwympg=hwympg*sqrtwgt;
   WHwympg2=hwympg2*sqrtwgt;
   WHorsepower=horsepower*sqrtwgt;
   WInt=1*sqrtwgt;
run;

proc reg data=wcars2;
   model wprice=wint whwympg whwympg2 whorsepower / noint;
   title 'Without WEIGHT Statement on Transformed Data';
run;
title;
quit;   						*ST2Dd04.sas; 						             

