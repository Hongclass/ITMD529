data mnthtot;
   set orion.aprsales;
   Mth2Dte=Mth2Dte+SaleAmt;
run;

proc print data=mnthtot noobs;
   format SaleDate date9.;
run;
