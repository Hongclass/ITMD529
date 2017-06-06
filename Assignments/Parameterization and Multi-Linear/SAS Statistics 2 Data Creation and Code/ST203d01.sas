
ods html style=statistical;
title "STAT2.SCHOOL DATA SET";
proc glm data=STAT2.school plots(unpack)=all;
   class school gender;
   model reading3 = school|gender;
run;
quit;          *ST203d01.sas;
				
