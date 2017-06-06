data test;
   set orion.employee_donations;
   array val{*} qtr1-qtr4;
   Tot1=sum(of qtr1-qtr4);
   Tot2=sum(of val{*});
run;
proc print data=test;
   var employee_id tot1 tot2;
run;
