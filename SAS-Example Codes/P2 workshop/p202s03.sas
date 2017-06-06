data work.lookup;
  set orion.country;
  Outdated='N';
  output;
  if Country_FormerName ne ' ' then do;
    Country_Name=Country_FormerName;
	Outdated='Y';
	output;
  end;
  drop Country_FormerName Population;
run;

title 'Current and Outdated Country Name Data';
proc print data=work.lookup;
run;
title;
