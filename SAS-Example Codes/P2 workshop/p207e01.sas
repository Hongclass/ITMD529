data future_expenses;
   drop start stop; 
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   Income=50000000;
   start=year(today())+1;
   stop=start+30;
  /* insert a DO loop here */
   	do Year=start to stop until(total_cost>income);
		wages=wages*1.06;
		retire=retire*1.014;
		medical=medical*1.095;
		income=income*1.01;
		Total_Cost=sum(wages,retire,medical);
		output;
	end;
run;
proc print data=future_expenses;
   format wages retire medical total_cost comma14.2;
   var year wages retire medical total_cost;
run;


data expenses;
	format income expenses dollar20.2;
	income=50000000;
	expenses=38750000;
	do Year=1 to 30 until(expenses>income);
		income=income*1.01;
		expenses=expenses*1.02;
	end;
run;