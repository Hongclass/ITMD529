proc print data=orion.customer_type noobs;
title "Listing of Customer_Type Data Set";
footnote1 "Created &systime &sysday, &sysdate9";
footnote2 "on the &sysscp System Using Release &sysver";
run;
title;
footnote;
