data work.small;
  set orion.newcompetitors;
  Country = substr(ID,1,2);
  Store_Code=left(substr(ID,3));
  if substr(Store_Code,1,1) = '1';
  City=propcase(City);
run;

title 'New Small-Store Competitors';
proc print data=work.small noobs;
   var Store_Code Country City Postal_Code;
run;
title;


