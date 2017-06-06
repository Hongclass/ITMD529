


%macro create_report(class1,fmt1,condition,main_source,contrib_source,out_file,out_dir,logo_file=) / store;

%*RUN THE STANDARD DATA REQUIRED;
    %penetration(main_source=&main_source, where=&condition, fmt1=&fmt1, class1=&class1,out=penet)

	%contribution(main_source=&main_source, contrib_source=&contrib_source, where=&condition, fmt1=&fmt1, class1=&class1,out=contr)

	%segments(main_source=&main_source, where=&condition, fmt1=&fmt1, class1=&class1,out=segments)


%*Do Additional processing on standard analysis;

	proc sort data=penet;
	by &class1;
	run;

	proc transpose data=penet out=penet1;
	by &class1;
	run;

	data penet1;
	length prod $10 what $ 10 what2 $ 10;
	set penet1;
	prod = upcase(scan(_name_,1,'_','i'));
	if prod eq 'CARD' then prod = 'CRD';
	if prod eq 'CCS' then prod = 'CRD';
	what=lowcase(scan(_name_,2,'_','i'));
	what2=lowcase(scan(_name_,3,'_','i'));
	proxy = put(&class1,&fmt1..);
	run;

	data penet1;
	set penet1;
	if what eq 'pctsum' then col2 = col2/100;
	if  what2 eq 'pctsum' then col3 = col3/(100*1000); *make in in thousands, also fix the *100 from tabulate;
	run;


	data penet1;
	set penet1;
	select  (prod);
		when ('DDA') order = 1;
		when ('MMS') order = 2;
		when ('SAV') order = 3;
		when ('TDA') order = 4;
		when ('IRA') order = 5;
		when ('SEC') order = 6;
		when ('MTG') order = 7;
		when ('HEQ') order = 8;
		when ('CRD') order = 9;
		when ('ILN') order = 10;
		when ('IND') order = 11;
		OTHERWISE ORDER=99;
	END;
	run;

	proc sort data=penet1;
	by order proxy;
	run;


	proc sort data=contr;
	by &class1;
	run;

	proc transpose data=contr out=contr1;
	by &class1;
	run;

	data contr1;
	length prod $10 what $ 10 what2 $ 10;
	set contr1;
	prod = upcase(scan(_name_,1,'_','i'));
	if prod eq 'CARD' then prod = 'CRD';
	if prod eq 'CCS' then prod = 'CRD';
	what=lowcase(scan(_name_,2,'_','i'));
	what2=lowcase(scan(_name_,3,'_','i'));
	proxy = put(&class1,&fmt1..);
	run;

	data contr1;
	set contr1;
	if what eq 'con' and  what2 eq 'pctsum' then col1 = col1/100; *fix the *100 from tabulate;
	if what eq 'contr' and  what2 eq 'pctsum' then col1 = col1/100; *fix the *100 from tabulate;
	run;


	data contr1;
	set contr1;
	select  (prod);
		when ('DDA') order = 1;
		when ('MMS') order = 2;
		when ('SAV') order = 3;
		when ('TDA') order = 4;
		when ('IRA') order = 5;
		when ('SEC') order = 6;
		when ('MTG') order = 7;
		when ('HEQ') order = 8;
		when ('CRD') order = 9;
		when ('ILN') order = 10;
		when ('IND') order = 11;
		OTHERWISE ORDER=99;
	END;
	run;

	proc sort data=contr1;
	by order proxy;
	run;



	proc sort data=segments;
	by &class1;
	run;

	%if &class1=segment or &class1=band or &class1=IXI_tot or &class1=CBR or &class1=distance or &class1=tenure_yr  or &class1=tran_code %then %do;
	data segments1 ;
	set segments;
	where substr(_type_,1,1) eq '1';
	pct = pctN_1000000 / 100;
	seg1=segment;
	if seg1 eq . then seg1 = 7;
	proxy = put(&class1,&fmt1..);
	band1 = put(band,$band.);
	format seg1 comma1.;
	run;
	%end;
	%else %do;
	data segments1 ;
	set segments;
	where substr(_type_,1,1) eq '1';
	pct = pctN_10000000 / 100;
	seg1=segment;
	proxy = put(&class1,&fmt1..);
	band1 = put(band,$band.);
	if seg1 eq . then seg1 = 7;
	format seg1 comma1.;
	run;
	%end;

	proc sort data=segments1;
	by proxy;
	run;


