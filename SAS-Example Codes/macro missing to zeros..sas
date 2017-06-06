*NEW CODE;
%macro null_to_zero(source, destination, variables) /store ;

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



*OLD CODE BELOW;


data test;
set hudson.business_hh;
run;

option mprint nosymbolgen nomlogic mcompilenote=all;
%macro null_to_zero(dataset);
	proc contents data = &dataset
	out = vars (keep = name type)
	noprint;
	run;

	data vars;
	set vars (where=(type eq 1));
	index=_n_;
	run;

	proc sql noprint;
	select max(index) into :nvars from vars;
	quit;

	%let nvars = &nvars;


	proc sql noprint;
	select name into :name1- :name&nvars from vars;
	quit;
    
	data &dataset;
	set &dataset;
		%do i = 1 %to &nvars;
			if &&name&i eq . then &&name&i = 0;
		%end;
	run;

	
%mend null_to_zero;

filename mprint "C:\Documents and Settings\ewnym5s\My Documents\Hudson City\zeros.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%null_to_zero(test)

;


data test;
input a b c;
datalines;
1 . 3
. . .
1 2 .
. 3 4
. 3 5
7 8 9
;
run;

%macro null_to_zero_new(dataset);
	proc contents data = &dataset
	out = vars (keep = name type)
	noprint;
	run;

	data vars;
	set vars (where=(type eq 1));
	index=_n_;
	run;

	proc sql noprint;
	select max(index) into :nvars from vars;
	quit;

	%let nvars = &nvars;

    
	data &dataset._new;
	set vars;
		if _n_ eq 0 then do;
		declare hash vars1(dataset:'work.vars');
		vars1.DefineKey('index') ;
		vars1.DefineData('name') ;
		vars1.DefineDone() ;
	    end;

		do until (eof2);
			set &dataset;
			%do index = 1 %to &nvars;
					%sysfunc(find(key: i),$) ;
					%let var_name = %eval(name);
					if &var_name eq . then &var_name = 0;
			%end;
		end;
	run;

	
%mend null_to_zero_new ;



filename mprint "C:\Documents and Settings\ewnym5s\My Documents\Hudson City\zeros.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%null_to_zero_new(test)

data test_clean;
length name $ 32;
set vars;
		if _n_ eq 0 then do;
			dcl hash vars1(datAset:'work.vars');
			vars1.DefineKey ( 'index' ) ;
			vars1.DefineData ( 'name' ) ;
			vars1.DefineDone () ;
			call missing(index,name);
		end;


do until ( eof2 );
	set test end=eof2;
		do i = 1 to 3;
			if vars1.find(key: i) = 0 then do;
				call symputx('var_name', name);
				if &var_name eq . then &var_name = 0;
			end;
		end;
end;
run;




data &dataset;
	set &dataset;
		%do i = 1 %to &nvars;
			if &&name&i eq . then &&name&i = 0;
		%end;
	run;

decl hash vars1(datset:'work.vars');
		vars1.DefineKey ( 'index' ) ;
		vars1.DefineData ( 'name' ) ;
		vars1.DefineDone () ;
%put _user_;
