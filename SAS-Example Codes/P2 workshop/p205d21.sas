data conversion;
  NVar1=614;
  NVar2=55000;
  NVar3=366;
  CVar1=put(NVar1,3.);
  CVar2=put(NVar2,dollar7.);
  CVar3=put(NVar3,date9.);
run;
proc contents data=conversion varnum;
run;
proc print data=conversion noobs;
run;

