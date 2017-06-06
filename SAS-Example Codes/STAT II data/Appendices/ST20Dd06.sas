proc stdize data=sasuser.cars method=mean out=sasuser.cars2;
   var citympg hwympg fueltank weight;
run;

data sasuser.cars2;
   set sasuser.cars2;
   citympg2 = citympg*citympg;
   hwympg2 = hwympg*hwympg;
   fueltank2=fueltank*fueltank;
   fueltank3=fueltank2*fueltank;
   logprice=log(price);
run;  
 
proc sql noprint;
   select avg(price)
      into :mean
   from sasuser.cars2;
quit; 							*ST20Bd06.sas;


proc reg data=sasuser.cars2;
   model logprice = hwympg hwympg2 horsepower;
   ods output ANOVA=ANOVATable; 
   output out=out p=pred;
run;
quit;

data _null_;
   set ANOVATable;
   if source='Error' then call symput('var', MS);
run;

%let n=81;
%let p=4;
data lognormal(keep=MSElog R2log adjR2log);
   retain sumdiff 0 sumtotal 0;
   set out end=eof;
   estimate = exp(pred + &var/2);
   difference = price - estimate;
   sumdiff = sumdiff + difference**2; 
   sumtotal = sumtotal + (price-&mean)**2;
   if eof then do;
      MSElog = sumdiff / (&n-&p);
      R2log = 1 - sumdiff/sumtotal;
      adjR2log = 1-(sumdiff / (&n-&p)) / (sumtotal/(&n-1));
      output;
   end;
run; 									*ST20Bd06.sas;

ods output obstats=gamma_obstats;
proc genmod data=sasuser.cars2;
  model price = hwympg hwympg2 horsepower / dist=gamma link=log
                                            obstats;
  title 'Assumed Gamma Distribution';
run;

data gamma(keep=MSEgammalog R2gammalog adjR2gammalog );
   retain sumdiff 0 sumtotal 0;
   set gamma_obstats end=eof;
   sumdiff = sumdiff + resraw**2;
   sumtotal = sumtotal + (price-&mean)**2; 
   if eof then do;
      MSEgammalog = sumdiff / (&n-&p);
      R2gammalog = 1 - sumdiff/sumtotal;
      adjR2gammalog = 1-(sumdiff / (&n-&p)) / (sumtotal/(&n-1));
      output;
   end;
run;

ods output obstats=gamma_obstats;
proc genmod data=sasuser.cars2;
  model price = hwympg hwympg2 horsepower / dist=gamma link=identity
                                            obstats;
  title 'Assumed Gamma Distribution';
run;

data gamma2(keep=MSEgammaiden R2gammaiden adjR2gammaiden);
   retain sumdiff 0 sumtotal 0;
   set gamma_obstats end=eof;
   sumdiff = sumdiff + resraw**2;
   sumtotal = sumtotal + (price-&mean)**2; 
   if eof then do;
      MSEgammaiden = sumdiff / (&n-&p);
      R2gammaiden = 1 - sumdiff/sumtotal;
      adjR2gammaiden = 1-(sumdiff / (&n-&p)) / (sumtotal/(&n-1));
      output;
   end;
run;

data all;
   merge lognormal gamma gamma2;
run;

proc print;
run;
quit;							*ST20Bd06.sas;

/* statistics for weighted least squares model*/
/*proc reg data=sasuser.cars2;
   model price=hwympg hwympg2 horsepower;
   output out=out p=pred;
run;
quit;

data out;
   set out;
   w=1/(pred*pred);
run;							*ST2Bd06.sas;

proc reg data=out;
   model price=hwympg hwympg2 horsepower;
   weight w;
   output out=wout p=wpred r=residual;
   title 'WLS Model Using the WEIGHT Statement';
run;                                      

data wls(keep=MSEwls R2wls adjR2wls);
   retain sumdiff 0 sumtotal 0;
   set wout end=eof;
   sumdiff = sumdiff + residual**2;
   sumtotal = sumtotal + (price-&mean)**2;
   if eof then do;
      MSEwls = sumdiff / (&n-&p);
      R2wls = 1 - sumdiff/sumtotal;
      adjR2wls = 1-(sumdiff / (&n-&p)) / (sumtotal/(&n-1));
      output;
   end;
run;
*/

