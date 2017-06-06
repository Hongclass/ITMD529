proc means data=univ.times_fl;
var world_rank teaching  international research citations income;
run;

%let interval= world_rank teaching  international research citations income ;
options nolabel;
proc sgscatter
data=UNIV.times_fl;
plot international_students*(&interval) / reg;
title "Associations of Interval Variables with International students pct";
run;


proc corr data=univ.times_fl rank
plots(only)=scatter(nvar=all ellipse=none);
var world_rank teaching  international research citations income ;
Title "Correlation in Regressor Variables";
run;

proc corr data=univ.times_fl rank
plots(only)=scatter(nvar=all ellipse=none);
var world_rank teaching  international research citations income ;
with international_students_pct;
Title "Correlation with International Students PCT ";
run;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=UNIV.TIMES_FL alpha=0.05 plots(only)=(diagnostics residuals 
		observedbypredicted);
	model international_students=international / vif tol collin;
	run;
quit;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=UNIV.TIMES_FL alpha=0.05 plots(only)=(diagnostics residuals 
		observedbypredicted);
	model international_students=research / vif tol collin;
	run;
quit;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=UNIV.TIMES_FL alpha=0.05 plots(only)=(diagnostics residuals 
		observedbypredicted);
	model international_students=international world_rank research  / vif tol collin;
	run;
quit;
