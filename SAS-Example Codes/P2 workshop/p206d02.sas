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

  /* Use PUTLOG to help identify the error */
data us_mailing;
   set orion.mailing_list;
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   putlog _n_=;
   putlog "Looking for country";
   if find(Address3,'US') > 0;
   putlog "Found US";
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=scan(address3,2,',');
   Zip=scan(Address3,3,',');
   putlog State= Zip=;
run;

  /* Use a format with PUTLOG to help identify the error */
  /* Use OBS= to limit processing to the first 10 obs */
data us_mailing;
   set orion.mailing_list (obs=10);
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   putlog _n_=;
   putlog "Looking for country";
   if find(Address3,'US') > 0;
   putlog "Found US";
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=scan(address3,2,',');
   putlog state $quote4.;
   Zip=scan(Address3,3,',');
   putlog Zip $quote7.;
run;


  /* Use the LEFT function to remove leading blanks */

data us_mailing;
   set orion.mailing_list (obs=10);
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   putlog _n_=;
   putlog "Looking for country";
   if find(Address3,'US') > 0;
   putlog "Found US";
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=left(scan(address3,2,','));
   putlog state $quote4.;
   Zip=left(scan(Address3,3,','));
   putlog Zip $quote7.;
run;

  /* Remove putlog statements */

data us_mailing;
   set orion.mailing_list;
   drop Address3;
   length City $ 25 State $ 2 Zip $ 5;
   if find(Address3,'US') > 0;
   Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
   City=scan(Address3,1,',');
   State=left(scan(address3,2,','));
   Zip=left(scan(Address3,3,','));
run;

proc print data=work.us_mailing noobs;
   title 'Corrected Output';
run;
title;
