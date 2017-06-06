proc template;
define statgraph balances;
begingraph;
entrytitle 'Distribution of Product Balances';
layout overlay / yaxisopts=(linearopts=(viewmin=0 viewmax=200000 tickvalueformat=dollar12.) label='Balance' )
xaxisopts=(display=(line ticks tickvalues)) cycleattrs=true;
boxplot x=_LABEL_ y=NJ  / discreteoffset=-0.1 boxwidth=.2 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=Plus)
name='a' legendlabel="NJNY/CT (N=&N_foot.)";
boxplot x=_LABEL_ y=FL / discreteoffset= 0.1 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=Plus) medianattrs=(color=red )
name='b' legendlabel="FL Snowbird (N=&N_fl.)";
referenceline y=1 / lineattrs=(pattern=dot);
discretelegend 'a' 'b' / location=outside valign=bottom halign=center across=2;
endlayout;
/*entryfootnote halign=left "For ALAT, ASAT and ALKPH, the Clinical ...;";*/
/*entryfootnote halign=left "For BILTOT, the CCL is 1.5 ULN: where ULN ...";*/
endgraph;
end; run;

ods graphics / reset border=off width=7.5in height=4in imagename="balances1";
proc sgrender data=fl_bals1(where=(_name_ not in ('MTG_amt','HEQ_amt','ILN_amt')))  template=balances; run;
proc sgrender data=fl_bals1(where=(_name_  in ('MTG_amt','HEQ_amt','ILN_amt')))  template=balances; run;

#overlapped below, maybe with alpha, cant work it;
proc sgplot data=fl_bals1 ;
where _name_ not in ('MTG_amt','HEQ_amt','ILN_amt');
vbox FL / group=  _label_ grouporder=data groupdisplay=cluster MEANATTRS=(color="red" symbol='DiamondFilled' ) MEDIANATTRS=(color="red") fillattrs=(transparency=0.8)
                OUTLIERATTRS=(color="lightgrey") name ='fl' legendlabel="FL Snowbird (N=&N_fl.)" ;
vbox NJ / group=  _label_ grouporder=data groupdisplay=cluster MEANATTRS=(color="red" symbol='DiamondFilled') MEDIANATTRS=(color="red") fillattrs=(transparency=0.4)
                OUTLIERATTRS=(color="lightgrey") name='other' legendlabel="NJNY/CT (N=&N_foot.)" ;
xaxis fitpolicy=staggerthin  label="Product" discreteorder=data offsetmax=.15 ;
yaxis max=200000 label="Balance";
keylegend "fl" "other";
format col1 dollar12.;
run;
