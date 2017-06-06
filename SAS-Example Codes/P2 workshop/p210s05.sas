  /* Part A */
%let minSal=60000;
title "Employees Earning at Least $&minSal";
proc print data=orion.employee_payroll;
	where salary > &minSal;
	format birth_date employee_hire_date employee_term_date date9.;
run;
title;

  /* Part B */
%let minSal=100000;
title "Employees Earning at Least $&minSal";
proc print data=orion.employee_payroll;
	where salary > &minSal;
	format birth_date employee_hire_date employee_term_date date9.;
run;
title;
