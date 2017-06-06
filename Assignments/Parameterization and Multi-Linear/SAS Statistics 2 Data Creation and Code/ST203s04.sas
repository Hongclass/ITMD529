
proc glm data=STAT2.disks plots(unpack)=diagnostics;
   class technician brand;
   model time=technician|brand;
run;
quit;        
		 					*ST203s04.sas;

data disks;
   set STAT2.disks;
   group=compress(technician||brand);
run;

proc glm data=disks;
   class group;
   model time=group;
   means group/hovtest;
run;
quit;							*ST203s04.sas;
