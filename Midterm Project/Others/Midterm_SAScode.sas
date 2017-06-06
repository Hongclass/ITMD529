libname STAT1 "/folders/myfolders";

title "A20355725";

proc surveyselect data=stat1.hads2013n
 method=srs n=500 out=stat1.hads2013n_500;
 run;

/*st102d01.sas*/ /*Part B*/
%let interval=ZINC2 
L30
L50
L80;

option label;

proc sgscatter
data=STAT1.hads2013n_500;
plot FMR*(&interval) / reg;
title "Associations of Interval
Variables with FMR";
Label ZINC2 =" Household Income";
Label L30="Extremely LowIncome";
Label L50="Very Low Income";
Label L80="Low Income";
run;



proc sgplot data=STAT1.hads2013n_500;
vbox FMR / category=BEDRMS
connect=mean;
title "FMR Differences across BEDROOM";
run;


 Data stat1.hads2013n;
 set stat1.hads2013n;
 if FMTBEDRMS='1 1BR' then FMTBEDRMS_1=1;
 else if FMTBEDRMS='2 2BR' then FMTBEDRMS_1=2;
 else if FMTBEDRMS='3 3BR' then FMTBEDRMS_1=3;
 else if FMTBEDRMS='4 4BR+' then FMTBEDRMS_1=4; 
 run;

proc surveyselect data=stat1.hads2013n
 method=srs n=100 out=stat1.hads_100;
 run;
 
 data stat1.hads_100;
set stat1.hads_100;
char_region= region;
Region_n=input(char_region, 8.);
run;

 proc glm data=STAT1.hads_100  plots=diagnostics; 
class structuretype ; 
model FMR=structuretype ; 
means structuretype / hovtest=levene; 
run; 
quit; 
 proc glm data=STAT1.hads_100  plots=diagnostics; 
class  bedrms ; 
model FMR= bedrms ; 
means  bedrms / hovtest=levene; 
run; 
quit; 
 proc glm data=STAT1.hads2013n  plots=diagnostics; 
class  region; 
model FMR= region; 
means  region/ hovtest=levene; 
run; 
quit; 
 proc glm data=STAT1.hads_100 plots=diagnostics; 
class structuretype bedrms region; 
model FMR=structuretype bedrms region; 
means structuretype bedrms region/ hovtest=levene; 
run; 
quit; 
proc corr data=stat1.hads_100 nosimple
plots=matrix(nvar=all histogram);
var FMR BEDRMS structuretype region_n;
run;

proc corr data=stat1.hads_data nosimple
plots=matrix(nvar=all histogram);
var FMR L80 L50 L30 Zinc2 ;
run;

proc surveyselect data=stat1.hads2013n
 method=srs n=1000 out=stat1.hads_new;
 run;

 Data income;
 set stat1.hads_new;
 if ZINC2 < 50000and ZINC2 >0 then income=1;
 else if ZINC2 > 50001 and ZINC2 <100000then income=2;
 else if ZINC2 > 100001 and ZINC2 <1000000then income=3;
 else if ZINC2 > 1000001 then income=4;
 run;
 
  Data FMR_1;
 set income ;
 if FMR< 2000 and FMR>0 then FMR_1=1;
 else if FMR> 2000 then FMR_1=2;
 run;
 
 Data FMR_freq;
 set stat1.hads2013n;
 if FMR< 1500 and FMR>0 then FMR_1=1;
 else if FMR> 1500then FMR_1=2;
 run;
ods graphics on;
proc freq data = FMR_freq; 
   tables FMR_1 / chisq plots=freqplot;
   label FMR_1= "Fair Market Rent";
run;
ods graphics off;
 
proc logistic data=FMR_1
alpha=.05 plots(only)=(effect oddsratio);
model FMR_1(event="1")=Income/ clodds=pl; 
run;

proc logistic data=FMR_1
alpha=.05 plots(only)=(effect oddsratio);
model FMR_1(event="2")=BEDRMS/ clodds=pl; 
run;
proc reg data=stat1.hads_1000 ;
model FMR=l30;
label FMR="Fair market rent(average) in $";
Label L30='Extremely low income limit(average)in $';
run;

proc reg data=stat1.hads_1000 ;
model FMR=l50;
label FMR="Fair market rent(average) in $";
Label L50='Very low income limit(average)in $';
run;

proc reg data=stat1.hads_1000 ;
model FMR=L80;
label FMR="Fair market rent(average) in $";
Label L80='Low income limit(average)in $';
run;



