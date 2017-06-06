%let class1 = test_group;
%let fmt1 = segfmt;
%let name1 = Segment;
%let directory = SAS;
%let main_source = data.main_201212;
%let contrib_source = data.contrib_201212;
%let demog_source = data.demog_201212;
%let condition = sec eq 1;
%let file=test_report_z;



%penetration(main_source=&main_source, where=&condition, fmt1=&fmt1, class1=&class1,out=penet)

%contribution(main_source=&main_source, contrib_source=&contrib_source, where=&condition, fmt1=&fmt1, class1=&class1,out=contr)

%segments(main_source=&main_source, where=&condition, fmt1=&fmt1, class1=&class1,out=segments)



%put _user_;
/*
proc format library=sas;
value $ ptypeorder (notsorted)
	'DDA' = 'Checking'
	'MMS' = 'Money Market'
	'SAV' = 'Savings'
	'TDA' = 'Time Deposit'
	'IRA' = 'IRAs'
	'MTG' = 'Mortgage'
	'HEQ' = 'Home Equity'
	'CRD' = 'Credit Card'
	'ILN' = 'Dir. Loan'
	'IND' = 'Ind. Loan'
	'SEC' = 'Securities';
run;
*/


*try charts;
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
by order &class1;
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
by order &class1;
run;



proc sort data=segments;
by &class1;
run;

data segments1 ;
set segments (rename=(pctn_10000000=pct));
pct = pct / 100;
seg1=segment;
if seg1 eq . then seg1 = 7;
format seg1 comma1.;
run;


%balance_box(main_source=&main_source,condition=&condition,class1=&class1,fmt1=&fmt1)

;

%contrib_box(main_source=&main_source,contrib_source=&contrib_source,condition=&condition,class1=&class1,fmt1=&fmt1)

;


proc means data=box2  noprint ;
class order &class1;
var balance;
format order order.;
output out=vals(where=(_type_ eq 3)) q3(balance)=q3;
run;

proc sql;
select max(q3) into :max1 from vals where order in (1 2 3 4 5);
select max(q3) into :max2 from vals where order in (6 7 8);
select max(q3) into :max3 from vals where order in (9 10 11);
select count(unique(&class1)) into :total from box2;
quit;

proc means data=cbox2  noprint;
class order &class1;
var contribution;
format order order.;
output out=cvals(where=(_type_ eq 3)) q3(contribution)=q3 q1(contribution)=q1 ;
run;

proc sql;
select max(q3) into :cmax1 from cvals where order in (1 2 3 4 5);
select max(q3) into :cmax2 from cvals where order in (6 7 8);
select max(q3) into :cmax3 from cvals where order in (9 10 11);
select count(unique(&class1)) into :ctotal from cbox2;
select min(q1) into :cmin1 from cvals where order in (1 2 3 4 5);
select min(q1) into :cmin2 from cvals where order in (6 7 8);
select min(q1) into :cmin3 from cvals where order in (9 10 11);
quit;

ods graphics / reset;
ods escapechar="^";  
options nodate nonumber;  
ods pdf file="My Documents\&directory.\&file..pdf" style=mtbnew nogfootnote  dpi=300;
options orientation=PORTRAIT;

ods graphics on / height=4in width=7.5in;

/*goptions hsize=7.5 vsize=5;*/
ODS PDF startpage=NO;
footnote height =8pt justify=left  "MCD - Customer Insights Analysis" j=c 'Page ^{thispage}' j=r "^S={preimage='C:\Documents and Settings\ewnym5s\My Documents\Tools\logo.png'}" ;
Title 'Product Penetration';
proc sgplot data=penet1 ;
where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS') and what = 'pctsum' and what2 eq '1';
vbar prod / missing group=&class1 groupdisplay=cluster response=col2 nostatlabel grouporder=data 
            datalabel DATALABELATTRS=(family=Arial Size=6);
xaxis label='Product' LABELATTRS=(family=Arial Weight=Bold)   tickvalueformat=DATA type=discrete 
      discreteorder=data fitpolicy=stagger valueattrs=(family=Arial );
yaxis label='Product Penetration' LABELATTRS=(family=Arial Weight=Bold) valueattrs=(family=Arial );
keylegend /title="&name1" TITLEATTRS=(family=Arial Weight=Bold) valueattrs=(family=Arial ) ;
format  prod $ptypeorder. &class1 &fmt1.. col2 percent4.;
run;

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=NO;
Title 'Average Balance';
proc sgplot data=penet1 ;
where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS') and what2 = 'pctsum' and what eq 'amt';
vbar prod / missing group=&class1 groupdisplay=cluster response=col3 nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Product' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label="Average Balance (000's)" LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  prod $ptypeorder. &class1 &fmt1.. col3 dollar12.;
run;

