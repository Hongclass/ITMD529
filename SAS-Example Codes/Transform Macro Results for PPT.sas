proc format;
value $ ordera (notsorted) 'Free Only' = 'Free Only'
				'College Only' = 'College Only'
				'Premium Only' = 'Premium Only'
				'Other Only' = 'Other Only'
				'Multi' = 'Multi';
run;


%macro prepare_for_ppt(group=, gfmt=, filename=) / store source des='transford for ppt excel macro';
ods html close;
%do q = 1 %to 13; %*cycle through words;
		%if &q eq 1 %then %do;
			%let wrd = segment; %let fmt = segfmt.;
		%end;
		%if &q eq 2 %then %do;
			%let wrd = cbr; %let fmt = cbr2012fmt.;
		%end;
		%if &q eq 3 %then %do;
			%let wrd = market; %let fmt = mkt2012fmt.;
		%end;
		%if &q eq 4 %then %do;
			%let wrd = band; %let fmt =$2.;
		%end;
		%if &q eq 5 %then %do;
			%let wrd = tenure_yr; %let fmt = tenureband.;
		%end;
		%if &q eq 6 %then %do;
			%let wrd = svcs; %let fmt =comma2.;
		%end;
		%if &q eq 7 %then %do;
			%let wrd = cqi; %let fmt =cqifmt.;
		%end;
		%if &q eq 8 %then %do;
			%let wrd = cqi_dd; %let fmt = binary_flag.;
		%end;
		%if &q eq 9 %then %do;
			%let wrd = cqi_bp; %let fmt = binary_flag.;
		%end;
		%if &q eq 10 %then %do;
			%let wrd = cqi_web; %let fmt = binary_flag.;
		%end;
		%if &q eq 11 %then %do;
			%let wrd = cqi_deb; %let fmt = binary_flag.;
		%end;
		%if &q eq 12 %then %do;
			%let wrd = cqi_odl; %let fmt = binary_flag.;
		%end;
		%if &q eq 13 %then %do;
			%let wrd = rm; %let fmt = $rmfmt.;
		%end;


%if &group = &wrd %then %do;
proc tabulate data=&wrd._results out=&wrd._a(rename=(hh_sum_sum=hh hh_sum_pctsum_1=pct1)) missing order=data ;
%end;
%if &group ne &wrd %then %do;
proc tabulate data=&wrd._results out=&wrd._a(rename=(hh_sum_sum=hh hh_sum_pctsum_10=pct1)) missing order=data ;
%end;
%if &group = &wrd %then %do;
where _type_ eq '1';
%end;
%if &group ne &wrd %then %do;
where _type_ eq '11';
%end;
%if &group = &wrd %then %do;
class &group /preloadfmt ;
%end;
%if &group ne &wrd %then %do;
class &group &wrd /preloadfmt ;
%end;
var hh_sum;
%if &group = &wrd %then %do;
table &group, hh_sum*(sum*f=comma12. rowpctsum<hh_sum>*f=pctfmt.) / nocellmerge;
%end;
%if &group ne &wrd %then %do;
table &group, &wrd*hh_sum*(sum*f=comma12. rowpctsum<hh_sum>*f=pctfmt.) / nocellmerge;
%end;
format &group &gfmt.. &wrd &fmt;
run;
ods html;

data &wrd._a;
set &wrd._a;
/*where _type_ ne '00';*/
/*Name = put(&wrd, &fmt);*/
pct1 = pct1/100;
%if &wrd eq segment %then %do;
if segment eq . then segment = 7;
%end;
%if &wrd eq cbr %then %do;
if cbr eq . then cbr = 99;
%end;
%if &wrd eq market %then %do;
if market eq . then market = 99;
%end;
format pct1 percent10.1;
run;


proc sort data=&wrd._a;
by &group &wrd;
run;

proc summary data=&wrd._a;
by &group &wrd;
output out=&wrd._b
       sum(hh)=hh
	   sum(pct1) = pct1;
run;

proc transpose data=&wrd._b out=&wrd._final;
by &group;
id &wrd;
var pct1;
run;

