data conversions;
   CVar1='32000';
   CVar2='32.000';
   CVar3='03may2008';
   CVar4='030508';
   NVar1=input(CVar1,5.);
   NVar2=input(CVar2,commax6.);
   NVar3=input(CVar3,date9.);
   NVar4=input(CVar4,ddmmyy6.);
run;

proc contents data=conversions;
run;

proc print data=conversions noobs;
run;

