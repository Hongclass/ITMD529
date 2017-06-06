%let path=/folders/myfolders/census;
libname census "&path";

/*Select particular variables from data set*/
data census.psam_h17_subset1;
set census.psam_h17;
 	if VALP >=175000 then BONUS = 1;
    else if VALP <175000 then BONUS = 0;
    if VALP <= 0 then delete;
keep HFL VALP BONUS;
label 
 	HFL ='Heating Fuel'
   	VALP='Property Value'
   	BONUS = 'VALP(Property Value)>$175,000';
run;

/*Crosstabulation*/
title;

proc format;
value bonusfmt	0="Not Eligible"
				1="Eligible";
value $hflfmt 	"1"="Utility gas"
				"2"="Bottled, tank, or LP gas"
				"3"="Electricity"
				"4"="Fuel oil, kerosene, etc."
				"5"="Coal or coke"
				"6"="Wood"
				"7"="Solar energy"
				"8"="Other fuel"
				"9"="No fuel used"
run;

proc freq data=census.psam_h17_subset1;
tables BONUS HFL
HFL*BONUS/
plots=freqplot(scale=percent);
format BONUS bonusfmt. HFL $hflfmt.;
run;
