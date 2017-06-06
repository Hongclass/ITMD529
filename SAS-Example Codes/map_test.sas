data a;
input state  val1;
datalines;
36 123
34 105
09 56
31 45
45 23
17 16
;
run;




data hudson.branches;
length address $ 50 city $ 50 state $ 2 zip $ 10;
infile 'C:\Documents and Settings\ewnym5s\My Documents\Hudson City\Hudson City Branches 20120827.txt' dsd dlm='09'x lrecl=4096 firstobs=2;
input  Address $ City $	State $	Zip $ lat long;
run;

data hudson.branches;
set hudson.branches;
state_code = state;
drop state;
run;

data hudson.branches;
set hudson.branches;
if state_code = 'NY' then state = 36;
if state_code = 'NJ' then state = 34;
if state_code = 'CT' then state = 09;
zip9 = zip;
drop zip;
run;

data hudson.branches;
length label $ 50;
set hudson.branches;
zip = input(substr(zip9,1,5),5.);
format zip z5.;
label = address;
run;

proc geocode data=hudson.branches out=test method=zip nocity ;
run;

data anno;
  /* Use the X and Y values from the LONGLAT data set */
   set hudson.branches;
  /* Set the data value coordinate system */
  /* Set the function to LABEL */
  /* Set the size of the symbol to .75 */
  /* Set a FLAG variable to signal annotate observations */
   retain xsys ysys '2' function 'label' size .75 flag 1 when 'a';
  /* Set the font to the Special font */
   style='special';
  /* The symbol is a star */
   text='M';
  /* Color for the symbol */
   color='depk';
  /* Output the observation to place the symbol */
   output;
run;

DATA states;
set maps.us;
  where state in (36,34,09);
run;

data all;
set states anno;
run;


proc gproject data=all out=allp;
  id state;
run;
quit;

proc freq data=all order=freq;
table zip;
run;

data map dot;
   set allp;
  /* If the FLAG variable has a value of 1, it is an annotate data */
  /* set observation; otherwise, it is a map data set observation. */
   if flag=1 then output dot;
   else output map;
run;



proc gmap all map=mapp  ;
id state;
choro state / discrete cdefault=lightgray annotate=annop;
run; quit;	
