proc cimport file='C:\Documents and Settings\ewnym5s\Desktop\zipcode_apr13_v9.cpt' lib=sashelp;
     run;

%let period = 13q2;
proc datasets lib=sashelp;
       delete zipcode;
     run;
       change zipcode_&period._unique=zipcode;
     run;
quit;

proc datasets lib=sashelp;
       delete zipmil;
     run;
       change zipmil_&period =zipmil;
     run;
quit;

*]create a zip_char;

data sashelp.zipcode;
length zip_char $5;
set sashelp.zipcode;
zip_char = put(zip,z5.);
run;
