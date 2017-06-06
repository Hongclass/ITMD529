data hrdata;
   keep EmpID;
   set orion.convert;
   EmpID = ID + 11000;
run;

proc print data=hrdata noobs;
run;
 /* check the variable type for EmpID and ID */
proc contents data=orion.convert;
run;

proc contents data=hrdata;
run;
