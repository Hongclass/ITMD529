data contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile 'phone.csv' dlm=',' missover;
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts noobs;
run;
