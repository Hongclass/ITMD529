%macro toexcel(filename=,out_dir=);

libname myxls oledb init_string="Provider=Microsoft.ACE.OLEDB.12.0;
Data Source=C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&filename..xls;
Extended Properties=Excel 12.0";

%if &word2 eq segment %then %do;
			%let fmt1 = segfmt.;
		%end;
		%if &word2 eq cbr %then %do;
			%let fmt1 = cbr2012fmt.;
		%end;
		%if &word2 eq market %then %do;
			 %let fmt1 = mkt2012fmt.;
		%end;
		%if &word2 eq band %then %do;
			 %let fmt1 =$2.;
		%end;
		%if &word2 eq tenure_yr %then %do;
			 %let fmt1 = tenureband.;
		%end;
		%if &word2 eq svcs %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi_dd %then %do;
			cqi_dd %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_bp %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_web %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_deb %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_odl %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq rm %then %do;
			%let fmt1 = $rmfmt.;
		%end;

data temp_xxx;
	length &word2._new $25;
	set  bal3;
	&word2._new = put(&word2, &fmt1);
	drop  &word2;
run;


data myxls.product;
	
   set temp_xxx (rename=(&word2._new = &word2) where=(&word2 ne ''));
run;

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
			%let wrd = cqi; %let fmt =comma2.;
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

		%if &word2 eq segment %then %do;
			%let fmt1 = segfmt.;
		%end;
		%if &word2 eq cbr %then %do;
			%let fmt1 = cbr2012fmt.;
		%end;
		%if &word2 eq market %then %do;
			 %let fmt1 = mkt2012fmt.;
		%end;
		%if &word2 eq band %then %do;
			 %let fmt1 =$2.;
		%end;
		%if &word2 eq tenure_yr %then %do;
			 %let fmt1 = tenureband.;
		%end;
		%if &word2 eq svcs %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi_dd %then %do;
			cqi_dd %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_bp %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_web %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_deb %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_odl %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq rm %then %do;
			%let fmt1 = $rmfmt.;
		%end;

		%local check ;
		%let check=%sysfunc(exist(&wrd._results));
		%if &check=1 %then %do;
			data temp_xxx;
				length &word2._new $25 &wrd._new $ 25;
				set  &wrd._results;
				&word2._new = put(&word2, &fmt1);
				&wrd._new = put(&wrd, &fmt);
				drop &wrd &word2;
			run;

			data myxls.&wrd ;
			   set temp_xxx (drop=_type_ _page_ _table_ rename=(&word2._new = &word2 &wrd._new = &wrd) where=(&word2 ne '' and &wrd ne ''));
			run;
		%end;
%end;


%if &word2 eq segment %then %do;
			%let fmt1 = segfmt.;
		%end;
		%if &word2 eq cbr %then %do;
			%let fmt1 = cbr2012fmt.;
		%end;
		%if &word2 eq market %then %do;
			 %let fmt1 = mkt2012fmt.;
		%end;
		%if &word2 eq band %then %do;
			 %let fmt1 =$2.;
		%end;
		%if &word2 eq tenure_yr %then %do;
			 %let fmt1 = tenureband.;
		%end;
		%if &word2 eq svcs %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi_dd %then %do;
			cqi_dd %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_bp %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_web %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_deb %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_odl %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq rm %then %do;
			%let fmt1 = $rmfmt.;
		%end;

data temp_xxx;
	length &word2._new $25;
	set  tran3;
	&word2._new = put(&word2, &fmt1);
	drop  &word2;
run;

data myxls.chk_Trans;
   set temp_xxx ( rename=(&word2._new = &word2) where=(&word2 ne ''));
run;

%if &word2 eq segment %then %do;
			%let fmt1 = segfmt.;
		%end;
		%if &word2 eq cbr %then %do;
			%let fmt1 = cbr2012fmt.;
		%end;
		%if &word2 eq market %then %do;
			 %let fmt1 = mkt2012fmt.;
		%end;
		%if &word2 eq band %then %do;
			 %let fmt1 =$2.;
		%end;
		%if &word2 eq tenure_yr %then %do;
			 %let fmt1 = tenureband.;
		%end;
		%if &word2 eq svcs %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi %then %do;
			 %let fmt1 =comma2.;
		%end;
		%if &word2 eq cqi_dd %then %do;
			cqi_dd %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_bp %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_web %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_deb %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq cqi_odl %then %do;
			 %let fmt1 = binary_flag.;
		%end;
		%if &word2 eq rm %then %do;
			%let fmt1 = $rmfmt.;
		%end;

data temp_xxx;
	length &word2._new $25;
	set  web3;
	&word2._new = put(&word2, &fmt1);
	drop  &word2;
run;

data myxls.web_trans;
   set temp_xxx (rename=(&word2._new = &word2) where=(&word2 ne ''));
run;

libname myxls clear;

%mend toexcel;

