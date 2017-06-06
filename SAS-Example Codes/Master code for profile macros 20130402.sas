options mcompilenote=all;

%macro create_report(class1,fmt1,condition,main_source,contrib_source,out_file,out_dir,logo_file=) / store;

%* define the MTB colors, not strictly required each time, but for portability;
proc template;
     define style mtbnew;
     parent=styles.printer;
	 style graphdatadefault  / color=cx007856 contrastcolor=black;
     style graphdata1 from graphdata1 / color=cx007856 contrastcolor=black;
     style graphdata2 from graphdata2 / color=cxC3E76F contrastcolor=black;
	 style graphdata3 from graphdata3 / color=cxFFB300 contrastcolor=black;
	 style graphdata4 from graphdata4 / color=cx86499D contrastcolor=black;
	 style graphdata5 from graphdata5 / color=cx003359 contrastcolor=black;
	 style graphdata6 from graphdata6 / color=cxAFAAA3 contrastcolor=black;
	 style graphdata7 from graphdata7 / color=cx7AB800 contrastcolor=black;
	 style graphdata8 from graphdata8 / color=cx23A491 contrastcolor=black;
	 style graphdata9 from graphdata9 / color=cx144629 contrastcolor=black;
	  style graphdata10 from graphdata10 / color=cxFFFFFF contrastcolor=black;

	 style fonts /
      'TitleFont2' = ('Arial, Helvetica, Helv',12pt,bold italic)
      'TitleFont' = ('Arial, Helvetica, Helv',13pt,bold italic)
      'StrongFont' = ('Arial, Helvetica, Helv',10pt,bold)
      'EmphasisFont' = ('Arial, Helvetica, Helv',10pt,italic)
      'FixedEmphasisFont' = ('Arial, Helvetica, Helv',9pt,italic)
      'FixedStrongFont' = ('Arial, Helvetica, Helv',9pt,bold)
      'FixedHeadingFont' = ('Arial, Helvetica, Helv',9pt,bold)
      'BatchFixedFont' = ("SAS Monospace, <MTmonospace>, Courier",6.7pt)
      'FixedFont' = ('Arial, Helvetica, Helv',9pt)
      'headingEmphasisFont' = ('Arial, Helvetica, Helv',11pt,bold italic)
      'headingFont' = ('Arial, Helvetica, Helv',11pt,bold)
      'docFont' = ('Arial, Helvetica, Helv',10pt);
   style GraphFonts /
      'GraphDataFont' = ('Arial, Helvetica, Helv',7pt)
      'GraphUnicodeFont' = ('Arial, Helvetica, Helv',9pt)
      'GraphValueFont' = ('Arial, Helvetica, Helv',9pt)
      'GraphLabel2Font' = ('Arial, Helvetica, Helv',10pt)
      'GraphLabelFont' = ('Arial, Helvetica, Helv',10pt)
      'GraphFootnoteFont' = ('Arial, Helvetica, Helv',10pt)
      'GraphTitleFont' = ('Arial, Helvetica, Helv',11pt,bold)
      'GraphTitle1Font' = ('Arial, Helvetica, Helv',14pt,bold)
      'GraphAnnoFont' = ('Arial, Helvetica, Helv',10pt);


	 style header  from header / background=cx007856 foreground=white;
	 style ProcTitle from proctitle / foreground=cx007856 ;
	 style SystemTitle from systemtitle / foreground=cx007856 ;
     
	end;
   run;

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


