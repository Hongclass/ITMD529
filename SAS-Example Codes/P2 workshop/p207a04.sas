data charity (keep=employee_id qtr1-qtr4);
   set orion.employee_donations;
   array Contrib1{3} qtr1-qtr4;
   array Contrib2{5} qtr:;
   /* additional SAS statements */        
run;
