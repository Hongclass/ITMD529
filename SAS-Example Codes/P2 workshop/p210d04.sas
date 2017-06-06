proc sql;
	select sales_mgmt.employee_id, 
           employee_name,
		   job_title, 
           salary
	from orion.sales_mgmt, 
         orion.employee_addresses
	where sales_mgmt.employee_id = 
          employee_addresses.employee_id;
quit;