%macro penetration(class1=,class2=,class3=,fmt1=,fmt2=,fmt3=,where=,main_source=,out=) / store source des='product poenetration and balances tables';

	%* Build the class String, checking for Nulls;
	%let class_str = All;
	%if &class3 ne %then %let class_str = (&class3 All)  &class_str;
	%if &class2 ne %then %do;
		%if &class3 ne %then %do;
			%let class_str = (&class2 All) * &class_str;
		%end;
		%else %do;
			%let class_str = (&class2 All)  &class_str;
		%end;
	%end;


	%if &class1 ne %then %do;
		%if &class3 ne or &class2 ne %then %do;
			%let class_str = (&class1 All) * &class_str;
		%end;
		%else %do;
			%let class_str = (&class1 All)  &class_str;
		%end;
	%end;

	proc tabulate data=&main_source order=data 
		%if &out ne %then out=&out;
		%* DID THEY ASK FOR OUT?;
	missing;
	%if &where ne %then %do;
		%* DID THEY PROVIDE A WHERE clause;
		where &where;
	%end;
		
	var dda: mms: tda: sav: mtg: heq: iln: ccs: ira: trs: sec: card ccs_amt ins ind: sln: hh sdb: ;
	CLASS &class1 &class2 &class3 / PRELOADFMT;
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (dda='Checking' mms='Mon Mkt' sav='Savings' tda='Time Dep' ira='IRA' mtg='Mortgage' 
	                heq='Home Eq' card='Credit Card' iln='Dir Loan' ind='Ind Loan' sln='Student loan' sec='Securities' ins='Insurance' trs='Trust' 
					sdb='Safe Deposit' )*sum='Product HHs'*f=comma12. / nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (dda='Checking' mms='Mon Mkt' sav='Savings' tda='Time Dep' ira='IRA' mtg='Mortgage' 
	                heq='Home Eq' card='Credit Card' iln='Dir Loan' ind='Ind Loan' sln='Student loan' sec='Securities' ins='Insurance' trs='Trust' 
					sdb='Safe Deposit' )*pctsum<hh>='Penet'*f=pctfmt. / nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
				   (dda_amt='Checking'*pctsum<dda>='Avg. Bal.' mms_amt='Mon Mkt'*pctsum<mms>='Avg. Bal.' sav_amt='Savings'*pctsum<sav>='Avg. Bal.' 
	                tda_amt='Time Dep'*pctsum<tda>='Avg. Bal.' ira_amt='IRA'*pctsum<ira>='Avg. Bal.' mtg_amt='Mortgage'*pctsum<mtg>='Avg. Bal.' 
	                heq_amt='Home Eq'*pctsum<heq>='Avg. Bal.' ccs_amt='Credit Card'*pctsum<card>='Avg. Bal.' iln_amt='Dir Loan'*pctsum<iln>='Avg. Bal.' 
					ind_amt='Ind Loan'*pctsum<ind>='Avg. Bal.' sln_amt='Student loan'*pctsum<sln>='Avg. Bal.' 
	                sec_amt='Securities'*pctsum<sec>='Avg. Bal.' trs_amt='Trust'*pctsum<trs>='Avg. Bal.' )*f=pctdoll. / nocellmerge misstext ='0.0'; 
	%if &fmt1 ne and &class1 ne %then  %do;
		format &class1 &fmt1.. ;
	%end;
	%if &fmt2 ne and &class2 ne %then  %do;
		format &class2 &fmt2.. ;
	%end;
	%if &fmt3 ne and &class3 ne %then %do;
		 format &class3 &fmt3.. ;
	%end;
	
	run;
%mend penetration;


%macro contribution(class1=,class2=,class3=,fmt1=,fmt2=,fmt3=,where=,main_source=,contrib_source=,out=) / store source des='contribution tables';

data temp_main;
set &main_source;
%if &where ne %then %do;
where &where;
%end;
keep hhid &class1 &class2 &class3 hh;
run;


data temp_contr;
merge &contrib_source (in=a) temp_main (in=b);
by hhid;
if b;
total_contr=sum(dda_con,mms_con,sav_con,tda_con,ira_con,mtg_con,heq_con,card_con,iln_con,ind_con,sec_con,trs_con,sln_con);
run;


	%* Build the class String, checking for Nulls;
	%let class_str = All;
	%if &class3 ne %then %let class_str = (&class3 All)  &class_str;
	%if &class2 ne %then %do;
		%if &class3 ne %then %do;
			%let class_str = (&class2 All) * &class_str;
		%end;
		%else %do;
			%let class_str = (&class2 All)  &class_str;
		%end;
	%end;


	%if &class1 ne %then %do;
		%if &class3 ne or &class2 ne %then %do;
			%let class_str = (&class1 All) * &class_str;
		%end;
		%else %do;
			%let class_str = (&class1 All)  &class_str;
		%end;
	%end;

	proc tabulate data=temp_contr order=data 
		%if &out ne %then out=&out;
		%* DID THEY ASK FOR OUT?;
	missing;

		
	var dda: mms: tda: sav: mtg: heq: iln:  ira: trs: sec: card_con  ind: sln: hh total_contr;
	CLASS &class1 &class2 &class3 / PRELOADFMT;
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
				   (dda_con='Checking'*pctsum<hh>='Avg. Con.' mms_con='Mon Mkt'*pctsum<hh>='Avg. Con.' sav_con='Savings'*pctsum<hh>='Avg. Con.' 
	                tda_con='Time Dep'*pctsum<hh>='Avg. Con.' ira_con='IRA'*pctsum<hh>='Avg. Con.' mtg_con='Mortgage'*pctsum<hh>='Avg. Con.' 
	                heq_con='Home Eq'*pctsum<hh>='Avg. Con.' card_con='Credit Card'*pctsum<hh>='Avg. Con.' iln_con='Dir Loan'*pctsum<hh>='Avg. Con.' 
					ind_con='Ind Loan'*pctsum<hh>='Avg. Con.' sln_con='Student loan'*pctsum<hh>='Avg. Con.' 
	                sec_con='Securities'*pctsum<hh>='Avg. Con.' trs_con='Trust'*pctsum<hh>='Avg. Con.'
                    total_contr='Total'*pctsum<hh>='Avg. Con.')*f=pctdoll. / nocellmerge misstext ='0.0'; 
	%if &fmt1 ne and &class1 ne %then  %do;
		format &class1 &fmt1.. ;
	%end;
	%if &fmt2 ne and &class2 ne %then  %do;
		format &class2 &fmt2.. ;
	%end;
	%if &fmt3 ne and &class3 ne %then %do;
		 format &class3 &fmt3.. ;
	%end;
	
	run;
