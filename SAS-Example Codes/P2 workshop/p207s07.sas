data preferred_cust;
   set orion.orders_midyear;
   array Mon{6} Month1-Month6;
   keep Customer_ID Over1-Over6 Total_Over;
   array Over{6};
   array Target{6} _temporary_ (200,400,300,100,100,200);
   do i=1 to 6;
      if Mon{i} > Target{i} then
         Over{i} = Mon{i} - Target{i};
   end;
   Total_Over=sum(of Over{*});
   if Total_Over > 500;
run;
proc print data=preferred_cust noobs;
run;


