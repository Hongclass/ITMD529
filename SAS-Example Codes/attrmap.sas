data attrmap;
length id $ 15 value $ 22;
input id $  value $  fillcolor $8. linecolor $8.;
 datalines;
 distance_name Under cx007856 black
 distance_name 1 cx7AB800 black
 distance_name 2 cxFFB300 black
 distance_name 3 cx86499D black
 distance_name 5 cx003359 black
 distance_name Over cxAFAAA3 black
   ;
   run;




proc sgplot data=wip.combined dattrmap=attrmap;
where y='Checking' and x="Savings";
vbar distance / group=distance response=percent datalabel ;
format distance distfmtnew.;
run;




 distance_name Under cx007856 black
 distance_name 1 cx7AB800 black
 distance_name 2 cxFFB300 black
 distance_name 3 cx86499D black
 distance_name 5 cx003359 black
 distance_name Over cxAFAAA3 black
