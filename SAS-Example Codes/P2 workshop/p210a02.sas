proc sql number;
     select sales_mgmt.employee_id,
            employee_name,
            job_title,
            salary
     from orion.sales_mgmt,
          orion.employee_addresses;
quit;

