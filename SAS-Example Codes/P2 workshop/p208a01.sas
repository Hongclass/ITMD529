proc transpose 
     data=orion.employee_donations 
     out=rotate2 (rename=(col1=Amount)
				  where=(Amount ne .))
     name=Period;
   by employee_id;
run;

proc freq data=rotate2;
/*	where Amount ne .;*/
   tables Period/nocum nopct;
   label Period=" ";
run;
