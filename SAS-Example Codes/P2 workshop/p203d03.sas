data mnthtot2;
   set orion.aprsales2;
   Mth2Dte+SaleAmt;
run;

proc print data=mnthtot2 noobs;
   format SaleDate date9.;
run;