%let total = &total;
%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max1,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);


/*goptions hsize=7.5 vsize=4;*/
ODS PDF startpage=YES;
%vbox_template(name=balances,title=)
Title 'Balance Ranges - Deposit Products';
proc sgrender data=box2(where=(order in (1 2 3 4 5)))  template=balances; 
format order order.;
run;

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max2,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);

%vbox_template(name=loans,title=)


/*goptions hsize=7.5 vsize=4;*/
ODS PDF startpage=NO;
Title 'Balance Ranges - Lending Products';
proc sgrender data=box2(where=(order in (6 7 8)))  template=loans; 
format order order.;
run;

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max3,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);


%vbox_template(name=other,title=)

/*goptions hsize=7.5 vsize=5;*/
ODS PDF startpage=YES;
Title 'Balance Ranges - Mortgage, Home Equity and Securities';
proc sgrender data=box2(where=(order in (9 10 11)))  template=other; 
format order order.;
run;


/*goptions hsize=7.5 vsize=5;*/
ODS PDF startpage=NO;
Title 'Average Contribution';
proc sgplot data=contr1 ;
where prod  in ('TOTAL') and what2 = 'pctsum' and what eq 'contr';
vbar &class1 / missing group=&class1 groupdisplay=cluster response=col1 nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Monthly Contribution' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  prod $ptypeorder. &class1 &fmt1.. col1 dollar12.1;
run;


/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=YES;
Title 'Average Contribution by Product';
proc sgplot data=contr1 ;
where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS') and what2 = 'pctsum' and what eq 'con';
vbar prod / missing group=&class1 groupdisplay=cluster response=col1 nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Product' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  prod $ptypeorder. &class1 &fmt1.. col1 dollar12.1;
run;


%let ctotal = &ctotal;
%let max =%sysevalf(%sysfunc(divide(%sysevalf(&cmax1,integer),100)),ceil);
%let max = %eval(%sysevalf(&max,integer)*125);

%let min =%sysevalf(%sysfunc(divide(%sysevalf(&cmin1,integer),100)),ceil);
%let min = %eval(%sysevalf(&min,integer)*125);

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=NO;

%vbox_template(name=contrib1,title=)
Title 'Contribution Ranges - Deposit Products';
proc sgrender data=cbox2(where=(order in (1 2 3 4 5)))  template=contrib1; 
format order order.;
run;

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&cmax2,integer),100)),ceil);
%let max = %eval(%sysevalf(&max,integer)*125);

%let min =%sysevalf(%sysfunc(divide(%sysevalf(&cmin2,integer),100)),ceil);
%let min = %eval(%sysevalf(&min,integer)*125);

%vbox_template(name=contrib2,title=)
/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=YES;
Title 'Contribution Ranges - Loan Products';
proc sgrender data=cbox2(where=(order in ( 6 7 8)))  template=contrib2; 
format order order.;
run;

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&cmax3,integer),100)),ceil);
%let max = %eval(%sysevalf(&max,integer)*125);

%let min =%sysevalf(%sysfunc(divide(%sysevalf(&cmin3,integer),100)),ceil);
%let min = %eval(%sysevalf(&min,integer)*125);

%vbox_template(name=contrib3,title=)

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=NO;
Title 'Contribution Ranges - Mortgage, Home Equity and Securities';
proc sgrender data=cbox2(where=(order in (9 10 11)))  template=contrib3; 
format order order.;
run;


proc sort data=segments1;
by seg1;
run;

/*goptions hsize=7 vsize=5;*/
Title 'Customer Segment';
ODS PDF startpage=YES;
proc sgplot data=segments1 ;
where _table_ eq 1 and hh_sum eq . ;
vbar segment / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Customer Lifecycle Segment' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;

proc sort data=segments1;
by tran_code;
run;

/*goptions hsize=7 vsize=5;*/
Title 'Transaction Segment';
ODS PDF startpage=NO;
proc sgplot data=segments1 ;
where _table_ eq 2 and hh_sum eq . ;
vbar tran_code / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Transaction Segment' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;

proc sort data=segments1;
by band;
run;

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=YES;
Title 'Profitability';
proc sgplot data=segments1 ;
where _table_ eq 7 and hh_sum eq . ;
vbar band / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Profitability Band' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;

proc sort data=segments1;
by ixi_tot;
run;

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=NO;
Title 'Estimated Investable Assets';
proc sgplot data=segments1 ;
where _table_ eq 3 and hh_sum eq . ;
vbar ixi_tot / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Investable Assets (IXI)' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;

