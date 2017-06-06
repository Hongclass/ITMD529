* Get Statistics from Merging;

data wip.products;
retain miss;
merge wip.products (in=left) data.contrib_201212 (in=right drop=STATE ZIP BRANCH CBR MARKET band band_yr rename=(contrib=contrib_mtd)) end=eof;
by hhid;
if left then output;
if left and not right then miss+1;
if eof then put 'WARNING: Records on left not found on right = ' miss;
drop miss;
run;


data a;
set data.main_201212 (obs=1000 keep=hhid state segment);
run;

data b;
set data.main_201212 (obs=1025 firstobs=26 keep=hhid zip tran_code rename=(tran_code=group));
run;

data c;
merge a (in=left) b (in=right);
by hhid;
run;


data c;
merge a (in=left) b (in=right) end=eof;
retain missleft missright;
by hhid;
*collect the desired statistics;
if left and not right then missright+1;
if right and not left then missleft+1;
if eof then do; *output the statistics;
	put 'There were ' missleft 'Record on left dataset not found on the right dataset';
 	put 'WARNING: There were ' missright 'Records on right dataset not found on the left dataset';
end;
if left; *We want all records from left table;
drop miss: ; *don't forget to drop the statistci variables or they will be part of the output dataset;
run;

ods rtf file='C:\Documents and Settings\ewnym5s\My Documents\SAS\paper output new.rtf' style = sasweb;
Title ' Contents of WORK.A';
proc print data=a (obs=29 firstobs=22);
run;

Title ' Contents of WORK.B';
proc print data=b (obs=8 );
run;

Title ' Contents of Merged Dataset';
proc print data=c (obs=29 firstobs=22 );
run;

ods rtf close;

data test;
length pseudo_hh 8 branch $ 3 ;
length rc 3;
retain misses 3;

if _n_ eq 1 then do;
	set branches end=eof1;
	dcl hash hh1 (dataset: 'branches', hashexp: 8, ordered:'a');
	hh1.definekey('pseudo_hh');
	hh1.definedata('branch');
	hh1.definedone();
end;

misses = 0;
do until (eof2);
	set hudson.hudson_hh end=eof2;
	rc = hh1.find()= 0 ;	
	if hh1.find() ne 0 then  do;
		branch = '';
	end;
	output;
end;

putlog 'WARNING: There were ' misses comma6. ' records in large file not matched';
drop rc misses;
run;

		proc contents data = b
		out = vars (keep = name type)
		noprint;
		run;


%let source = b;
%let dest = b;

*Convert Data;
options nominoperator;
option mprint nosymbolgen nomlogic mcompilenote=all;


%macro null_to_zero(source, destination, variables);

	%if &variables eq all or &variables eq %then %do;
		*% if the user did not provide a list of variables then create one with all numeric variables; 
		proc contents data = &source
		out = vars (keep = name type)
		noprint;
		run;

		data vars;
		set vars (where=(type eq 1));
		index=_n_;
		run;

		proc sql noprint;
		select name into :myvars separated by ' ' from vars;
		quit;

	%end;
    %else %do;
		%let myvars = &variables;
	%end;

	data &destination;
	set &source;
	array names{*} &myvars;
	do i = 1 to dim(names);
		if names{i} eq . then names{i} = 0;
	end;
	drop i;
	run;
%mend null_to_zero;

%macro null_to_zero(source, destination, variables);
    data &destination;
	set &source;
	array names{*} 
      %if &variables eq all or &variables eq %then _numeric_;
	  %else &variables; ;

	do i = 1 to dim(names);
		if names{i} eq . then names{i} = 0;
	end;
	drop i;
	run;
%mend null_to_zero;



data sample_data;
input jan_orders feb_orders mar_orders;
datalines;
1 3 .
2 3 4
1 . .
0 . 5
3 0 0
;
run;

%null_to_zero(source=sample_data,destination=sample_adjusted, variables=jan_orders feb_orders);

