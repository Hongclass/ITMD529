proc template;
define statgraph balances4;
begingraph;
entrytitle 'Distribution of Product Balances';
layout overlay / yaxisopts=(linearopts=(viewmin=0 viewmax=100000 tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
boxplot x=product y=one  / discreteoffset=-0.3 boxwidth=.2 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
name='a' legendlabel="1 to 5";
boxplot x=product y=two / discreteoffset= -0.1 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
name='b' legendlabel="6 to 10";
boxplot x=product y=three / discreteoffset= 0.1 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
name='c' legendlabel="11 to 15";
boxplot x=product y=two / discreteoffset= 0.3 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
name='d' legendlabel="16 to 20";
referenceline y=1 / lineattrs=(pattern=dot);
discretelegend 'a' 'b' 'c' 'd' / location=outside valign=bottom halign=center across=4;
endlayout;
/*entryfootnote halign=left "For ALAT, ASAT and ALKPH, the Clinical ...;";*/
/*entryfootnote halign=left "For BILTOT, the CCL is 1.5 ULN: where ULN ...";*/
endgraph;
end; run;

proc template;
define statgraph balances4l;
begingraph;
entrytitle 'Distribution of Product Balances';
layout overlay / yaxisopts=(linearopts=(viewmin=0 viewmax=200000 tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
xaxisopts=(label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER)) cycleattrs=true;
boxplot x=product y=one  / discreteoffset=-0.3 boxwidth=.2 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
name='a' legendlabel="1 to 5";
boxplot x=product y=two / discreteoffset= -0.1 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
name='b' legendlabel="6 to 10";
boxplot x=product y=three / discreteoffset= 0.1 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
name='c' legendlabel="11 to 15";
boxplot x=product y=two / discreteoffset= 0.3 boxwidth=.2 outlierattrs=(color=grey) meanattrs=(color=red symbol=DiamondFilled) medianattrs=(color=red )
name='d' legendlabel="16 to 20";
referenceline y=1 / lineattrs=(pattern=dot);
discretelegend 'a' 'b' 'c' 'd' / location=outside valign=bottom halign=center across=4;
endlayout;
/*entryfootnote halign=left "For ALAT, ASAT and ALKPH, the Clinical ...;";*/
/*entryfootnote halign=left "For BILTOT, the CCL is 1.5 ULN: where ULN ...";*/
endgraph;
end; run;




proc sgrender data=balancebox(where=(order not in (7,8)))  template=balances4; run;

proc sgrender data=balancebox(where=(order in (7,8)))  template=balances4l; run;

%macro vbox_template;
	
