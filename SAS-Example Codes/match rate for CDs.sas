data hudson.tda;
length acct_nbr $ 14;
set hudson.tda;
if length(acct) = 9 then acct_nbr="02000"||acct;
if length(acct) = 10 then acct_nbr="0200"||acct;
run;


options compress=y;
 data hudson.clean_20121106;
length acct_nbr $ 14  rate 8;
length rc 3;
retain misses 3;

if _n_ eq 1 then do;
	set hudson.tda end=eof1;
	dcl hash hh1 (dataset: 'hudson.tda', hashexp: 8, ordered:'a');
	hh1.definekey('acct_nbr');
	hh1.definedata('rate');
	hh1.definedone();
end;

misses = 0;
do until (eof2);
	set hudson.clean_20121106 end=eof2;
	rc = hh1.find()= 0 ;	
	if hh1.find() ne 0 then  do;
		rate = .;
	end;
	output;
end;

putlog 'WARNING: There were ' misses comma6. ' records in large file not matched';
drop rc misses;
run;

proc freq data=test;;
where ptype = 'IRA';
table rate ;
run;
