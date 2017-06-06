axis1 minor=none color=black label=(a=90 f="Arial/Bold" "Avg. % of HHs") order=(0 to 1 by 0.25);
axis2 split=" " value=(h=7pt) label=none  ;
axis3 split=" " value=(h=8pt) color=black label=NONE value=none;

axis1;

%put &axis1;


axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none value=none ;
axis3 split=" " value=(h=8pt) color=black label=NONE  ;
legend2 position=(outside bottom center) mode=reserve cborder=black shape=bar(.15in,.15in) label=("Segment" position=(top center));
proc gchart data=wip.cbr5 ;
vbar cbr_num / type=percent freq=hh 
noframe inside=percent g100  subgroup=virtual_seg group=cbr_num
gspace = 1 width=10
raxis = axis1 maxis=axis2 gaxis=axis3 nozero
/*PATTERNID=MIDPOINT*/
legend=legend2
autoref clipref cref=graybb;
format  cbr_num $cbrfmt.;
run;
quit;

options orientation=landscape;
axis1 minor=none major=none value=none label=(a=90 f="Arial/Bold" "% of HHs in Group") ;
axis2 split=" " value=(h=9pt) label=none order=('<25M' '25 to 100M' '100 to 250M' '250 to 500M' '500M to 1MM' '1 to 2MM' '2 to 3MM' '3 to 4MM' '4 to 5MM'
                     '5 to 10MM' '10 to 15MM' '15 to 20MM' '20 to 25MM' '25MM+');
axis3 split=" " value=(h=8pt) color=black label=NONE value=none ;
%vbar_stacked (analysis_var=N,group_var=virtual_seg,class_var=band1,table=wealth5,title_str=&title,value_format=Percent8.1,group_format=);

order = ('Building their Future' 'Mass Affl No Kids' 'Mainst Fam' 'Mass Affl Fam' 'Mainst Ret' 'Mass Affl Ret' 'Unknown')

quit;

%quit;
