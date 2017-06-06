proc sql;
   create table direct_reports as
      select employee_id, job_title, salary
      from orion.sales_mgmt;
quit;

proc sql number;
  select *
  from direct_reports
  ;
quit;

proc print data=direct_reports;
run;
