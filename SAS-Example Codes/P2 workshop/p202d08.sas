  /* Example using OBS= data set option */

data australia;
	set orion.employee_addresses (obs=100);
	if Country='AU' then output;
run;

proc print data=australia;
run;

