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


%macro demographics (class1=,class2=,class3=,fmt1=,fmt2=,fmt3=,where=,main_source=,demog_source=,out=)/ store source des='demographics';

data temp_hh;
set &main_source;
where &where;
keep hhid hh &class1 &class2 &class3;
run;

data temp_demog;
merge &demog_source (in=a) temp_hh (in=b);
by hhid;
if a and b;
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



proc tabulate data=temp_demog missing;
class &class1 &class2 &class3 ;
class dwelling education income ethnic_rollup home_owner marital poc: gender age_hoh religion languag length_resid ;
var hh;
table  (dwelling='Type of Residence' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (education='Education Level' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (income='Estimated Income' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (ethnic_rollup='Ethnicity' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (home_owner='Home Ownership' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (marital='Marital Status' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (poc="Children" all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0'; 
table  (gender='Gender' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (age_hoh="HOH Age" all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (religion all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (languag='Language' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
table  (length_resid='Length of Residence' all),(N="HHs"*f=comma12. colpctN="Percent"*f=pctfmt.)*&class_str / nocellmerge misstext='0';
format dwelling $dwelling. education $educfmt. income $incmfmt.  home_owner $homeowner.  marital $marital.  
       religion $religion. languag $language. length_resid $residence.   age_hoh ageband. ethnic_rollup $ethnic.;
%if &fmt1 ne and &class1 ne %then  %do;
		format &class1 &fmt1.. ;
	%end;
	%if &fmt2 ne and &class2 ne %then  %do;
		format &class2 &fmt2.. ;
	%end;
	%if &fmt3 ne and &class3 ne %then %do;
		 format &class3 &fmt3.. ;
	%end;
keylabel rowpctN=' ';
run;

%mend demographics;




filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\test.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;
%demographics (class1=,class2=,class3=,fmt1=segfmt,fmt2=,fmt3=,where=dda eq 1,period=201206,out=)
/*%segments(class1=segment,class2=,fmt1=segfmt,fmt2=segfmt,period=201209,where=sdb eq 1,out=test)*/
