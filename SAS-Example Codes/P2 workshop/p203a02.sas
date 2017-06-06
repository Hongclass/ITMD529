data mnthtot;
   set orion.aprsales2;
   retain Mth2Dte 0;
   Mth2Dte=Mth2Dte+SaleAmt;
run;

proc print data=mnthtot noobs;
run;
