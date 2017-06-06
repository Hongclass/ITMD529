  /*Sort data set to prepare for BY group processing*/
proc sort data=orion.projsals out=projsort;
	by Proj Dept;
run;

proc print data=projsort noobs;
   var Proj Dept Salary;
run;

  /*Summarize Salaries by Project and Department*/
data pdsals(keep= Proj Dept DeptSal NumEmps);
   set projsort;
   by Proj Dept;
   if First.Dept then do;
      DeptSal=0;
      NumEmps=0;
   end;
   DeptSal+Salary;
   NumEmps+1;
   if Last.Dept;
run;

  /* List the data */
proc print data=pdsals noobs;
run;

  /* Optional: Create a report based off the data */
proc print data=pdsals noobs;
	by proj;
	sum DeptSal NumEmps;
	format DeptSal dollar12.0;
run;
