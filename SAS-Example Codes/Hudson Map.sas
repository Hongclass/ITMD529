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
/*if state_code = 'NY' then state = 36;*/
/*if state_code = 'NJ' then state = 34;*/
/*if state_code = 'CT' then state = 09;*/
state = stfips(state_code);
zip9 = zip;
drop zip;
run;

data hudson.branches;
length label $ 50;
set hudson.branches;
zip = input(substr(zip9,1,5),5.);
format zip z5.;
label = address;
/*   x=atan(1)/45*long;*/
/*   y=atan(1)/45*lat;*/
/*   x=-x;*/
run;


data mystates;
   set maps.states;
   if state in (9,10,11,34,36,24,42,51,54);
run;

data state_names;
length text $ 2 color $ 10 style $ 20;
set maps.uscenter;
retain xsys ysys '2' function 'label' size 2 flag 1 when 'a';
where (state in (9,10,11,34,36,24,42,51,54)) and ocean='N';
color = 'white';
style="'Albany AMT/bold'";
x=atan(1)/45*long;
   y=atan(1)/45*lat;
/*   select;*/
/*     when (state=9) text='CT';*/
/*	 when (state=36) text='NY';*/
/*	 when (state=34) text='NJ';*/
/*   end; */
   text=fipstate(state);
   output;
keep lat long xsys ysys  function  size flag  when x y text style color;
run;



data anno;
 /* Use the X and Y values from the LONGLAT data set. */
length text $ 2 color $ 10 style $ 20;
  set hudson.branches;
  retain xsys ysys '2' function 'label' size 1.3 flag 1 when 'a';
 /* Set the font to the Special font. */
  style='special';
 /* The symbol is a star. */
  text='M';
 /* Specify the color for the symbol. */
  color='depk';
 /* Output the observation to place the symbol. */
   x=atan(1)/45*long;
   y=atan(1)/45*lat;
   x=-x;
  output;
run;

data anno_mtb;
 /* Use the X and Y values from the LONGLAT data set. */
length text $ 2 color $ 10 style $ 20;
  set branch.mtb_branches_201206;
  retain xsys ysys '2' function 'label' size 1.3 flag 1 when 'a';
 /* Set the font to the Special font. */
  style='special';
 /* The symbol is a star. */
  text='M';
 /* Specify the color for the symbol. */
  color='Green';
 /* Output the observation to place the symbol. */
   x=atan(1)/45*long;
   y=atan(1)/45*lat;
   x=-x;
  output;
run;

data all;
  set  mystates anno state_names anno_mtb ;
run;

proc gproject data=all out=allp;
   id;
run;

data mystatesp annop;
  set allp;
  if when='a' then output annop;
  else output mystatesp;
run;

title1 'M&T Bank Branch Network (After Hudson City Acquisition)';
proc gmap data=annop map=mystatesp all ;
   id state;
   choro state
         /   stat=freq discrete levels=1 coutline=blue 
			anno=annop;
run;
quit;




