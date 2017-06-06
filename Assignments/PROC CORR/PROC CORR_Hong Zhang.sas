%let path=/folders/myfolders/census;
libname census "&path";

/*Select particular variables from data set*/
data census.psam_h17_subset1;
set census.psam_h17;
if VALP <= 0 then delete;
run;

/*Get the sample dataset of 100 obs*/
proc surveyselect data=census.psam_h17_subset1
method=srs n=101 out=census.corr;
run;

proc print data=census.corr(obs=100);
run;

proc contents data=census.corr;
run;

proc corr data=census.corr rank
	plots(only)=scatter(nvar=all ellipse=none);
	var HINCP RMSP MRGP WATP FINCP SMOCP;
	with VALP;
	title "Correlations with VALP";
run;

ods graphics/imagemap=on;
proc corr data=census.corr nosimple
	plots=matrix(nvar=all histogram);
	var HINCP RMSP MRGP WATP FINCP SMOCP;
	title "Correlations with VALP";
run;