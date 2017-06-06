*-------------------------------------------------------
  Use PROC REG for multicollinearity diagnostics. 
  First create design variables with PROC GLMSELECT
-------------------------------------------------------;
ods select none;
proc glmselect data=STAT2.trials outdesign=design;
   class treatment;
   model bpchange = treatment|baselinebp / selection=none;
run;
%put macro variable _glsmod=&_glsmod;

ods select ParameterEstimates DiagnosticsPanel DFFITSPlot DFBETASPanel;
proc reg data=design plots=(dfbetas dffits);
   model bpchange=&_glsmod / vif influence;
title 'Check Collinearity on ANCOVA Model';
run;
quit;

*****;
proc stdize data=STAT2.trials method=mean 
            out=trials2c (rename=(baselinebp=baselinebpc));
   var baselinebp; 
run;

ods select none;
proc glmselect data=trials2c outdesign=design2c;
   class treatment;
   model bpchange = treatment|baselinebpc / selection=none;
title 'Check Collinearity on Centered ANCOVA Model';
run;

ods select ParameterEstimates DiagnosticsPanel DFFITSPlot DFBETASPanel;
proc reg data=design2c plots=(dfbetas dffits);
   model bpchange=&_glsmod / vif influence;
run;
quit;						*ST204d03.sas;

ods html style=listing;
proc sgplot data=STAT2.trials;
  reg y=bpchange x=baselinebp / group=treatment;
  *xaxis values=(0 to 125 by 25);
  refline 95 / axis=x;
title 'Original Data';
run;

proc sgplot data=trials2c;
  reg y=bpchange x=baselinebpc / group=treatment;
  refline 0 / axis=x;
title 'Centered Data';
run;						*ST204d03.sas;
