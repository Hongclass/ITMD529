data hrdata;
   keep EmpID GrossPay Bonus HireDate;
   set orion.convert;
   EmpID = input(ID,5.)+11000;
   Bonus = input(GrossPay,comma6.)*.10;
   HireDate = input(Hired,mmddyy10.);
run;

proc print data=hrdata noobs;
	var EmpID GrossPay Bonus HireDate;
run;

proc print data=hrdata noobs;
	var EmpID GrossPay Bonus HireDate;
   format HireDate mmddyy10.;
run;
