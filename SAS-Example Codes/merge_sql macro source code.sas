%macro merge_sql (table1=,table2=,key1=,key2=,output_name=,prefix=,dir=,where_str=1=1)/ store source des='merge 2 sql tables into a table in bagels/Mario1';

%delvars

proc contents data=&dir..&table1  out=test;
run;

proc sql;
select count(*) into :counta from test;
quit;

proc sql;
select label, type, format   into :names_a1-:names_a9999 , :type_a1-:type_a9999, :format_a1 - :format_a9999 from test;
quit;

proc contents data=&dir..&table2  out=test2;
run;

proc sql;
select count(*) into :countb from test2;
quit;

proc sql;
select name, type, format   into :names_b1-:names_b9999 , :type_b1-:type_b9999, :format_b1 - :format_b9999 from test2;
quit;

libname bagels oledb init_string="Provider=SQLOLEDB.1;
 Password=Reporting2;
 Persist Security Info=True;
 User ID=reporting_user;
 Initial Catalog=Mario1;
 Data Source=bagels"  schema=dbo; 

proc sql;
   connect to oledb as myconn (init_string='Provider=SQLOLEDB;Password=Reporting2;Persist
Security Info=True;User ID=reporting_user;Initial Catalog=Mario1;
Data Source=Bagels'); 

%local check ;
%let check=%sysfunc(exist(bagels.&output_name));
%if &check=1 %then %do;
	execute (drop table &output_name) by myconn %str(;);
%end;
execute( create table &output_name (
	%do i=1 %to &counta; 
		%if &&type_a&i = 1 and &&format_a&i ne DATETIME %then &&names_a&i float;
		%if &&type_a&i = 1 and &&format_a&i eq DATETIME %then &&names_a&i datetime;
		%if &&type_a&i = 2  %then &&names_a&i char(20);
		%if &i ne &counta %then,;
	%end;
	,
	%do i=1 %to &countb;
		%if &&type_b&i = 1  and &&format_b&i ne DATETIME %then &&names_b&i float;
		%if &&type_b&i = 1  and &&format_b&i eq DATETIME %then &&names_b&i datetime;
		%if &&type_b&i = 2  %then &&names_b&i char(20);
		%if &i ne &countb %then,;
	%end;
    ) %str(;) ) by myconn;

	execute (insert &output_name select 
	%do i=1 %to &counta;
		%if &i ne &counta %then a.&&names_a&i,;
		%if &i eq &counta %then a.&&names_a&i;
	%end;
	,
	%do i=1 %to &countb;
		%if &i ne &countb %then b.&&names_b&i,;
		%if &i eq &countb %then b.&&names_b&i;
	%end;
	from &prefix..&table1 as a inner join &prefix..&table2 as b on a.&key1 = b.&key2 where &where_str ) by myconn;
	quit;
%mend merge_sql;
