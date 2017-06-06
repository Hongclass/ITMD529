options compress=y;
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
	rc = hh1.find();	
	if hh1.find() ne 0 then  do;
		branch = '';
	end;
	output;
end;

putlog 'WARNING: There were ' misses comma6. ' records in large file not matched';
drop rc misses;
run;
