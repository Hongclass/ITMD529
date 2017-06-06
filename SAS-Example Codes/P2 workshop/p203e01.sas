data work.mid_q4;
  set orion.order_fact;
  where '01nov2004'd <= Order_Date <= '14dec2004'd;
  Sales2Dte+Total_Retail_Price;
  Num_Orders+1;
  Num_Order2=_N_;
run;


title 'Orders from 01Nov2004 through 14Dec2004';
proc print data=work.mid_q4;
  var Order_ID Order_Date Total_Retail_Price Sales2Dte Num_orders Num_order2;
  format Sales2Dte dollar10.2;
run;
title;

data typetotals;
	set orion.order_fact;
	where year(order_date)=2005;
	select (order_type);
		when (1) TotalRetail+Quantity;
		when (2) TotalCatalog+Quantity;
		when (3) TotalInternet+Quantity; 
		otherwise;
	end;
	keep Order_date Order_ID TotalRetail TotalCatalog TotalInternet;
run;


*Ex 3-42;
proc sort data=orion.order_summary out=sumsort;
	by customer_id;
run;

data customers;
	set sumsort;
	by customer_id;
	if first.customer_id then Total_Sales=0;
	Total_Sales+Sale_Amt;
	format total_sales dollar11.2;
	if last.customer_id;
run;

proc sort data=orion.order_qtrsum out=order_qtrsum_sort;
	by customer_id order_Qtr;
run;

data qtrcustomers;
	set order_qtrsum_sort;
	by customer_id order_qtr;
	if first.order_qtr then do;
		total_sales=0;
		num_months=0;
		end;
	total_sales+sale_amt;
	num_months+1;
	if last.order_qtr;
	keep customer_id order_qtr total_sales num_months;
run;

data sales_stuff;
	infile 's:\workshop\sales1.dat';
	input @1 Employee_ID 6.
		  /*@8 First_Name $12.*/
		  @21 Last_Namw $18.
		  /*@40 Gender $1.*/
		  @43 Job_Title $20.
		  @64 Salary dollar8.
		  @73 Country $2.
		  /*@76 Birth_Date mmddyy10.*/
		  @87 Hire_Date mmddyy10.;
run;

data US_trainees AU_trainees;
	set sales_stuff;
	where Job_Title='Sales Rep. I';
	select (upcase(country));
		when ('US') output US_trainees;
		when ('AU') output AU_trainees;
		otherwise;
	end;
run;

*Ex 4-49;

data US_sales AU_sales;
	infile 's:\workshop\sales3.dat';
	input Employee_ID 6.
		  @21 Last_Name $18.
		  @43 Job_Title $20. ;
	input @10 Country $2. @;
	if upcase(Country)='AU' then do;
		input @1 salary dollarx8.
			@24 Hire_date ddmmyy10.;
		output AU_sales;
		end;
	if upcase(Country)='US' then do;
		input @1 salary dollar8.
			@24 Hire_date mmddyy10.;
		output US_sales;
		end;
run;


*Ex 5-25;

data codes;
	set orion.au_salesforce;
	FCode1=lowcase(char(First_Name, 1));
	FCode2=lowcase(char(First_Name, length(First_name)));
	LCode=lowcase(substr(Last_Name, 1, 4));
run;

data codes;
	set orion.newcompetitors;
	Country=substr(ID, 1, 2);
	Store_Code=left(substr(ID, 3, length(ID)));
	City=propcase(City);
	if char(Store_Code, 1)='1';
	keep Store_code country city postal_code;
run;

*Ex 5-53;

data split;
	set orion.employee_donations(keep=employee_id recipients);
	PctLoc=find(Recipients, '%');
	if PctLoc>0 then do;
		Charity=substr(Recipients, 1, PctLoc); output;
		Charity=substr(Recipients, PctLoc+3); output;
		end;
run;