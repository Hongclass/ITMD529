
option mprint nosymbolgen nomlogic mcompilenote=all minoperator;
options mstored sasmstore=sas;
*Parameters;


* this macro wil parse through the variable string and assign each ot a variable, it will create global variables for that and also pass me the count of variables;

%macro split_variables(string1) / store source des='Splits variables';
	%let i = 1;
	%let current = xxx;
	%do %until (&current eq); 
	  %let current = %scan(&string1,&i);
	  %if &current ne %then %do;
	     %global word&i;
	     %let word&i= &current;
		 %let i = %eval(&i+1);
	  %end;
	  %else %do;
	  	 %global class_num;
	     %let class_num = %eval(&i-1);
	  %end;
	%end;
%mend split_variables;

%let variables = one two three four five six seven eight;

%split_variables(&variables)

%put _user_;

* Now I need to write the analysis macro that will do the tabulations, the macro needs to create a crossed class list
like &word1.*&word2.*&word3 ......;
 
%macro create_class /store source des='Creates class statement for profile2';
/*	%split_variables(&variables)*/
	%global claSS_STR class_str1;
	%LET COUNT=1;
	%let class_Str = %sysfunc(catx(*,&word&count));
	%let class_Str1 = %unquote(%sysfunc(catx(%str(*%(),&word&count, %str( ALL%) )));
	%do count = 2 %to &class_num;
		%let class_Str = %sysfunc(catx(*,&class_str,&word&count));
		%let class_Str1 = %unquote(%sysfunc(catx(%str(*%(),&word&count, %str( ALL%))));
	%end;
   %let class_Str1 = %unquote(%sysfunc(catx(%str(*%(), %str( ALL%)))); 
%mend create_class;

%macro create_strings /store source des='Creates strings for profile2'; 
    %global class_num; 
	%let class_num=%sysfunc(countw(&variables));                                                                                            
	%put &class_num;                                                                                                                        
	%do i=1 %to &class_num; 
        %global word&i; 
	 	%let word&i=%scan(&variables,&i);                                                                                                       
	%end;                                                                                                                                   
                                                                                                                                                                                                                                           
	 %do count=1 %to &class_num;                                                                                                            
	 	%if &count=1 %then %do;                                                                                                                    
	  		%let class_str&count=%str(%()&&word&count ALL%str(%));  
            %put count= &count  &&class_str&count;
		%end;
	 	%else %do;                                                                                                                             
		  %let temp=%eval(&count-1);                                                                                                            
		  %let class_str&count=%unquote(&&class_str&temp*%str(%()&&word&count ALL%str(%)));                                                     
		  %put count= &count &&class_str&count;                                                                                                               
	 	%end;     
        %global class_str;
		%let class_str = &&class_str&count;
	%end;                                                                                                                                                                                                                                                                  
%mend create_strings;

%macro Profile2 (classvars=,period=201203,data_library=data,condition=,name=) 
       /store source des='conducts profile analysis for multiple class levels';
    %global variables;
	%let variables = &classvars;
	%create_strings

%* generate a format_str for the class variables;
	%global fmt_str;
	%let fmt_str =;
	%do i=1 %to &class_num; %* cycle for all class variables;
		%* concatenate the correct format to fmt-str;
		%if %lowcase(&&word&i) eq segment %then %let fmt_str = &fmt_str segment segfmt.;
		%if %lowcase(&&word&i) eq cbr %then %let fmt_str = &fmt_str cbr cbr2012fmt.;
		%if %lowcase(&&word&i) eq market %then %let fmt_str = &fmt_str market mkt2012fmt.;
		%if %lowcase(&&word&i) eq rm %then %let fmt_str = &fmt_str rm $rmfmt.;
		%if %lowcase(&&word&i) eq tenure_yr %then %let fmt_str = &fmt_str tenure_yr tenureband.;
	%end;
		

%*start doing the analysis - try to do it modular;

%******************************************;
%**  Balance and Contribution Analysis   **;
%******************************************;
   ods html close;
	%*A. Part 1: Product penetration, Balances and contribution;
    data temp_bal;
	set &data_library..main_&period;
	where &condition;
	if segment eq . then segment = 7;
	if cbr eq . then cbr = 99;
	if market eq . then market = 99;
	keep hhid segment  cbr market band rm hh dda mms sav tda ira mtg heq iln ind card sln sec ins trs sdb
	     dda_amt mms_amt sav_amt tda_amt ira_amt mtg_amt heq_amt iln_amt ind_amt ccs_amt sln_amt sec_amt trs_amt &classvars;
		 rename card=ccs;
	run;


	data temp_contrib;
	set &data_library..contrib_&period;
	keep hhid DDA_CON MMS_CON SAV_CON TDA_CON IRA_CON SEC_CON TRS_CON mtg_con heq_con card_con ILN_CON SLN_CON ind_con;
		 rename card_con=ccs_con;
	run;

	data temp_merged;
	merge temp_bal (in=a) temp_contrib (in=b);
	by hhid;
	if a ;
	run;

	proc tabulate data=temp_merged missing out=bal1;
	class &classvars;
    var hh dda mms sav tda ira mtg heq iln ind ccs sln sec ins trs sdb 
         dda_amt mms_amt sav_amt tda_amt ira_amt mtg_amt heq_amt iln_amt ind_amt ccs_amt sln_amt sec_amt trs_amt
         DDA_CON MMS_CON SAV_CON TDA_CON IRA_CON SEC_CON TRS_CON mtg_con heq_con ccs_con ILN_CON SLN_CON ind_con;
	table &class_str ,   (hh dda mms sav tda ira mtg heq iln ind ccs sln sec ins trs sdb)*(sum) 
                            (dda_amt mms_amt sav_amt tda_amt ira_amt mtg_amt heq_amt iln_amt ind_amt ccs_amt sln_amt sec_amt trs_amt)*(sum) 
							(dda_amt mms_amt sav_amt tda_amt ira_amt mtg_amt heq_amt iln_amt ind_amt ccs_amt sln_amt sec_amt trs_amt)*(mean)
							(DDA_CON MMS_CON SAV_CON TDA_CON IRA_CON SEC_CON TRS_CON mtg_con heq_con ccs_con ILN_CON SLN_CON ind_con)*sum
							(DDA_CON MMS_CON SAV_CON TDA_CON IRA_CON SEC_CON TRS_CON mtg_con heq_con ccs_con ILN_CON SLN_CON ind_con)*mean; 
	run;


%*this step build a data step that goes line by line and puts all or -1 on the empty lines (-1 is so the format assignes the right value of ALL)
it has one if statement by class variable and if they are of special types it adds -1;

	data bal2;
	set bal1;
		%do i =1 %to &class_num;
			if substr(_type_,&i,1) eq 0 then do;
				%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                    &&word&i = -1;
				%end;
				%else %do;
                    &&word&i = 'All';
				%end;
			end;
		%end;
		format &fmt_str;
	run;


	%let p1 = dda;
	%let p2 = mms;
	%let p3 = sav;
	%let p4 = tda;
	%let p5 = ira;
	%let p6 = mtg;
	%let p7 = heq;
	%let p8 = iln;
	%let p9 = ind;
	%let p10 = ccs;
	%let p11 = sln;
	%let p12 = sec;
	%let p13 = ins;
	%let p14 = trs;
	%let p15 = sdb;



	data bal3;
	length product $ 25;
	set bal2;
	   product = "hh";
		prod_hh =  hh_sum;
		penetration = divide(hh_sum , hh_sum);
		balance = .;
		bal_prod_hh = .;
		bal_tot_hh = .;
		contribution = .;
		con_prod_hh = .;
		con_tot_hh = .;
		output;
	 %do k =1 %to 15;
	 	product = "&&p&k";
		prod_hh =  &&p&k.._sum;
		penetration = divide(&&p&k.._sum , hh_sum);
		%if &&p&k ne ins and &&p&k ne sdb %then %do;
			balance = &&p&k.._amt_sum;
			bal_prod_hh = divide( &&p&k.._amt_sum ,&&p&k.._sum);
			bal_tot_hh = &&p&k.._amt_mean;
			contribution = &&p&k.._con_sum;
			con_prod_hh = divide(&&p&k.._con_sum ,&&p&k.._sum);
			con_tot_hh = &&p&k.._con_mean;
		%end;
		%if &&p&k eq ins or &&p&k eq sdb %then %do;
			balance = 0;
			bal_prod_hh = 0;
			bal_tot_hh = 0;
			contribution = 0;
			con_prod_hh = 0;
			con_tot_hh = 0;
		%end;
		output;
	%end;
	keep &variables product prod_hh penetration balance bal_prod_hh bal_tot_hh contribution con_prod_hh con_tot_hh;
	format penetration percent8.1; 
	run;

%******************************************;
%***  conduct std descriptive analysis   **;
%******************************************;

data temp_data;
set &data_library..main_&period;
where &condition;
cqi = sum(of cqi:);
if segment eq . then segment = 7;
	if cbr eq . then cbr = 99;
	if market eq . then market = 99;
keep &variables cbr market segment band tenure_yr rm svcs cqi: hh hhid;
run;

%*cycle through all the descriptive analyses and if it is in the class then do not do a cross with itself and apply the correct format;

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

		%let found = 0; %*reset found variable;
		%do k = 1 %to &class_num;	 %*iterate for all words;
			%if %scan(&variables , &k) eq &wrd %then %do; %*did I find the word;
				%let found = 1; %*mark found as 1;
				%let k = &class_num; %*increase counter k to exit loop as I do not need to check anymore;
			%end;
		%end;

	
			proc tabulate data=temp_data out=&wrd._results missing;
			class &variables ;
			%if &found eq 0 %then %do;
				%* if it was not found then add it to the class, if found it was already there so no need to;
				class &wrd;
			%end;
			var hh;

			%if &found eq 0 %then %do;
				table &class_str *(&wrd ALL), hh*sum*f=comma12. / nocellmerge;
			%end;
			%if &found eq 1 %then %do;
				table &class_str , hh*sum*f=comma12. / nocellmerge;
			%end;
			%if &fmt ne or &fmt_str ne %then format;
			%if &fmt ne %then &wrd &fmt;
			%if &fmt_str ne %then &fmt_str;
			;
			run;

			data &wrd._results;
			set &wrd._results;
				%do i =1 %to &class_num;
					if substr(_type_,&i,1) eq 0 then do;
						%if &&word&i=segment or &&word&i=market or &&word&i=cbr or %substr(&&word&i,1,3)=cqi or &&word&i=svcs or &&word&i=tenure_yr %then %do;
		                    &&word&i = -1;
						%end;
						%else %do;
		                    &&word&i = 'All';
						%end;
					end;
				%end;
					if substr(_type_,%eval(&class_num+1),1) eq 0 then do;
					%if &wrd=segment or &wrd=market or &wrd=cbr or %substr(&wrd,1,3)=cqi or &wrd=svcs or &wrd=tenure_yr %then %do;
			            &wrd = -1;
					%end;
					%else %do;
			            &wrd = 'All';
					%end;
					end;
				format &fmt_str;
		
	%end; %* for the loop;
	run;
*************************************************;
**        ANALYSIS FOR TRANSACTIONS (WEB)      **;
*************************************************;

data temp_web ;
set &data_library..main_&period;
where &condition;
where also WEB = 1;
	if web_signon ge 1 then web1 = 1; else web1 = 0;
    if bp_num ge 1 then bp1 = 1; else bp1 = 0;
    if sms_num ge 1 then sms1 = 1; else sms1 = 0;
	if wap_num ge 1 then wap1 = 1; else wap1 = 0;
    if fico_num ge 1 then fico1 = 1; else fico1 = 0;
	if fworks_num ge 1 then fworks1 = 1; else fworks1 = 0;
	edeliv1 = 0;
	estat1 = 0;
	edeliv_num = 0;
	estat_num = 0;
keep &variables HHID HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num  
     web1 bp1 sms1 wap1 fico1 fworks1 edeliv1 estat1 estat_num edeliv_num; 
rename web_signon = web_num;
run;

Proc tabulate data=temp_web out=web1 missing;
class &variables;
var HH web bp WAP SMS edeliv estat fico FWorks web_num BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num 
       web1 bp1 sms1 wap1 fico1 fworks1 edeliv1 estat1 estat_num edeliv_num;
table  &class_str, (sum)*(HH web bp WAP SMS edeliv estat fico FWorks web_num BP_NUM BP_AMT SMS_NUM WAP_NUM 
                          fico_num fworks_num web1 bp1 sms1 wap1 fico1 fworks1 edeliv1 estat1 estat_num edeliv_num) / nocellmerge;
run;  

data web2;
	set web1;
		%do i =1 %to &class_num;
			if substr(_type_,&i,1) eq 0 then do;
				%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                    &&word&i = -1;
				%end;
				%else %do;
                    &&word&i = 'All';
				%end;
			end;
		%end;
		format &fmt_str;
	run; 

	%let s1=web;
%let s2=bp;
%let s3=wap;
%let s4=sms;
%let s5=fico;
%let s6=fworks;
%let s7=edeliv;
%let s8=estat;

data web3;
length Service $ 25;
set web2;
  %do i = 1 %to 8;
	   Service = "&&s&i";
	   Enrolled = &&s&i.._sum;
	   Enrolled_pct = 0;	
	   if hh_sum ne 0 then Enrolled_pct = divide(&&s&i.._sum, hh_sum);
	   Active = &&s&i..1_sum;
	   Active_pct = 0;	
	   if enrolled ne 0 then Active_pct = divide(&&s&i..1_sum, enrolled);
	   volume_avg = 0;
	   if &&s&i..1_sum ne 0 then volume_avg = divide(&&s&i.._num_sum, &&s&i..1_sum);
	   spend_avg = .;
	   %if &i eq 2 %then %do; 
			if &&s&i.._sum ne 0 then spend_avg = divide(&&s&i.._amt_sum, &&s&i.._sum); 
       %end;
	   output;
  %end;
  format service svcfmt.;
  keep &variables service enrolled: active: volume_avg spend_avg;
run;


*************************************************;
**        ANALYSIS FOR TRANSACTIONS (CHK)      **;
*************************************************;
data temp_tran ;
set &data_library..main_&period;
where &condition;
where also dda = 1;
    if bp_num ge 1 then bp1 = 1; else bp1 = 0;
    if VPOS_NUM ge 1 then VPOS1 = 1; else VPOS = 0;
	if MPOS_NUM ge 1 then MPOS1 = 1; else MPOS = 0;
	if ATMO_NUM ge 1 then ATMO1 = 1; else ATMO = 0;
	if ATMT_NUM ge 1 then ATMT1 = 1; else ATMT = 0;
	if BR_TR_NUM ge 1 then BR_TR1 = 1; else BR_TR = 0;
	if vru_NUM ge 1 then VRU1 = 1; else VRU = 0;
    if web_signon ge 1 then web1 = 1; else web1 = 0;
	if chk_num ge 1 then chk1 = 1; else chk1 = 0;
    *below are always enrolled;
	chk = 1;
    vru = 1;
	br_tr = 1;
	dd = 1;
	*these are always zero;
	dd_num = 0;
	chk_amt=0;
	*do we have a debit card?, if so turn atm,deb flags enrolled on;
	if cqi_deb eq 1 then do;
		vpos = 1;
		mpos = 1;
		atmt = 1;
		atmo =1;
	end;
	if cqi_deb eq 0 then do;
		vpos = 0;
		mpos = 0;
		atmt = 0;
		atmo =0;
	end;
keep &variables HHID HH web web1 bp1 bp web_signon BP_NUM BP_AMT vpos: mpos: br_tr: vru: chk: dd: atmo: atmt: cqi_dd ;   
rename web_signon = web_num cqi_dd=dd1;
run;

Proc tabulate data=temp_tran out=tran1 missing;
class &variables ;   
var HH hh vpos: mpos: chk: atmo: atmt: dd: bp:  ;
table  &class_str, (sum)*(HH  vpos: mpos: chk: atmo: atmt: dd: bp: ) / nocellmerge;
run;  

data tran2;
	set tran1;
	%do i =1 %to &class_num;
		if substr(_type_,&i,1) eq 0 then do;
			%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                &&word&i = -1;
			%end;
			%else %do;
                &&word&i = 'All';
			%end;
		end;
	%end;
	format &fmt_str;
run; 

%let t1=vpos;
%let t2=mpos;
%let t3=atmo;
%let t4=atmt;
%let t5=bp;
%let t6=chk;
%let t7=dd;


data tran3;
length transaction $ 25;
set tran2;
  %do i = 1 %to 7;
	   Transaction = "&&t&i";
	   Enrolled = &&t&i.._sum;
	   Enrolled_pct = 0;	
	   if hh_sum ne 0 then Enrolled_pct = divide(&&t&i.._sum, hh_sum);
	   Active = &&t&i..1_sum;
	   Active_pct = 0;	
	   if enrolled ne 0 then Active_pct = divide(&&t&i..1_sum, enrolled);
	   %if &&t&i eq dd %then %do;
			volume_avg = 0;
		%end;
	   %if &&t&i ne dd %then %do; %* we do not have count for dd;
	   		if &&t&i..1_sum ne 0 then volume_avg = divide(&&t&i.._num_sum, &&t&i..1_sum);
	   %end;
		%if &&t&i eq chk %then %do;
			spend_avg = .;
		%end;
	   %if &&t&i ne chk %then %do; %* we do not have amount for checks;
			if &&t&i.._sum ne 0 then spend_avg = divide(&&t&i.._amt_sum, &&t&i.._sum); 
       %end;
	   output;
  %end;
  format transaction $tranfmt.;
  keep &variables Transaction Enrolled: active: volume_avg spend_avg;
run;


******************************************;
**        CLV and IXI Analysis          **;
******************************************;

data temp_clv ;
set &data_library..main_&period;
where &condition;
keep &variables HHID HH clv: ixi: ; 
run;

proc tabulate data=temp_clv out=clv1;
where clv_total ne . and clv_steady eq '1' and clv_flag eq 'Y' ;
class &variables ;
var  HH clv_total clv_rem clv_rem_ten;
table &class_str, N (clv_total clv_rem clv_rem_ten)*mean;
run;

data clv2;
	set clv1;
	%do i =1 %to &class_num;
		if substr(_type_,&i,1) eq 0 then do;
			%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                &&word&i = -1;
			%end;
			%else %do;
                &&word&i = 'All';
			%end;
		end;
	%end;
	format &fmt_str;
run; 
proc tabulate data=temp_clv out=clv3 ;
where clv_total ne .;
class &variables clv_total;
var  HH ;
table &class_str ,(clv_total  ALL)*(hh)*(sum rowpctsum<hh>) ;
format clv_total clvband.;
run;

data clv4;
	set clv3;
	%do i =1 %to &class_num;
		if substr(_type_,&i,1) eq 0 then do;
			%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                &&word&i = -1;
			%end;
			%else %do;
                &&word&i = 'All';
			%end;
		end;
	%end;
	HHs = hh_sum;
	percent_hhs = sum (of hh_pctsum:); 
	format &fmt_str;
	keep &variables clv_total HHs percent_hhs;
run; 

proc tabulate data=temp_clv out=ixi1;
where ixi_tot ne .;
class &variables ;
var  HH ixi: ;
table &class_str, N (ixi:)*mean;
run;

data ixi2;
	set ixi1;
	%do i =1 %to &class_num;
		if substr(_type_,&i,1) eq 0 then do;
			%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                &&word&i = -1;
			%end;
			%else %do;
                &&word&i = 'All';
			%end;
		end;
	%end;
	format &fmt_str;
run; 

proc tabulate data=temp_clv out=ixi3 ;
where ixi_tot ne .;
class &variables IXI_tot;
var  HH ;
table &class_str ,(ixi_tot  ALL)*(hh)*(sum rowpctsum<hh>*f=pctfmt.) ;
format ixi_tot wealthband.;
run;

data ixi4;
	set ixi3;
	%do i =1 %to &class_num;
		if substr(_type_,&i,1) eq 0 then do;
			%if &&word&i=segment or &&word&i=market or &&word&i=cbr %then %do;
                &&word&i = -1;
			%end;
			%else %do;
                &&word&i = 'All';
			%end;
		end;
	%end;
	HHs = hh_sum;
	percent_hhs = sum (of hh_pctsum:); 
	format &fmt_str;
	keep &variables ixi_tot HHs percent_hhs;
run; 

ods html;
%global period1;
%let period1 = &period;
%mend profile2;

*ideally you would test if any step has zero elements in the dataset, if so then skip the analysis;





*for this chart macro I need
   1. add all the charts
   2. trap issue if pdf file exists
   3. ensure for clv and ixi charts formats work and the where clause has the right logic - remember there is a new class variable created for the band ones
   4. check chart titles
   5. use format thing to add to title things like by Customer Segment or by  Marjet as needed (for key words);



%macro create_charts (filename=,dir=temp_sas_files) / store source des='Creates charts for profile2' ;

%*Assign the pdf file name;
options orientation=landscape;
ods html close;
%let a = &filename._%sysfunc(date(),yymmddn8.);
ods pdf file="C:\Documents and Settings\ewnym5s\My Documents\&dir.\&a..pdf" ;

%*cycle through the words;
%do i =1 %to &class_num;
    %*here I need to build a string for the where clause, that is going to take only the rows where current work is ne 'All' and the other are eq 'All';
	%if &&word&i eq segment or &&word&i eq market or &&word&i eq cbr %then %do;
		%let where_str = &&word&i ne -1 ;
	%end;
	%else %do;
		%let where_str = &&word&i ne 'All' ;
	%end;
   
	%do j=1 % to &class_num;
		%if &j ne &i %then %do;
		    %if &&word&j eq segment or &&word&j eq market or &&word&j eq cbr %then %do;
				%let where_str = &where_str and &&word&j eq -1;
			%end;
			%else %do;
				%let where_str = &where_str and &&word&j eq 'All';
			%end;
		%end;
	%end;
    %* Product penetration charts;
	Title1 "Product Penetration (&period1.)";
	axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Product Penetration") order=(0 to 1 by 0.25)  split=" " ;
	axis2 split=" " value=(h=9pt f="Arial/Bold") order=('dda' 'mms' 'sav' 'tda' 'ira' 'sec' 'ins' 'mtg' 'heq' 'iln' 'ind' 'ccs' 'sln' 'sdb') color=black;
	axis3 split=" " value=(h=9pt) label=none value=none;
	legend1 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=('Analysis Group' position=(top center));
	proc gchart data=bal3;
	where product not in ( 'hh', 'trs');
	where also &where_str;
	vbar &&word&i / type=sum sumvar=penetration group=product subgroup=&&word&i
	     raxis = axis1 maxis=axis3 gaxis=axis2 legend=legend1 autoref clipref cref=graybb;
	run;
	quit;

	Title1 'Product Balances Per Product HH (&period1.)';
	axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Bal per Product HH")   split=" " ;
	axis2 split=" " value=(h=9pt f="Arial/Bold") order=('dda' 'mms' 'sav' 'tda' 'ira' 'sec' 'ins'  'mtg' 'heq' 'iln' 'ind' 'ccs' 'sln' 'sdb') color=black;
	axis3 split=" " value=(h=9pt) label=none value=none;
	proc gchart data=bal3;
	where product not in ( 'hh', 'trs');
	where also &where_str;
	vbar &&word&i / type=sum sumvar=bal_prod_hh group=product subgroup=&&word&i
	     raxis = axis1 maxis=axis3 gaxis=axis2 legend=legend1 autoref clipref cref=graybb;
	run;

	Title1 'Product Balances Per Total HH (&period1.)';
	axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Bal per Total HH")   split=" " ;
	axis2 split=" " value=(h=9pt f="Arial/Bold") order=('dda' 'mms' 'sav' 'tda' 'ira' 'sec' 'ins'  'mtg' 'heq' 'iln' 'ind' 'ccs' 'sln' 'sdb') color=black;
	axis3 split=" " value=(h=9pt) label=none value=none;
	proc gchart data=bal3;
	where product not in ( 'hh', 'trs');
	where also &where_str;
	vbar &&word&i / type=sum sumvar=bal_tot_hh group=product subgroup=&&word&i
	     raxis = axis1 maxis=axis3 gaxis=axis2 legend=legend1 autoref clipref cref=graybb;
	run;

	Title1 'Product Contribution Per Product HH (&period1.)';
	axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Contribution per Product HH")   split=" " ;
	axis2 split=" " value=(h=9pt f="Arial/Bold") order=('dda' 'mms' 'sav' 'tda' 'ira' 'sec' 'ins'  'mtg' 'heq' 'iln' 'ind' 'ccs' 'sln' 'sdb') color=black;
	axis3 split=" " value=(h=9pt) label=none value=none;
	proc gchart data=bal3;
	where product not in ( 'hh', 'trs');
	where also &where_str;
	vbar &&word&i / type=sum sumvar=con_prod_hh group=product subgroup=&&word&i
	     raxis = axis1 maxis=axis3 gaxis=axis2 legend=legend1 autoref clipref cref=graybb;
	run;

	Title1 'Product Contribution Per Total HH (&period1.)';
	axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Contribution per Total HH")   split=" " ;
	axis2 split=" " value=(h=9pt f="Arial/Bold") order=('dda' 'mms' 'sav' 'tda' 'ira' 'sec' 'ins'  'mtg' 'heq' 'iln' 'ind' 'ccs' 'sln' 'sdb') color=black;
	axis3 split=" " value=(h=9pt) label=none value=none;
	proc gchart data=bal3;
	where product not in ( 'hh', 'trs');
	vbar &&word&i / type=sum sumvar=con_tot_hh group=product subgroup=&&word&i
	     raxis = axis1 maxis=axis3 gaxis=axis2 legend=legend1 autoref clipref cref=graybb;
	run;
%end;



ods pdf close;
ods htm;
%mend create_charts;





filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\macbug.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%profile2 (classvars= segment,period = 201209, data_library = data,condition = ptype eq 'CCS' and stype in ("REW","NOR","SIG"), name=test_analysis)


filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\charts.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;
%create_charts (filename=test1)

/*%let period = 201203;*/
/*%let data_library = data;*/
/*%let condition = sdb eq 1 and com eq 0 and bus eq 0;*/
%let classvars = tran_segment segment rm;


%delvars
%put _user_;

%profile2(classvars=one two three four five six seven eight )

%put _user_;


proc datasets libraray=wip;
copy out=work move memtype=data;
run;

%macro test_a;
%let period = 201203;
%let data_library = data;
%let condition = state eq 'FL' and com eq 0 and bus eq 0;

 %global variables;
	%let variables = tran_segment segment rm band;
	%create_strings

%global fmt_str;
	%let fmt_str =;
	%do i=1 %to &class_num; %* cycle for all class variables;
		%* concatenate the correct format to fmt-str;
		%if %lowcase(&&word&i) eq segment %then %let fmt_str = &fmt_str segment segfmt.;
		%if %lowcase(&&word&i) eq cbr %then %let fmt_str = &fmt_str cbr cbr2012fmt.;
		%if %lowcase(&&word&i) eq market %then %let fmt_str = &fmt_str market mkt2012fmt.;
		%if %lowcase(&&word&i) eq rm %then %let fmt_str = &fmt_str rm $rmfmt.;
		%if %lowcase(&&word&i) eq tenure_yr %then %let fmt_str = &fmt_str tenure_yr tenureband.;
	%end;

data hhs;
set temp_bal;
where dda eq 1;
keep hhid;
run;

data temp_ptype;
merge hhs (in=a keep=&variables)  &data_library..checking_&period (in=b);
by hhid;
if a and b;
run;

data temp_ptype;
set temp_ptype;
by hhid;
hh = 0;
if first.hhid then


%mend test_a;

filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\macbug.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic noSYMBOLGEN mcompilenote=all;
%test_a





proc freq data=bal1;
table _type_;
run;

data data.main_201203;
set data.main_201203;
if segment eq . then segment = 7;
run;

proc freq data=data.main_201203;
table segment;
run;


 *I made the macto do more than I needed, but it is cool;

 %macro test;
	%do q = 1 %to 12; *cycle through words;
		%if &q eq 1 %then %let wrd = segment;
		%if &q eq 2 %then %let wrd = cbr;
		%if &q eq 3 %then %let wrd = market;
		%if &q eq 4 %then %let wrd = band;
		%if &q eq 5 %then %let wrd = tenure_yr;
		%if &q eq 6 %then %let wrd = svcs;
		%if &q eq 7 %then %let wrd = cqi;
		%if &q eq 8 %then %let wrd = cqi_dd;
		%if &q eq 9 %then %let wrd = cqi_bp;
		%if &q eq 10 %then %let wrd = cqi_web;
		%if &q eq 11 %then %let wrd = cqi_deb;
		%if &q eq 12 %then %let wrd = cqi_odl;

		%let found = 0; *reset found variable;
		%put &q &wrd;
		%do k = 1 %to &class_num;	 *iterate for all words;
			%if %scan(&variables , &k) eq &wrd %then %do; *did I find the word;
				%let found = 1; *mark found as 1;
				%let k = &class_num; *increase counter k to exit loop as I do not need to check anymore;
				%put found it;
			%end;
		%end;
		%if &found eq 1 %then %do;
			%let aux&q = ; *set current aux to null;
		%end;
		%if &found eq 0 %then %do;
			%let aux&q = %str(%() &wrd ALL%str(%)) ; *set current aux to: (word ALL);
		%end;
		%if &q eq 1 %then %do;
			%let aux&q = &&aux&q; *create aux-n variable as old one and current word;
		%end;
		%if &q gt 1 %then %do;
			%let temp = %eval(&q-1); *create q-1 value;
			%let aux&q =  %unquote(&&aux&temp  &&aux&q ); *create aux-n variable as old string || *(current word ALL);
		%end;
		%put &&aux&q;
	%end;
	%global wrd_str;
	%let wrd_str = &aux12;
	%put &aux12;
	%put &class_str * &wrd_str ;
%mend test;





%put _user_;

filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\macbug.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

proc format library=sas;
value $ svcfmt  'web' = 'Web Banking'
             'bp'  = 'Bill Pay'
			 'wap' = 'Mobile Banking'
			 'sms' = 'Text Banking'
			 'fico' = 'Credit Score'
			 'fworks' = 'FinanceWorks'
			 'edeliv' = 'e-Delivery'
			 'estat' = 'e-Statements';
value $ tranfmt 'vpos' = 'Debit Signature'
                'mpos' = 'Debit PIN'
				'atmo' = 'M&T ATM'
				'atmt' = 'Other ATM'
				'bp' = 'Bill Pay'
				'chk' = 'Checks' 
				'dd' = 'Direct Deposit';
run;

proc format library=sas;
value binary_flag 0 = 'No'
                  1 = 'Yes'
				  -1 = 'All';
run;

proc format library=sas;
value cqifmt 0='0'
             1='1'
			 2='2'
			 3='3'
			 4='4'
			 5='5'
			 -1='All';
run;

proc format library=sas;
value segfmt . = 'Not Coded'
			 1 = 'Building Their Future'
             2 = 'Mass Affluent no Kids'
			 3 = 'Mainstream Families'
			 4 = 'Mass Affluent Families'
			 5 = 'Mainstream Retired'
			 6 = 'Mass Affluent Retired'
			 7 = 'Not Coded'
			 8 = 'Building Their Future'
			 9 = 'Mass Affluent Families'
			 -1 = 'All';
 
value cbr2012fmt  1 = 'WNY' 
				  2='Roch'              
				  3='Ctl NY'      
	 			  4='S NY'     
				 5='Alb HVN'     
				6='Tarry'    
				7='NYC'     
				8='Philly'      
				9='PA N'     
				10='C&W PA'      
				11='SE PA'          
				12='Balt'             
				13='G Wash'      
				14='Ches A'           
				15='Ches B'         
				16='Ctl VA'         
				17='Ches DE'          
				99='Out of Mkt'
	            -1='All';

value mkt2012fmt 	1='WNY'      
					2='Ctl NY/E PA'    
					3='Estrn/Metro'     
					4='Ctl PA/W MD'    
					6='G Balt'      
					7='G Wash'   
					8='G Del'    
					98='NATL'      
					99='Out of Mkt'
 					-1='All';
run;

proc format library=sas;
value $ rmfmt 'Y' = 'Managed'
			'N' = 'Not Managed'
			'A' = 'All';
run;



proc format library=sas;
value clvband low-<0 = 'Below Zero'
			  0 = 'Zero'
			  0<-<250 = 'Up to $250'
			  250-<500 = '$250 to $500'
			  500-<750 = '$500 to $750'
			  750-<1000 = '$750 to $1,000'
			  1000-<1500 = '$1,000 to $1,500'
			  1500-<2500 = '$1,500 to $2,500'
			  2500-<5000 = '$2,500 to $5,000'
			  5000-high = '$5,000+'
			  . = 'All';
run;


proc format ;
value clvbanda low-<0 = 'Below Zero'
              0-<1 = 'Zero'
			  1-<250 = 'Up to $250'
			  250-<500 = '$250 to $500'
			  500-<750 = '$500 to $750'
			  750-<1000 = '$750 to $1,000'
			  1000-<1500 = '$1,000 to $1,500'
			  1500-<2500 = '$1,500 to $2,500'
			  2500-<5000 = '$2,500 to $5,000'
			  5000-high = '$5,000+'
			  . = 'All';
run;

%macro test;
  %let xxx = ;
  %do i=1 %to 3;
     %let xxx = &xxx &&word&i &&format&i;
  %end;
  %put &xxx;
%mend test;

%test


proc format library=sas;
value $ formats 'segment' = 'segfmt.'
                'cbr' = 'cbr2012fmt.'
	            'market' = 'mkt2012fmt.'
				'clv_total' = 'clvband.'
				'tenure_yr' = 'tenurenand.'
				'ixi_tot' = 'wealthband.';
run;

%macro a;
%do i =1 %to &class_num;
    %*here I need to build a string for the where clause, that is going to take only the rows where current work is ne 'All' and the other are eq 'All';
	%let where_str = &&word&i ne 'All' ;
	%do j=1 % to &class_num;
		%if &j ne &i %then %do;
			%let where_str = &where_str and &&word&j eq 'All';
		%end;
	%end;
%put &where_str;
%end;
%mend a;

%let class_num = 3;
%a




proc format;
value $ test 'segment' = 'segfmt.'
       'cbr' = 'cbr2012fmt.'
	   'market' = 'mkt2012fmt.';
	  run;

data a;
length word $ 20;
input word $;
datalines;
segment
cbr
market
;
run;

data b;
set a;
format = put(word, $test.);
run;

proc sql;
select word,format into :word1-:word3, :format1-:format3 from b;
quit;

