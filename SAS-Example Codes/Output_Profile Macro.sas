option mprint nosymbolgen nomlogic mcompilenote=all minoperator;
options mstored sasmstore=sas;

%macro output_profile (library=work,path=C:\Documents and Settings\ewnym5s\My Documents,name=) / store source des='Outputs to Excel';

		libname myxls oledb init_string="Provider=Microsoft.ACE.OLEDB.12.0;
		Data Source=&path.\&name..xls;
		Extended Properties=Excel 12.0";

	%do q=1 %to 13;
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
		%if &q eq 13 %then %let wrd = RM;

		data myxls.&wrd;
   			set &library..&wrd._results;
		run;
     %end;

	%do q=1 %to 5;
		%if &q eq 1 %then %let wrd = bal3;
		%if &q eq 2 %then %let wrd = clv4;
		%if &q eq 3 %then %let wrd = ixi4;
		%if &q eq 4 %then %let wrd = tran3;
		%if &q eq 5 %then %let wrd = web3;

		data myxls.&wrd;
   			set &library..&wrd;
		run;
     %end;

	 libname myxls clear;

	 %mend output_profile;

