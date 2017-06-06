data work.supplier;
   length Supplier_ID $ 5 Supplier_Name $ 30 Country $ 2;
   infile 'supply.dat';  *PC and UNIX;
   *infile '.sas.rawdata(supply);  *Z/OS Mainframe;
   input Supplier_ID $;
   Country=scan(_INFILE_,-1,' ');
   StartCol=find(_INFILE_,' ');
   EndCol=find(_INFILE_,' ',-999);
   /* Everything between these first and last blanks is
   the supplier name. */
   Supplier_Name=substr(_INFILE_,StartCol+1,EndCol-StartCol);
   /* Knowing where the last blank is, Country could have 
   also been created using SUBSTR. */
   drop StartCol EndCol;
run;

title 'Supplier Information';
proc print data=work.supplier noobs;
run;
title;
