%macro vbox_template (templ_name=template1,title=)/ store;
	proc template;
	define statgraph &templ_name;
	begingraph;
	entrytitle "&title";
	layout overlay / yaxisopts=(linearopts=( viewmax =&max viewmin=&min tickvalueformat=dollar12.) label='Balance' labelattrs=(weight=bold))
	xaxisopts=( label="Product" labelattrs=(weight=bold) discreteopts=(TICKVALUEFITPOLICY=STAGGER) ) cycleattrs=true ;
	%do i = 1 %to &total ;
	
		%let a =  %sysfunc(ceil(&total/2));
		%let a1 = %eval(-1*&a);
		%let a2 = %eval(&a1+&i);
		%let a3 = %sysevalf(&a2*0.1);
		boxplot x=order y=amt&i  / discreteoffset=&a3 boxwidth=.1 outlierattrs=(color=grey) medianattrs=(color=red) meanattrs=(color=red symbol=DiamondFilled)
		display=(CAPS FILL MEAN MEDIAN) name="&i" legendlabel="&&name&i";
	%end;
	referenceline y=0 / lineattrs=(pattern=dot);
	discretelegend 
	%do i = 1 %to &total;
		"&i"  
	%end;
     / location=outside valign=bottom halign=center across=3 DISPLAYCLIPPED=Yes;
	endlayout;
	endgraph;
	end; run;
%mend vbox_template;
