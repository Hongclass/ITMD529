data work.admin work.stock work.purchasing;
   set orion.employee_organization;
   if Department='Administration' then output work.admin;
   else if Department='Stock & Shipping' then output work.stock;
   else if Department='Purchasing' then output work.purchasing;
run;

title 'Administration Employees';
proc print data=work.admin;
run;
title;

title 'Stock and Shipping Employees';
proc print data=work.stock;
run;
title;

title 'Purchasing Employees';
proc print data=work.purchasing;
run;
title;


  /* Alternate Solution */

data work.admin work.stock work.purchasing;
   set orion.employee_organization;
   select (Department);
      when ('Administration') output work.admin;
      when ('Stock & Shipping') output work.stock;
	  when ('Purchasing') output work.purchasing;
	  otherwise;
   end;
run;

title 'Administration Employees';
proc print data=work.admin;
run;
title;

title 'Stock and Shipping Employees';
proc print data=work.stock;
run;
title;

title 'Purchasing Employees';
proc print data=work.purchasing;
run;
title;

