data test;
input a $ b ;
datalines;
john 1
peter 3
sarah 5
abby 4
alex 7
bea 2
;
run;


data test;
do b = 1 to 10000;
a = ranuni(7);
output;
end;
run;





proc sort data=test;
by a;
run;

data _null_;
length a  8 b 8;
set test end=eof;

if _n_ eq 1 then do;
dcl hash hh (dataset: 'test', ordered: 'A');
hh.definekey ('a');
hh.definedata('a','b');
hh.definedone();
end;

if eof then do;
	hh.output(dataset: 'test');
end;
run;

