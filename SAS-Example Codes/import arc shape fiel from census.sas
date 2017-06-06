proc mapimport datafile="C:\Documents and Settings\ewnym5s\Desktop\zt24_d00.shp" out=md;
id zcta;
run;

proc mapimport datafile="C:\Documents and Settings\ewnym5s\Desktop\zt42_d00.shp" out=pa;
id zcta;
run;

data mapfiles.zips_PA_MD;
set pa md;
run;
