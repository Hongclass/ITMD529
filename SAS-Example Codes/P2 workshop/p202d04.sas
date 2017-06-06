  /* Use a Select group for conditional output */

data usa australia other;
   set orion.employee_addresses;
   select (country);
	  when ('US') output usa;
	  when ('AU') output australia;
	  otherwise output other;
   end;
run;

  /* Check for multiple values with SELECT */

data usa australia other;
   set orion.employee_addresses;
   select (country);
	  when ('US','us') output usa;
	  when ('AU','au') output australia;
	  otherwise output other;
   end;
run;

  /* Use UPCASE function with SELECT */

data usa australia other;
   set orion.employee_addresses;
   select (upcase (country));
	  when ('US') output usa;
	  when ('AU') output australia;
	  otherwise output other;
   end;
run;

  /* Use DO-END in a Select group */

data usa australia other;
   set orion.employee_addresses;
   select (upcase(country));
	  when ('US') do;
         Benefits=1;
         output usa;
      end;
	  when ('AU') do;
	  	 Benefits=2;
         output australia;
      end;
	  otherwise do;
	     Benefits=0;
         output other;
      end;
   end;
run;

  /* alternate form of select statement */

data usa australia other;
   set orion.employee_addresses;
   select;
	  when (country='US') output usa;
	  when (country='AU') output australia;
	  otherwise output other;
   end;
run;

  /* A PRINT procedure is required for each data set. */
title 'Employees in the United States';
proc print data=usa;
run;

title 'Employees in Australia';
proc print data=australia;
run;

title 'Non US and AU Employees';
proc print data=other;
run;
title;


