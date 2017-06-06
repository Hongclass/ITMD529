data us_mailing;
   set orion.mailing_list;
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   if find(Address3,'US');
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=scan(address3,2,',');
   Zip=scan(Address3,3,',');
run;

proc print data=us_mailing noobs;
   title 'Current Output from Program';
run;
title;

