odsresults; clear;
ods html close;
ods html;

ods html style=analysis;
proc sgplot data=sasuser.normtemp;
scatter x=heartrate  y=bodytemp / group=gender   ;
loess x=heartrate  y=bodytemp / group=gender ;
run;

ods html style=statistical;

proc sgpanel data=sasuser.normtemp;
panelby gender heartrate;
reg y=heartrate  x=bodytemp / group=gender ;
loess x=heartrate  y=bodytemp / group=gender;

run;

proc sgplot data=sasuser.mggarlic;
reg y=BulbWt x=cloves /group=fertilizer;
run;

proc sgplot data=sasuser.MGGarlic;
    vbox cloves / category=Fertilizer datalabel=BedID;
    format BedID 5.;
    title "Box and Whisker Plots of Garlic Weight";
run;

proc sgpanel data=sasuser.mggarlic_block;
panelby sector / rows=3 columns=3;
scatter y=bulbwt x=fertilizer;
run;


proc freq data=sasuser.mggarlic_block;
table sector*fertilizer / norow nocol nopercent;
run;

proc sgplot data=sasuser.mggarlic_block;
    scatter y=bulbwt x=Fertilizer / group=sector groupdisplay=cluster;
	xaxis type=discrete;
    title "scatter Plots of Garlic Weight";
run;

proc sgplot data=sasuser.mggarlic_block;
    scatter y=bulbwt x=sector / group=Fertilizer groupdisplay=cluster;
	xaxis type=discrete;
    title "scatter Plots of Garlic Weight";
run;

*above is kind of cool, shows the groups a bit jittered for easier reading, the data make sit hard to really see;


proc freq data=sasuser.drug;
table drugdose*disease/ norow nocol nopercent;
run;

proc sgplot data=sasuser.drug;
scatter x=drugdose y=bloodp / group=disease groupdisplay=cluster;
xaxis type=discrete;
title 'scatter plots of Drug';
run;

proc sgpanel data=sasuser.drug;
panelby drugdose / colums=4;
vbox bloodp  / group=disease groupdisplay=cluster;
title 'scatter plots of Drug';
format drugdose dosefmt.;
run;

proc sgpanel data=sasuser.drug;
panelby disease / colums=3;
vbox bloodp  / group=drugdose groupdisplay=cluster;
title 'scatter plots of Drug';
run;
