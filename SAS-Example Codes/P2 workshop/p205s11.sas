data US_converted
      (drop=cID nTelephone cBirthday);
  set orion.US_newhire
      (rename=(ID=cID Telephone=nTelephone
               Birthday=cBirthday));
  ID = input(compress(cID,'-'),15.);
  length Telephone $ 8;
  Telephone = cat(substr(put(nTelephone,7.),1,3),
              '-',substr(put(nTelephone,7.),4));
  Birthday = input(cBirthday,date9.);
run;

title 'US New Hires';
proc print data=US_converted noobs;
run;
title;

proc contents data=US_converted varnum;
run;
