

data a;
set data.main_201212;
where cbr eq 16;
keep hhid dda mms sav tda ira mtg card heq hh;
run;


proc tabulate data=data.main_201212  out=out mising;
class dda mms sav tda ira mtg card heq iln ind sec;
var hh;
/*table (dda mms sav tda ira mtg card heq ln ind sec),(dda mms sav tda ira mtg card heqln ind sec)*hh;*/
table (dda mms sav tda ira mtg card heq iln ind sec),(dda mms sav tda ira mtg card heq iln ind sec)*hh*rowpctsum*f=pctfmt. / nocellmerge ;
run;

data out1;
set out;
where sum(dda ,mms ,sav, tda ,ira ,mtg ,card, heq, ind, iln, sec) eq 2;
pct = sum(of hh:);
run;

data out2;
set out1;
array prods{11} dda mms sav tda ira mtg card heq ind iln sec;
source = .;
target = .;
do i =1 to 10;
	if prods{i} eq 1 and source eq . then do;
		first = i;
		source = i;
	end;
end;

do i =first+1 to 11;
	if prods{i} eq 1 and target eq . then do;
	   target = i;
	end;
end;

keep source target pct;
rename pct = width;
run;

proc sort data=out2 out=out3 ;
by source target;
run;

data out3;
length temp sname tname $ 15;
set out3;
by source target;
id = _N_;
Type="directed";
select (source);
	when(1) sname = 'Checking';
	when(2) sname = "Money Market";
	when(3) sname = 'Savings';
	when(4) sname = 'Time Deposits';
	when(5) sname = 'IRAs';
	when(6) sname = 'Mortgage';
	when(7) sname = 'Credit Card';
	when(8) sname = 'Home Equity';
	when(9) sname = 'Dir. Loan';
	when(10) sname = 'Ind. Loan';
	when(11) sname = 'Securities';
end;
select (target);
	when(1) tname = 'Checking';
	when(2) tname = "Money Market";
	when(3) tname = 'Savings';
	when(4) tname = 'Time Deposits';
	when(5) tname = 'IRAs';
	when(6) tname = 'Mortgage';
	when(7) tname = 'Credit Card';
	when(8) tname = 'Home Equity';
	when(9) tname = 'Dir. Loan';
	when(10) tname = 'Ind. Loan';
	when(11) tname = 'Securities';
end;
if not first.source and not first.target then do;
	temp = sname;
	sname = tname;
	tname = temp;
end;
drop temp;
run;

proc tabulate data=data.main_201212  out = freq1;
var hh dda mms sav tda ira mtg card heq iln ind sec;
table colpctsum<hh>*(dda mms sav tda ira mtg card heq iln ind sec)*f=pctfmt.,all;
run;

proc transpose data=freq1(drop=_:) out=freq2;
run;

data freq2;
length node $ 15;
set freq2;
select (scan(_name_,1,'_'));
	when('dda') node = 'Checking';
	when('mms') node = "Money Market";
	when('sav') node = 'Savings';
	when('tda') node = 'Time Deposits';
	when('ira') node = 'IRAs';
	when('mtg') node = 'Mortgage';
	when('card') node = 'Credit Card';
	when('heq') node = 'Home Equity';
	when('ILN') node = 'Dir. Loan';
	when('IND') node= 'Ind. Loan';
	when('sec') node= 'Securities';
end;
run;


proc export data=freq2 outfile = 'C:\Documents and Settings\ewnym5s\My Documents\SAS\nodes_new.csv' dbms=csv replace;
run;


proc export data=out3 outfile = 'C:\Documents and Settings\ewnym5s\My Documents\SAS\edges_new.csv' dbms=csv replace;
run;

data nodes;
length label $ 15;
id = 1;
label = 'Checking';
output;
id = 2;
label = 'Money Market';
output;
id = 3;
label = 'Savings';
output;
id = 4;
label = 'Time Deposits';
output;
id = 5;
label = 'IRAs';
output;
id = 6;
label = 'Mortgage';
output;
id = 7;
label = 'Credit Card';
output;
id = 8;
label = 'Home Equity';
output;
run;

data wip.edges;
set out3;
run;

data wip.nodes;
set freq2;
run;
