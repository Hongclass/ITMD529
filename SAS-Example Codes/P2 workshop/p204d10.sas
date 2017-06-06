data donate07;
   length ID $ 4;
   infile 'charity.dat';  *PC and Unix;
   *infile '.workshop.rawdata(charity)'; *Z/OS Mainframe;
   input ID $ Amount @@;
run;

proc print data=donate07 noobs;
run;
