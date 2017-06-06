filename myfile 'C:\Documents and Settings\ewnym5s\My Documents\Data\stype.txt';

data temp;
length hhid $ 9 stype $ 3;
infile myfile dlm='09'x lrecl=4096 firstobs=2 dsd;
input hhid $ stype $ balance contribution;
run;

data temp;
set temp;
by hhid;
hh=0;
if first.hhid then hh=1;
pkg = 1;
run;

ods html close;
proc tabulate data=temp out=temp1;
class hhid stype;
var balance contribution  pkg;
table hhid, stype *( pkg*sum balance*mean contribution*mean);
run;

ods html;

data temp1;
set temp1;
pkg_sum = 1;
run;

data temp2 ;
set temp1(rename=(pkg_sum=pkg balance_mean=balance contribution_mean=contribution));
keep hhid stype pkg balance contribution;
run;

proc transpose data=temp2 out=data.checking_201203 (drop=_name_);
by hhid;
id stype;
var  pkg;
run;


ods html close;
proc tabulate data=temp1 (drop= _type_ _page_ _table_ rename=( balance_mean = balance contribution_mean=contribution hh_sum=hh pkg_sum=pkg)) out=temp2;
class hhid stype;
var hh pkg balance contribution;
table hhid,  stype*( pkg*sum balance*mean contribution*mean);
run;
ods html;

proc sort data=temp2;
by hhid stype;
run;

proc transpose data=temp2 (obs=1000) out=temp3;
var pkg_sum ;
by hhid ;
id stype;
run;

proc transpose data=temp2 (obs=1000) out=temp4;
var balance_mean ;
by hhid ;
id stype;
run;

proc transpose data=temp2 (obs=1000) out=temp5;
var contribution_mean ;
by hhid ;
id stype;
run;

