/* Risk in males vs risk in females */
proc format;
    value Gender 1 = "Male"
                   2 = "Female"
                  ;
run;

proc format;
    value Heart 1 = "Yes"
                   2 = "No"
                  ;
run;


ods graphics on;
proc logistic data=census.brfss_20
plots(only)=(effect oddsratio);
class sex (ref ='Female') / param = ref ;
model CVDINF(event = 'Yes') = sex/ clodds=pl;
title 'LOGISTIC MODEL (1):Heart Attack risk Male vs Female';
format sex Gender.;
format CVDINF Heart.;
run;

proc format;
    value Ethinc 1 = "White"
                   2 = "Others"
                  ;
run;

/* ethincity */
ods graphics on;
proc logistic data=census.brfss_20
plots(only)=(effect oddsratio);
class ETHIN (ref ='Others')/ param = ref  ;
model CVDINF(event = 'Yes') = ETHIN/ clodds=pl;
title 'LOGISTIC MODEL (1):Heart Attack risk in White vs Other Races ';
format ETHIN Ethinc.;
format CVDINF Heart.;
run;


/*BP high & smoke yes */
proc format;
    value BPVal 1 = "High"
                   2 = "Normal"
                  ;
run;
proc format;
    value SMOKE_VAlUE 1 = "Yes Did"
                   2 = "Never"
                  ;
run;

ods graphics on;
proc logistic data=census.brfss_20 
plots(only)=(effect oddsratio);
class SMOKE (ref ='Never') BP (ref='Normal')/ param = ref;
model CVDINF(event = 'Yes') = SMOKE BP/ clodds=pl;
title 'LOGISTIC MODEL (1):Heart Attack risk for Person who has High BP and also Smokes ';
format BP BPVal.;
format CVDINF Heart.;
format SMOKE SMOKE_VALUE.;
label CVDINF = "Heart Attack";
run;