%* Generate data for boxplots;

	%balance_box(main_source=&main_source,condition=&condition,class1=&class1,fmt1=&fmt1)

	;

	%contrib_box(main_source=&main_source,contrib_source=&contrib_source,condition=&condition,class1=&class1,fmt1=&fmt1)

	;

%* Massage data for boxplots;

	proc means data=box_tran  noprint ;
	class order variable;
	var balance;
	format order order.;
	output out=vals(where=(_type_ eq 3)) q3(balance)=q3 q1(balance)=q1;
	run;

	proc sql noprint;
	select max(q3) into :max1 from vals where order in (1 2 3 4 5);
	select max(q3) into :max2 from vals where order in (6 7 8);
	select max(q3) into :max3 from vals where order in (9 10 11);
	select count(unique(variable)) into :total from box_tran;
	select min(q1) into :min1 from vals where order in (1 2 3 4 5);
	select min(q1) into :min2 from vals where order in (6 7 8);
	select min(q1) into :min3 from vals where order in (9 10 11);
	quit;

	proc means data=cbox_tran  noprint;
	class order variable;
	var contribution;
	format order order.;
	output out=cvals(where=(_type_ eq 3)) q3(contribution)=q3 q1(contribution)=q1 ;
	run;

	proc sql noprint;
	select max(q3) into :cmax1 from cvals where order in (1 2 3 4 5);
	select max(q3) into :cmax2 from cvals where order in (6 7 8);
	select max(q3) into :cmax3 from cvals where order in (9 10 11);
	select count(unique(variable)) into :ctotal from cbox_tran;
	select min(q1) into :cmin1 from cvals where order in (1 2 3 4 5);
	select min(q1) into :cmin2 from cvals where order in (6 7 8);
	select min(q1) into :cmin3 from cvals where order in (9 10 11);
	quit;

 %*Generate the charts;

	ods graphics / reset;
	ods escapechar="^";  
	options nodate nonumber;  
	ods pdf file="&out_dir.\&out_file..pdf" style=mtbnew nogfootnote  dpi=300;
	options orientation=PORTRAIT;

	ods graphics on / height=4in width=7.5in;

	ODS PDF startpage=NO;
	footnote height =8pt justify=left  "MCD - Customer Insights Analysis" j=c 'Page ^{thispage}' j=r "^S={preimage='&logo_file.'}" ;
	Title 'Product Penetration';
	proc sgplot data=penet1 ;
	where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS','INS') and what = 'pctsum' and what2 eq '1';
	vbar prod / missing group=&class1 groupdisplay=cluster response=col2 nostatlabel grouporder=data 
	            datalabel DATALABELATTRS=(family=Arial Size=6);
	xaxis label='Product' LABELATTRS=(family=Arial Weight=Bold)   tickvalueformat=DATA type=discrete 
	      discreteorder=data fitpolicy=stagger valueattrs=(family=Arial );
	yaxis label='Product Penetration' LABELATTRS=(family=Arial Weight=Bold) valueattrs=(family=Arial );
	keylegend / TITLEATTRS=(family=Arial Weight=Bold) valueattrs=(family=Arial ) ;
	format  prod $ptypeorder. &class1 &fmt1.. col2 percent4.;
	run;

	ODS PDF startpage=NO;
	Title 'Average Balance';
	proc sgplot data=penet1 ;
	where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS','INS') and what2 = 'pctsum' and what eq 'amt';
	vbar prod / missing group=&class1 groupdisplay=cluster response=col3 nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Product' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label="Average Balance (000's)" LABELATTRS=(Weight=Bold) ;
	keylegend / TITLEATTRS=(Weight=Bold);
	format  prod $ptypeorder. &class1 &fmt1.. col3 dollar12.;
	run;

	title;
	%let total = &total;
	%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max1,integer),10000)),ceil);
	%let max = %eval(%sysevalf(&max,integer)*12500);
    %let min =%sysevalf(%sysfunc(divide(%sysevalf(&min1,integer),10000)),ceil);
	%let min = %eval(%sysevalf(&min,integer)*12500);

	ODS PDF startpage=YES;
	%vbox_template(templ_name=balances,title=Balance Ranges - Deposit Products)

	proc sgrender data=box_tran(where=(order in (1 2 3 4 5)))  template=balances; 
	format order order.;
	run;

	%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max2,integer),10000)),ceil);
	%let max = %eval(%sysevalf(&max,integer)*12500);
    %let min =%sysevalf(%sysfunc(divide(%sysevalf(&min2,integer),10000)),ceil);
	%let min = %eval(%sysevalf(&min,integer)*12500);

	%vbox_template(templ_name=loans,title=Balance Ranges - Lending Products)


	ODS PDF startpage=NO;

	proc sgrender data=box_tran(where=(order in (6 7 8)))  template=loans; 
	format order order.;
	run;

	%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max3,integer),10000)),ceil);
	%let max = %eval(%sysevalf(&max,integer)*12500);
	%let min =%sysevalf(%sysfunc(divide(%sysevalf(&min3,integer),10000)),ceil);
	%let min = %eval(%sysevalf(&min,integer)*12500);

	%vbox_template(templ_name=other,title=Balance Ranges - Mortgage Home Equity and Securities)

	ODS PDF startpage=YES;

	proc sgrender data=box_tran(where=(order in (9 10 11)))  template=other; 
	format order order.;
	run;


	ODS PDF startpage=NO;
	Title 'Average Contribution';
	proc sgplot data=contr1 ;
	where prod  in ('TOTAL') and what2 = 'pctsum' and what eq 'contr';
	vbar &class1 / missing group=&class1 groupdisplay=cluster response=col1 nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Monthly Contribution' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
	keylegend / TITLEATTRS=(Weight=Bold);
	format  prod $ptypeorder. &class1 &fmt1.. col1 dollar12.1;
	run;


	ODS PDF startpage=YES;
	Title 'Average Contribution by Product';
	proc sgplot data=contr1 ;
	where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS','INS') and what2 = 'pctsum' and what eq 'con';
	vbar prod / missing group=&class1 groupdisplay=cluster response=col1 nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Product' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
	keylegend / TITLEATTRS=(Weight=Bold);
	format  prod $ptypeorder. &class1 &fmt1.. col1 dollar12.1;
	run;

	title;

	%let ctotal = &ctotal;
	%let max =%sysevalf(%sysfunc(divide(%sysevalf(&cmax1,integer),100)),ceil);
	%let max = %eval(%sysevalf(&max,integer)*125);

	%let min =%sysevalf(%sysfunc(divide(%sysevalf(&cmin1,integer),100)),ceil);
	%let min = %eval(%sysevalf(&min,integer)*125);

	ODS PDF startpage=NO;
	%vbox_template(templ_name=contrib1,title=Contribution Ranges - Deposit Products)

	proc sgrender data=cbox_tran(where=(order in (1 2 3 4 5)))  template=contrib1; 
	format order order.;
	run;

	%let max =%sysevalf(%sysfunc(divide(%sysevalf(&cmax2,integer),100)),ceil);
	%let max = %eval(%sysevalf(&max,integer)*125);

	%let min =%sysevalf(%sysfunc(divide(%sysevalf(&cmin2,integer),100)),ceil);
	%let min = %eval(%sysevalf(&min,integer)*125);

	%vbox_template(templ_name=contrib2,title=Contribution Ranges - Loan Products)

	ODS PDF startpage=YES;

	proc sgrender data=cbox_tran(where=(order in ( 6 7 8)))  template=contrib2; 
	format order order.;
	run;

	%let max =%sysevalf(%sysfunc(divide(%sysevalf(&cmax3,integer),100)),ceil);
	%let max = %eval(%sysevalf(&max,integer)*125);

	%let min =%sysevalf(%sysfunc(divide(%sysevalf(&cmin3,integer),100)),ceil);
	%let min = %eval(%sysevalf(&min,integer)*125);

	%vbox_template(templ_name=contrib3,title=Contribution Ranges - Mortgage Home Equity and Securities)

	ODS PDF startpage=NO;

	proc sgrender data=cbox_tran(where=(order in (9 10 11)))  template=contrib3; 
	format order order.;
	run;


	
	
	%if &class1=segment %then %do;
	proc sort data=segments1;
	by  proxy;
	run;

	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 1 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'Customer Segment';
	ODS PDF startpage=YES;
	proc sgplot data=segments1 ;
	where _table_ eq 1 and  hh_sum ne . ;
	vbar segment / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar segment / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='Customer Lifecycle Segment' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;

	proc sort data=segments1;
	by seg1 proxy;
	run;

	Title 'Customer Segment';
	ODS PDF startpage=YES;
	proc sgplot data=segments1 ;
	where _table_ eq 1 and hh_sum eq . ;
	vbar segment / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Customer Lifecycle Segment' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Percent of HHs' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;

	

	%if &class1=tran_code %then %do;
	proc sort data=segments1;
	by  proxy;
	run;

	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 2 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'Transaction Segment';
	ODS PDF startpage=NO;
	proc sgplot data=segments1 ;
	where _table_ eq 2 and  hh_sum ne . ;
	vbar tran_code / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar tran_code / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='Customer Lifecycle Segment' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;
	proc sort data=segments1;
	by tran_code proxy;
	run;

	Title 'Transaction Segment';
	ODS PDF startpage=NO;
	proc sgplot data=segments1 ;
	where _table_ eq 2 and hh_sum eq . ;
	vbar tran_code / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Transaction Segment' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Percent of HHs' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;


	%if &class1=band %then %do;
	proc sort data=segments1;
	by proxy;
	run;

	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 7 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'Profitability';
	ODS PDF startpage=YES;
	proc sgplot data=segments1 ;
	where _table_ eq 7 and  hh_sum ne . ;
	vbar band / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar band / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='Profitability Band' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;
	proc sort data=segments1;
	by band1 proxy;
	run;
	ODS PDF startpage=YES;
	Title 'Profitability';
	proc sgplot data=segments1 ;
	where _table_ eq 7 and hh_sum eq . ;
	vbar band / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Profitability Band' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Percent of HHs' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;

	

	%if &class1=ixi_tot %then %do;
	proc sort data=segments1;
	by proxy;
	run;

	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 3 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'Estimated Investable Assets';
	ODS PDF startpage=NO;
	proc sgplot data=segments1 ;
	where _table_ eq 3 and  hh_sum ne . ;
	vbar ixi_tot / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar ixi_tot / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='Investable Assets (IXI)' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;
	proc sort data=segments1;
	by ixi_tot proxy;
	run;
	ODS PDF startpage=NO;
	Title 'Estimated Investable Assets';
	proc sgplot data=segments1 ;
	where _table_ eq 3 and hh_sum eq . ;
	vbar ixi_tot / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Investable Assets (IXI)' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;

	

	%if &class1=distance %then %do;
	proc sort data=segments1;
	by proxy;
	run;
	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 5 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'Distance to Branch';
	ODS PDF startpage=YES;
	proc sgplot data=segments1 ;
	where _table_ eq 5 and  hh_sum ne . ;
	vbar distance / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar distance / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='Distance to Branch in Miles' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;
	proc sort data=segments1;
	by distance proxy;
	run;
	ODS PDF startpage=YES;
	Title 'Distance to Branch';
	proc sgplot data=segments1 ;
	where _table_ eq 5 and hh_sum eq . ;
	vbar distance / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Distance to Branch in Miles' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Percent of HHs' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;

	

	%if &class1=tenure_yr %then %do;
	proc sort data=segments1;
	by proxy;
	run;

	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 6 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'Tenure';
	ODS PDF startpage=NO;
	proc sgplot data=segments1 ;
	where _table_ eq 6 and  hh_sum ne . ;
	vbar tenure_yr / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar tenure_yr / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='Tenure in Years' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;
	proc sort data=segments1;
	by tenure_yr proxy;
	run;

	ODS PDF startpage=NO;
	Title 'Tenure';
	proc sgplot data=segments1 ;
	where _table_ eq 6 and hh_sum eq . ;
	vbar tenure_yr / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='Tenure in Years' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Percent of HHs' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;


	%if &class1=cbr %then %do;
	proc sort data=segments1;
	by proxy;
	run;

	proc sql noprint;
	select sum(hh_sum) into :count from segments1 where _table_ eq 1;
	quit;

	data segments1;
	set segments1;
	if _table_ eq 4 and hh_sum ne . then pct = hh_sum/&count;
	run;
	
	Title 'CBR';
	ODS PDF startpage=YES;
	proc sgplot data=segments1 ;
	where _table_ eq 4 and  hh_sum ne . ;
	vbar cbr / missing group=&class1 groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
	vbar cbr / missing group=&class1 groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
	xaxis label='CBR' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
	yaxis label='Number of HHs' LABELATTRS=(Weight=Bold) ;
	keylegend "A" /;
	format &class1 &fmt1.. pct percent6. hh_sum comma12.;
	run;
	%end;
	%else %do;
	proc sort data=segments1;
	by cbr proxy;
	run;

	ODS PDF startpage=YES;
	Title 'CBR';
	proc sgplot data=segments1 ;
	where _table_ eq 4 and hh_sum eq . ;
	vbar cbr / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
	           datalabel DATALABELATTRS=(Size=6);
	xaxis label='CBR' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
	      fitpolicy=stagger;
	yaxis label='Percent of HHs' LABELATTRS=(Weight=Bold) ;
	format  &class1 &fmt1.. pct percent6.;
	run;
	%end;

	ODS PDF startpage=NO;
	Title 'Counts for Analysis Groups';
	proc tabulate data=&main_source missing;
	where &condition;
	class  &class1;
	var hh;
	table &class1='Analysis Group' ALL='Total',N='HHs'*f=comma12. pctN='Percent'*f=pctfmt./ nocellmerge ;
	format &class1 &fmt1..;
	run;

	ods pdf close;

%mend create_report;


libname denies '\\denies\CI_SAS_Datasets\';


filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\test_super_macro.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%create_report(class1 = segment, fmt1 = segfmt,out_dir = C:\Documents and Settings\ewnym5s\My Documents\SAS, main_source = data.main_201212,
                contrib_source = data.contrib_201212, condition = cbr eq 16,out_file=test_x,logo_file=C:\Documents and Settings\ewnym5s\My Documents\Tools\logo.png)

%create_report(class1 =tran_code , fmt1 = $transegm,out_dir = C:\Documents and Settings\ewnym5s\My Documents\SAS, main_source = data.main_201212,
                contrib_source = data.contrib_201212, condition = cbr eq 16,out_file=test_report_cbr16_trans)


%create_report(class1 =tenure_yr , fmt1 = tenureband,out_dir = C:\Documents and Settings\ewnym5s\My Documents\SAS, main_source = data.main_201212,
                contrib_source = data.contrib_201212, condition = cbr eq 16,out_file=tenure_report)
