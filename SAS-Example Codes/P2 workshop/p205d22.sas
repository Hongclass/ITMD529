data hrdata;
   keep Phone Code Mobile;
   set orion.convert;
   Phone='(' !! put(Code,3.) !! ') ' !! Mobile;
run;

proc print data=hrdata noobs;
run;
