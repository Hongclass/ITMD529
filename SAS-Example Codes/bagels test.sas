libname bagels oledb init_string="Provider=SQLOLEDB.1;
     Password=Reporting2;
     Persist Security Info=True;
     User ID=reporting_user;
     Initial Catalog=Mario1;
     Data Source=Bagels"  schema=dbo; 

libname denies '\\denies\Mario_Test';

libname data 'C:\Documents and Settings\ewnym5s\My Documents\Data';


data denies.test;
set data.main_201111;
where hh eq 1 and web_signon le 100 and CBR eq .;
run;

ods html close;
proc freq data=data.main_201112 (keep=cbr);
table cbr;
run;


proc freq data=bagels.main_201112 (keep=cbr);
table cbr;
run;

proc freq data=bagels.main_201112 (keep=cbr);
table cbr / out=bagels.freq1;
run;

data bagels.main_201111;
set data.main_201111;
run;


proc freq data=denies.test (keep = cbr);
table cbr;
run;


PROC TABULATE data=data.main_201112;
class segment;
var dda mms sav tda ira sec trs mtg heq card ILN IND sln sdb ins hh DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt IND_AMT sln_amt ;
table  segment, (sum)*(dda mms sav tda ira sec trs mtg heq card ILN ind sln sdb ins hh DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt ind_amt sln_amt );
run;

PROC TABULATE data=bagels.main_201112;
class segment;
var dda mms sav tda ira sec trs mtg heq card ILN IND sln sdb ins hh DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt IND_AMT sln_amt ;
table  segment, (sum)*(dda mms sav tda ira sec trs mtg heq card ILN ind sln sdb ins hh DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt ind_amt sln_amt );
run;

data ;
set bagels.main_201112;
where segment eq 1;
run;

data bagels.test1;
set bagels.main_201112;
where segment eq 1;
run;

proc sql;
create table bagels.test2 as
select * from bagels.main_201112 where segment = 1;
quit;

proc sql;
create table data.test2 as
select * from data.main_201112 where segment = 1;
quit;

proc sql;
connect to oledb init_string="Provider=SQLOLEDB.1;
     Password=Reporting2;
     Persist Security Info=True;
     User ID=reporting_user;
     Initial Catalog=Mario1;
     Data Source=Bagels";
quit;

proc sql;
connect to oledb as bagels1 (user=reporting_user password=Reporting2 datasource=Bagels
   provider=sqloledb );
   
	 create table test as select * from connection to bagels1(select hhid, hh, dda from MAIN_201112 where sdb=1); 
quit;

execute (select * into work.test)
from tbl_labs;

proc sql;
connect to oledb as bagels1 (user=reporting_user password=Reporting2 datasource=Bagels
   provider=sqloledb );
   
	 create table test as select * from connection to bagels1(select hhid, hh, dda from MAIN_201112 where sdb=1); 
quit;

/* 
