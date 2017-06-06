  /* Program with incorrect output */
data us_mailing;
   set orion.mailing_list;
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   if find(Address3,'US');
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=scan(Address3,2,',');
   Zip=scan(Address3,3,',');
run;

proc print data=us_mailing noobs;
   title 'Current Output from Program';
run;
title;

  /* Use DEBUG option to identify the logic error */
data us_mailing /debug;
   set orion.mailing_list;
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   if find(Address3,'US');
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=scan(Address3,2,',');
   Zip=scan(Address3,3,',');
run;

  /* Use the LEFT function to correct the error */
data us_mailing;
   set orion.mailing_list;
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   if find(Address3,'US');
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=left(scan(Address3,2,','));
   Zip=left(scan(Address3,3,','));
run;

proc print data=work.us_mailing noobs;
   title 'Corrected Output from Program';
run;
title;