%mend contribution;


%macro segments(class1=,class2=,class3=,fmt1=,fmt2=,fmt3=,where=,main_source=,out=)/ store source des='assorted descriptrive tables';

	%* Build the class String, checking for Nulls;
	%let class_str = All;
	%if &class3 ne %then %let class_str = (&class3 All)  &class_str;
	%if &class2 ne %then %do;
		%if &class3 ne %then %do;
			%let class_str = (&class2 All) * &class_str;
		%end;
		%else %do;
			%let class_str = (&class2 All)  &class_str;
		%end;
	%end;


	%if &class1 ne %then %do;
		%if &class3 ne or &class2 ne %then %do;
			%let class_str = (&class1 All) * &class_str;
		%end;
		%else %do;
			%let class_str = (&class1 All)  &class_str;
		%end;
	%end;

	proc tabulate data=&main_source order=data 
		%if &out ne %then out=&out;
		%* DID THEY ASK FOR OUT?;
	missing;
	%if &where ne %then %do;
		%* DID THEY PROVIDE A WHERE clause;
		where &where;
	%end;
		
	var hh;
	CLASS &class1 &class2 &class3 segment band ixi_tot cbr distance tenure_yr tran_code/ PRELOADFMT;
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (segment)*N='HHs'*f=comma12.  segment*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (tran_code='Tran. Segment')*N='HHs'*f=comma12.  tran_code='Tran. Segment'*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (ixi_tot='Estimated Wealth')*N='HHs'*f=comma12.  ixi_tot='Estimated Wealth'*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (cbr)*N='HHs'*f=comma12.  cbr*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (distance='Dist to Branch')*N='HHs'*f=comma12.  distance='Dist to Branch'*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (tenure_yr="tenure (Yrs)")*N='HHs'*f=comma12.  tenure_yr="tenure (Yrs)"*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';
	table &class_str, sum='All'*hh='HHs'*f=comma12. 
	               (band='Profit Band')*N='HHs'*f=comma12.  band='Profit Band'*rowPCTN="Percent"*f=pctfmt./ nocellmerge misstext ='0';

	%if &fmt1 ne and &class1 ne %then  %do;
		format &class1 &fmt1.. ;
	%end;
	%if &fmt2 ne and &class2 ne %then  %do;
		format &class2 &fmt2.. ;
	%end;
	%if &fmt3 ne and &class3 ne %then %do;
		 format &class3 &fmt3.. ;
	%end;
	format segment segfmt. cbr cbr2012fmt. tenure_yr tenureband. ixi_tot ixifmt. distance distfmt. tran_code $transegm. band $band.;
	keylabel rowpctN=' ';
	run;
%mend segments;


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

%macro vbox_template (templ_name=template1,title=)/ store;
	proc template;
	define statgraph &templ_name;
	begingraph;
	entrytitle "&title";
	layout overlay / yaxisopts=(linearopts=( viewmax =&max viewmin=&min tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
	xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
	%do i = 1 %to &total ;
	
		%let a =  %sysfunc(ceil(&total/2));
		%let a1 = %eval(-1*&a);
		%let a2 = %eval(&a1+&i);
		%let a3 = %sysevalf(&a2*0.1);
		boxplot x=order y=amt&i  / discreteoffset=&a3 boxwidth=.1 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
		display=(CAPS FILL MEAN MEDIAN) name="&i" legendlabel="&&name&i";
	%end;
	referenceline y=0 / lineattrs=(pattern=dot);
	discretelegend 
	%do i = 1 %to &total;
		"&i"  
	%end;
     / location=outside valign=bottom halign=center across=3 DISPLAYCLIPPED=Yes;
	endlayout;
	endgraph;
	end; run;
%mend vbox_template;
