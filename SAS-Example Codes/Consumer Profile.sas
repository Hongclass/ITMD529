options MSTORED SASMSTORE = mjstore;
libname mjstore 'C:\Documents and Settings\ewnym5s\My Documents\SAS\Macros';


%macro profile_analysis (condition=,Class1=,out_file=,out_dir=,identifier=,dir=, title=, clean=) / store source des='get Profile_analysis macro';
libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
options fmtsearch=(SAS);

/*for testing, these are the variable assignmnets */

/*%let condition = virtual_seg in ('Uncoded no Check','Uncoded w/Check');*/
/*%let class1 = virtual_seg;*/
/*%let out_file = test_new;*/
/*%let  out_dir = Data;*/
/*%let identifier = 201111;*/
/*%let dir = "C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files";*/
/*%let title = 'Analysis of Not Coded';*/



%local dtend dtstart;
%let dtstart=%sysfunc(datetime(), datetime18.);
%put &dtstart;

libname data 'C:\Documents and Settings\ewnym5s\My Documents\Data';

libname wip;
libname wip &dir;

libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
options fmtsearch=(SAS);

%if %sysfunc(libref(wip)) ne 0 %then %do;
	%put ERROR: The SAS Data Library could;
	%put ERROR- not be established;
	%goto quit;
%end;

%if %sysfunc(exist(data.&class1._class)) %then %do;
/* if the class file is found for class variable then do the macro*/

%if %sysfunc(fileexist("C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&out_file..xls")) ne 0 %then %do;
	%put ERROR: The Excel Output file;
	%put ERROR- already exists;
	libname myxls clear;
	%goto quit;
%end;

libname myxls oledb init_string="Provider=Microsoft.ACE.OLEDB.12.0;
Data Source=C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&out_file..xls;
Extended Properties=Excel 12.0";

ods html close;


data wip.temp ;
set data.Main_&identifier ;
where &condition;
run;

