  /*Sort data set to prepare to summarize*/
proc sort data=orion.specialsals out=salsort;
   by Dept;
run;

  /*Summarize Salaries by Division*/
data deptsals(keep=Dept DeptSal);
   set SalSort;
   by Dept;
   if First.Dept then DeptSal=0;
   DeptSal+Salary;
   if Last.Dept;
run;

proc print data=deptsals noobs;
   format DeptSal 7.;
   title 'Employee Salaries by Department';
run;

