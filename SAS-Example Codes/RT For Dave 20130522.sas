proc import file='C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled\RT file for Datamart analysis.xlsx'
             out=virtual.RT_from_dave dbms=excel replace;
run;

  
data virtual.RT_from_dave;
length hhid $ 9;
set virtual.RT_from_dave;
hhid = monthly_id;
run;


proc freq data=virtual.RT_from_dave;
table rt2;
run;

proc sort data=virtual.RT_from_dave;
by hhid;
run;

data merged_data;
retain miss;
merge data.main_201303 (in=a) virtual.RT_from_dave (in=b keep = hhid rt2 q10: q11: q12: ) end=eof;
by hhid;
if a and b then output;
if a and not b then miss+1;
if eof then put 'WARNING: non matches = ' miss;
drop miss;
run;

ods pdf close;

%create_report(class1=RT2,fmt1=Rt2a,condition=RT2 ne .,main_source=merged_data,contrib_source=data.contrib_201303,out_file=RT_2013522,
               out_dir=C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled,
               logo_file=C:\Documents and Settings\ewnym5s\My Documents\Tools\logo.png)
;

data dec;
retain miss;
merge data.main_201212 (in=a keep=hhid br_: atm: vpos: mpos: web_signon sms_num wap_num) merged_data (in=b keep = hhid) end=eof;
by hhid;
if a and b then output;
if a and not b then miss+1;
if eof then put 'WARNING: non matches = ' miss;
drop miss;
run;

data jan;
retain miss;
merge data.main_201301 (in=a keep=hhid br_: atm: vpos: mpos: web_signon sms_num wap_num) merged_data (in=b keep = hhid) end=eof;
by hhid;
if a and b then output;
if a and not b then miss+1;
if eof then put 'WARNING: non matches = ' miss;
drop miss;
run;

data feb;
retain miss;
merge data.main_201302 (in=a keep=hhid br_: atm: vpos: mpos: web_signon sms_num wap_num) merged_data (in=b keep = hhid) end=eof;
by hhid;
if a and b then output;
if a and not b then miss+1;
if eof then put 'WARNING: non matches = ' miss;
drop miss;
run;

data mar;
retain miss;
merge data.main_201303 (in=a keep=hhid br_: atm: vpos: mpos: web_signon sms_num wap_num) merged_data (in=b keep = hhid) end=eof;
by hhid;
if a and b then output;
if a and not b then miss+1;
if eof then put 'WARNING: non matches = ' miss;
drop miss;
run;

DATA VIRTUAL.TRAn_DAVE;
SET DEC JAN FEB MAR;
RUN;


proc sort data=virtual.tran_dave;
by hhid;
run;

proc summary data=virtual.tran_dave;
var _numeric_;
output out= virtual.tran_summary_dave mean= / autoname;
by hhid;
run;


data combo;
merge  virtual.tran_summary_dave (drop=_type_ _freq_ in=a) virtual.RT_from_dave (in=b keep = hhid rt2 q10: q11: q12: ) end=eof;
by hhid;
if a and b;
run;


proc format ;
value cnt .,0 = 'None'
	  0 <- .5 = 'Less than 0.5'
	  .5 <- 1 = '0.5 to 1'
	  1 <- 2 = '1 to 2'
	  2 <- 3 = '2 to 3'
	3 <- 4 = '3 to 4'
	4 <- 5 = '4 to 5'
	5 <- 7 = '5 to 7'
	7 <- 10 = '7 to 10'
	10 <- 15 = '10 to 15'
	15 <- 20 = '15 to 20'
	20 <- high = 'Over 20';
run;

 

proc tabulate data=combo order=data missing;
class q10_4 br_tr_num_mean / preloadfmt;
table q10_4='Survey Response' all,(br_tr_num_mean='Observed 4 month Avg.' all)*n='HHs'*f=comma12./nocellmerge misstext='0';
format q10_4  br_tr_num_mean cnt.;
run;

data merged_data;
merge merged_data (in=a) combo(in=b keep=hhid br_tr_num_mean);
if a and b;
run;

proc format ;
value cnt_a (notsorted) 0 = 'A. None'
	  0 <- 1 = 'B. Less than 1'
	  1 <- 3 = 'C. 1 to 3'
	3 <- 5 = 'D. 3 to 5'
	5 <- high = 'E. Over 5'
;
run;

%create_report(class1=br_tr_num_mean,fmt1=cnt_a,condition=RT2 ne .,main_source=merged_data,contrib_source=data.contrib_201303,
                out_file=Branch_Usage_Profile,
               out_dir=C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled,
               logo_file=C:\Documents and Settings\ewnym5s\My Documents\Tools\logo.png)
;

proc format;
value $RT 
'Branch user 45-65' = 'Branch user 45-65'
'Branch user 65+' = 'Branch user 65+'
'Branch user <45' ='Branch user <45'
'Branch user-Non Primary' = 'Branch user-Non Primary' 
'RT 45+' = 'RT 45+' 
'RT <45' = 'RT <45'
'RT-Non Primary' = 'RT-Non Primary';
run;
 

%create_report(class1=RT2,fmt1=$RT,condition=RT2 ne '',main_source=merged_data,contrib_source=data.contrib_201303,out_file=RT_2013522,
               out_dir=C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled,
               logo_file=C:\Documents and Settings\ewnym5s\My Documents\Tools\logo.png)
;
ods pdf close;

proc freq data=merged_data;
table RT2;
run;