ods rtf file = 'C:\Documents and Settings\ewnym5s\My Documents\SAS\output2.rtf';;

Title 'Sample Data with Nulls';
proc print data=sample_data;
run;

Title 'With Zeros instead of Nulls';
proc print data=sample_adjusted;
run;
ods rtf close;

%macro as_logical(source, destination, variables);

	%if &variables eq all or &variables eq %then %do;
		*% if the user did not provide a list of variables then create one with all numeric variables; 
		proc contents data = &source
		out = vars (keep = name type)
		noprint;
		run;

		data vars;
		set vars (where=(type eq 1));
		index=_n_;
		run;

		proc sql noprint;
		select name into :myvars separated by ' ' from vars;
		quit;

	%end;
    %else %do;
		%let myvars = &variables;
	%end;

	data &destination;
	set &source;
	array names{*} &myvars;
	do i = 1 to dim(names);
		if names{i} ge 1 then names{i} = 1;
		else names{i} = 0;
	end;
	drop i;
	run;
%mend as_logical;

%macro as_logical(source, destination, variables);
    data &destination;
	set &source;
	array names{*} 
      %if &variables eq all or &variables eq %then _numeric_;
	  %else &variables; ;

	do i = 1 to dim(names);
		if names{i} ge 1 then names{i} = 1;
		else names{i} = 0;
	end;
	drop i;
	run;
%mend null_to_zero;

data sample_data;
input checking savings loans;
datalines;
1 3 0
2 3 4
1 1 0
0 . 5
3 0 0
;
run;

%as_logical(source=sample_data,destination=sample_logical,variables=checking);

ods rtf file = 'C:\Documents and Settings\ewnym5s\My Documents\SAS\output4.rtf';;
Title 'Sample Product Counts';
proc print data=sample_data;
run;

Title 'Converted to Logical Indicators';
proc print data=sample_logical;
run;
ods rtf close;

*FORMAT;
data test;
input a ;
b = a;
c=a;
d=a;
e=a;
f=a;
datalines;
-7500000
-625000
-500
0
400
36790
88000000
;
run;

proc format; 
	picture thousands 
	   low-high = '000,000,000,000,009' (mult=0.001  )  ;
	picture thousandsr (round)
	   low-high = '000,000,000,000,009' (mult=0.001  )  ;
	picture thoudec 
	   low-high = '000,000,000,000,009.9' (mult=0.001  )  ;
	picture millions 
	   low-high = '000,000,000,000,009' (mult=0.000001  )  ;
	picture millionsr (round)
	   low-high = '000,000,000,000,009' (mult=0.000001  )  ;
run;


Proc format                                                                                                                                                      ;
	picture thou_final (round)
	-999999999999 -<0 = '00,000,000,000,009.9' (mult=0.01 prefix='-' )
	0 - 1000000000000 = '00,000,000,000,009.9' (mult=0.01)  ;
    picture mill_final (round)
	-999999999999 -<0 = '00,000,000,000,009.9' (mult=0.00001 prefix='-' )
	0 - 1000000000000 = '00,000,000,000,009.9' (mult=0.00001)  ;
run;


 ods rtf file = 'C:\Documents and Settings\ewnym5s\My Documents\SAS\paper output fmt1.rtf';;
 ods rtf style=sasweb;

Title 'Demonstration of How Picture Formats Work';

proc print data=test;
run;

proc print data=test split=" ";;
format a comma24. b thousands. c thousandsr. d  thoudec.  e millionsr.  f millionsr.;
var a  b  c d e f;
label  a='Original comma24.' b='Thousands' c='Thousands Rounded' d='Thousands with Decimals' e='Millions Rounded' f='Millions Rounded';
run;

Title ' Putting it all to work Properly';
proc print data=test split=" ";;
format a comma24. b thou_final. c mill_final. ;
var a  b  c ;
label  a='Original comma24.' b='Thousands Rounded With Negatives' c='Millions Rounded With Negatives';
run;


ods rtf close;
