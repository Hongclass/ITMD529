options MSTORED SASMSTORE = mjstore;
libname mjstore 'C:\Documents and Settings\ewnym5s\My Documents\SAS\Macros';

%macro demog_analysis (condition=,Class1=,out_file=,out_dir=,identifier=,dir=, title=, clean=) / store source des='get demog_analysis macro';

libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
libname data 'C:\Documents and Settings\ewnym5s\My Documents\Data';
options fmtsearch=(SAS);

/*for testing, these are the variable assignmnets */

%let condition = tran_segm ne "XXXX";
%let class1 = tran_segm;
%let out_file = tran_segm;
%let  out_dir = Data;
%let identifier = 201111;
%let dir = "C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files";
%let title = 'Analysis by Summary Segment';

%local dtend dtstart;
%let dtstart=%sysfunc(datetime(), datetime18.);

%if %sysfunc(libref(wip)) ne 0 %then %do;
libname wip &dir;
%end;

%if %sysfunc(libref(wip)) ne 0 %then %do;
	%put ERROR: The SAS Data Library could;
	%put ERROR- not be established;
	%goto quit;
%end;



data wip.temp_demog;
merge data.demog_201111 (in=a) data.main_201111 (in=b keep= hhid hh segment cbr market &class1 distance band where=(&condition));
by hhid;
if a and b;
run;
	
%IF %SYSFUNC(EXIST(wip.temp_demog)) = 1 %THEN %DO;
%LET DSID = %SYSFUNC(OPEN(wip.temp_demog));
%LET NUMOBS = %SYSFUNC(ATTRN(&DSID,NLOBS));
%IF &NUMOBS GT 0 %THEN %DO;

%let rc=%sysfunc(close(&DSID));
 
