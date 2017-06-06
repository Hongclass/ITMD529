data work.discounts;
  infile 'offers.dat'; *PC and Unix;
  *infile '.workshop.rawdata(offers)';  *Z/OS Mainframe;
  input @1 Cust_type 4. 
        @5 Offer_dt mmddyy8.
        @14 Item_gp $8. 
        @22 Discount percent3.;
run;

proc print data=work.discounts noobs;
run;

proc print data=work.discounts noobs;
  format Offer_dt date9.;
run;