%IF %SYSFUNC(EXIST(wip.temp)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(close(&DSID));


Proc tabulate data=wip.temp out=wip.prod1;
class &class1;
var dda mms sav tda ira sec trs mtg heq card ILN IND sln sdb ins hh DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt IND_AMT sln_amt ;
table  &class1, (sum)*(dda mms sav tda ira sec trs mtg heq card ILN ind sln sdb ins hh DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt ind_amt sln_amt );
run;

data wip.prod2;
set wip.prod1 (drop=_TABLE_ _TYPE_ _PAGE_);

ins_amt = 0;
sdb_amt=0;

/*percentages*/
if hh_sum gt 0 then do;
dda_pct = divide(dda_sum,hh_sum);
sav_pct = divide(sav_sum,hh_sum);
mms_pct = divide(mms_sum,hh_sum);
tda_pct = divide(tda_sum,hh_sum);
ira_pct = divide(ira_sum,hh_sum);
sec_pct = divide(sec_sum,hh_sum);
ins_pct = divide(ins_sum,hh_sum);
trs_pct = divide(trs_sum,hh_sum);
mtg_pct = divide(mtg_sum,hh_sum);
heq_pct = divide(heq_sum,hh_sum);
iln_pct = divide(iln_sum,hh_sum);
ind_pct = divide(ind_sum,hh_sum);
sln_pct = divide(sln_sum,hh_sum);
ccs_pct = divide(card_sum,hh_sum);
sdb_pct = divide(sdb_sum,hh_sum);
end;
else do;
dda_pct = 0;
sav_pct = 0;
mms_pct = 0;
ira_pct = 0;
tda_pct = 0;
sec_pct = 0;
ins_pct = 0;
trs_pct = 0;
mtg_pct = 0;
heq_pct = 0;
iln_pct = 0;
ind_pct = 0;
sln_pct = 0;
ccs_pct = 0;
sdb_pct = 0;
end;
/*averages*/
dda_avg1 = divide(dda_amt_sum,dda_sum);
sav_avg1 = divide(sav_amt_sum,SAV_sum);
mms_avg1 = divide(mms_amt_sum,MMS_sum);
tda_avg1 = divide(tda_amt_sum,tda_sum);
ira_avg1 = divide(ira_amt_sum,ira_sum);
sec_avg1 = divide(sec_amt_sum,sec_sum);
ins_avg1 = 0;
trs_avg1 = divide(trs_amt_sum,trs_sum);
mtg_avg1 = divide(mtg_amt_sum,mtg_sum);
heq_avg1 = divide(heq_amt_sum,heq_sum);
iln_avg1 = divide(iln_amt_sum,iln_sum);
ind_avg1 = divide(ind_amt_sum,ind_sum);
sln_avg1 = divide(sln_amt_sum,sln_sum);
ccs_avg1 = divide(ccs_amt_sum,card_sum);
sdb_avg1 = 0;

dda_avg2 = divide(dda_amt_sum,hh_sum);
sav_avg2 = divide(sav_amt_sum,hh_sum);
mms_avg2 = divide(mms_amt_sum,hh_sum);
ira_avg2 = divide(ira_amt_sum,hh_sum);
tda_avg2 = divide(tda_amt_sum,hh_sum);
sec_avg2 = divide(sec_amt_sum,hh_sum);
ins_avg2 = 0;
trs_avg2 = divide(trs_amt_sum,hh_sum);
mtg_avg2 = divide(mtg_amt_sum,hh_sum);
heq_avg2 = divide(heq_amt_sum,hh_sum);
iln_avg2 = divide(iln_amt_sum,hh_sum);
ind_avg2 = divide(ind_amt_sum,hh_sum);
sln_avg2 = divide(sln_amt_sum,hh_sum);
ccs_avg2 = divide(ccs_amt_sum,hh_sum);
sdb_avg2 = 0;
run;


data wip.prod3;
length Product $ 20 HH 8 Penetration 8 Balance 8 Avg_a 8 Avg_b 8;
array counts {15} 8 dda_sum mms_sum sav_sum tda_sum ira_sum sec_sum ins_sum trs_sum mtg_sum heq_sum ILN_sum ind_sum sln_sum card_sum sdb_sum;
array bals {15} 8 dda_amt_sum mms_amt_sum sav_amt_sum tda_amt_sum ira_amt_sum sec_amt_sum ins_amt_sum trs_amt_sum mtg_amt_sum heq_amt_sum 
                  ILN_amt_sum ind_amt_sum sln_amt_sum ccs_amt_sum sdb_amt_sum;
array pcts {15} 8 dda_pct mms_pct sav_pct tda_pct ira_pct sec_pct ins_pct trs_pct mtg_pct heq_pct ILN_pct ind_pct sln_pct ccs_pct sdb_pct;
array avg1 {15}  8 dda_avg1 mms_avg1 sav_avg1 tda_avg1 ira_avg1 sec_avg1 ins_avg1 trs_avg1 mtg_avg1 heq_avg1 ILN_avg1 ind_avg1 sln_avg1 ccs_avg1 sdb_avg1;
array avg2 {15} 8 dda_avg2 mms_avg2 sav_avg2 tda_avg2 ira_avg2 sec_avg2 ins_avg2 trs_avg2 mtg_avg2 heq_avg2 ILN_avg2 ind_avg2 sln_avg2 ccs_avg2 sdb_avg2;
Array Prod {15} $ 20 ('Checking' 'Money Market' 'Savings' 'Time Deposits' 'IRAs' 'Securities' 'Insurance' 'Trust' 'Mortgage' 'Home Equity' 
'Dir. Inst. Loan' 'Ind. Inst. Loan' 'Student Loan' 'Credit Card' 'Safe Deposit Box');
set wip.prod2;

do i=1 to 15;
   Product = Prod{i};
   HH = counts{i};
   Balance = bals{i};
   Penetration = pcts{i};
   Avg_a = avg1{i};
   Avg_b = avg2{i};
   output;
end;
   Product = 'Total';
   HH = hh_sum;
   Balance = .;
   Penetration = .;
   Avg_a = .;
   Avg_b = .;
   output;
keep &class1 Product HH Penetration Balance Avg_a Avg_b;
run;



data myxls.product;
   set wip.prod3;
run;

%end;
%end;

/*title2 "Product Ownership Report for " &TitleName;*/
/*proc print data=prod3 split=' ' noobs;*/
/*format HH comma12.0 Balance Avg_a Avg_b dollar20.2 Penetration Percent9.1;*/
/*by &class1;*/
/*label Avg_a ='Average Per Product HH'*/
/*      avg_b='Average per Total HH';*/
/*run;*/
/*title2;*/


/*########################################################################################################################################################*/
/*analyze cbr distribution*/

%if &CLass1 ne cbr %then 
%do;
PROC SQL;
create table wip.class as 
SELECT *
FROM data.cbr_class, data.&class1._class
;
QUIT;


Proc tabulate data=wip.temp out=wip.cbr1 (drop=_PAGE_ _TYPE_ _TABLE_) missing classdata=wip.class exclusive;
class cbr &class1;
var hh  ;
keylabel N='Count';
table  (cbr), (&class1)*(N) ;
run;

data wip.cbr2;
length type $ 1;
set wip.cbr1;
type=vtype(&class1);
if type = 'N' then do;
	if (&class1 eq .) then do;
		&class1 = 99;
	end;
end;
else do;
	if (&class1 eq '') then do;
		&class1 = '99';
	end;
end;
if cbr eq . then do;
	cbr = 99;
end;
if N eq . then do;
	N = 0;
end;
drop type;
run;

proc sort data=wip.cbr2;
by &class1 cbr;
run;

proc transpose data=wip.cbr2 out=wip.cbr3 (drop=_NAME_) prefix=cbr;
by &class1 ;
id cbr;
run;

data wip.cbr4;
set wip.cbr3;
retain tot;
array cbr_val{18} cbr1-cbr17 cbr99;
array pct{18};
tot=0;
do i = 1 to 18;
	tot = tot+cbr_val{i};
end;
do j = 1 to 18;
	if tot ne 0 then do;
	pct{j} = cbr_val{j}/tot;
	END;
	else do;
		pct{j} = 0;
	end;
end;
output;
drop i j tot;
run;



data wip.cbr5;
array hh_val{18} 8 cbr1-cbr17 cbr99 ;
array pct_val{18} 8 pct1-pct18 ;
length cbr_num $ 2;
set wip.cbr4;

	cbr_num = '1';
	HH = hh_val{1};
	pct_1 = pct_val{1};
	output;

	
	cbr_num = '2';
	HH = hh_val{2};
	pct_1 = pct_val{2};
	output;

	cbr_num = '3';
	HH = hh_val{3};
	pct_1 = pct_val{3};
	output;

	
	cbr_num = '4';
	HH = hh_val{4};
	pct_1 = pct_val{4};
	output;

	cbr_num = '5';
	HH = hh_val{5};
	pct_1 = pct_val{5};
	output;


	cbr_num = '6';
	HH = hh_val{6};
	pct_1 = pct_val{6};
	output;


	cbr_num = '7';
	HH = hh_val{7};
	pct_1 = pct_val{7};
	output;

	cbr_num = '8';
	HH = hh_val{8};
	pct_1 = pct_val{8};
	output;

		cbr_num = '9';
	HH = hh_val{9};
	pct_1 = pct_val{9};
	output;

	
	cbr_num = '10';
	HH = hh_val{10};
	pct_1 = pct_val{10};
	output;

	cbr_num = '11';
	HH = hh_val{11};
	pct_1 = pct_val{11};
	output;

	
	cbr_num = '12';
	HH = hh_val{12};
	pct_1 = pct_val{12};
	output;

	cbr_num = '13';
	HH = hh_val{13};
	pct_1 = pct_val{13};
	output;


	cbr_num = '14';
	HH = hh_val{14};
	pct_1 = pct_val{14};
	output;


	cbr_num = '15';
	HH = hh_val{15};
	pct_1 = pct_val{15};
	output;

	cbr_num = '16';
	HH = hh_val{16};
	pct_1 = pct_val{16};
	output;


	cbr_num = '17';
	HH = hh_val{17};
	pct_1 = pct_val{17};
	output;

	cbr_num = '99';
	HH = hh_val{18};
	pct_1 = pct_val{18};
	output;

drop cbr1-cbr17 cbr99 pct1-pct18;
run;

data myxls.cbr;
   set wip.cbr5;
run;

%end;



/*########################################################################################################################################################*/
/*segments*/

%if &class1 ne segment %then
%do;
PROC SQL;
create table wip.class as 
SELECT *
FROM data.segment_class, data.&class1._class
;
QUIT;


Proc tabulate data=wip.temp out=wip.seg1 (drop=_PAGE_ _TYPE_ _TABLE_) missing classdata=wip.class exclusive;
class segment &class1;
var hh  ;
keylabel N='Count';
table  (segment), (&class1)*(N) ;
run;

data wip.seg2;
length type $ 1;
set wip.seg1;
type=vtype(&class1);
if type = 'N' then do;
	if (&class1 eq .) then do;
		&class1 = 99;
	end;
end;
else do;
	if (&class1 eq '') then do;
		&class1 = '99';
	end;
end;
if segment eq . then do;
	segment = 99;
end;
if N eq . then do;
	N = 0;
end;
drop type;
run;

proc sort data=wip.seg2;
by &class1 segment;
run;

proc transpose data=wip.seg2 out=wip.seg3 (drop=_NAME_) prefix=seg;
by &class1 ;
id segment;
run;

data wip.seg4;
set wip.seg3;
retain tot;
array seg_val{10} seg1-seg9 seg99;
array pct{10};
tot=0;
do i = 1 to 10;
	tot = tot+seg_val{i};
end;
do j = 1 to 10;
	if tot ne 0 then do;
	pct{j} = seg_val{j}/tot;
	end;
	else do;
		pct{j} = 0;
	end;
end;
output;
drop i j tot;
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


data myxls.segment;
   set wip.seg5;
run;

%end;
/*########################################################################################################################################################*/

/*Market*/

%if &class1 ne market %then
%do;

PROC SQL;
create table wip.class as 
SELECT *
FROM data.market_class, data.&class1._class
;
QUIT;


Proc tabulate data=wip.temp out=wip.mkt1 (drop=_PAGE_ _TYPE_ _TABLE_ rename=(N=Count) ) missing classdata=wip.class exclusive;
class market &class1;
var hh  ;
keylabel N='Count';
table  (market), (&class1)*(N) ;
run;

data wip.mkt2;
length type $ 1;
set wip.mkt1;
type=vtype(&class1);
if type = 'N' then do;
	if (&class1 eq .) then do;
		&class1 = 99;
	end;
end;
else do;
	if (&class1 eq '') then do;
		&class1 = '99';
	end;
end;
if market eq . then do;
	market = 99;
end;
if cOUNT eq . then do;
	COUNT = 0;
end;
drop type;
run;


Proc tabulate data=wip.mkt2 out=wip.mkt3 (drop=_PAGE_ _TYPE_ _TABLE_ rename=(count_sum=N)) missing;
class market &class1;
var count;
keylabel SUM='SUm';
table  (market), (&class1)*(count*SUM) ;
run;

proc sort data=wip.mkt3;
by &class1 market;
run;



proc transpose data=wip.mkt3 out=wip.mkt4 (drop=_NAME_) prefix=mkt;
by &class1 ;
id market;
run;

data wip.mkt5;
set wip.mkt4;
retain tot;
array mkt_val{99};
array pct{99};
tot=0;
mkt_val{1} = mkt1;
mkt_val{2} = mkt2;
mkt_val{3} = mkt3;
mkt_val{4} = mkt4;
mkt_val{6} = mkt6;
mkt_val{7} = mkt7;
mkt_val{8} = mkt8;
mkt_val{99} = mkt99;
 
tot = sum(mkt1,mkt2,mkt3,mkt4,mkt6,mkt7,mkt8,mkt99);

if mkt1 ne 0 then do;
	pct{1} = mkt1/tot;
end;
else do;
	pct{1} = 0;
end;

if mkt2 ne 0 then do;
	pct{2} = mkt2/tot;
end;
else do;
	pct{2} = 0;
end;

if mkt3 ne 0 then do;
	pct{3} = mkt3/tot;
end;
else do;
	pct{3} = 0;
end;

if mkt4 ne 0 then do;
	pct{4} = mkt4/tot;
end;
else do;
	pct{4} = 0;
end;

if mkt6 ne 0 then do;
	pct{6} = mkt6/tot;
end;
else do;
	pct{6} = 0;
end;

if mkt7 ne 0 then do;
	pct{7} = mkt7/tot;
end;
else do;
	pct{7} = 0;
end;

if mkt8 ne 0 then do;
	pct{8} = mkt8/tot;
end;
else do;
	pct{8} = 0;
end;

if mkt99 ne 0 then do;
	pct{99} = mkt99/tot;
end;
else do;
	pct{99} = 0;
end;
output;
drop tot mkt_val: pct5 pct9-pct98;
run;



data wip.mkt6;
array hh_val{8} 8 mkt1-mkt4 mkt6-mkt8 mkt99;
array pct_val{8} 8 pct1-pct4 pct6-pct8 pct99;
length mkt_num $ 2;
set wip.mkt5;

	mkt_num = '1';
	HH = hh_val{1};
	pct_1 = pct_val{1};
	output;

	
	mkt_num = '2';
	HH = hh_val{2};
	pct_1 = pct_val{2};
	output;

	mkt_num = '3';
	HH = hh_val{3};
	pct_1 = pct_val{3};
	output;

	
	mkt_num = '4';
	HH = hh_val{4};
	pct_1 = pct_val{4};
	output;

	mkt_num = '6';
	HH = hh_val{5};
	pct_1 = pct_val{5};
	output;


	mkt_num = '7';
	HH = hh_val{6};
	pct_1 = pct_val{6};
	output;


	mkt_num = '8';
	HH = hh_val{7};
	pct_1 = pct_val{7};
	output;

	mkt_num = '99';
	HH = hh_val{8};
	pct_1 = pct_val{8};
	output;

drop mkt1-mkt4 mkt6-mkt8 mkt99 pct1-pct4 pct6-pct8 pct99  ;
run;



data myxls.market;
   set wip.mkt6;
run;

%end;

/*########################################################################################################################################################*/

/*Profit Band*/

%if &class1 ne band %then
%do;

PROC SQL;
create table wip.class as 
SELECT *
FROM data.band_class, data.&class1._class
;
QUIT;

Proc tabulate data=wip.temp out=wip.band1 (drop=_PAGE_ _TYPE_ _TABLE_) missing classdata=wip.class exclusive;
class band &class1;
var hh  ;
keylabel N='Count';
table  (band), (&class1)*(N) ;
run;

data wip.band2;
length type $ 1;
set wip.band1;
type=vtype(&class1);
if type = 'N' then do;
	if (&class1 eq .) then do;
		&class1 = 99;
	end;
end;
else do;
	if (&class1 eq '') then do;
		&class1 = '99';
	end;
end;
if band eq '' then do;
	band = 'X';
end;
if N eq . then do;
	N = 0;
end;
drop type;
run;

proc sort data=wip.band2;
by &class1 band;
run;

proc transpose data=wip.band2 out=wip.band3 (drop=_NAME_) ;
by &class1 ;
id band;
run;

data wip.band4;
set wip.band3;
retain tot;
array band_val{5} A B C D E;
array pct{5};
tot=0;
do i = 1 to 5;
	tot = tot+band_val{i};
end;
do j = 1 to 5;
	if tot ne 0 then do;
	   pct{j} = band_val{j}/tot;
	end;
	else do;
		pct{j} = 0;
	end;
end;
output;
drop i j tot;
run;

data wip.band5;
array hh_val{5} 8 A B C D E;
array pct_val{5} 8 pct1-pct5;
length band_name $ 1;
set wip.band4;

	band_name = 'A';
	HH = hh_val{1};
	pct_1 = pct_val{1};
	output;

	
	band_name = 'B';
	HH = hh_val{2};
	pct_1 = pct_val{2};
	output;

	band_name = 'C';
	HH = hh_val{3};
	pct_1 = pct_val{3};
	output;

	
	band_name = 'D';
	HH = hh_val{4};
	pct_1 = pct_val{4};
	output;

	band_name = 'E';
	HH = hh_val{5};
	pct_1 = pct_val{5};
	output;


	
drop A B C D E pct1-pct5 ;
run;



data myxls.band;
   set wip.band4;
run;


%end;


/*########################################################################################################################################################*/
/*CQI*/


%if &class1 ne cqi %then
%do;




data wip.temp_cqi ;
set wip.temp;
where DDA = 1;
cqi = sum(of cqi:);
run;

%IF %SYSFUNC(EXIST(wip.temp_cqi)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_cqi));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(Close(&DSID));

