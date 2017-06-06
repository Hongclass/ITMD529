Data correct;
   set orion.clean_up;
   if find(Product,'Mittens','I') > 0 then do;
      substr(Product_ID,9,1) = '5';
   end;
run;

proc print data=correct noobs;
run;
