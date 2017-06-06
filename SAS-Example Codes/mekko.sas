%let name=mekko;
filename odsout '.';

/*
SAS/Graph gareabar version of ...
http://mekkographics.com/product.html#
http://mekkographics.com/images/chart_pop/Slide1.gif
http://www.sginews.com/sginews/gifs/SGI_afwint_2003.pdf
*/

goptions reset=all;
goptions device=actximg;

/* 
I'm jumping through a few hoops here with the data, because I wanted to 
start with the data in a form like the sginews website had it, and show
how data in that format/structure can be converted into what sas/graph
proc gareabar needs.
*/

data mydata;
input Company $15. US Non_US Licensed;
group_total=US+Non_US+Licensed;
pct_US=(US/group_total);
pct_Non_US=(Non_US/group_total);
pct_Licensed=(Licensed/group_total);
original_order=_n_;
datalines;
Nike            3005 3186  45
Adidas           750 2028 215
Reebok          1036  725  75
New Balance      891  186 151
Puma             173  802 139
Converse         245    0 570
;
run;

data mydata; 
 set mydata (keep=Company pct_US pct_Non_US pct_Licensed group_total original_order);
run;

/* turn rows into columns */
proc sort data=mydata out=mydata;
by company group_total original_order;
run;
proc transpose data=mydata out=mydata;
by company group_total original_order;
run;

/* rename variables */
proc datasets;
 modify mydata;
 rename col1 = sales_pct;
 rename _name_ = grouping;
run;

/* The order of the data controls the order of the bars, left-to-right */
proc sort data=mydata out=mydata;
by original_order;
run;

data mydata; set mydata;
/* manipulate the grouping's text, to make it more palatable */
grouping=substr(grouping,5,length(grouping)-4);
grouping=translate(grouping,'-','_');
/* gareabar only wants this value once, otherwise it sum's the values */
if (grouping ne 'US') then group_total=0;
run;

/* 
Bummer - can't use user-defined format (either numeric or char-based)
on the values, to control the order colors are assigned in the legend.
*/


/*
data mydata; set mydata;
   format actual percent5.0;
   length htmlvar $200;
   htmlvar='title='||quote(
   'ID: '|| trim(left(id)) ||'0D'x||
   'Target: '|| trim(left(put(target,percent5.0))) ||'0D'x||
   'Actual: '|| trim(left(put(actual,percent5.0))) 
   ) || ' '|| 
   'href="'||"http://support.sas.com/rnd/datavisualization/dashboards/generic_drilldown.htm"||'"';
run;
*/


goptions gunit=pct htitle=4 htext=3 ftitle="arial/bo" ftext="arial/bo";
goptions xpixels=700 ypixels=500;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS AreaBar Chart (aka, Marimekko Chart)") style=minimal /* usegopts */;
goptions noborder;


title justify=left 'Nike dominates its top four competitors with a mix of U.S. and international sales.';

footnote justify=left link="http://www.sginews.com/sginews/gifs/SGI_afwint_2003.pdf" 
   'Source: Sporting Good Intelligence (www.sginews.com)';

/* You'll need to use the colorlist in v9.1.3 */
/*
goptions colors=(blue red gray);
*/

/* in v9.2, you'll get to use pattern statements for colors */
pattern1 v=s c=cx4169E1;  /* blue */
pattern2 v=s c=cxCD5555;  /* red */
pattern3 v=s c=graya8;


PROC gareabar data=mydata;
format sales_pct percent6.0;
format group_total dollar7.0;
/* 
this next label is a mis-nomer ... 
sales_pct is really on the left axis, but since the label prints at the top/left
of the graph, I'm making the text for the group_total values 
*/
label sales_pct='Wholesale Footwear Sales in $ Million (year = 2003)'; 
label company='Manufacturer';  
label grouping='Grouping:';
vbar Company * group_total /
  sumvar=sales_pct subgroup=grouping
  discrete 
  des="" name="&name";
run;

/*
proc print data=mydata; run;
*/

quit;
ODS HTML CLOSE;
ODS LISTING;
