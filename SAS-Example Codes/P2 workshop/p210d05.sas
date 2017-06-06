proc sql;
   select  s.employee_id,employee_name,
		   job_title,salary
   from orion.sales_mgmt as s,
        orion.employee_addresses as a
   where s.employee_id =
          a.employee_id;
quit;
