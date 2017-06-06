Proc format library=sas;
picture pctdoll (round)
	-999999999999 -<0 = '00,000,000,000,009.99' (mult=1 prefix='-$' )
	0 - 1000000000000 = '00,000,000,000,009.99' (mult=1 prefix='$');
picture pctcomma (round)
	-999999999999 -<0 = '00,000,000,000,009.9' (mult=.1 prefix='-' )
	0 - 1000000000000 = '00,000,000,000,009.9' (mult=.1)  ;
run;
