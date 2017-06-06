*--------------------------------------------------------
	Data  Exploration on sasuser.paper data set in 
	preparation for regression analysis
--------------------------------------------------------;
options formdlim="_";
title1 "Sasuser.Paper Data Set";
ods html close;
ods listing;
proc sgplot data=sasuser.paper;
 scatter x=amount y=strength;
 title2 "Scatter Plot";
run;

proc sgplot data=sasuser.paper;
    reg  x=amount y=strength / lineattrs =(color=brown       
         pattern=solid) legendlabel="Linear";
title2 "Linear Model";
run; 

proc sgplot data=sasuser.paper;
    reg  x=amount y=strength / degree=2 lineattrs =(color=green       
         pattern=mediumdash) legendlabel="2nd Degree";
title2 "Second Degree Polynomial";
run;

proc sgplot data=sasuser.paper;
   reg  x=amount y=strength / degree=3 lineattrs =(color=red   
        pattern=shortdash) legendlabel="3rd Degree";
title2 "Third Degree Polynomial";
run;

proc sgplot data=sasuser.paper;
    reg  x=amount y=strength / degree=4 lineattrs =(color=blue
      pattern=longdash) legendlabel="4th Degree";
title2 "Fourth Degree Polynomial";
run; 												*ST201d02.sas;


