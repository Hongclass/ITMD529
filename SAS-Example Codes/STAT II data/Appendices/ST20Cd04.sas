proc glm data=sasuser.school;
   class school;
   model reading3=school;
   lsmeans school / pdiff adjust=tukey;
run;  
quit;								*ST20Cd04.sas;
