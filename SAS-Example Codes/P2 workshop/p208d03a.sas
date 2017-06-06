  /* create a data set with multiple observations for some employees*/
data donations(drop=recipients paid_by);
	set orion.employee_donations(obs=10);
	Code=1000+_n_;
	if _n_ < 3 then output;
	qtr1= 35;
	qtr3=10;
	code=code+10;
	output;
run;
proc print data=donations;
run;

  /* transpose all numeric variables */
proc transpose 
     data=donations
     out=rotate3;
   by Employee_ID;
run;
proc print data=rotate3;
run;