PROC SQL;
create table wip.class as 
SELECT *
FROM data.cqi_class, data.&class1._class
;
QUIT;

Proc tabulate data=wip.temp_cqi out=wip.cqi1 (drop=_PAGE_ _TYPE_ _TABLE_) missing classdata=wip.class exclusive;
class cqi &class1;
var hh  ;
keylabel N='Count';
table  (cqi), (&class1)*(N) ;
run;

data wip.cqi2;
length type $ 1;
set wip.cqi1;
type=vtype(&class1);
if type = 'N' then do;
	if (&class1 eq .) then do;
		&class1 = 99;
	end;
end;
else do;
	if (&class1 eq '') then do;
		&class1 = '99';
	end;
end;
if cqi eq . then do;
	cqi = 99;
end;
if N eq . then do;
	N = 0;
end;
drop type;
run;

proc sort data=wip.cqi2;
by &class1 cqi;
run;

proc transpose data=wip.cqi2 out=wip.cqi3 (drop=_NAME_) prefix=cqi ;
by &class1 ;
id cqi;
run;

data wip.CQI4;
set wip.CQI3;
retain tot;
array cqi_val{6} cqi:;
array pct{6};
tot=0;
do i = 1 to 6;
	tot = tot+cqi_val{i};
end;
do j = 1 to 6;
	if tot ne 0 then do;
	   pct{j} = cqi_val{j}/tot;
	end;
	else do;
		pct{j} = 0;
	end;
end;
output;
drop i j tot;
run;


/*now do the part of the table by cqi copmponents */
Proc tabulate data=wip.temp_cqi out=wip.cqi5;
class &class1;
var cqi_: hh ;
table  &class1, (sum)*(cqi_: hh);
run;

data wip.cqi6;
set wip.cqi5 (drop=_TABLE_ _TYPE_ _PAGE_);
/*percentages*/
if hh_sum gt 0 then do;
	dd_pct = cqi_dd_sum/hh_sum;
	web_pct = cqi_web_sum/hh_sum;
	deb_pct = cqi_deb_sum/hh_sum;
	dl_pct = cqi_odl_sum/hh_sum;
	bp_pct = cqi_bp_sum/hh_sum;
end;
else do;
	dd_pct = 0;
	web_pct = 0;
	deb_pct = 0;
	dl_pct = 0;
	bp_pct = 0;
end;
run;

data wip.cqi7;
array hh_val{6} 8 cqi0 cqi1-cqi5;
array pct_val{6} 8 pct1-pct6;
length name $ 1;
set wip.cqi4;

	name = '0';
	HH = hh_val{1};
	pct_1 = pct_val{1};
	output;

	
	name = '1';
	HH = hh_val{2};
	pct_1 = pct_val{2};
	output;

	name = '2';
	HH = hh_val{3};
	pct_1 = pct_val{3};
	output;

	
	name = '3';
	HH = hh_val{4};
	pct_1 = pct_val{4};
	output;

	name = '4';
	HH = hh_val{5};
	pct_1 = pct_val{5};
	output;

	name = '5';
	HH = hh_val{6};
	pct_1 = pct_val{6};
	output;


	
drop cqi0 cqi1-cqi5 pct1-pct6  ;
run;




data wip.cqi8;
array hh_val{5} 8  cqi_deb_Sum cqi_web_Sum cqi_bp_Sum cqi_DD_Sum cqi_odl_Sum  ;
array pct_val{5} 8 deb_pct  web_pct  bp_pct  dd_pct dl_pct;
length name $ 10;
set wip.cqi6;

	name = 'Debit';
	HH = hh_val{1};
	pct_1 = pct_val{1};
	output;

	
	name = 'Web';
	HH = hh_val{2};
	pct_1 = pct_val{2};
	output;

	name = 'Bill Pay';
	HH = hh_val{3};
	pct_1 = pct_val{3};
	output;

	
	name = 'Dir. Dep.';
	HH = hh_val{4};
	pct_1 = pct_val{4};
	output;

	name = 'Overdraft';
	HH = hh_val{5};
	pct_1 = pct_val{5};
	output;
	
drop  cqi_bp_Sum cqi_DD_Sum cqi_deb_Sum cqi_odl_Sum cqi_web_Sum hh_Sum dd_pct web_pct deb_pct dl_pct bp_pct ;
run;



data myxls.cqi_detail;
   set wip.cqi8;
run;

data myxls.cqi_score;
   set wip.cqi7;
run;

%end;
%end;

%end;

/*########################################################################################################################################################*/
/*Contrib*/
data wip.temp_hh;
set wip.temp (keep= hhid hh dda mms sav tda ira ins sec trs mtg heq card iln sln ind &class1);
run;

proc sort data=data.Contrib_&identifier;
by hhid;
run;

data wip.temp_contrib ;
merge  data.Contrib_&identifier (in=b) wip.temp_hh (in=a);
by hhid;
if a and b;
run;

%IF %SYSFUNC(EXIST(wip.temp_contrib)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_contrib));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(Close(&DSID));

Proc tabulate data=wip.temp_contrib out=wip.contr1;
class &class1;
var dda mms sav tda ira sec trs mtg ins heq card iln sln ind ins DDA_CON MMS_CON SAV_CON TDA_CON IRA_CON SEC_CON TRS_CON mtg_con heq_con card_con ILN_CON SLN_CON IND_con HH;
table  &class1, (sum)*(dda mms sav tda ira sec trs mtg heq card iln sln ind ins DDA_CON MMS_CON SAV_CON TDA_CON IRA_CON SEC_CON TRS_CON mtg_con heq_con card_con ILN_CON SLN_CON IND_con HH );
run;

data wip.contr2;
set wip.contr1 (drop=_TABLE_ _TYPE_ _PAGE_);

sdb_con_Sum = 0;
ins_con_sum = 0;
/*averages*/
dda_avg1 = divide(dda_con_sum,dda_sum);
sav_avg1 = divide(sav_con_sum,SAV_sum);
mms_avg1 = divide(mms_con_sum,MMS_sum);
ira_avg1 = divide(ira_con_sum,ira_sum);
tda_avg1 = divide(tda_con_sum,tda_sum);
sec_avg1 = divide(sec_con_sum,sec_sum);
ins_avg1 = divide(ins_con_sum,ins_sum);
trs_avg1 = divide(trs_con_sum,trs_sum);
mtg_avg1 = divide(mtg_con_sum,mtg_sum);
heq_avg1 = divide(heq_con_sum,heq_sum);
iln_avg1 = divide(iln_con_sum,iln_sum);
ind_avg1 = divide(ind_con_sum,ind_sum);
sln_avg1 = divide(sln_con_sum,sln_sum);
ccs_avg1 = divide(card_con_sum,card_sum);
sdb_avg1 = 0;

