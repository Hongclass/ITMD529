  /* Part A */
data work.split;
   set orion.employee_donations (obs=10);
   PctLoc=find(Recipients,'%');
   /* Position in which the first '%' occurs */
   if PctLoc > 0 then do;
      Charity=substr(Recipients,1,PctLoc);
	   output;
	   Charity=substr(Recipients,PctLoc+3);
	   output;
   end;
   /* If '%' was found, then there's more than one recipient */
   /* Use PctLoc+3 for the '%, ' before the second charity */
   else do;
      Charity=trim(Recipients)!!' 100%';
	   output;
   end;
   drop PctLoc Recipients;
run;

proc print data=work.split noobs;
   var Employee_ID Charity;
run;

  /* Part B */
data work.split;
   set orion.employee_donations;
   PctLoc=find(Recipients,'%');
   /* Position in which the first '%' occurs */
   if PctLoc > 0 then do;
      Charity=substr(Recipients,1,PctLoc);
      output;
	   Charity=substr(Recipients,PctLoc+3);
      output;
   end;
   /* If '%' was found, then there's more than one recipient */
   /* Use PctLoc+3 for the '%, ' before the second charity */
   else do;
      Charity=trim(Recipients)!!' 100%';
	   output;
   end;
   drop PctLoc Recipients;
run;

title 'Charity Contributions for each Employee';
proc print data=work.split noobs;
   var Employee_ID Charity;
run;
title;


  /* Alternate solution */
  /* Use SCAN with '%' as a delimiter */

data work.split;
   set orion.employee_donations;
   PctLoc=find(Recipients,'%');
   /* Position in which the first '%' occurs */
   if PctLoc > 0 then do;
      Charity=scan(Recipients,1,'%')!!'%';
      output;
      Charity=substr(scan(Recipients,2,'%')!!'%',3);
      output;
   end;
   /* Since '%' is the delimiter, we must concatenate
      a '%' to the character string after the SCAN */
   else do;
      Charity=trim(Recipients)!!' 100%';
	   output;
   end;
   drop PctLoc Recipients ;
run;

title 'Charity Contributions for each Employee';
proc print data=work.split noobs;
   var Employee_ID Charity;
run;
title;
