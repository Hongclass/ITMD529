data bayview;
infile 'My Documents\Bayview.txt' dsd dlm='09'x lrecl=4096 firstobs=2;
input fips $ st $ count state;
run;


proc tabulate data=bayview out=sums;
var count;
class state;
table  state, pctsum*count;
run;

data sums;
set sums;
percent1 = count_pctsum_0/100;
format percent1 percent6.1;
run;

data labels;
retain function 'label' xsys ysys '2' hsys '3' when 'a';
merge sums(in=a where=(percent1 gt .03)) maps.uscenter (in=b)maps.us2 (in=c keep=state statecode);
by state;
if a;
text=put(percent1,percent6.1); style="'Albany AMT/bold'";
   color='white'; size=2; position='5'; output;
run;

proc gmap all map=maps.us data=sums ;
id state;
choro percent1 /  cdefault=white range midpoints=(.01 .05 .1 .2  .5) anno=labels;
run; quit;     