proc sort data=segments1;
by distance;
run;

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=YES;
Title 'Distance to Branch';
proc sgplot data=segments1 ;
where _table_ eq 5 and hh_sum eq . ;
vbar distance / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Distance to Branch in Miles' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;

proc sort data=segments1;
by tenure_yr;
run;

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=NO;
Title 'Tenure';
proc sgplot data=segments1 ;
where _table_ eq 6 and hh_sum eq . ;
vbar tenure_yr / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='Tenure in Years' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;

proc sort data=segments1;
by cbr;
run;

/*goptions hsize=7 vsize=5;*/
ODS PDF startpage=YES;
Title 'CBR';
proc sgplot data=segments1 ;
where _table_ eq 4 and hh_sum eq . ;
vbar cbr / missing group=&class1 groupdisplay=cluster response=pct nostatlabel grouporder=data 
           datalabel DATALABELATTRS=(Size=6);
xaxis label='CBR' LABELATTRS=(Weight=Bold)   tickvalueformat=DATA type=discrete discreteorder=data 
      fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend /title="&name1" TITLEATTRS=(Weight=Bold);
format  &class1 &fmt1.. pct percent6.;
run;


ods pdf close;













*try the boxplots;

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

/*proc sort data=box;*/
/*by  &class1;*/
/*run;*/

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



/*data box1;*/
/*set box1;*/
/*if balance eq . then delete;*/
/*run;*/


proc sort data=box1;
by  hhid;
run;

/*proc transpose data=box1 out=box2 prefix=amt;*/
/*id &class1;*/
/*var balance;*/
/*by hhid;*/
/*copy &class1;*/
/*run;*/

data box2;
set box1;
select (&class1);
	when (1) amt1 = balance;
	when (2) amt2 = balance;
	when (3) amt3 = balance;
	when (4) amt4 = balance;
	when (5) amt5 = balance;
	when (6) amt6 = balance;
	when (7) amt7 = balance;
	when (8) amt8 = balance;
	when (9) amt9 = balance;
end;
run;


proc sort data=box1(keep=hhid order) out=class nodupkey;
by hhid;
run;

data box2;
merge box2 (in=a) class (in=b);
by hhid;
if a;
run;



proc sort data=box2;
by order;
run;


ods html style = mtbhtml;


proc means data=box2 noprint ;
class order;
var balance;
format order order.;
output out=vals(where=(_type_ eq 1)) q3(balance)=q3;
run;

proc sql;
select max(q3) into :max1 from vals where order in (1 2 3 4 5);
select max(q3) into :max2 from vals where order in (6 7 8);
select max(q3) into :max3 from vals where order in (9 10 11);
select count(unique(&class1)) into :total from box2;
quit;

%let total = &total;


%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max1,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);
%put &max;

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max2,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max2,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);

