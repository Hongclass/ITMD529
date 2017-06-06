  /* Use FIRSTOBS= and OBS= in an INFILE statement */

data employees;
  infile 'emps.dat' firstobs=11 obs=15;
  /* infile '.workshop.rawdata(emps)' firstobs=11 obs=15; */
  input @1 EmpID 8. @9 EmpName $40. @153 Country $2.;
run;
proc print data=employees;
run;
