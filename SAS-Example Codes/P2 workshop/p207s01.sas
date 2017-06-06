  /* Part A */

data future_expenses;
   drop start stop;
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   start=year(today())+1;
   stop=start+9;
   do Year=start to stop;
      wages = wages * 1.06;
      retire=retire*1.014;
      medical=medical *1.095;
      Total_Cost=sum(wages,retire,medical);
      output;
   end;
run;

  /* Part B */
proc print data=future_expenses;
   format wages retire medical total_cost comma14.2;
   var year wages retire medical total_cost;
run;

  /* Alternate solution */

data future_expenses;
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   do Year=year(today())+1 to year(today())+10;
      wages = wages * 1.06;
      retire=retire*1.014;
      medical=medical *1.095;
      Total_Cost=sum(wages,retire,medical);
      output;
   end;
run;
proc print data=future_expenses;
   format wages retire medical total_cost comma14.2;
   var year wages retire medical total_cost;
run;

  /* Part C */
data income_expenses;
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   Income=50000000;
   Year=year(today())+1;
   do until (Total_Cost > Income);
      wages = wages * 1.06;
      retire=retire*1.014;
      medical=medical *1.095;
      Total_Cost=sum(wages,retire,medical);
      Income=Income *1.01;
      output;
      year+1;
   end;
run;
proc print data=income_expenses;
   format total_cost income comma14.2;
   var year income total_cost;
run;
