/*st102d06.sas*/  /*Part A*/
proc print data=sasuser.drug(obs=10);
    title 'Partial Listing of Drug Data Set';
run;

/*st102d06.sas*/  /*Part B*/
proc format;
    value dosefmt 1='Placebo'
                  2='50 mg'
                  3='100 mg'
                  4='200 mg';
run;

proc means data=sasuser.drug
           mean var std nway;
    class Disease DrugDose;
    var BloodP;
	format DrugDose dosefmt.;
    output out=means mean=BloodP_Mean;
    title 'Selected Descriptive Statistics for Drug Data Set';
run;

/*st102d06.sas*/  /*Part C*/
proc sgplot data=means;
    series x=DrugDose y=BloodP_Mean / group=Disease markers;
    xaxis integer;
    title 'Plot of Stratified Means in Drug Data Set';
	format DrugDose dosefmt.;
run;

/*st102d06.sas*/  /*Part D*/
proc glm data=sasuser.drug order=internal;
    class DrugDose Disease;
    model Bloodp=DrugDose Disease DrugDose*Disease;
    title 'Analyze the Effects of DrugDose and Disease';
    title2 'Including Interaction';
	format DrugDose dosefmt.;
run;
quit;

/*st102d06.sas*/  /*Part E*/
ods graphics off;
ods select LSMeans SlicedANOVA;
proc glm data=sasuser.drug order=internal;
    class DrugDose Disease;
    model Bloodp=DrugDose Disease DrugDose*Disease;
    lsmeans DrugDose*Disease / slice=Disease;
    title 'Analyze the Effects of DrugDose';
    title2 'at Each Level of Disease';
	format DrugDose dosefmt.;
run;
quit;

ods graphics on;
