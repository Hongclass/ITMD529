data charity;
   set orion.employee_donations;
   keep employee_id qtr1-qtr4; 
   array Contrib{4} qtr1-qtr4;
   do i=1 to 4;        
      Contrib{i}=Contrib{i}*1.25;
   end; 
run; 

proc print data=charity noobs;
run;
