%let class1 = atm_group;
%let period = 201212;
%let condition = dda eq 1;
%let fmt1 = sheetz;

options MSTORED SASMSTORE = mjstore;
libname mjstore 'C:\Documents and Settings\ewnym5s\My Documents\SAS';

%macro ranges(class1=,period=, fmt1=, where=) / store source des='calculate data for my modified boxplot';
	data products;
	set data.main_&period;
	where &where;
	keep hhid atm_group dda_amt mms_amt sav_amt tda_amt ira_amt sec_amt mtg_amt heq_amt iln_amt ind_amt ccs_amt
	     dda mms sav tda ira sec mtg heq iln ind card &class1;
	run;


	data products;
	retain miss;
	merge products (in=left) data.contrib_&period (in=right drop=STATE ZIP BRANCH CBR MARKET band band_yr rename=(contrib=contrib_mtd)) end=eof;
	by hhid;
	if left then output;
	if left and not right then miss+1;
	if eof then put 'WARNING: Records on left not found on right = ' miss;
	drop miss;
	run;

	data products;
	set products;
		if not dda then dda_amt = .;
		if not mms then mms_amt = .;
		if not sav then sav_amt = .;
		if not tda then tda_amt = .;
		if not ira then ira_amt = .;
		if not sec then sec_amt = .;
		if not mtg then mtg_amt = .;
		if not heq then heq_amt = .;
		if not iln then iln_amt = .;
		if not ind then ind_amt = .;
		if not card then ccs_amt = .;
		products = sum(dda,mms,sav,tda,ira,mtg,heq,sec,card,iln,ind);
	run;

	proc transpose data=products out=balances(rename=(_name_=variable col1=balance));
	by hhid &class1;
	var dda_amt mms_amt sav_amt tda_amt ira_amt mtg_amt heq_amt iln_amt ind_amt ccs_amt sec_amt;
	run;

	proc transpose data=products out=contribution(rename=(_name_=variable col1=contribution));
	by hhid &class1;
	var dda_con mms_con sav_con tda_con ira_con mtg_con heq_con iln_con ind_con card_con sec_con;
	run;

	proc tabulate data=balances missing order=data;
	class variable /preloadfmt;
	class &class1  ;
	var balance;
	table balance*(q1 qrange median mean)*f=dollar12., variable*&class1 / nocellmerge;
	format &class1 &fmt1.. variable $prod1a. ;
	run;


	proc tabulate data=contribution missing order=data;
	class variable /preloadfmt;
	class &class1  ;
	var contribution;
	table contribution*(q1 qrange median mean)*f=dollar12.2, variable*&class1 / nocellmerge;
	format &class1 &fmt1.. variable $prod1a. ;
	run;

	proc tabulate data=products missing;
	class &class1  ;
	var products contrib_mtd;
	table contrib_mtd*(q1 qrange median mean)*f=dollar12.2, &class1 / nocellmerge;
	table products*(q1 qrange median mean)*f=comma12.2, &class1 / nocellmerge;
	format &class1 &fmt1..;
	run;
%mend;

%ranges(class1=atm_group,period=201212,fmt1=sheetz,condition=dda eq 1 and atm_group ne 6)

/*
proc freq data=balances;
table variable / out=t1;
run;


data fmt;
length label $ 20;
set t1;
FMTNAME='Prods1';
START=variable;
END=variable;
LABEL='';
keep fmtname start end label;
run;

data fmt;
set fmt;
order=1;
run;

proc sort data=fmt;
by order;
run;

data fmt;
set fmt;
FMTNAME='Prod1A';
type='C';
HLO='S';
run;

proc format library=sas cntlin=fmt;
run;
*/
