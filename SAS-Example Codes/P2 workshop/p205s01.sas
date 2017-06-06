data work.codes;
  set orion.au_salesforce;
  length FCode1 FCode2 $ 1 LCode $ 4;
  FCode1=lowcase(substr(First_Name,1,1));
  FCode2=substr(First_Name,length(First_Name),1);
  LCode=lowcase(substr(Last_Name,1,4));
run;

title 'Extracted Letters for User IDs';
proc print data=work.codes;
  var First_Name FCode1 FCode2 Last_Name LCode;
run;
title;

 /* Alternate solution */

data work.codes;
  set orion.au_salesforce;
  length FCode1 FCode2 $ 1 LCode $ 4;
  FCode1=lowcase(substr(First_Name,1,1));
  FCode2=substr(right(First_Name),12,1);
  /* Note 12 is the variable length of First_Name */
  LCode=lowcase(substr(Last_Name,1,4));
run;

title 'Extracted Letters for User IDs';
proc print data=work.codes;
  var First_Name FCode1 FCode2 Last_Name LCode;
run;
title;



 
