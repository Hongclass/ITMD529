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


*old;



options mstored sasmstore=sas;

%macro as_logical(dataset, exclude=) / store source  des='creates 0/1 flags from counts';
data &dataset;
set &dataset;
array all_nums[*] _NUMERIC_; 
do i = 1 to dim(all_nums);
  if all_nums[i] ne &exclude and all_nums[i] ge 1 then all_nums[i] = 1; 
end; 
drop i; 
run; 
%mend as_logical;