dda_avg2 = divide(dda_con_sum,hh_sum);
sav_avg2 = divide(sav_con_sum,hh_sum);
mms_avg2 = divide(mms_con_sum,hh_sum);
ira_avg2 = divide(ira_con_sum,hh_sum);
tda_avg2 = divide(tda_con_sum,hh_sum);
sec_avg2 = divide(sec_con_sum,hh_sum);
ins_avg2 = divide(ins_con_sum,hh_sum);
trs_avg2 = divide(trs_con_sum,hh_sum);
mtg_avg2 = divide(mtg_con_sum,hh_sum);
heq_avg2 = divide(heq_con_sum,hh_sum);
iln_avg2 = divide(iln_con_sum,hh_sum);
ind_avg2 = divide(ind_con_sum,hh_sum);
sln_avg2 = divide(sln_con_sum,hh_sum);
ccs_avg2 = divide(card_con_sum,hh_sum);
sdb_avg2 = 0;
run;


data wip.contr3;
length Product $ 20 HH 8   Avg_a 8 Avg_b 8;
array counts {15} 8 dda_sum mms_sum sav_sum tda_sum ira_sum sec_sum ins_sum trs_sum mtg_sum heq_sum ILN_sum ind_sum sln_sum card_sum sdb_sum;
array bals {15} 8 dda_con_sum mms_con_sum sav_con_sum tda_con_sum ira_con_sum sec_con_sum ins_con_sum trs_con_sum mtg_con_sum heq_con_sum 
                  ILN_con_sum ind_con_sum sln_con_sum ccs_con_sum sdb_con_sum;
array avg1 {15}  8 dda_avg1 mms_avg1 sav_avg1 tda_avg1 ira_avg1 sec_avg1 ins_avg1 trs_avg1 mtg_avg1 heq_avg1 ILN_avg1 ind_avg1 sln_avg1 ccs_avg1 sdb_avg1;
array avg2 {15} 8 dda_avg2 mms_avg2 sav_avg2 tda_avg2 ira_avg2 sec_avg2 ins_avg2 trs_avg2 mtg_avg2 heq_avg2 ILN_avg2 ind_avg2 sln_avg2 ccs_avg2 sdb_avg2;
Array Prod {15} $ 20 ('Checking' 'Money Market' 'Savings' 'Time Deposits' 'IRAs' 'Securities' 'Insurance' 'Trust' 'Mortgage' 'Home Equity' 
'Dir. Inst. Loan' 'Ind. Inst. Loan' 'Student Loan' 'Credit Card' 'Safe Deposit Box');
set wip.contr2;

do i=1 to 15;
   Product = Prod{i};
   HH = counts{i};
   Contribution = bals{i};
   Avg_a = avg1{i};
   Avg_b = avg2{i};
   output;
end;
   Product = 'Total';
   HH = hh_sum;
   Contribution = .;
   Avg_a = .;
   Avg_b = .;
   output;
keep &Class1 Product HH  Contribution Avg_a Avg_b;
run;


data myxls.contribution;
   set wip.contr3;
run;

%end;
%end;

/*########################################################################################################################################################*/
/*Web Transactions and Services*/
/* FOR WEB HH Only*/
data wip.temp_web ;
set wip.temp;
where WEB = 1;
	if web_signon ge 1 then web1 = 1; else web1 = 0;
    if bp_num ge 1 then bp1 = 1; else bp1 = 0;
    if sms_num ge 1 then sms1 = 1; else sms1 = 0;
	if wap_num ge 1 then wap1 = 1; else wap1 = 0;
    if fico_num ge 1 then fico1 = 1; else fico1 = 0;
	if fworks_num ge 1 then fworks1 = 1; else fworks1 = 0;
keep HHID HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num &class1 web1 bp1 sms1 wap1 fico1 fworks1; 
run;

%IF %SYSFUNC(EXIST(wip.temp_web)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_web));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(Close(&DSID));

Proc tabulate data=wip.temp_web out=wip.web1;
class &class1;
var HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num web1 bp1 sms1 wap1 fico1 fworks1;
table  &class1, (sum)*(HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num web1 bp1 sms1 wap1 fico1 fworks1);
run;

data wip.web2;
set wip.web1 (drop=_TABLE_ _TYPE_ _PAGE_);
	/*penetrations*/
	web_pct = divide(web_sum,hh_sum);
	bp_pct = divide(bp_sum,hh_sum);
	sms_pct = divide(sms_sum,hh_sum);
	wap_pct = divide(wap_sum,hh_sum);
	fico_pct = divide(fico_sum,hh_sum);
	fworks_pct = divide(fworks_sum,hh_sum);
	estat_pct = divide(estat_sum,hh_sum);
	edeliv_pct = divide(edeliv_sum,hh_sum);
	/*avg trans*/
	web_avg1 = divide(web_signon_sum,web_sum);
	bp_avg1 = divide(bp_num_sum,bp_sum);
	sms_avg1 = divide(sms_num_sum,sms_sum);
	wap_avg1 = divide(wap_num_sum,wap_sum);
	fico_avg1 = divide(fico_num_sum,fico_sum);
	fworks_avg1 = divide(fworks_num_sum,fworks_sum);
	estat_avg1 = .;
	edeliv_avg1 = .;
	/*avg amt*/
	web_avg2 = .;
	bp_avg2 = divide(bp_amt_sum,bp_sum);
	sms_avg2 = .;
	wap_avg2 = .;
	fico_avg2 = .;
	fworks_avg2 = .;
	estat_avg2 = .;
	edeliv_avg2 = .;
	/*active, if enrolled did they had activity, for vpos, mpos, atm, br_tr and vru assume all are enrolled*/
	web_pct2 = divide(web1_sum,hh_sum);
	bp_pct2 = divide(bp1_sum,hh_sum);
	sms_pct2 = divide(sms1_sum,hh_sum);
	wap_pct2 = divide(wap1_sum,hh_sum);
	fico_pct2 = divide(fico1_sum,hh_sum);
	fworks_pct2 = divide(fworks1_sum,hh_sum);
	estat_pct2 = .;
	edeliv_pct2 = .;
run;


data wip.web3;
length Name $ 20 HH 8 Penetration 8 Active 8 Avg_a 8 Avg_b 8;
array counts {8} 8 web_Sum bp_Sum WAP_Sum SMS_Sum edeliv_Sum estat_Sum fico_Sum FWorks_Sum;
array pcts {8} 8 web_pct bp_pct sms_pct wap_pct fico_pct fworks_pct estat_pct edeliv_pct ;
array pcts2 {8} 8 web_pct2 bp_pct2 sms_pct2 wap_pct2 fico_pct2 fworks_pct2 estat_pct2 edeliv_pct2 ;
array avg1 {8}  8 web_avg1 bp_avg1 sms_avg1 wap_avg1 fico_avg1 fworks_avg1 estat_avg1 edeliv_avg1;
array avg2 {8} 8 web_avg2 bp_avg2 sms_avg2 wap_avg2 fico_avg2 fworks_avg2 estat_avg2 edeliv_avg2;
Array Prod {8} $ 20 ('Web Banking' 'Bill Pay' 'Text Banking' 'Mobile Banking' 'FICO Score' 'Finance Works' 'e Statements' 'e Delivery');
set wip.web2;

do i=1 to 8;
   Name = Prod{i};
   HH = counts{i};
   Penetration = pcts{i};
   Active = pcts2{i};
   Avg_a = avg1{i};
   Avg_b = avg2{i};
   output;
end;
   Name = 'Total';
   HH = hh_sum;
   Penetration = .;
   Active = .;
   Avg_a = .;
   Avg_b = .;
   output;
keep &Class1 Name HH  Penetration Active Avg_a Avg_b;
run;



data myxls.web_svcs;
   set wip.web3;
run;
%end;
%end;
/*########################################################################################################################################################*/
/*Transactions and Services*/
/* FOR CHK HH Only*/
data wip.temp_tran ;
set wip.temp;
where DDA = 1;

	if VPOS_NUM ge 1 then VPOS = 1; else VPOS = 0;
	if MPOS_NUM ge 1 then MPOS = 1; else MPOS = 0;
	if ATMO_NUM ge 1 then ATMO = 1; else ATMO = 0;
	if ATMT_NUM ge 1 then ATMT = 1; else ATMT = 0;
	if BR_TR_NUM ge 1 then BR_TR = 1; else BR_TR = 0;
	if vru_NUM ge 1 then VRU = 1; else VRU = 0;
    if web_signon ge 1 then web1 = 1; else web1 = 0;
    if bp_num ge 1 then bp1 = 1; else bp1 = 0;
    if sms_num ge 1 then sms1 = 1; else sms1 = 0;
	if wap_num ge 1 then wap1 = 1; else wap1 = 0;
    if fico_num ge 1 then fico1 = 1; else fico1 = 0;
	if fworks_num ge 1 then fworks1 = 1; else fworks1 = 0;
	if chk_num ge 1 then chk1 = 1; else chk1 = 0;

keep HHID HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num chk_num cqi_dd
VPOS_AMT vpos_num mpos_amt mpos_num ATMO_AMT ATMO_NUM ATMT_AMT ATMT_NUM BR_TR_NUM BR_TR_amt VRU_NUM &class1 dd_amt
vpos mpos atmo atmt br_tr vru web1 bp1 sms1 wap1 fico1 fworks1 chk1; 
run;


%IF %SYSFUNC(EXIST(wip.temp_tran)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_tran));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(Close(&DSID));

