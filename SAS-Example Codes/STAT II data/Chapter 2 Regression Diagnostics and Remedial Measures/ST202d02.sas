*---------------------------------------------------------------------------------
	Screening program to output potentially influential observations for 
	further examination
----------------------------------------------------------------------------------;

/*set the values of the macro variables based on your data and model*/

%let numparms = 4;
%let numobs = 81;
data influence;
 set check;
 absrstud=abs(rstudent);
 if absrstud ge 2 then output;
 else if leverage ge (2*&numparms /&numobs) then output;
run;
proc print data=influence;
 var manufacturer model price hwympg horsepower;
 run;									 *ST202d02.sas;
