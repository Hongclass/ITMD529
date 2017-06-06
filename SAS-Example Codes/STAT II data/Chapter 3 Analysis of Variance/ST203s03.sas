proc glm data=sasuser.disks plots(unpack)=diagnostics;
   class technician brand;
   model time=technician|brand;
run;
quit;        
		 					*ST203s03.sas;

data disks;
   set sasuser.disks;
   group=compress(technician||brand);
run;

proc glm data=disks;
   class group;
   model time=group;
   means group/hovtest;
run;
quit;							*ST203s03.sas;