Proc tabulate data=wip.temp_tran out=wip.tran1;
class &class1;
var HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num chk_num cqi_dd
    VPOS_AMT vpos_num mpos_amt mpos_num ATMO_AMT ATMO_NUM ATMT_AMT ATMT_NUM BR_TR_NUM BR_TR_amt VRU_NUM
    vpos mpos atmo atmt br_tr vru web1 bp1 sms1 wap1 fico1 fworks1 chk1 dd_amt;
table  &class1, (sum)*(HH web bp WAP SMS edeliv estat fico FWorks web_signon BP_NUM BP_AMT SMS_NUM WAP_NUM fico_num fworks_num chk_num cqi_dd
                       VPOS_AMT vpos_num mpos_amt mpos_num ATMO_AMT ATMO_NUM ATMT_AMT ATMT_NUM BR_TR_NUM BR_TR_amt VRU_NUM
                       vpos mpos atmo atmt br_tr vru web1 bp1 sms1 wap1 fico1 fworks1 chk1 dd_amt);
run;




data wip.tran2;
set wip.tran1 (drop=_TABLE_ _TYPE_ _PAGE_);
	/*penetrations*/
	web_pct = divide(web_sum,hh_sum);
	bp_pct = divide(bp_sum,hh_sum);
	sms_pct = divide(sms_sum,hh_sum);
	wap_pct = divide(wap_sum,hh_sum);
	fico_pct = divide(fico_sum,hh_sum);
	fworks_pct = divide(fworks_sum,hh_sum);
	estat_pct = divide(estat_sum,hh_sum);
	edeliv_pct = divide(edeliv_sum,hh_sum);
	vpos_pct = .;
	mpos_pct = .;
	atmo_pct = .;
	atmt_pct = .;
	br_tr_pct = .;
	vru_pct = .;
	chk_pct = .;
	dd_pct = .;
	/*avg trans*/
	web_avg1 = divide(web_signon_sum,web_sum);
	bp_avg1 = divide(bp_num_sum,bp_sum);
	sms_avg1 = divide(sms_num_sum,sms_sum);
	wap_avg1 = divide(wap_num_sum,wap_sum);
	fico_avg1 = divide(fico_num_sum,fico_sum);
	fworks_avg1 = divide(fworks_num_sum,fworks_sum);
	estat_avg1 = .;
	edeliv_avg1 = .;
	vpos_avg1 = divide(vpos_num_sum,vpos_sum);
	mpos_avg1 = divide(mpos_num_sum,mpos_sum);
	atmo_avg1 = divide(atmo_num_sum,atmo_sum);
	atmt_avg1 = divide(atmt_num_sum,atmt_sum);
	br_tr_avg1 = divide(br_tr_num_sum,br_tr_sum);
	vru_avg1 = divide(vru_num_sum,vru_sum);
	chk_avg1 = divide(chk_num_sum,chk1_sum);
	dd_avg1 = .;
	/*avg amt*/
	web_avg2 = .;
	bp_avg2 = divide(bp_amt_sum,bp_sum);
	sms_avg2 = .;
	wap_avg2 = .;
	fico_avg2 = .;
	fworks_avg2 = .;
	estat_avg2 = .;
	edeliv_avg2 = .;
	vpos_avg2 = divide(vpos_amt_sum,vpos_sum);
	mpos_avg2 = divide(mpos_amt_sum,mpos_sum);
	atmo_avg2 = divide(atmo_amt_sum,atmo_sum);
	atmt_avg2 = divide(atmt_amt_sum,atmt_sum);
	br_tr_avg2 = divide(br_tr_amt_sum,br_tr_sum);
	vru_avg2 = 0;
	chk_avg2 = .;
	dd_avg2 = divide(dd_amt_sum,cqi_dd_sum);
	/*active, if enrolled did they had activity, for vpos, mpos, atm, br_tr and vru assume all are enrolled*/
	web_pct2 = divide(web1_sum,hh_sum);
	bp_pct2 = divide(bp1_sum,hh_sum);
	sms_pct2 = divide(sms1_sum,hh_sum);
	wap_pct2 = divide(wap1_sum,hh_sum);
	fico_pct2 = divide(fico1_sum,hh_sum);
	fworks_pct2 = divide(fworks1_sum,hh_sum);
	estat_pct2 = .;
	edeliv_pct2 = .;
	vpos_pct2 = divide(vpos_sum,hh_sum);
	mpos_pct2 = divide(mpos_sum,hh_sum);
	atmo_pct2 = divide(atmo_sum,hh_sum);
	atmt_pct2 = divide(atmt_sum,hh_sum);
	br_tr_pct2 = divide(br_tr_sum,hh_sum);
	vru_pct2 = divide(vru_sum,hh_sum);
	chk_pct2 = divide(chk1_sum,hh_sum);
	dd_pct2 = divide(cqi_dd_sum,hh_Sum);
run;

data wip.tran3;
length Name $ 20 HH 8 Penetration 8 Active 8 Avg_Tr 8 Avg_Amt 8 ;
array counts {16} 8 web_Sum bp_Sum SMS_Sum WAP_Sum fico_Sum FWorks_Sum estat_Sum edeliv_Sum vpos_sum mpos_sum atmo_sum atmt_sum br_tr_sum vru_sum chk1_sum cqi_dd_sum;
array pcts {16} 8 web_pct bp_pct sms_pct wap_pct fico_pct fworks_pct estat_pct edeliv_pct vpos_pct mpos_pct atmo_pct atmt_pct br_tr_pct vru_pct chk_pct dd_pct;
array pcts2 {16} 8 web_pct2 bp_pct2 sms_pct2 wap_pct2 fico_pct2 fworks_pct2 estat_pct2 edeliv_pct2 vpos_pct2 mpos_pct2 atmo_pct2 atmt_pct2 br_tr_pct2 vru_pct2 chk_pct2 dd_pct2;
array avg1 {16}  8 web_avg1 bp_avg1 sms_avg1 wap_avg1 fico_avg1 fworks_avg1 estat_avg1 edeliv_avg1 vpos_avg1 mpos_avg1 atmo_avg1 atmt_avg1 br_tr_avg1 vru_avg1 chk_avg1 dd_avg1;
array avg2 {16} 8 web_avg2 bp_avg2 sms_avg2 wap_avg2 fico_avg2 fworks_avg2 estat_avg2 edeliv_avg2 vpos_avg2 mpos_avg2 atmo_avg2 atmt_avg2 br_tr_avg2 vru_avg2 chk_avg2 dd_avg2;
Array Prod {16} $ 20 ('Web Banking' 'Bill Pay' 'Text Banking' 'Mobile Banking' 'FICO Score' 'Finance Works' 'e Statements' 'e Delivery' 
                      'Signature Debit' 'PIN Debit' 'M&T ATM' 'Other ATM' 'Branch' 'VRU' 'Checks' 'Direct Deposit');
set wip.tran2;

do i=1 to 16;
   Name = Prod{i};
   HH = counts{i};
   Penetration = pcts{i};
   Active = pcts2{i};
   Avg_tr = avg1{i};
   Avg_amt = avg2{i};
   output;
end;
   Name = 'Total';
   HH = hh_sum;
   Penetration = .;
   Active = .;
   Avg_tr = .;
   Avg_Amt = .;
   output;
keep &Class1 Name HH  Penetration Active Avg_tr Avg_Amt;
run;



data myxls.trans;
   set wip.tran3;
run;

%end;
%end;

/*########################################################################################################################################################*/
/*Wealth*/
data wip.temp_wealth;
set wip.temp;
length wealth $ 15;
    where ixi_tot ne .;
	x = max(ixi_tot,sum(dda_amt,sav_amt,tda_amt,ira_amt,mms_amt,sec_amt));
	select;
		when (x ge 0 and x lt 25000) wealth='Up to 25M';
		when (x ge 25000 and x lt 100000) wealth='25-100M'; 
		when (x ge 100000 and x lt 250000) wealth='100-250M'; 
		when (x ge 250000 and x lt 500000) wealth='250-500M'; 
		when (x ge 500000 and x lt 1000000) wealth='500M-1M'; 
		when (x ge 1000000 and x lt 2000000) wealth='1-2MM';
		when (x ge 2000000 and x lt 3000000) wealth='2-3MM';
		when (x ge 3000000 and x lt 4000000) wealth='3-4MM'; 
		when (x ge 4000000 and x lt 5000000) wealth='4-5MM';
		when (x ge 5000000 and x lt 10000000) wealth='5-10MM';
	 	when (x ge 10000000 and x lt 15000000) wealth='10-15MM';
		when (x ge 15000000 and x lt 20000000) wealth='15-20MM';
		when (x ge 20000000 and x lt 25000000) wealth='20-25MM';
		when (x ge 25000000 ) wealth='25MM+'; 
		otherwise wealth='XXX';
	end;
drop x;
run;

%IF %SYSFUNC(EXIST(wip.temp_wealth)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_wealth));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(Close(&DSID));

PROC SQL;
create table wip.class as 
SELECT *
FROM data.wealth_class, data.&class1._class
;
QUIT;

Proc tabulate data=wip.temp_wealth out=wip.wealth1 (drop=_PAGE_ _TYPE_ _TABLE_) missing classdata=wip.class exclusive;
class wealth &class1;
var hh  ;
keylabel N='Count';
table  (wealth), (&class1)*(N) ;
run;

data wip.wealth2;
length type $ 1;
set wip.wealth1;
type=vtype(&class1);
if type = 'N' then do;
	if (&class1 eq .) then do;
		&class1 = 99;
	end;
