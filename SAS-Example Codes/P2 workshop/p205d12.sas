data descript;
   Var1=12;
   Var2=.;
   Var3=7;
   Var4=5;
   SumVars=sum(Var1,Var2,Var3,Var4);
   AvgVars=mean(of Var1-Var4);
   MissVars=cmiss(of Var1-Var4);
run;

proc print data=descript noobs;
run;
