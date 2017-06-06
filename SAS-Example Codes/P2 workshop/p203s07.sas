proc sort data=orion.customer_dim out=work.customers;
  by Customer_Type;
run;

data work.agecheck;
  set work.customers;
  by Customer_Type;
  retain oldest youngest o_ID y_ID;
  if first.Customer_Type=1 then do;
    oldest=Customer_BirthDate;
	youngest=Customer_BirthDate;
	o_ID=Customer_ID;
	y_ID=Customer_ID;
  end;
  if Customer_BirthDate < oldest then do;
    o_ID=Customer_ID;
    oldest=Customer_BirthDate;
  end;
  else if Customer_BirthDate > youngest then do;
    y_ID=Customer_ID;
    youngest=Customer_BirthDate;
  end;
  if last.Customer_Type=1 then do;
    agerange=(youngest-oldest)/365.25;
	output;
  end;
  keep Customer_Type oldest youngest o_ID y_ID agerange;
run;

title 'Oldest and Youngest Customers of each Customer Type';
proc print data=work.agecheck noobs;
  format oldest youngest date9. agerange 5.1;
run;
title;


 /* Alternate solution */
proc sort data=orion.customer_dim out=work.customers;
  by Customer_Type Customer_BirthDate;
run;

data work.agecheck;
  set work.customers;
  by Customer_Type;
  /* Could instead use: by Customer_Type Customer_BirthDate; 
     In this DATA step, either BY statement works. */
  retain oldest youngest o_ID y_ID;
  if first.Customer_Type=1 then do;
    o_ID=Customer_ID;
	oldest=Customer_BirthDate;
  end;
  /* Having sorted also on Customer_BirthDate, we know the first
  customer in each BY group will be the oldest (have the 
  smallest SAS date value for a Birthday). */
  if last.Customer_Type=1 then do;
    y_ID=Customer_ID;
	youngest=Customer_BirthDate;
    agerange=(youngest-oldest)/365.25;
	output;
  end;
  /* Similar story: last in each BY group will be the youngest. */
  keep Customer_Type oldest youngest o_ID y_ID agerange;
run;

title 'Oldest and Youngest Customers of each Customer Type';
proc print data=work.agecheck noobs;
  format oldest youngest date9. agerange 5.1;
run;
title;
