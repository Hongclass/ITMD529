  /* Part A: */
proc sql;
  create table work.matches as
  select Employee_Name, City, Order_Date
    from orion.Order_fact as o 
        INNER JOIN 
      orion.Employee_addresses as a
	  on a.Employee_ID=o.Employee_ID
    order by Order_Date; 
quit;

title 'Matches from the Order and Address Tables';
proc print data=work.matches;
run;
title;

  /* Part B: */
proc sql;
  create table work.allorders as
  select Employee_Name, City, Order_Date
    from orion.Order_fact as o 
        LEFT JOIN 
      orion.Employee_addresses as a
	  on a.Employee_ID=o.Employee_ID
    order by Order_Date; 
quit;

title 'Order Dates, with Employee Information when Available';
proc print data=work.allorders;
run;
title;