end;
else do;
	if (&class1 eq '') then do;
		&class1 = '99';
	end;
end;
if wealth eq '' then do;
	wealth = '99';
end;
if N eq . then do;
	N = 0;
end;
drop type;
run;

proc sort data=wip.wealth2;
by &class1 wealth;
run;

proc transpose data=wip.wealth2 out=wip.wealth3 (drop=_NAME_) prefix = Wealth_ ;
by &class1 ;
id wealth;
run;


data wip.wealth4;
set wip.wealth3;
retain tot;
array wealth_val{14} Wealth_Up_to_25M Wealth_25_100M Wealth_100_250M  Wealth_250_500M Wealth_500M_1M 
                     Wealth_1_2MM Wealth_2_3MM Wealth_3_4MM Wealth_4_5MM Wealth_5_10MM Wealth_10_15MM 
                     Wealth_15_20MM Wealth_20_25MM Wealth_25MM_   ;   
array pct{14};
tot=0;
do i = 1 to 14;
	tot = tot+wealth_val{i};
end;
do j = 1 to 14;
	if tot ne 0 then do;
	   pct{j} = wealth_val{j}/tot;
	end;
	else do;
		pct{j} = 0;
	end;
end;
output;
drop i j tot;
run;

data wip.wealth5;
length band1 $ 20 N 8 percent 8;
set wip.wealth4;
retain tot;
array wealth_val{14} Wealth_Up_to_25M Wealth_25_100M Wealth_100_250M  Wealth_250_500M Wealth_500M_1M 
                     Wealth_1_2MM Wealth_2_3MM Wealth_3_4MM Wealth_4_5MM Wealth_5_10MM Wealth_10_15MM 
                     Wealth_15_20MM Wealth_20_25MM Wealth_25MM_   ;   
array pct_val{14} pct:  ; 
array name{14} $ 20 ('<25M' '25 to 100M' '100 to 250M' '250 to 500M' '500M to 1MM' '1 to 2MM' '2 to 3MM' '3 to 4MM' '4 to 5MM'
                     '5 to 10MM' '10 to 15MM' '15 to 20MM' '20 to 25MM' '25MM+'); 
tot = 0;
do i = 1 to 14;
    band1 = Name{i};
	N = wealth_val{i};
	percent = pct_val{i};
	tot=tot+N;
    output;
end;
    band1 = 'Total';
	N = tot;
	percent = 1;
    output;
	return;
keep band1 N percent &class1 i;
run;




data myxls.wealth;
   set wip.wealth5;
run;

%end;
%end;

/*########################################################################################################################################################*/
/*CLV*/


data wip.temp_clv;
set wip.temp;
where clv_total ne .;
keep hhid hh clv_total clv_rem clv_rem_ten &class1;
run;

%IF %SYSFUNC(EXIST(wip.temp_clv)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_clv));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(Close(&DSID));


Proc tabulate data=wip.temp_clv out=wip.clv1 (drop=_PAGE_ _TYPE_ _TABLE_) missing classdata=data.&class1._class exclusive;
class &class1;
var hh clv_total clv_rem clv_rem_ten ;
keylabel N='Count';
table   (&class1),(HH clv_total clv_rem clv_rem_ten) ;
run;

data wip.clv2;
set wip.clv1;

avg_clv = divide(clv_total_sum,hh_sum);
avg_rem = divide(clv_rem_sum,hh_sum);
avg_ten = divide(clv_rem_ten_sum,hh_sum);
run;

data myxls.clv;
   set wip.clv2;
run;

%end;
%end;

libname myxls clear;

ods pdf file="C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&out_file._radar.pdf";
/*goptions hsize=6 in vsize= 3.5in;*/
title1 Analysis by &Title. (&identifier.);
title2 'Product Penetration';

axis3 order=0 to 1 by 0.25 major=none minor=none ;
axis4 order=0 to 1 by 0.25 major=none minor=none value=None;
%radar_chart (analysis_var=Penetration,group_var=Product,class_var=&class1,table=prod3,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4
axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4);

title2 'Segments';
axis3 major=none minor=none ;
axis4 major=none minor=none value=None;
%radar_chart (analysis_var=pct_1,group_var=name,class_var=&class1,table=Seg5,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4
axis4 axis4 );

title2 'Profit Band';
axis3 major=none minor=none ;
axis4 major=none minor=none value=None;
%radar_chart (analysis_var=pct_1,group_var=band_name,class_var=&class1,table=band5,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4);

title2 'CQI Score';
axis3 major=none minor=none label=(f="Arial/Bold" "CQI Score");
axis4 major=none minor=none value=None;
%radar_chart (analysis_var=pct_1,group_var=name,class_var=&class1,table=cqi7,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4
axis4 );

title2 'CQI Elements';
axis3 major=none minor=none order=0 to 1 by 0.25;
axis4 major=none minor=none order=0 to 1 by 0.25 value=None;
%radar_chart (analysis_var=pct_1,group_var=name,class_var=&class1,table=cqi8,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4);

title2 'Estimated Wealth';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=percent,group_var=band1,class_var=&class1,table=wealth5,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4
axis4 axis4 axis4 axis4 axis4);

title2 'Transaction Penetration (CHK HHs)';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=Penetration,group_var=Name,class_var=&class1,table=tran3,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4
axis4 axis4 axis4 axis4 axis4 axis4 axis4);

title2 'Transaction Incidence (CHK HHs)';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=Active,group_var=Name,class_var=&class1,table=tran3,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4
axis4 axis4 axis4 axis4 axis4 axis4 axis4);

title2 'Service Enrollment (Web HHs)';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=Penetration,group_var=Name,class_var=&class1,table=web3,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 );

title2 'Service Activity (Y/N) (Web HHs)';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=Active,group_var=Name,class_var=&class1,table=web3,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 );


title2 'Markets';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=pct_1,group_var=mkt_num,class_var=&class1,table=mkt6,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 axis4 axis4 );

title2 'CBRs';
axis3 major=none minor=none ;
axis4 major=none minor=none  value=None;
%radar_chart (analysis_var=pct_1,group_var=cbr_num,class_var=&class1,table=cbr5,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4
axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4);

quit;
ods pdf close;

/*#########################################*/

ods pdf file="C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&out_file._bars.pdf";
title2 'Product Penetration';

data wip.chart_data;
set wip.prod3;
where Product ne 'Total' and Product ne 'Trust';
run;


axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Product Penetration") order=(0 to 1 by 0.25)  split=" " ;
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split=" " value=(h=7pt) order=('DDA' 'MMS' 'SAV' 'TDA' 'IRA' 'SEC' 'INS' 'MTG' 'HEQ' 'ILN' 'IND' 'Card' 'SLN' 'SDB') 
color=black label=NONE;
legend1 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=(&Title position=(top center));
%vbar_grouped (analysis_var=Penetration,group_var=Product,class_var=&class1,table=chart_data,title_str=&title,value_format=Percent6.0,group_format=$PTYPE.);

title2 'Avg. Product Balances Per Product HH';
axis1 minor=none color=black label=(a = 90 f="Arial/Bold" "Avg. Balance")  split=" " ;
%vbar_grouped (analysis_var=Avg_a,group_var=Product,class_var=&class1,table=chart_data,title_str=&title,value_format=dollar14.,group_format=$PTYPE.);

data wip.chart_data;
set wip.contr3;
where Product ne 'Total' and Product ne 'Trust';
run;

title2 'Avg. Product Contr Per Total HH';
axis1 minor=None  color=black label=(a=90 f="Arial/Bold" "Avg. Contrib Tot HH") split=" ";
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split=" " value=(h=7pt) order=('DDA' 'MMS' 'SAV' 'TDA' 'IRA' 'SEC' 'INS' 'MTG' 'HEQ' 'ILN' 'IND' 'Card' 'SLN' 'SDB') ;
%vbar_grouped (analysis_var=Avg_b,group_var=Product,class_var=&class1,table=chart_data,title_str=&title,value_format=dollar8.2,group_format=$PTYPE.);



title2 'Segments';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Avg. % of HHs") order=(0 to 1 by 0.25);
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split=" " value=(h=8pt) color=black label=NONE;
%vbar_grouped (analysis_var=pct_1,group_var=name,class_var=&class1,table=seg5,title_str=&title,value_format=Percent8.1,group_format=);


axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE  ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=(&Title position=(top center));
/*legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));*/
%vbar_stacked (analysis_var=HH,group_var=&class1,class_var=seg_num,table=seg5,title_str=&title,value_format=Percent8.1,group_format=segfmt.,
midpts='Building their Future' 'Mainst Fam' 'Mass Affl No Kids' 'Mass Affl Fam' 'Mainst Ret' 'Mass Affl Ret' 'Unknown');

title2 'Profit Band';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% of HHs") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=9pt) label=none value=none;
axis3 split=" " value=(h=8pt) color=black label=NONE;
%vbar_grouped (analysis_var=pct_1,group_var=band_name,class_var=&class1,table=Band5,title_str=&title,value_format=Percent8.1,group_format=);

axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none;
axis3 split=" " value=(h=8pt) color=black label=NONE  ;
%vbar_stacked (analysis_var=HH,group_var=&class1,class_var=band_name,table=band5,title_str=&title,value_format=Percent8.1,group_format=$CHAR1.,
midpts='A' 'B' 'C' 'D' 'E');



