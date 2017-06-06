proc format ;
value $ ptypeorder (notsorted)
	'DDA' = 'Checking'
	'MMS' = 'Money Market'
	'SAV' = 'Savings'
	'TDA' = 'Time Deposit'
	'IRA' = 'IRAs'
	'MTG' = 'Mortgage'
	'HEQ' = 'Home Equity'
	'CRD' = 'Credit Card'
	'ILN' = 'Dir. Loan'
	'IND' = 'Ind. Loan'
	'SEC' = 'Securities';
run;

proc sgplot data=penet1 ;
where prod not in ('HH','PAGE','TABLE','SDB','SLN','TRS') and what = 'pctsum' and what2 eq '1';
vbar prod / missing group=underbanked groupdisplay=cluster response=col2 nostatlabel grouporder=data datalabel ;
xaxis label='Product'  tickvalueformat=$ptypeorder. type=discrete discreteorder=formatted;
yaxis label='Product Penetration' ;
format  prod $ptypeorder. underbanked $underb. col2 comma4.;
run;
