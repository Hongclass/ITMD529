data rotate (keep=Employee_Id Period Amount);
   set orion.employee_donations
	         (drop=recipients paid_by);
   array contrib{4} qtr1-qtr4;
   do i=1 to 4;
      if contrib{i} ne . then do;
         Period=cats("Qtr",i);
         Amount=contrib{i};
         output;
      end;
   end;
run;

proc print data=rotate;
run;

proc freq data=rotate;
   tables Period /nocum nopct;
run;