title2 'CQI Score';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% of HHs") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE;
%vbar_grouped (analysis_var=pct_1,group_var=name,class_var=&class1,table=cqi7,title_str=&title,value_format=Percent8.1,group_format=);

axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE;
%vbar_stacked (analysis_var=HH,group_var=&class1,class_var=name,table=CQI7,title_str=&title,value_format=Percent8.1,group_format=$CHAR1.,
midpts='0' '1' '2' '3' '4' '5');


axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("CQI Score" position=(top center));
%vbar_stacked2 (analysis_var=HH,group_var=NAME,class_var=&class1,table=CQI7,title_str=&title,value_format=Percent8.1,group_format=,
midpts=);



title2 'CQI Elements';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% of HHs") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=9pt) label=none value=none;
axis3 split=" " value=(h=8pt) color=black label=NONE;
%vbar_grouped (analysis_var=pct_1,group_var=name,class_var=&class1,table=cqi8,title_str=&title,value_format=Percent8.1,group_format=);

axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=(&Title position=(top center));
/*legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));*/
%vbar_stacked (analysis_var=HH,group_var=&class1,class_var=name,table=CQI8,title_str=&title,value_format=Percent8.1,group_format=$CHAR10.,
midpts='Debit' 'Web' 'Bill Pay' 'Dir. Dep.' 'Overdraft');




title2 'Estimated Wealth';

data wip.chart_data;
set wip.wealth5;
where i ne 15;
run;

axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% of HHs") order=(0 to 1 by 0.25);
axis2 split=" " value=(h=9pt) label=none value=none;
axis3 order=('<25M' '25 to 100M' '100 to 250M' '250 to 500M' '500M to 1MM' '1 to 2MM' '2 to 3MM' '3 to 4MM' '4 to 5MM'
                     '5 to 10MM' '10 to 15MM' '15 to 20MM' '20 to 25MM' '25MM+') split=" " value=(h=8pt) color=black label=NONE;
%vbar_grouped (analysis_var=percent,group_var=band1,class_var=&class1,table=wealth5,title_str=&title,value_format=Percent8.1,group_format=);

axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE;
%vbar_stacked (analysis_var=N,group_var=&class1,class_var=i,table=chart_data,title_str=&title,value_format=Percent8.1,group_format=wealthfmt.,
midpts='<25M' '25 to 100M' '100 to 250M' '250 to 500M' '500M to 1MM' '1 to 2MM' '2 to 3MM' '3 to 4MM' '4 to 5MM' 
'5 to 10MM' '10 to 15MM' '15 to 20MM' '20 to 25MM' '25MM+');


data wip.chart_data;
set wip.tran3;
where Name ne 'Total';
run;

title2 'Transaction Penetration (CHK HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Enrollment CHK HHs") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split=" " value=(h=7pt) ORDER=('Web Banking' 'Bill Pay' 'Text Banking' 'Mobile Banking' 'FICO Score' 'Finance Works' 'e Statements' 'e Delivery' 
                      'Signature Debit' 'PIN Debit' 'M&T ATM' 'Other ATM' 'Branch' 'VRU' 'Checks' 'Direct Deposit') color=black label=NONE;
%vbar_grouped (analysis_var=Penetration,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=Percent8.1,group_format=);


title2 'Transaction Incidence (CHK HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% Active CHK HHs") split=" ";
%vbar_grouped (analysis_var=Active,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=Percent8.1,group_format=);

title2 'Avg. Tran Volume (CHK HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Avg. Trans CHK HHs") split=" ";
%vbar_grouped (analysis_var=Avg_Tr,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=Comma8.1,group_format=);

title2 'Avg. Tran Amt (CHK HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Avg. Amt CHK HHs") ;
%vbar_grouped (analysis_var=Avg_Amt,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=dollar12.0,group_format=);

data wip.chart_data;
set wip.web3;
where name ne 'Total';
run;

title2 'Service Enrollment (Web HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Enrollment Web HHs") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split=" " value=(h=7pt) ORDER=('Web Banking' 'Bill Pay' 'Text Banking' 'Mobile Banking' 'FICO Score' 'Finance Works' 'e Statements' 'e Delivery')
 color=black label=NONE;
%vbar_grouped (analysis_var=Penetration,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=Percent8.1,group_format=);

title2 'Service Activity (Y/N) (Web HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% Active Web HHs") split=" ";
%vbar_grouped (analysis_var=Active,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=Percent8.1,group_format=);

title2 'Avg. Tran Volume (Web HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Avg. Trans Web HHs") split=" ";
%vbar_grouped (analysis_var=Avg_a,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=Comma8.1,group_format=);

title2 'Avg. Tran Amt (Web HHs)';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Avg. Amt Web HHs") split=" ";
%vbar_grouped (analysis_var=Avg_b,group_var=Name,class_var=&class1,table=chart_data,title_str=&title,value_format=dollar12.0,group_format=);


title2 'Markets';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% HHS") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split="/" value=(h=7pt) order = ('WNY' 'Ctl NY/E PA' 'Estrn/Metro' 'Ctl PA/W MD' 'G Balt' 'G Wash' 'G Del' 'Out of Mkt') color=black label=NONE;
%vbar_grouped (analysis_var=pct_1,group_var=mkt_num,class_var=&class1,table=mkt6,title_str=&title,value_format=percent8.1,group_format=$mktfmt.);

axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE;
/*legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));*/
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=(&Title position=(top center));
%vbar_stacked (analysis_var=HH,group_var=&class1,class_var=mkt_num,table=mkt6,title_str=&title,value_format=Percent8.1,group_format=$mktfmt.,
midpts='WNY' 'Ctl NY/E PA' '‚Estrn/Metro' 'Ctl PA/W MD' 'G Balt' 'G Wash' 'G Del' 'Out of Mkt' );

title2 'CBRs';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% HHS") split=" " order=(0 to 1 by 0.25);
axis2 split=" " value=(h=7pt) label=none value=none;
axis3 split=" " value=(h=7pt) order = ('WNY' 'Roch' 'Ctl NY' 'S NY' 'Alb/HVN' 'Tarry' 'NYC' 'Philly' 'PA N' 'C&W PA' 'SE PA' 'Balt' 'G Wash' 
'Ches A' 'Ches B' 'Ctl VA' 'Ches DE' 'Out of Mkt') color=black label=NONE;
%vbar_grouped (analysis_var=pct_1,group_var=cbr_num,class_var=&class1,table=cbr5,title_str=&title,value_format=percent8.1,group_format=$cbrfmt.);

axis1  label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE ('WNY' 'Roch' 'Ctl NY' 'S NY' 'Alb/HVN' 'Tarry' 'NYC' 'Philly' 'PA N' 'C&W PA' 'SE PA' 'Balt' 'G Wash' 
'Ches A' 'Ches B' 'Ctl VA' 'Ches DE' 'Out of Mkt');
%vbar_stacked1 (analysis_var=HH,group_var=&class1,class_var=cbr_num,table=cbr5,title_str=&title,value_format=Percent8.1,group_format=$cbrfmt.,
midpts='WNY' 'Roch' 'Ctl NY' 'S NY' 'Alb/HVN' 'Tarry' 'NYC' 'Philly' 'PA N' 'C&W PA' 'SE PA' 'Balt' 'G Wash' 
'Ches A' 'Ches B' 'Ctl VA' 'Ches DE' 'Out of Mkt');


title2 'Total CLV';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% HHS") split=" ";
axis2 label=(f="Arial/Bold" "Average Total CLV") value=none color=black;
proc gchart data=wip.clv2 ;
vbar &class1 / subgroup=&class1 type=sum sumvar=avg_clv outside=sum
raxis=axis1 maxis=axis2 noframe legend=legend1;
format avg_clv dollar12.;
run;


title2 'Remaining CLV';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% HHS") split=" ";
axis2 label=(f="Arial/Bold" "Average Remainign CLV") value=none color=black;
proc gchart data=wip.clv2 ;
vbar &class1 / subgroup=&class1 type=sum outside=sum sumvar=avg_rem
raxis=axis1 maxis=axis2 noframe legend=legend1;
format avg_rem dollar12.;
run;

title2 'Remaining Tenure';
axis1 minor=none color=black label=(a=90 f="Arial/Bold" "% HHS") split=" ";
axis2 label=(f="Arial/Bold" "Average Remaining Tenure") value=none color=black ;
proc gchart data=wip.clv2 ;
vbar &class1 / type=sum sumvar=avg_ten outside=sum subgroup=&class1
raxis=axis1 maxis=axis2 noframe legend=legend1;
format avg_ten comma5.1;
run;
quit;

ods pdf close;
ods html;

/* CLEAN AFTER MYSELF */
%if &clean eq 1 %then %do;
	PROC DATASETS LIB = wip; 
	delete CBR1-CBR5 BAND1-BAND5 CLASS CONTR1-CONTR3 CQI1-CQI8 TRAN1-TRAN3 WEB1-WEb3 MKT1-MKT6 PROD1-PROD3 SEG1-SEG5 TEMP TEMP_CLV
    TEMP_TRAN TEMP_WEB TEMP_CONTRIB TEMP_HH TEMP_WEALTH TEMP_CQI WEALTH1-WEALTH5 CLV1-CLV3 chart_data;
	QUIT;
	RUN;