proc tabulate data=wip.temp_demog out=wip.own_age1(drop=_PAGE_  _TABLE_);
class &class1 own_age;
var    hh;
table ( own_age='Age Band' ALL)*HH*(sum='HHs'*f=comma12. ) ( own_age='Age Band' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL/ nocellmerge;
format own_age ageband.;
keylabel ALL='Total';
run;

data wip.own_age2;
set wip.own_age1;
where _type_ eq '11';
run;

proc tabulate data=wip.temp_demog out=wip.age_prime1(drop=_PAGE_  _TABLE_);
class &class1 age_prime;
var    hh;
table ( age_prime='Age Prime' ALL)*HH*(sum='HHs'*f=comma12. ) ( age_prime='Age Prime' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL/ nocellmerge;
format age_prime ageband.;
keylabel ALL='Total';
run;

data wip.age_prime2;
set wip.age_prime1;
where _type_ eq '11';
run;

proc tabulate data=wip.temp_demog out=wip.age_hoh1(drop=_PAGE_  _TABLE_);
class &class1 age_hoh;
var    hh;
table ( age_hoh='Age HOH' ALL)*HH*(sum='HHs'*f=comma12. ) ( age_hoh='Age HOH' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL/ nocellmerge;
format age_hoh ageband.;
keylabel ALL='Total';
run;

data wip.age_hoh2;
set wip.age_hoh1;
where _type_ eq '11';
run;

proc tabulate data=wip.temp_demog out=wip.income1(drop=_PAGE_  _TABLE_);
class &class1 income  ;
var    hh;
table ( income='Income' ALL)*HH*(sum='HHs'*f=comma12. ) ( income='Income' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL/ nocellmerge;
format income incmfmt.;
run;

data wip.income2;
set wip.income1;
where _type_ eq '11';
run;


proc tabulate data=wip.temp_demog out=wip.home1(drop=_PAGE_  _TABLE_);
class &class1  home_owner  ;
var    hh;
table ( home_owner='Home Owner' ALL)*HH*(sum='HHs'*f=comma12. ) ( home_owner='Home Owner' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL/ nocellmerge;
run;

data wip.home2;
set wip.home1;
where _type_ eq '11';
run;


proc tabulate data=wip.temp_demog out=wip.educ1(drop=_PAGE_  _TABLE_);
class &class1 education  ;
var    hh;
table ( education='Education' ALL)*HH*(sum='HHs'*f=comma12. ) ( education='Education' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL / nocellmerge;
/*table virtual_seg,( education *HH )*(N ROWPCTSUM);*/
run;

data wip.educ2;
set wip.educ1;
where _type_ eq '11';
run;


proc tabulate data=wip.temp_demog out=wip.ocup1(drop=_PAGE_  _TABLE_);
class &class1 ocupation  ;
var    hh;
table ( ocupation='Occupation' ALL)*HH*(sum='HHs'*f=comma12. ) ( ocupation='Occupation' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL / nocellmerge;
/*table virtual_seg,( ocupation *HH )*(N ROWPCTSUM);*/
run;

data wip.ocup2;
set wip.ocup1;
where _type_ eq '11';
run;

proc tabulate data=wip.temp_demog out=wip.married (drop=_PAGE_  _TABLE_);
class &class1 married  ;
var    hh;
table ( married='Marital Status' ALL)*HH*(sum='HHs'*f=comma12. ) ( married='Marital Status' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL / nocellmerge;
/*table virtual_seg,( married *HH )*(N ROWPCTSUM);*/
/*format married $marital.;*/
run;

data wip.married2;
set wip.married;
where _type_ eq '11';
run;

/*children*/
proc tabulate data=wip.temp_demog out=wip.child1a(drop=_PAGE_  _TABLE_)  ;
class &class1 children FLAG_UNDER_10 flag_11_15 flag_16_17;
var    hh;
/*table ( married='Marital Status' ALL)*HH*(sum='HHs'*f=comma12. ) ( married='Marital Status' ALL)*HH*colPCTSUM<hh>='Percent of group', &class1 ALL / nocellmerge;*/
table  &class1, (children ),(FLAG_UNDER_10 );
run;

proc sort data=wip.child1a;
by children &class1;
run;


proc transpose data=wip.child1a out = wip.child2a label=under10;
by children &class1;
ID flag_under_10;
run;

data wip.child3a;
set wip.child2a (rename=(Y=under10_Y N=under10_N));
drop _NAME_;
run;



proc tabulate data=wip.temp_demog out=wip.child4a(drop=_PAGE_  _TABLE_)  ;
class &class1 children FLAG_UNDER_10 flag_11_15 flag_16_17;
var    hh;
table  &class1, (children ),(flag_11_15 );
run;

proc sort data=wip.child4a;
by children &class1;
run;

proc transpose data=wip.child4a out = wip.child5a label=under10;
by children &class1;
ID flag_11_15;
run;

data wip.child6a;
set wip.child5a (rename=(Y=_11_15_Y N=_11_15_N));
drop _NAME_;
run;

proc tabulate data=wip.temp_demog out=wip.child7a(drop=_PAGE_  _TABLE_)  ;
class &class1 children FLAG_UNDER_10 flag_11_15 flag_16_17;
var    hh;
table  &class1, (children ),(flag_16_17 );
run;

proc sort data=wip.child7a;
by children &class1;
run;

proc transpose data=wip.child7a out = wip.child8a label=under10;
by children &class1;
ID flag_16_17;
run;

data wip.child9a;
set wip.child8a (rename=(Y=_16_17_Y N=_16_17_N));
drop _NAME_;
run;

proc tabulate data=wip.temp_demog out=wip.childa(drop=_PAGE_  _TABLE_)  ;
class &class1 children FLAG_UNDER_10 flag_11_15 flag_16_17;
var    hh;
table  &class1, (children *HH);
run;

proc sort data=wip.childa;
by children &class1;
run;

proc sort data=wip.child3a;
by children &class1;
run;

proc sort data=wip.child6a;
by children &class1;
run;

proc sort data=wip.child9a;
by children &class1;
run;

data wip.child10a;
merge wip.childa (in=a) wip.child3a wip.child6a wip.child9a;
by children &class1;
run;

data wip.child11a;
set wip.child10a;
length segment $ 20 grp $ 8;
array data{7} HH_sum under10_y under10_n _11_15_y _11_15_n _16_17_y _16_17_n;
array Y{8,7} _temporary_;
array N{8,7} _temporary_;

select (&class1);
	when ("ATM Dominant") j=1;
	when ("Branch Dominant") j=2;
	when ("Inac") j=3;
	when ("Multi - High Branch") j=4;
	when ("Multi - Low Branch") j=5;
	when ("Multi - Med Branch") j=6;
	when ("Online Dominant") j=7;
	when ("Phone Dominant") j=8;
end;

if children='N' then do;
	do i = 1 to 7 ;
		N{j,i} = data{i};
	end;
	return;
end;
else if children='Y' then do;
		do i = 1 to 7 ;
			Y{j,i} = data{i};
		end;
    if j ne 8 then do; /*this should stop at the last record allowing me to output the data I really want*/
		return;
	end;
end;

do k=1 to 8;

	select (k);
		when (1) segment = "ATM Dominant" ;
		when (2) segment ="Branch Dominant";
		when (3) segment ="Inac";
		when (4) segment ="Multi - High Branch";
		when (5) segment = "Multi - Low Branch";
		when (6) segment = "Multi - Med Branch";
		when (7) segment = "Online Dominant";
		when (8) segment = "Phone Dominant";
	end;

	Grp = 'All';
	val = 'Y';
	HH = Y{k,1};
	PCT = Y{k,1}/ (Y{k,1}+ N{k, 1});
	output;
	val = 'N';
	HH = N{k, 1};
	PCT = n{k,1}/ (Y{k,1}+ N{k, 1});
	output;

	Grp = 'Under 10';
	val = 'Y';
	HH = sum(Y{k,2},N{k,2});
	PCT = Y{k,2}/ (Y{k,1}+ N{k, 1});
	output;
	val = 'N';
	HH = sum(Y{k,3},N{k,3});
	PCT = n{k,3}/ (Y{k,1}+ N{k, 1});
	output;

	Grp = '11 to 15';
	val = 'Y';
	HH = sum(Y{k,4},N{k,4});
	PCT = Y{k,4}/ (Y{k,1}+ N{k, 1});
	output;
	val = 'N';
	HH = sum(Y{k,5},N{k,5});
	PCT = n{k,5}/ (Y{k,1}+ N{k, 1});
	output;

	Grp = '16 to 17';
	val = 'Y';
	HH = sum(Y{k,6},N{k,6});
	PCT = Y{k,6}/ (Y{k,1}+ N{k, 1});
	output;
	val = 'N';
	HH = sum(Y{k,7},N{k,7});
	PCT = n{k,7}/ (Y{k,1}+ N{k, 1});
	output;
end;

drop i children hh_sum under10_n under10_y _11_15_n _11_15_y _16_17_y _16_17_n &class1 j k;
run;

DATA wip.child12a;
set wip.child11a;
where val = "Y";
drop val;
run;

options orientation=landscape;
ods html close;
ods pdf file = 'C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled\test_demog.pdf';



/* charts*/
Title2 'Education level';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=education,table=educ2,title_str=,value_format=,group_format=$educfmt.,
midpts='HIGH SCHOOL' 'VOCATIONAL/TECHNICAL' 'COLLEGE' 'GRADUATE SCHOOL');


Title2 'Ocupation';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=ocupation,table=ocup2,title_str=,value_format=,group_format=$ocupfmt.,
midpts='Prof Tech' 'Admin Mgr' 'Sales Svc' 'Clercl Wh Cllr' 'Crafts Bl Cllr' 'Stdnt' 'Home''Retrd' 'Farmer' 'Military' 'Relig' 'Self Empl' 
'Education' 'Finance' 'Legal' 'Medical' 'Other' 'Uncoded');

Title2 'Income';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=income,table=income2,title_str=,value_format=,group_format=incmfmt.,
midpts='<$15M' '$15M-20M' '$20M-30M'  '$30M-40M' '$40M-50M' '$50M-75M' '$75M-100M' '$100M-125M'  '$125M+' 'Uncoded');

Title2 'Best HH Age Estimate';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=own_age,table=own_age2,title_str=,value_format=,group_format=ageband.,
midpts='Invalid' 'Under 18'  '18 to 25' '26 to 35' '36 to 45' '46 to 55'  '56 to 65'  '66 to 70' '71 to 75'  '76 to 80'  '81 to 85'  '86 to 90'  '91+');

Title2 'Prime Account Age Estimate';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=age_prime,table=age_prime2,title_str=,value_format=,group_format=ageband.,
midpts='Invalid' 'Under 18'  '18 to 25' '26 to 35' '36 to 45' '46 to 55'  '56 to 65'  '66 to 70' '71 to 75'  '76 to 80'  '81 to 85'  '86 to 90'  '91+');

Title2 'Head of HH Age Estimate';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=age_hoh,table=age_hoh2,title_str=,value_format=,group_format=ageband.,
midpts='Invalid' 'Under 18'  '18 to 25' '26 to 35' '36 to 45' '46 to 55'  '56 to 65'  '66 to 70' '71 to 75'  '76 to 80'  '81 to 85'  '86 to 90'  '91+');

Title2 'Homeownership';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=home_owner,table=home2,title_str=,value_format=,group_format=$homeowner.,
midpts='Owner' 'Renter');

Title2 'Marital Status';
axis1 minor=none major=none label=(a=90 f="Arial/Bold" "% of HHs in Group") value=none;
axis2 split="" value=(h=9pt) label=none  color=black label=NONE value=none;
axis3 split=" " value=(h=7pt)  color=black label=NONE ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Transaction Segment" position=(top center));
%vbar_stacked (analysis_var=HH_sum,group_var=&class1,class_var=married,table=married2,title_str=,value_format=,group_format= $marital.,
midpts='Married' 'Single');


Title2 'Presence of Children';
axis1 minor=none  label=(a=90 f="Arial/Bold" "% of HHs With Children");
axis2 split=" " value=(h=7pt) label=none  color=black  value=none ;
axis3 split=" " value=(h=9pt font="Albany AMT/bold")  color=black label=NONE 
order=('Branch Dominant'  'Multi - High Branch'  'Multi - Med Branch'  'Multi - Low Branch'  'ATM Dominant'  'Phone Dominant'  'Online Dominant'  'Inac');
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in ,.15in) label=("Children Present" position=(top center)) 
order=('All'  'Under 10'  '11 to 15'  '16 to 17');

