data EuropeQ1;
   infile 'sales.dat';  *PC and Unix;
   *infile '.workshop.rawdata(sales)'; *Z/OS Mainframe;
   input @6 Location $3. @;
   if Location = 'EUR';
   input  @1 SaleID $4.
         @10 SaleDate date9. 
         @20 Amount commax7.;
run;

proc print data=EuropeQ1 noobs;
   var SaleID Location SaleDate Amount;
run;
