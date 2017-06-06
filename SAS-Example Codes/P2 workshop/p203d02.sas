data mnthtot;
   set orion.aprsales;
   retain Mth2Dte 0;
   Mth2Dte=Mth2Dte+SaleAmt;
run;

proc print data=mnthtot noobs;
   format SaleDate date9.;
run;
