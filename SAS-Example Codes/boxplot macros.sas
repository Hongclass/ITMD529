%macro balance_box(main_source=,contrib_source=,condition=,class1=,fmt1=) / store;

	data box;
	set &main_source;
	where &condition;
	keep &class1 dda: mms: sav: tda: ira: mtg: iln: ind: heq: card: ccs: sec:  hhid ;
	rename ccs_amt = card_amt;
	run;

	data box;
	set box;
		if not dda then dda_amt = .;
		if not mms then mms_amt = .;
		if not sav then sav_amt = .;
		if not tda then tda_amt = .;
		if not ira then ira_amt = .;
		if not mtg then mtg_amt = .;
		if not heq then heq_amt = .;
		if not iln then iln_amt = .;
		if not sec then sec_amt = .;
		if not ind then ind_amt = .;
		if not card then card_amt = .;
	run;


	data box1 ;
	set box ;
	order = 1;
	balance = dda_amt;
	output;
	order = 2;
	balance = mms_amt;
	output;
	order = 3;
	balance = sav_amt;
	output;
	order = 4;
	balance = tda_amt;
	output;
	order = 5;
	balance = ira_amt;
	output;
	order = 6;
	balance = card_amt;
	output;
	order = 7;
	balance = iln_amt;
	output;
	order = 8;
	balance = ind_amt;
	output;
	order = 9;
	balance = sec_amt;
	output;
	order = 10;
	balance = mtg_amt;
	output;
	order = 11;
	balance = heq_amt;
	output;
	keep order balance &class1 hhid;
	run;


	proc format;
	value order 1 = 'Checking'
	              2 = 'Money Mkt'
				  3 = 'Savings'
				  4 = 'Time Dep'
				  5 = 'IRAs'
				  6 = 'Credit Card'
				  7 = 'Dir. Loan'
				  8 = 'Ind. Loan'
				  9 = 'Securities'
				  10= 'Mortgage'
				  11='Home Equity';
	run;



	data box1;
	set box1;
	variable = put(&class1,&fmt1..);
	run;

	proc sql;
		select count(unique(variable)) into :class_n TRIMMED from box1 ;
	quit;
    
	%do k = 1 %to &class_n;
	%global name&k  n&k;
	%end;

	proc sql;
		select variable, count(*) into :name1 - :name&class_n, :n1 - :n&class_n from box1 group by variable ;
	quit;

	proc sort data=box1;
	by  variable;
	run;

	data box1;
	set box1;
	retain index;
	by variable;
	if first.variable then index+1;
	run;

	proc sort data=box1;
	by  hhid order;
	run;

	proc transpose data=box1 out=box_tran prefix=amt;
	var balance;
	id index;
	by hhid order;
	copy variable balance;
	run;

	proc sort data=box_tran;
	by order;
	run;
%mend balance_box;


%macro contrib_box(main_source=,contrib_source=,condition=,class1=,fmt1=) / store;

	data cbox;
	set &main_source;
	where &condition;
	keep &class1 dda mms sav tda ira mtg iln ind heq card  sec  hhid ;
	run;

	data cbox;
	merge cbox(in=a) &contrib_source(in=b keep=hhid dda_con mms_con sav_con tda_con ira_con mtg_con iln_con ind_con heq_con card_con  sec_con);
	by hhid;
	if a;
	run;
 

	data cbox;
	set cbox;
		if not dda then dda_con = .;
		if not mms then mms_con = .;
		if not sav then sav_con = .;
		if not tda then tda_con = .;
		if not ira then ira_con = .;
		if not mtg then mtg_con = .;
		if not heq then heq_con = .;
		if not iln then iln_con = .;
		if not sec then sec_con = .;
		if not ind then ind_con = .;
		if not card then card_con = .;
	run;


	data cbox1 ;
	set cbox ;
	order = 1;
	contribution = dda_con;
	output;
	order = 2;
	contribution = mms_con;
	output;
	order = 3;
	contribution = sav_con;
	output;
	order = 4;
	contribution = tda_con;
	output;
	order = 5;
	contribution = ira_con;
	output;
	order = 6;
	contribution = card_con;
	output;
	order = 7;
	contribution = iln_con;
	output;
	order = 8;
	contribution = ind_con;
	output;
	order = 9;
	contribution = sec_con;
	output;
	order = 10;
	contribution = mtg_con;
	output;
	order = 11;
	contribution = heq_con;
	output;
	keep order contribution &class1 hhid;
	run;


	proc format;
	value order 1 = 'Checking'
	              2 = 'Money Mkt'
				  3 = 'Savings'
				  4 = 'Time Dep'
				  5 = 'IRAs'
				  6 = 'Credit Card'
				  7 = 'Dir. Loan'
				  8 = 'Ind. Loan'
				  9 = 'Securities'
				  10= 'Mortgage'
				  11='Home Equity';
	run;

	data cbox1;
	set cbox1;
	variable = put(&class1,&fmt1..);
	run;

	proc sql;
		select count(unique(variable)) into :class_n TRIMMED from cbox1 ;
	quit;

	%do k = 1 %to &class_n;
	%global name&k  n&k;
	%end;


	proc sql;
		select variable, count(*) into :name1 - :name&class_n, :n1 - :n&class_n from cbox1 group by variable ;
	quit;

	proc sort data=cbox1;
	by  variable;
	run;

	data cbox1;
	set cbox1;
	retain index;
	by variable;
	if first.variable then index+1;
	run;

	proc sort data=cbox1;
	by  hhid order;
	run;

	proc transpose data=cbox1 out=cbox_tran prefix=amt;
	var contribution;
	id index;
	by hhid order;
	copy variable contribution;
	run;

	proc sort data=cbox_tran;
	by order;
	run;
	
%mend contrib_box;
	
filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\contrib_box.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%contrib_box(main_source=data.main_201212,contrib_source=data.contrib_201212,condition=cbr eq 16,class1=band,fmt1=$band)


