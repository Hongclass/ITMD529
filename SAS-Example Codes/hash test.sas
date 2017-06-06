
data test;
input name $ a b c;
datalines;
john 1 . 3
jill . . .
jack 1 2 .
peter . 3 4
paul . 3 5
mary 7 8 9
;
run;

data ids;
input name $ ID $;
datalines;
john A123
jill B345
jack C124
peter D345
paul X098
mary G568
;
run;

data withids;
set ids point = _n_;
 if _n_ eq 1 then do;
 	dcl hash hh (dataset:'work.ids');
	hh.DefineKey ('name') ;
	hh.DefineData ('ID') ;
	hh.DefineDone () ;
end;

do until ( eof2 );
set test end=eof2;
	if hh.find() = 0 then output;
end;

run;

*I was able toload the table, not to use it;
*the first ione is iterating and you need to finsih that first, then worjk on the sdeciond one;
