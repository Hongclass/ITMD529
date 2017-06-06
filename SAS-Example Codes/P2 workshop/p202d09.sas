  /* Example using OBS= and FISRTOBS= options */
data australia;
	set orion.employee_addresses 
            (firstobs=50 obs=100);
	if Country='AU' then output;
run;

proc print data=australia;
run;
