libname online 'C:\Documents and Settings\ewnym5s\My Documents\Online';
libname data 'C:\Documents and Settings\ewnym5s\My Documents\Data';
libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
options fmtsearch=(SAS);

options MSTORED SASMSTORE = mjstore;
libname mjstore 'C:\Documents and Settings\ewnym5s\My Documents\SAS\Macros';

%read_monthly_data (source=201112.txt,identifier=201112,directory=C:\Documents and Settings\ewnym5s\My Documents\Data\);
%read_contr_data (source=c12.txt,identifier=201112,directory=C:\Documents and Settings\ewnym5s\My Documents\Data\);


goptions reset=goptions;


%profile_analysis(condition=grp eq 1,class1=grp,out_file=consumer_all,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100,class1=web_band,out_file=all_web,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and numprod eq 1 and web_signon le 100,class1=web_band,out_file=single_web,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and web_band eq 'q1',class1=segment,out_file=q1,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and web_band eq 'q2',class1=segment,out_file=q2_new,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and web_band eq 'q3',class1=segment,out_file=q3,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and web_band eq 'q4',class1=segment,out_file=q4,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");


%profile_analysis(condition=hh eq 1 and web_signon le 100 and web_band eq 'Inactive',class1=segment,out_file=inactive,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and web_band eq 'No Web',class1=segment,out_file=no_web,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");


%profile_analysis(condition=hh eq 1 and web_signon le 100 and CBR eq .,class1=web_band,out_file=out_of_mkt,
out_dir=Online,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");


%profile_analysis(condition=hh eq 1 and web_signon le 100 and band eq 'A' ,class1=web_band,out_file=A,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and band eq 'B' ,class1=web_band,out_file=B,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and band eq 'C' ,class1=web_band,out_file=C,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and band eq 'D' ,class1=web_band,out_file=D,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");

%profile_analysis(condition=hh eq 1 and web_signon le 100 and band eq 'E' ,class1=web_band,out_file=E,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");



%profile_analysis(condition=hh eq 1 and web_signon le 100 ,class1=web_band,out_file=test_new,
out_dir=Data,identifier=201111,dir="C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files");


ods html;

data tempx;
length web_band $ 10;
set data.main_201111;
Select;
	when (web_signon eq .) web_band = 'No Web';
	when (web_signon eq 0)  web_band = 'Inactive';
	when (web_signon ge 1 and web_signon le 4)  web_band = 'q4';
	when (web_signon ge 5 and web_signon le 9)  web_band = 'q3';
	when (web_signon ge 10 and web_signon le 21)  web_band = 'q2';
	when (web_signon ge 22)  web_band = 'q1';
end;
numprod = dda + mms + sav + tda + ira + mtg + heq + card + iln + ind + sdb + sec + ins + trs + sln;
/*keep hhid web_signon web_band;*/
run;


data data.main_201111;
set tempx;
run;

data tempx;
merge data.contrib_201111 (in=a) data.main_201111 (in=b keep=hhid web_band);
by hhid;
run;


data data.contrib_201111;
set tempx;
run;



data tempx;
merge data.main_201111(in=a keep=hhid web_signon web_band rename=(web_signon=nov)) data.main_201112 (in=b keep=hhid web_signon rename=(web_signon=dec));
by hhid;
run;

data tempz;
set tempx;
if nov ge 1 then m1='Y';
else m1='N';

if dec ge 1 then m2='Y';
else m2='N';

run;


proc tabulate data=tempz(where=(nov ne .)) missing;
class m1 m2;
table m1,m2*(N);
run;

data temp1;
set data.main_201111;
hh = 1;
run;

data temp2;
set data.contrib_201111;
hh = 1;
run;

data data.contrib_201111;
set temp2;
run;

data data.main_201111;
set temp1;
run;


proc rank data=tempx  out=ranks1 groups=10;
where (web_signon ge 72);
ranks group;
var web_signon;
run;

proc sort data=ranks1;
by group;
run;

proc tabulate data=ranks1 out=bins;
class group;
var web_signon;
table group, web_signon*(N pctn min max mean);
run;

PROC DATASETS LIB = Work; 
CONTENTS DATA =_all_;
QUIT; RUN;

PROC DATASETS LIB = Work; 
delete CBR: BAND: CLASS: BINS: CONTR: CQI: TRAN: WEALTH: WEB: MKT: PROD: SEG: TEMP_: WEALTH: WEB;
QUIT; RUN;


PROC DATASETS LIB = WORK.SASMACR; 
QUIT; RUN;

libname temp1 work;


PROC CATALOG catalog=mjstore.sasmacr;
Contents;
run;

ods html;

option nosymbolgen;

data tempx;
set data.main_201111;
numprod = dda + mms + sav + tda + ira + mtg + heq + card + iln + ind + sdb + sec + ins + trs + sln;
run;

proc tabulate data=tempx(where=(numprod eq 1));
class web_band;
var dda  mms  sav  tda  ira  mtg  heq  card  iln  ind  sdb  sec  ins  trs  sln hh;
table web_band, (dda  mms  sav  tda  ira  mtg  heq  card  iln  ind  sdb  sec  ins  trs  sln hh)*(sum);
run;


data data.main_201111;
set tempx;
run;



filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\SLN11.txt';

data sln11;
length HHID $ 9 SLN_CON 8;
infile mydata DLM='09'x firstobs=2 lrecl=4096 dsd;
	  INPUT hhID $
		SLN_CON;
run;


filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\SLN12.txt';

data sln12;
length HHID $ 9 SLN_CON 8;
infile mydata DLM='09'x firstobs=2 lrecl=4096 dsd;
	  INPUT hhID $
		SLN_CON;
run;


data tempq11;
merge data.contrib_201111 (in=a drop=SLN_CON) sln11 (in=b);
if a;
run;

data tempq12;
merge data.contrib_201112 (in=a drop=SLN_CON) sln12 (in=b);
if a;
run;


data data.contrib_201111;
SET tempq11;
run;

data data.contrib_201112;
SET tempq12;
run;

proc univariate data=data.contrib_201111;
histogram SLN_CON;
run;

proc univariate data=data.contrib_201112;
histogram SLN_CON;
run;





filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\bp12.txt';
data bp12;
length HHID $ 9 bp_num 8 bp_Amt 8;
infile mydata DLM='09'x firstobs=2 lrecl=4096 dsd;
	  INPUT hhID $
	  bp_num
	  bp_amt;
run;

data merged11;
merge data.main_201111 (in=a drop=bp_num bp_amt) bp11 (in=b);
by hhid;
if A;
run;

data merged12;
merge data.main_201112 (in=a drop=bp_num bp_amt) bp12 (in=b);
by hhid;
if A;
run;


proc freq data=data.main_201111;
table web_band / missing ;
run;

/*#############################################################################################*/




data wip.temp ;
set data.Main_201111 ;
where &condition;
hh = 1;
run;










proc freq data=data.main_201112 (keep=IND ILN);
table ind iln;
run;


proc freq data=data.main_201111 (keep=IND ILN);
table ind iln;
run;

proc freq data=wip.temp;
table grp / out=work.grp_class ;
run;


data data.grp_class;
set work.grp_class;
drop count percent;
run;

proc freq data=data.main_201111;
table web_band;
run;


filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\bp12.txt';
data bp12;
length HHID $ 9 bp_num 8 bp_Amt 8;
infile mydata DLM='09'x firstobs=2 lrecl=4096 dsd;
	  INPUT hhID $
	  bp_num
	  bp_amt;
run;

data tempy;
merge data.main_201112 (in=a drop=bp_num bp_amt) bp12 (in=b);
by hhid;
if a ;
run;


data data.main_201112;
set tempy;
run;


filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\chk11.txt';
data chk11;
length HHID $ 9 chk_num 8 dd_Amt 8;
infile mydata DLM='09'x firstobs=2 lrecl=4096 dsd;
	  INPUT hhID $
	  chk_num
	  dd_amt;
run;

data tempz;
merge data.main_201111 (in=a) chk11 (in=b);
by hhid;
if a and b;
run;


data data.main_201111;
set tempz;
run;


proc freq data=data.main_201111 order=freq;
where hh eq 1 and web_signon le 100 and CBR eq .;
table state;
run;


data wip.seg5;
array seg_val{10} 8 seg1-seg9 seg99;
array pct_val{10} 8 pct1-pct10;
set wip.seg4;
do i = 1 to 10;
	if i = 10 then do;
       segment = 99;
	end;
	else do;
		segment =i;
	end;
	HH = seg_val{i};
	PCT = pct_val{i};
	output;
end;
drop seg1-seg9 seg99 pct1-pct10;
run;


data wip.seg5;
array seg_val{10} 8 seg1-seg9 seg99;
array pct_val{10} 8 pct1-pct10;
length name $ 25 seg_num 8;
set wip.seg4;

	seg_num = 1;
	name = 'Building their Future';
	HH = seg_val{1}+seg_val{8};
	pct_1 = pct_val{1}+pct_val{8};
	output;

	name = 'Mass Affl No Kids';
	seg_num = 2;
	HH = seg_val{2};
	pct_1 = pct_val{2};
	output;

	name = 'Mainst Fam';
	seg_num = 3;
	HH = seg_val{3};
	pct_1 = pct_val{3};
	output;

	name = 'Mass Affl Fam';
	seg_num = 4;
	HH = seg_val{4}+seg_val{9};
	pct_1 = pct_val{4}+pct_val{9};
	output;

	name = 'Mainst Ret';
	seg_num = 5;
	HH = seg_val{5};
	pct_1 = pct_val{5};
	output;
    
	name = 'Mass Affl Ret';
	seg_num = 6;
	HH = seg_val{6};
	pct_1 = pct_val{6};
	output;

	name = 'Unknown';
	seg_num = 7;
	HH = seg_val{7}+seg_val{10};
	pct_1 = pct_val{7}+pct_val{10};
	output;

drop seg1-seg9 seg99 pct1-pct10;
run;