%end;

%let dtend=%sysfunc(datetime(), datetime18.);
%put Execution Started at: &dtStart;
%put Execution Stopped at: &dtend;

%end;
/* end of the execution if we had the class table */
%else %do;
/*generate error message */
%PUT THERE IS NO CLASS DATASET FOR CLASS VARIABLE;
ods html;
%quit:

ods html;
%let dtend=%sysfunc(datetime(), datetime18.);
%put Execution Started at: &dtStart;
%put Execution Stopped at: &dtend;
%end;
%mend;



%macro bar_chart (analysis_var=,group_var=,class_var=,table=,title_str=,format_name=) / store source des='create bar chart macro';
proc gchart data=wip.&table ;
vbar &group_var / outside = sum type=sum sumvar=&analysis_var
raxis=axis1 maxis=axis2 noframe;
format &analysis_var &format_name;
by &class_var;
run;
%mend;

%macro hbar_chart (analysis_var=,group_var=,class_var=,table=,title_str=,format_name=) / store source des='create hbar chart macro';
proc gchart data=wip.&table ;
hbar &group_var / type=sum sumvar=&analysis_var
raxis=axis1 maxis=axis2 noframe
group= &class_var;
format &analysis_var &format_name;
run;
%mend;

%macro radar_chart (analysis_var=,group_var=,class_var=,table=,format_name=,cond=, axis_str=) / store source des='create radar chart macro';
proc gradar data=wip.&table (where=(&group_var &Cond ));
chart &Group_Var / sumvar=&analysis_var overlayvar=&Class_var
staraxis=(&axis_str)
starcircles=(0.5 1.0)
cstarcircles=ltgray;
format &analysis_var &format_name;
run;
%mend;

%let class2=virtual_seg;
%let identifier=201111;

%macro make_class (class2=, identifier=) / store source des='Create class table';

proc freq data=data.main_&identifier;
table &class2 / nofreq nocum nocol nopercent out=temp.&class2._class; 
run;

data data.&class2._class;
set temp.&class2._class;
keep &class2;
run;

%mend;

%macro hbar_grouped (analysis_var=,group_var=,class_var=,table=,title_str=,format_name=) / store source des='create hbar grouped chart macro';
proc gchart data=wip.&table ;
hbar &class_var / type=sum sumvar=&analysis_var
noframe
group= &group_var
gspace = 3 
raxis = axis1 maxis=axis2 gaxis = axis3
subgroup=&class_var
legend=legend1
autoref clipref cref=graybb;
format &analysis_var &format_name;
run;
%mend;

%macro vbar_grouped (analysis_var=,group_var=,class_var=,table=,title_str=,value_format=,group_format=) / store source des='create vbar group chart macro';
proc gchart data=wip.&table ;
vbar &class_var / type=sum sumvar=&analysis_var
noframe outside=sum subgroup=&class_var
group= &group_var
gspace = 3 
raxis = axis1 maxis=axis2 gaxis = axis3
/*PATTERNID=MIDPOINT*/
legend=legend1
autoref clipref cref=graybb;
format &analysis_var &value_format &group_var &group_format;
run;
%mend;

%macro vbar_stacked (analysis_var=,group_var=,class_var=,table=,title_str=,value_format=,group_format=,midpts=) / store source des='create vbar group chart macro';
proc gchart data=wip.&table ;
vbar &class_var / freq=&analysis_var type=percent  
noframe inside=SUBPCT g100  subgroup=&group_var group=&class_var
gspace = 2 width=10
raxis = axis1 maxis=axis2 gaxis=axis3 nozeros
midpoints = &midpts
legend=legend2;
format  &class_var &group_format;
run;
%mend;

%macro vbar_stacked2 (analysis_var=,group_var=,class_var=,table=,title_str=,value_format=,group_format=,midpts=) / store source des='create vbar group chart macro';
proc gchart data=wip.&table ;
vbar &class_var / freq=&analysis_var type=percent  
noframe inside=SUBPCT g100  subgroup=&group_var group=&class_var
gspace = 2 width=10
raxis = axis1 maxis=axis2 gaxis=axis3 nozeros
/*midpoints = &midpts*/
legend=legend2;
/*format  &class_var &group_format;*/
run;
%mend;

%macro vbar_stacked1 (analysis_var=,group_var=,class_var=,table=,title_str=,value_format=,group_format=,midpts=) / store source des='create vbar group chart macro';
proc gchart data=wip.&table ;
vbar &class_var / freq=&analysis_var type=percent  
noframe inside=SUBPCT g100  subgroup=&group_var group=&class_var
gspace = 1 width=10
raxis = axis1 maxis=axis2 gaxis=axis3 nozeros
/*midpoints = &midpts*/
legend=legend2;
format  &class_var &group_format;
run;
%mend;

/*axis3 order=0 to 1 by 0.25 major=none minor=none;*/
/*axis4 order=0 to 1 by 0.25 major=none minor=none value=None;*/
/*%radar_chart (analysis_var=Penetration,group_var=Product,class_var=Web_band,table=prod3,format_name=Percent8.1,cond=ne 'Total',axis_str=axis3 axis4 axis4 axis4 axis4*/
/*axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4);*/

/*axis1;*/
/*axis2;*/

/*ods pdf file="C:\LAYOUT1.pdf";*/
/*axis2 label=(f="Arial/Bold" "Product") split=" ";*/
/*axis1 major=None minor=NOne color=grey value=None label=(f="Arial/Bold" "Product Penetration") split=" ";*/
/*%bar_chart (analysis_var=pct_1,group_var=cbr_num,class_var=web_band,table=cbr5,title_str=&title,format_name=Percent8.1);*/
/*ods pdf close;*/
/**/
/*ods pdf file="C:\LAYOUT1.pdf";*/
/*axis2 label=(f="Arial/Bold" "Product") split=" " order=('Checking' 'Money Market' 'Savings' 'Time Deposits' 'IRAs' 'Securities' 'Trust' 'Insurance' */
/*'Mortgage' 'Home Equity' 'Dir. Inst. Loan' 'Ind. Inst. Loan' 'Credit Card' 'Safe Deposit Box') split=" ";*/
/*/*axis1 major=None minor=NOne color=grey value=None label=(f="Arial/Bold" "Avg. Balance") split=" ";*/*/
/*axis1 noaxis;*/
/*%bar_chart (analysis_var=Avg_a,group_var=Product,class_var=web_band,table=Prod3,title_str=&title,format_name=);*/
/*ods pdf close;*/
/**/
/**/
/**/
/**/
/*axis2 label=(f="Arial/Bold" "Product") split=" " order=('Checking' 'Money Market' 'Savings' 'Time Deposits' 'IRAs' 'Securities' 'Trust' 'Insurance' */
/*'Mortgage' 'Home Equity' 'Dir. Inst. Loan' 'Ind. Inst. Loan' 'Credit Card' 'Safe Deposit Box') split=" ";*/
/*axis1 major=None minor=NOne color=black value=None label=(f="Arial/Bold" "Product Penetration") split=" ";*/
/*proc gchart data=wip.prod3 (where=(Product ne 'Total'));*/
/*vbar Product / outside = sum type=sum sumvar=Penetration*/
/*raxis=axis1 maxis=axis2 noframe;*/
/*format Penetration Percent8.1;*/
/*by web_band;*/
/*run;*/
/**/
/*axis2 label=(f="Arial/Bold" "Product") split=" " order=('Checking' 'Money Market' 'Savings' 'Time Deposits' 'IRAs' 'Securities' 'Trust' 'Insurance' */
/*'Mortgage' 'Home Equity' 'Dir. Inst. Loan' 'Ind. Inst. Loan' 'Credit Card' 'Safe Deposit Box') split=" ";*/
/*axis1 major=None minor=NOne color=NONe value=None label=(f="Arial/Bold" "Avg. Balance") split=" ";*/
/*proc gchart data=wip.prod3 (where=(Product ne 'Total'));*/
/*vbar Product / outside = sum type=sum sumvar=Avg_a*/
/*raxis=axis1 maxis=axis2;*/
/*by web_band;*/
/*/*format avg_a best.;*/*/
/*run;*/
/**/
/*proc gchart data=wip.prod3 (where=(Product ne 'Total'));*/
/*star Product / discrete sumvar=Penetration;*/
/*format Penetration Percent8.1;*/
/*by web_band;*/
/*run;*/
/**/
/*axis3 order=0 to 1 by 0.25 major=none minor=none;*/
/*axis4 order=0 to 1 by 0.25 major=none minor=none value=None;*/
/*proc gradar data=wip.prod3 (where=(Product ne 'Total' ));*/
/*chart Product / sumvar=Penetration overlayvar=web_band*/
/*staraxis=(axis3 axis4 axis4 axis4 axis4 axis4 axis4 axis4 axis4*/
/*axis4 axis4 axis4 axis4 axis4 axis4)*/
/*starcircles=(0.5 1.0)*/
/*cstarcircles=ltgray;*/
/*format Penetration Percent8.1;*/
/*run;*/


/*%let condition = hh eq 1;*/
/*%let TitleName = Web Activity;*/
/*%let Class1 = web_band;*/
/*%let out_file = Profile_web_activity;*/
/*%let out_dir = Data; /*from my documents, add slash for sub folders */*/
/*%profile_analysis;*/






