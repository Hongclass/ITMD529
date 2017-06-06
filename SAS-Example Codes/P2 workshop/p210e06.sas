%let lib=orion;
%let ds=country;
proc print data=&lib.&ds;
    var country country_name population;
run;

