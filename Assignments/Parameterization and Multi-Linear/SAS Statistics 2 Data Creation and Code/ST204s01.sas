
proc glm data=STAT2.school;
   class gender;
   model reading3=gender words1 gender*words1;
run;

				 						*ST204s01.sas;
proc glm data=STAT2.school;
   class gender;
   model reading3=gender|words1 / solution;
run;
quit;									*ST204s01.sas;
