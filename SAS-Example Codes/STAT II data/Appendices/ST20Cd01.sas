ods html close;
ods listing;
proc print data=sasuser.school (obs=25);
run;                          	*ST20Cd01.sas;

proc univariate data=sasuser.school;
   var reading3;
   histogram / normal;
   probplot / normal(mu=est sigma=est);
   id school;
run;                       		*ST20Cd01.sas;


proc sgpanel data=sasuser.school;
   panelby school / columns=4;
   vbox reading3;
run;	
ods listing close;
ods html;						*ST20Cd01.sas;
