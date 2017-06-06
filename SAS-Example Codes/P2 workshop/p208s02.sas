data travel;
   set orion.travel_expense;
   keep employee_id trip_id Expense_Type amount;
   array exp{5} exp1-exp5;
   array descr{5} $ 14 _temporary_ 
      ('Airfare','Hotel','Meals','Transportation','Miscellaneous');
   do i=1 to 5;
      if exp{i} ne . then do;
         Expense_Type=descr{i};
         Amount=exp{i};
         output;
      end;
   end;
run;
proc print data=travel;
   format Amount dollar8.2;
run;
