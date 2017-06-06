%macro Auto_Dummy_Variable(tablename=,variablename=,outputtable=,MissingDummy=N,
MaxLevel=10,delimiter=);
%local _N_Vars_ var_name variabletype _Value_Raw_List_ dsid _N_Var_values_ 
missing_dummy_name missing_dummy_label MissingMark i kkk;
/*create variable list for automatically generating dummy variables*/
proc contents data=&tablename.(keep=&variablename.) noprint varnum 
out=_var_list_(keep=name rename=(name=VariableName));
run;
%if &tablename.^=&outputtable. %then
%do;
data &outputtable.;
set &tablename.;
run;
%end;
%let _N_Vars_=0;
%let fid=%sysfunc(open(work._var_list_));
%let _N_Vars_=%sysfunc(attrn(&fid,NOBS));
%let fid=%sysfunc(close(&fid));
%if &_N_Vars_>0 %then
%do;
Data _null_;
set _var_list_;
call symputx('_Var_name_'||left(put(_n_,8.)),VariableName);
run;
%do kkk=1 %to &_N_Vars_.;
%let Var_name=&&_Var_name_&kkk.;
/*get variable type*/
%let dsid=%sysfunc(open(&tablename.,i));
%let 
variabletype=%sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&var_name.))));
%let rc=%sysfunc(close(&dsid));
%let _Value_Raw_List_=&tablename.;
/*split the multiple options to get values*/
%if %length(&delimiter.)^=0 %then
%do;
%let _Value_Raw_List_=_zzz_;
data _zzz_(drop=_iii_);
set &tablename.;
_iii_=1;
do until(scan(&var_name.,_iii_,"&delimiter.")='');
_vvv_=scan(&var_name.,_iii_,"&delimiter.");
output;
_iii_=_iii_+1;
end;
drop &var_name.;
rename _vvv_=&var_name.;
run;
%end;
/*create list of distinct values*/
proc sql noprint;
create table _Value_distinct_List_ as
select distinct &var_name. 
as Variable_Value label="Variable Value"
from &_Value_Raw_List_.;11
quit;
/*create dummy variable name and label*/
data _Value_distinct_List_;
format variable_name $32.;
set _Value_distinct_List_;
format dummy_name $32.;
format dummy_label $500.;
label Variable_name="Variable Name"
dummy_name="Dummy Variable Name"
dummy_label="Dummy Variable Label";
%if &variabletype.=C %then 
%do;
variable_value=propcase(variable_value);
%end;
variable_name="&var_name.";
dummy_name=cats("DV_",substr("&var_name.",1,min(24,length("&var_name."))),_N_);
dummy_label=cats("Dummy Variable||","&var_name.",":",Variable_Value);
where Variable_Value is not null;
run;
%let 
missing_dummy_name=DV_%substr(&var_name.,1,%sysfunc(min(21,%length(&var_name.))))_Mi
ssing;
%let missing_dummy_label=Dummy Variable||&var_name.: Missing Value;
/*create macro matrix*/
%let _N_Var_values_=0;
%let fid=%sysfunc(open(work._value_distinct_list_));
%let _N_Var_values_=%sysfunc(attrn(&fid,NOBS));
%let fid=%sysfunc(close(&fid));
%put N of levels = &_N_Var_values_.;
%put Max number of levels considered for coding dummy variables = 
&maxlevel.;
%if "&MaxLevel"="" %then %let Maxlevel=1000;
%if &_N_Var_values_.>0 and &_N_Var_values_.<=&maxlevel. %then
%do;
Data _null_;
set _value_distinct_list_;
%if &variabletype.=N %then 
%do;
call symputx('_var_value_'||left(put(_n_,8.)),Variable_Value);
%end;
%if &variabletype.=C %then 
%do;
call symputx('_var_value_'||left(put(_n_,8.)),cats('"', Variable_Value, 
'"'));
%end;
call symputx('_dummyname_'||left(put(_n_,8.)),dummy_name);
call symputx('_dummylabel_'||left(put(_n_,8.)),dummy_label);
run;
/*set Missing Mark*/
%if &variabletype.=N %then %let MissingMark=.;
%if &variabletype.=C %then %let MissingMark="";
/*Start to generate dummy variables*/
Data &outputtable.;
set &outputtable.;
_var_temp_=&var_name.;
%if &variabletype.=C %then 
%do; 
_var_temp_=propcase(_var_temp_);
%end;12
/*generate non-missing dummy variables*/
if _var_temp_^= &MissingMark. then
do;
/*if the variable is multiple options text variable*/
%if %length(&delimiter.)^=0 %then
%do;
%do i=1 %to &_N_Var_values_;
&&_dummyname_&i.=0;
label &&_dummyname_&i.="&&_dummylabel_&i.";
%end;
_iii_=1;
do until(scan(_var_temp_,_iii_,"&delimiter.")='');
_jjj_=scan(_var_temp_,_iii_,"&delimiter.");
%if &variabletype.=C %then 
%do; 
_jjj_=propcase(_jjj_);
%end;
%do i=1 %to &_N_Var_values_;
if _jjj_=&&_var_value_&i then
&&_dummyname_&i.=1;
%end;
_iii_=_iii_+1;
end;
drop _iii_ _jjj_;
%end;
/*if the variable is not multiple options text variable*/
%else
%do i=1 %to &_N_Var_values_;
if _var_temp_=&&_var_value_&i then 
&&_dummyname_&i.=1;
Else 
&&_dummyname_&i.=0;
%end;
end;
/*generate missing dummy variable*/
%if &MissingDummy=Y %then
%do;
if _var_temp_= &MissingMark. then 
do;
%do i=1 %to &_N_Var_values_;
if &&_dummyname_&i.=. then 
&&_dummyname_&i.=0;
%end;
&missing_dummy_name=1;
end;
else 
&missing_dummy_name=0;
label &missing_dummy_name="&missing_dummy_label";
%end;
drop _var_temp_;
run;
%end;
proc datasets library=work nolist; 
delete _Value_distinct_List_ 
%if %length(&delimiter.)^=0 %then %do; _zzz_ %end; ; 
quit;
%end;
%end;
proc datasets library=work nolist; 
delete _var_list_; 
quit;
%mend Auto_Dummy_Variable;
