data names;
   length New_Name $50 
          FMnames $30
          Last $30;
   set orion.customers_ex5;
   FMnames = scan(Name,2,',');
   Last = propcase(scan(Name,1,','));
	if Gender="F" then New_Name=CATX(' ','Ms.',FMNames,Last);
	else if Gender="M" then New_Name=CATX(' ','Mr.',FMNames,Last);
	keep New_Name Name Gender;
run;

proc print data=names;
run;
