proc template;
     define style mtb;
     parent=styles.default;
     style graphdata1 from graphdata1 / color=cx007856 contrastcolor=black;
     style graphdata2 from graphdata2 / color=cx7AB800 contrastcolor=black;
	 style graphdata3 from graphdata2 / color=cxFFB300 contrastcolor=black;
	 style graphdata4 from graphdata2 / color=cx86499D contrastcolor=black;
	 style graphdata5 from graphdata2 / color=cx003359 contrastcolor=black;
	 style graphdata6 from graphdata2 / color=cxAFAAA3 contrastcolor=black;
     end;
   run;


options mcompilenote=all;
%macro create_panel_charts1 (xsize=,ysize=, file=, group1=,  order1=, prodfile=);


proc sql;
select min((ceil(max(percent)*10)/10)+ 0.2,1.2) into :max1 from &file;
quit;


proc catalog c=work.gseg kill; 
run; quit; 

ods html style=mtb;
goptions reset=all cback=white noborder htitle=14pt htext=10pt;  
goptions device=gif nodisplay xpixels=&xsize ypixels=&ysize;

%do i = 1 %to 10;
	%if &i eq 1 %then %let yname=Checking;
	%if &i eq 2 %then %let yname=Money Market;
	%if &i eq 3 %then %let yname=Savings;
	%if &i eq 4 %then %let yname=Time Deposits;
	%if &i eq 5 %then %let yname=IRA;
	%if &i eq 6 %then %let yname=Svcd Mortgage;
	%if &i eq 7 %then %let yname=Non-Svcd Mortgage;
	%if &i eq 8 %then %let yname=Home Equity;
	%if &i eq 9 %then %let yname=Inst. Loan;
	%if &i eq 10 %then %let yname=Overdraft;
	%do j = 1 %to 10;
		%if &j eq 1 %then %let xname=Checking;
		%if &j eq 2 %then %let xname=Money Market;
		%if &j eq 3 %then %let xname=Savings;
		%if &j eq 4 %then %let xname=Time Deposits;
		%if &j eq 5 %then %let xname=IRA;
		%if &j eq 6 %then %let xname=Svcd Mortgage;
		%if &j eq 7 %then %let xname=Non-Svcd Mortgage;
		%if &j eq 8 %then %let xname=Home Equity;
		%if &j eq 9 %then %let xname=Inst. Loan;
		%if &j eq 10 %then %let xname=Overdraft;

		%if &i eq 1 %then %do;
			title1 "&xname";
		%end;
		%if &i ne 1 %then %do;
			title1 ;
		%end;
		%if &j eq 1 %then %do;
			axis1 label=(angle=90 f="Arial / bo" justify=center color=black height=14pt "&yname")  minor=none major=none color=white value=none order=(0 to &max1 by 0.1); 
		%end;
		%if &j ne 1 %then %do;
			axis1 label=(angle=90 f="Arial / bo" justify=center color=white height=14pt "&yname")  minor=none major=none color=white value=none order=(0 to &max1 by 0.1); 
		%end;
		axis2 label=none  minor=none major=none value=none order=(&order1);
		
	
		proc gchart data=&file(where=(y="&yname" and x="&xname")) gout=work.gseg;
		vbar &group1 / sumvar=percent subgroup=&group1 missing discrete raxis=axis1 width=25 maxis=axis2 gaxis=axis2 outside=sum nolegend noframe;
		format percent percent8.0 ;
		run;
		quit;
	%end;
	 title1 ;
      %if &i eq 1 %then %do;
		title1 'Avg. Products';
	%end;

	 axis1 label=(angle=90 f="Arial / bo" justify=center color=white height=14pt "&yname")  minor=none major=none color=white value=none order=(0 to 5 by 0.5); 
	  axis2 label=none  minor=none major=none value=none order=(&order1);
	   proc gchart data=&prodfile(where=(num=&i)) gout=work.gseg;
		vbar &group1 / sumvar=prods subgroup=&group1 discrete raxis=axis1 missing width=25 maxis=axis2 gaxis=axis2 outside=sum nolegend noframe;
		format prods comma5.1 ;
		run;
		quit;
%end;



%mend create_panel_charts1;



%macro custom_panel(x=,y=, fileout=,x_size=,y_size=) / store source des='Creates panel';



		goptions reset=all device=gif 
        gsfname=grafout gsfmode=replace 
       	xpixels=&x_size ypixels=&y_size cback=white;
		filename grafout "&fileout"; 
        %let xsize=%eval(100/&x);
		%let ysize=%eval(100/&y
);

proc greplay igout=work.gseg tc=tempcat nofs;

  /* Define a custom template called NEWTEMP */
  tdef newtemp des="y=&y by x=&x panel template"

%do q = 1 %to &y;
  %do p = 1 %to &x; 
		%let panel = %eval(&p + (&q-1)*&x);
        %let s = %eval(&y+1-&q);
       &panel./llx=%eval((&p-1)*&xsize)   lly=%eval((&s-1)*&ysize)

	      lrx=%eval((&p)*&xsize)  lry=%eval((&s-1)*&ysize)

          ulx=%eval((&p-1)*&xsize)    uly=%eval((&s)*&ysize)

          urx=%eval((&p)*&xsize)  ury=%eval((&s)*&ysize)

          color=blue

	%end;
  %end;
  ;

	template newtemp;
    list template;

	treplay 1 : gchart
 	%do r = 1 %to %eval((&x*&y)-1);
	    %if &r le 99 %then %do;
    		%eval(&r+1) :gchart&r

		%end;
		%if &r gt 99 and &r lt 999 %then %do;
    		%eval(&r+1) :gchar&r

		%end;
		%if &r gt 999 and &r lt 9999 %then %do;
    		%eval(&r+1) :gcha&r

		%end;
	%end;
	;
run;
quit;

%mend custom_panel;


%create_panel_charts1 (xsize=300, ysize=200, file=combined, group1=distance_name ,
                         order1 = "Under 1 mile" "1 to 2 Miles" "2 to 3 Miles" "3 to 5 Miles" 
                                  "5 to 10 Miles" "Over 10 Miles",prodfile=prods_hudson)



%custom_panel(x=11,y=10,fileout=C:\Documents and Settings\ewnym5s\My Documents\Hudson City\panelchart.gif,x_size=3300,y_size=2000)

