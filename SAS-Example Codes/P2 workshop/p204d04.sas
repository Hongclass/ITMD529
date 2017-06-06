data salesQ1;
   infile 'sales.dat';  *PC and Unix;
   *infile '.workshop.rawdata(sales)'; *Z/OS Mainframe;
   input SaleID $4. @6 Location $3.;
   if Location='USA' then
       input @10 SaleDate mmddyy10. 
             @20 Amount 7.;
   else if Location='EUR' then
       input @10 SaleDate date9. 
             @20 Amount commax7.;
run;

proc print data=salesQ1 noobs;
run;
