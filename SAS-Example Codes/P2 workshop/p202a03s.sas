data usa australia;
   set orion.employee_addresses;
   select (Country);
	  when ('US') output usa;
	  when ('AU') output australia;
	  otherwise;
   end;
run;