data &wrd._final;
length name $ 50;
set &wrd._final;
name = put(&group,&gfmt..);
run;

%END;
ods html;

%* clean up cqi detail;


%do q = 1 %to 13; %*cycle through words;
		%if &q eq 1 %then %do;
			%let wrd = segment; %let fmt = segfmt.;
		%end;
		%if &q eq 2 %then %do;
			%let wrd = cbr; %let fmt = cbr2012fmt.;
		%end;
		%if &q eq 3 %then %do;
			%let wrd = market; %let fmt = mkt2012fmt.;
		%end;
		%if &q eq 4 %then %do;
			%let wrd = band; %let fmt =$2.;
		%end;
		%if &q eq 5 %then %do;
			%let wrd = tenure_yr; %let fmt = tenureband.;
		%end;
		%if &q eq 6 %then %do;
			%let wrd = svcs; %let fmt =comma2.;
		%end;
		%if &q eq 7 %then %do;
			%let wrd = cqi; %let fmt =cqifmt.;
		%end;
		%if &q eq 8 %then %do;
			%let wrd = cqi_dd; %let fmt = binary_flag.;
		%end;
		%if &q eq 9 %then %do;
			%let wrd = cqi_bp; %let fmt = binary_flag.;
		%end;
		%if &q eq 10 %then %do;
			%let wrd = cqi_web; %let fmt = binary_flag.;
		%end;
		%if &q eq 11 %then %do;
			%let wrd = cqi_deb; %let fmt = binary_flag.;
		%end;
		%if &q eq 12 %then %do;
			%let wrd = cqi_odl; %let fmt = binary_flag.;
		%end;
		%if &q eq 13 %then %do;
			%let wrd = rm; %let fmt = $rmfmt.;
		%end;
		
		
		proc print data=&wrd._final (drop=_name_ &group) noobs;
		run;

		PROC EXPORT data=&wrd._final (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet="&wrd";
		RUN;
%end;

data bal_a;
length order 3.;
set bal3;
%if &group=segment or &group=market or &group=cbr or %substr(&group,1,3)=cqi or &group=svcs or &group=tenure_yr %then %do;
    where product ne 'hh' and &group ne -1;
%end;
%else %do;
	where product ne 'hh' and &group ne 'All';
%end;
order = put(trim(product), $prod_order.);
Name = put(trim(product),$prod_name.);
bal=bal_prod_hh/1000;
format bal dollar12.;
run;


proc sort data=bal_a;
by &group order;
run;

proc transpose data=bal_a out=bal_final_penet;
where product ne 'trs' and product ne 'ins' and product ne 'sln';
by &group;
id Name;
var penetration;
run;

data bal_final;
length name $ 50;
set bal_final;
name = put(&group,&gfmt..);
run;

proc print data=bal_final_penet(drop=_Name_ &group) noobs;
run;

	PROC EXPORT data=bal_final_penet (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='penetration';
		RUN;

proc transpose data=bal_a out=bal_final_bals;
where product ne 'trs' and product ne 'ins' and product ne 'sln';
by &group;
id Name;
var bal;
run;

data bal_final_bals;
length name $ 50;
set bal_final_bals;
name = put(&group,&gfmt..);
run;

proc print data=bal_final_bals (drop=_Name_ &group) noobs;
run;

PROC EXPORT data=bal_final_bals (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='balances';
		RUN;

proc transpose data=bal_a out=bal_final_cont;
where product ne 'trs' and product ne 'ins' and product ne 'sln';
by &group;
id Name;
var con_tot_hh;
format con_tot_hh dollar10.2;
run;

data bal_final_cont;
length name $ 50;
set bal_final_cont;
name = put(&group,&gfmt..);
run;

proc print data=bal_final_cont (drop=_Name_ &group) noobs;
run;

PROC EXPORT data=bal_final_cont (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='contribution';
		RUN;

proc summary data=bal_a;
by &group;
output out=hh_contrib
       sum(con_tot_hh) = hh_cont;
format con_tot_hh dollar10.2;
run;

data hh_contrib;
length name $ 50;
set hh_contrib;
name = put(&group,&gfmt..);
run;

proc print data=hh_contrib (drop=_type_ _freq_ &group) noobs;
run;

PROC EXPORT data=hh_contrib (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='contr_total';
RUN;

data tran_a;
length order 3.;
set tran3;
%if &group=segment or &group=market or &group=cbr or %substr(&group,1,3)=cqi or &group=svcs or &group=tenure_yr %then %do;
	where &group ne -1;
%end;
%else %do;
	where &group ne 'All';
%end;
format active_pct percent8.1 volume_avg comma12.1;
run;

proc transpose data=tran_a out=tran_active;
by &group;
id transaction;
var active_pct;
run;

data tran_active;
length name $ 50;
set tran_active;
name = put(&group,&gfmt..);
run;

proc print data=tran_active (drop=_name_ &group) noobs;
run;

PROC EXPORT data=tran_active (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='tran_active';
RUN;

proc transpose data=tran_a out=tran_volume;
by &group;
id transaction;
var volume_avg;
run;

data tran_volume;
length name $ 50;
set tran_volume;
name = put(&group,&gfmt..);
run;

proc print data=tran_volume (drop=_name_ &group) noobs;
run;

PROC EXPORT data=tran_volume (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='tran_volume';
RUN;

data clv1;
length name $ 50;
set clv1;
name = put(&group,&gfmt..);
run;

PROC EXPORT data=clv1 (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='clv';
RUN;

data ixi_a;
set ixi4;
%if &group=segment or &group=market or &group=cbr or %substr(&group,1,3)=cqi or &group=svcs or &group=tenure_yr %then %do;
    where IXI_tot ne .  and &group ne -1;
%end;
%else %do;
	where IXI_tot ne .  and &group ne 'All';
%end;
run;

proc sort data=ixi_a;
by &group ixi_tot;
format &group &gfmt.. ixi_tot wealthband.;
run;

proc transpose data=ixi_a out=ixi_final;
by &group;
id ixi_tot;
format ixi_tot wealthband.;
var percent_hhs;
run;

data ixi_final;
length name $ 50;
set ixi_final;
name = put(&group,&gfmt..);
run;

proc print data=ixi_final (drop=&group) noobs;
run;

PROC EXPORT data=ixi_final (drop=&group)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='wealth';
RUN;

data svcs_a;
set svcs_results;
a = svcs*hh_sum;
run;

proc tabulate data=svcs_a missing out=svcs_b;
var a hh_sum;
class &group;
table &group, sum*(a hh_sum)*f=comma12.  ; 
format &group &gfmt..;
run;

data svcs_b;
set svcs_b;
%if &group=segment or &group=market or &group=cbr or %substr(&group,1,3)=cqi or &group=svcs or &group=tenure_yr %then %do;
    where &group ne -1;
%end;
%else %do;
	where &group ne 'All';
%end;
avg_svcs = a_sum/hh_sum_sum;
run;

data svcs_b;
length name $ 50;
set svcs_b;
name = put(&group,&gfmt..);
run;

PROC EXPORT data=svcs_b (drop=&group _type_ _page_ _table_)
            OUTFILE= "C:\Documents and Settings\ewnym5s\My Documents\Data\&filename..xls"
            DBMS=EXCEL REPLACE;
			sheet='avgsvcs';
RUN;


%mend prepare_for_ppt;










*#####################################################################################################################;

data ixi_a;
set ixi4;
where IXI_tot ne . and fworks_flag1 ne 'All';
run;

proc sort data=ixi_a;
by tag_new ixi_tot;
format fworks_flag1 $ordera. ixi_tot wealthband.;
run;

proc transpose data=ixi_a out=ixi_final;
by fworks_flag1;
id ixi_tot;
format ixi_tot wealthband.;
var percent_hhs;
run;

proc print data=ixi_final noobs;
run;


proc format library=sas;
value $ prod_order 'dda' = 1
					'mms' = 2
					'sav' = 3
					'tda' = 4
					'ira' = 5
					'sec' = 6
					'mtg' = 7
					'heq' = 8
					'iln' = 9
					'ccs' = 10
					'ind' = 11
					'sdb'= 12
					other = 99;
value $ prod_name 'dda' = 'Checking'
					'mms' = 'Money Market'
					'sav' = 'Savings'
					'tda' = 'Time Dep.'
					'ira' = 'IRAs'
					'sec' = 'Securities'
					'mtg' = 'Mortgage'
					'heq' = 'Home Eq.'
					'iln' = 'Inst. Ln.'
					'ccs' = 'Credit Card'
					'ind' = 'Ind. Ln.'
					'sdb'= 'Safe Dep.'
					'sln' = 'Stud. Ln.'
					'ins' = 'Imsurance'
					'trs' = 'Trust';
run;

data bal_a;
length order 3.;
set bal3;
where product ne 'hh' and fworks_flag1 ne 'All';
order = put(trim(product), $prod_order.);
Name = put(trim(product),$prod_name.);
bal=bal_prod_hh/1000;
format bal dollar12.;
run;


proc sort data=bal_a;
by fworks_flag1 order;
run;

proc transpose data=bal_a out=bal_final_penet;
where product ne 'trs' and product ne 'ins' and product ne 'sln';
by fworks_flag1;
id Name;
var penetration;
run;

proc print data=bal_final_penet(drop=_Name_) noobs;
run;

proc transpose data=bal_a out=bal_final_bals;
where product ne 'trs' and product ne 'ins' and product ne 'sln';
by fworks_flag1;
id Name;
var bal;
run;

proc print data=bal_final_bals (drop=_Name_) noobs;
run;

proc transpose data=bal_a out=bal_final_cont;
where product ne 'trs' and product ne 'ins' and product ne 'sln';
by fworks_flag1;
id Name;
var con_tot_hh;
format con_tot_hh dollar10.2;
run;

proc print data=bal_final_cont (drop=_Name_) noobs;
run;

proc summary data=bal_a;
by fworks_flag1;
output out=hh_contrib
       sum(con_tot_hh) = hh_cont;
format con_tot_hh dollar10.2;
run;

proc print data=hh_contrib (drop=_type_ _freq_) noobs;
run;


data tran_a;
length order 3.;
set tran3;
where tag_new ne 'All';
format active_pct percent8.1 volume_avg comma12.1;
run;

proc transpose data=tran_a out=tran_active;
by tag_new;
id transaction;
var active_pct;
run;

proc print data=tran_active (drop=_name_) noobs;
run;

proc transpose data=tran_a out=tran_volume;
by tag_new;
id transaction;
var volume_avg;
run;

proc print data=tran_volume (drop=_name_) noobs;
run;



data cqi_web_Final1;
set cqi_web_Final;
rename yes=Web;
drop No _name_;
run;

data cqi_odl_Final1;
set cqi_odl_Final;
rename yes=Overdraft;
drop No _name_;
run;
data cqi_bp_Final1;
set cqi_bp_Final;
rename yes=Bill_Pay;
drop No _name_;
run;
data cqi_deb_Final1;
set cqi_deb_Final;
rename yes=Debit;
drop No _name_;
run;
data cqi_dd_Final1;
set cqi_dd_Final;
rename yes=Direct_Deposit;
drop No _name_;
run;

data cqi_summary;
merge cqi_deb_final1 cqi_web_final1 cqi_bp_final1 cqi_odl_final1 cqi_dd_final1;
by tag_new;
run;

proc print data=cqi_summary noobs;
run;


proc format;
value $ ordera (notsorted) 'Free Only' = 'Free Only'
				'College Only' = 'College Only'
				'Premium Only' = 'Premium Only'
				'Other Only' = 'Other Only'
				'Multi' = 'Multi';
run;



filename mprint "C:\Documents and Settings\ewnym5s\My Documents\Data\transform.sas" ;
data _null_ ; file mprint ; run ;
options  mprint mfile nomlogic ;

%prepare_for_ppt(group=segment,gfmt=segfmt.,filename=test1)
