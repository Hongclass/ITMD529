data branch.pop2010byzip;
infile 'C:\Documents and Settings\ewnym5s\My Documents\Maps\2010 Pop by Zip.txt' dsd dlm='09'x firstobs=2 lrecl=4096;
input zip $ pop hhs;
run;

proc sort data=branch.cbr_by_zip_2012;
by zip;
run;

data cbr1;
merge branch.cbr_by_zip_2012 (in=a) branch.pop2010byzip (in=b);
by zip;
if a;
run;

proc tabulate data=cbr1 missing;
where cbr_zip ne 99 and cbr_zip ne .;
class cbr_zip;
var pop hhs;
table cbr_zip ALL, sum*(pop hhs)*f=comma24. / nocellmerge;
format cbr_zip cbr2012fmt.;
run;

proc sort data=cbr1;
by  zip;
run;

data cbr2;
set cbr1;
if substr(zip,1,2)ne '00' then statecode = zipstate(put(zip,5.));
run;

proc tabulate data=cbr2 missing;
where cbr_zip ne 99 and cbr_zip ne . and statecode ne 'NJ' and statecode ne '';
class cbr_zip;
var pop hhs;
table cbr_zip ALL, sum*(pop hhs)*f=comma24. / nocellmerge;
format cbr_zip cbr2012fmt.;
run;