proc gchart data=wip.child12a ;
vbar grp /  type=sum  sumvar=PCT
noframe outside=sum   subgroup=grp group=segment
gspace = 1 width=10
raxis = axis1 maxis=axis2 gaxis=axis3 
midpoints = 'All' 'Under 10' '11 to 15' '16 to 17'
autoref clipref cref=graybb
legend=legend2;
format  PCT PERCEnT6.1;
run;
quit;

ods pdf close;

/*%if %sysfunc(fileexist("C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&out_file..xls")) ne 0 %then %do;*/
/*	%put ERROR: The Excel Output file;*/
/*	%put ERROR- already exists;*/
/*	libname myxls clear;*/
/*	%goto quit;*/
/*%end;*/
/**/
/*libname myxls oledb init_string="Provider=Microsoft.ACE.OLEDB.12.0;*/
/*Data Source=C:\Documents and Settings\ewnym5s\My Documents\&out_dir\&out_file..xls;*/
/*Extended Properties=Excel 12.0";*/


%end;
%end;

/* CLEAN AFTER MYSELF */
%if &clean eq 1 %then %do;
	PROC DATASETS LIB = wip; 
	delete child: age: educ: home: income: married: ocup: own_age: temp_demog;
	QUIT;
	RUN;
%end;

%quit:

ods html;
%let dtend=%sysfunc(datetime(), datetime18.);
%put Execution Started at: &dtStart;
%put Execution Stopped at: &dtend;

%mend



