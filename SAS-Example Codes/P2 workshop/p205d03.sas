data charities;
  length ID $ 5;
  set orion.biz_list;
  if substr(Acct_Code,length(Acct_Code),1)='2';
  ID=substr(Acct_Code,1,length(Acct_Code)-1);
  Name = propcase(Name);
run;

proc print data=charities noobs;
  title 'Charity Names and ID Codes';
  var ID Name;
run;

title;
