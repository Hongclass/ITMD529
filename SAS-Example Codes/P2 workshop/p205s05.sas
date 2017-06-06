data work.silver work.gold work.platinum;
   set orion.customers_ex5;
   Customer_ID=tranwrd(Customer_ID,'-00-','-15-');
   if find(Customer_ID,'Silver','I') > 0 then
	  output work.silver;
   else if find(Customer_ID,'Gold','I') > 0 then
	  output work.gold;
   else if find(Customer_ID,'Platinum','I') > 0 then
	  output work.platinum;
   keep Name Customer_ID Country; 
run;

title 'Silver-Level Customers';
proc print data=work.silver noobs;
run;

title 'Gold-Level Customers';
proc print data=work.gold noobs;
run;

title 'Platinum-Level Customers';
proc print data=work.platinum noobs;
run;
title;
