data hrdata;
   keep Phone Code Mobile;
   set orion.convert;
   Phone='(' !! Code !! ') ' !! Mobile;
run;

proc print data=hrdata noobs;
run;
