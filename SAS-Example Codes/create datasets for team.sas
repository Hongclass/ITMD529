options compress = yes;
%let period = 201303;
data wip.main_&period (alter=takecare);
set data.main_&period ;
run;

data wip.contrib_&period (alter=takecare);
set data.contrib_&period ;
run;

