proc sql;
select sum(hh_sum) into :count from segments1 where _table_ eq 1;
quit;



data segments1;
set segments1;
if _table_ eq 1 and hh_sum ne . then pct = hh_sum/&count;
run;

ods html style=mtbnew nogfootnote ;

proc sgplot data=segments1 ;
where _table_ eq 1 and  hh_sum ne . ;
vbar segment / missing group=segment groupdisplay=cluster response=hh_sum  stat=sum  grouporder=data nostatlabel  datalabel DATALABELATTRS=(Size=6) name="A";
vbar segment / missing group=segment groupdisplay=cluster response=pct stat=sum  nostatlabel grouporder=data datalabel  DATALABELATTRS=(Size=6) name="B";
xaxis label='Customer Lifecycle Segment' LABELATTRS=(Weight=Bold) tickvalueformat=DATA type=discrete discreteorder=data fitpolicy=stagger;
yaxis label='Average Contribution' LABELATTRS=(Weight=Bold) ;
keylegend "A" /;
format segment segfmt. pct percent6. hh_sum comma12.;
run;