proc template;
define statgraph balances;
begingraph;
entrytitle 'Distribution of Deposit Balances';
layout overlay / yaxisopts=(linearopts=( viewmax =&max tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
boxplot x=order y=amt1  / discreteoffset=-0.4 boxwidth=.1 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
display=(CAPS FILL MEAN MEDIAN) name='a' legendlabel="Group1";
boxplot x=order y=amt2 / discreteoffset= -0.3 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='b' legendlabel="Group 2";
boxplot x=order y=amt3 / discreteoffset= -0.2 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='c' legendlabel="Group 3";
boxplot x=order y=amt4 / discreteoffset= -0.1 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='d' legendlabel="Group 4";
boxplot x=order y=amt5 / discreteoffset= 0.0 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='e' legendlabel="Group 5";
boxplot x=order y=amt6 / discreteoffset= +0.1 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='f' legendlabel="Group 6";
boxplot x=order y=amt7 / discreteoffset= +0.2 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='g' legendlabel="Group 7";
boxplot x=order y=amt8 / discreteoffset= +0.3 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='h' legendlabel="Group 8";
boxplot x=order y=amt9 / discreteoffset= +0.4 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='i' legendlabel="Group 9";
referenceline y=1 / lineattrs=(pattern=dot);
discretelegend 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' / location=outside valign=bottom halign=center across=3;
endlayout;
/*entryfootnote halign=left "For ALAT, ASAT and ALKPH, the Clinical ...;";*/
/*entryfootnote halign=left "For BILTOT, the CCL is 1.5 ULN: where ULN ...";*/
endgraph;
end; run;




proc template;
define statgraph loans;
begingraph;
entrytitle 'Distribution of Consumer Loan Balances';
layout overlay / yaxisopts=(linearopts=(viewmax =&max tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
boxplot x=order y=amt1  / discreteoffset=-0.4 boxwidth=.1 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
display=(CAPS FILL MEAN MEDIAN) name='a' legendlabel="Group1";
boxplot x=order y=amt2 / discreteoffset= -0.3 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='b' legendlabel="Group 2";
boxplot x=order y=amt3 / discreteoffset= -0.2 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='c' legendlabel="Group 3";
boxplot x=order y=amt4 / discreteoffset= -0.1 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='d' legendlabel="Group 4";
boxplot x=order y=amt5 / discreteoffset= 0.0 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='e' legendlabel="Group 5";
boxplot x=order y=amt6 / discreteoffset= +0.1 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='f' legendlabel="Group 6";
boxplot x=order y=amt7 / discreteoffset= +0.2 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='g' legendlabel="Group 7";
boxplot x=order y=amt8 / discreteoffset= +0.3 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='h' legendlabel="Group 8";
boxplot x=order y=amt9 / discreteoffset= +0.4 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='i' legendlabel="Group 9";
referenceline y=1 / lineattrs=(pattern=dot);
discretelegend 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' / location=outside valign=bottom halign=center across=3;
endlayout;
/*entryfootnote halign=left "For ALAT, ASAT and ALKPH, the Clinical ...;";*/
/*entryfootnote halign=left "For BILTOT, the CCL is 1.5 ULN: where ULN ...";*/
endgraph;
end; run;

%let max =%sysevalf(%sysfunc(divide(%sysevalf(&max3,integer),10000)),ceil);
%let max = %eval(%sysevalf(&max,integer)*12500);


proc template;
define statgraph large;
begingraph;
entrytitle 'Distribution of Secured Lending and Securities Balances';
layout overlay / yaxisopts=(linearopts=(viewmax =&max tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
boxplot x=order y=amt1  / discreteoffset=-0.4 boxwidth=.1 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
display=(CAPS FILL MEAN MEDIAN) name='a' legendlabel="Group1";
boxplot x=order y=amt2 / discreteoffset= -0.3 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='b' legendlabel="Group 2";
boxplot x=order y=amt3 / discreteoffset= -0.2 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='c' legendlabel="Group 3";
boxplot x=order y=amt4 / discreteoffset= -0.1 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='d' legendlabel="Group 4";
boxplot x=order y=amt5 / discreteoffset= 0.0 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='e' legendlabel="Group 5";
boxplot x=order y=amt6 / discreteoffset= +0.1 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='f' legendlabel="Group 6";
boxplot x=order y=amt7 / discreteoffset= +0.2 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='g' legendlabel="Group 7";
boxplot x=order y=amt8 / discreteoffset= +0.3 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='h' legendlabel="Group 8";
boxplot x=order y=amt9 / discreteoffset= +0.4 boxwidth=.1 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
display=(CAPS FILL MEAN MEDIAN) name='i' legendlabel="Group 9";
referenceline y=1 / lineattrs=(pattern=dot);
discretelegend 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' / location=outside valign=bottom halign=center across=3;
endlayout;
/*entryfootnote halign=left "For ALAT, ASAT and ALKPH, the Clinical ...;";*/
/*entryfootnote halign=left "For BILTOT, the CCL is 1.5 ULN: where ULN ...";*/
endgraph;
end; run;


proc sgrender data=box2(where=(order in (1 2 3 4 5)))  template=balances; 
format order order.;
run;

proc sgrender data=box2(where=(order in (6 7 8)))  template=loans; 
format order order.;
run;

proc sgrender data=box2(where=(order in (9 10 11)))  template=large; 
format order order.;
run;

options mcompilenote=all;



%macro vbox_template (name=template1,title=);
	proc template;
	define statgraph &name;
	begingraph;
	entrytitle "&title";
	layout overlay / yaxisopts=(linearopts=( viewmax =&max viewmin=&min tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
	xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
	%do i = 1 %to &total ;
		%let labelx = %sysfunc(putn(&i,&fmt1..));
		%let a =  %sysfunc(ceil(&total/2));
		%let a1 = %eval(-1*&a);
		%let a2 = %eval(&a1+&i);
		%let a3 = %sysevalf(&a2*0.1);
		boxplot x=order y=amt&i  / discreteoffset=&a3 boxwidth=.1 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
		display=(CAPS FILL MEAN MEDIAN) name="&i" legendlabel="&labelx";
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

filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\template_code.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%vbox_template(name=test1,title=)
;
proc sgrender data=box2(where=(order in (9 10 11)))  template=test1; 
format order order.;
run;

%put &max;
