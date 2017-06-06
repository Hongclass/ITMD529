title "SASUSER.SCHOOL DATA SET";
proc glm data=sasuser.school plots(unpack)=all;
   class school gender;
   model reading3 = school|gender;
run;
quit;
					*ST203d01.sas;
