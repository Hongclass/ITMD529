/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Wednesday, December 07, 2011     TIME: 3:48:19 PM
PROJECT: Day1
PROJECT PATH: D:\SAS\Day1.egp
---------------------------------------- */

/* ---------------------------------- */
/* MACRO: enterpriseguide             */
/* PURPOSE: define a macro variable   */
/*   that contains the file system    */
/*   path of the WORK library on the  */
/*   server.  Note that different     */
/*   logic is needed depending on the */
/*   server type.                     */
/* ---------------------------------- */
%macro enterpriseguide;
%global sasworklocation;
%if &sysscp=OS %then %do; /* MVS Server */
	%if %sysfunc(getoption(filesystem))=MVS %then %do;
        /* By default, physical file name will be considered a classic MVS data 
set. */
	    /* Construct dsn that will be unique for each concurrent session under a 
particular account: */
		filename egtemp '&egtemp' disp=(new,delete); /* create a temporary data set */
 		%let tempdsn=%sysfunc(pathname(egtemp)); /* get dsn */
		filename egtemp clear; /* get rid of data set - we only wanted its name */
		%let unique_dsn=".EGTEMP.%substr(&tempdsn, 1, 16).PDSE"; 
		filename egtmpdir &unique_dsn
			disp=(new,delete,delete) space=(cyl,(5,5,50))
			dsorg=po dsntype=library recfm=vb
			lrecl=8000 blksize=8004 ;
		options fileext=ignore ;
	%end; 
 	%else %do; 
        /* 
		By default, physical file name will be considered an HFS 
		(hierarchical file system) file. 
		Note:  This does NOT support users who do not have an HFS home directory.
		It also may not support multiple simultaneous sessions under the same account.
		*/
		filename egtmpdir './';                          
	%end; 
	%let path=%sysfunc(pathname(egtmpdir));
        %let sasworklocation=%sysfunc(quote(&path));  
%end; /* MVS Server */
%else %do;
	%let sasworklocation = "%sysfunc(getoption(work))/";
%end;
%if &sysscp=VMS_AXP %then %do; /* Alpha VMS server */
	%let sasworklocation = "%sysfunc(getoption(work))";                         
%end;
%if &sysscp=CMS %then %do; 
	%let path = %sysfunc(getoption(work));                         
	%let sasworklocation = "%substr(&path, %index(&path,%str( )))";
%end;
%mend enterpriseguide;

%enterpriseguide

ODS PROCTITLE;
OPTIONS DEV=ACTIVEX;
GOPTIONS XPIXELS=0 YPIXELS=0;
FILENAME EGSRX TEMP;
ODS tagsets.sasreport12(ID=EGSRX) FILE=EGSRX STYLE=Analysis STYLESHEET=(URL=
"file:///C:/Program%20Files/SAS/EnterpriseGuide/4.3/Styles/Analysis.css") 
NOGTITLE NOGFOOTNOTE GPATH=&sasworklocation ENCODING=UTF8 options(rolap="on");

/*   START OF NODE: Program   */
%LET _CLIENTTASKLABEL='Program';
%LET _CLIENTPROJECTPATH='D:\SAS\Day1.egp';
%LET _CLIENTPROJECTNAME='Day1.egp';
%LET _SASPROGRAMFILE=;

GOPTIONS ACCESSIBLE;
libname orion 's:\workshop';

*Ex 2-31;

data admin stock purchasing;
	set orion.employee_organization;
	select (lowcase(Department));
		when ('administration') output admin;
		when ('stock & shipping') output stock;
		when ('purchasing') output purchasing;
		otherwise;
	end;
run;

data fast slow veryslow;
	set orion.orders;
	where order_type in (2, 3);
	drop employee_id;
	ShipDays=Delivery_date - order_date;
	select;
		when (ShipDays < 3) output fast;
		when (5 <= ShipDays <= 7) output slow;
		when (ShipDays > 7) output veryslow;
		otherwise;
	end;
run;

*Ex 2-51;

data sales(keep= employee_id job_title manager_id) 
		exec(keep=employee_id job_title);
	set orion.employee_organization;
	select (upcase(Department));
		when ('SALES') output sales;
		when ('EXECUTIVES') output exec;
		otherwise;
	end;
run;

proc print data=sales(obs=6);
run;

proc print data=exec(obs=3 firstobs=2);
run;

data instore(keep= order_id customer_id order_date) 
	 delivery(keep=order_id customer_id order_date ShipDays);
	set orion.orders ();
	where order_type=1;
	ShipDays=Delivery_Date - Order_date;
	if ShipDays=0 then output instore;
	else if ShipDays>0 then output delivery;
run;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;


/*   START OF NODE: p201a01   */
%LET _CLIENTTASKLABEL='p201a01';
%LET _CLIENTPROJECTPATH='D:\SAS\Day1.egp';
%LET _CLIENTPROJECTNAME='Day1.egp';
%LET _SASPROGRAMFILE='S:\workshop\p201a01.sas';

GOPTIONS ACCESSIBLE;
libname orion 's:\workshop';
data work.qtr1salesrep;
   set orion.sales;
   where Job_Title contains 'Rep';
   BonusMonth=month(Hire_Date);
   if BonusMonth in (1,2,3);
   if Country='US' then Bonus=500;
   else if Country='AU' then Bonus=300;
   Compensation=sum(Salary,Bonus);
   keep First_Name Last_Name Country Gender Salary
        Hire_Date BonusMonth Bonus Compensation;
   label First_Name='First Name'
         Last_Name='Last Name'
		 Hire_Date='Date of Hire'
		 BonusMonth='Month of Bonus';
   format Hire_Date ddmmyy10.;
run;

proc sort data=work.qtr1salesrep;
   by Country descending Last_Name;
run;

proc format;
   value $ctryfmt 'AU'='Australia'
                  'US'='United States';
run;

options nodate pageno=1;
ods html file='salesrep.html' style=sasweb;
proc print data=work.qtr1salesrep label noobs;
   var Last_Name First_Name BonusMonth Bonus;
   title1 'Quarter 1 Orion Sales Reps';
   title2 'Males Only';
   footnote 'Confidential';
   format Bonus  dollar8. Country $ctryfmt.;
   where Gender='M';   
   by Country;
run;
ods html close;
title;
footnote;



GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;


/*   START OF NODE: p202a01   */
%LET _CLIENTTASKLABEL='p202a01';
%LET _CLIENTPROJECTPATH='D:\SAS\Day1.egp';
%LET _CLIENTPROJECTNAME='Day1.egp';
%LET _SASPROGRAMFILE='S:\workshop\p202a01.sas';

GOPTIONS ACCESSIBLE;
data forecast;
   set orion.growth;
   Year=1;
   Total_Employees=Total_Employees*(1+Increase);
   *output;
   Year=2;
   Total_Employees=Total_Employees*(1+Increase);
   output;
run;
proc print data=forecast noobs;
   var Department Total_Employees Year;
run;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;


/*   START OF NODE: p202e01   */
%LET _CLIENTTASKLABEL='p202e01';
%LET _CLIENTPROJECTPATH='D:\SAS\Day1.egp';
%LET _CLIENTPROJECTNAME='Day1.egp';
%LET _SASPROGRAMFILE='S:\workshop\p202e01.sas';

GOPTIONS ACCESSIBLE;
data work.price_increase;
   set orion.prices;
   Year=1;
   Unit_Price=Unit_Price*factor;
   output;
   Year=2;
   Unit_Price=Unit_Price*factor;
   output;
   Year=3;
   Unit_Price=Unit_Price*factor;
   output;
run;
proc print data=work.price_increase;
	var Product_ID Unit_Price Year;
run;

data work.extended;
	set orion.discount;
	where Start_Date='01Dec2007'd;
	Promotion=Unit_Sales_Price*Discount;
	if month(Start_Date)=7 then Season=

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;


/*   START OF NODE: p202a03   */
%LET _CLIENTTASKLABEL='p202a03';
%LET _CLIENTPROJECTPATH='D:\SAS\Day1.egp';
%LET _CLIENTPROJECTNAME='Day1.egp';
%LET _SASPROGRAMFILE='S:\workshop\p202a03.sas';

GOPTIONS ACCESSIBLE;
data usa australia;
   set orion.employee_addresses;
   select (Country);
	  when ('US') output usa;
	  when ('AU') output australia;
	  otherwise;
   end;
run;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;


/*   START OF NODE: p203e01   */
%LET _CLIENTTASKLABEL='p203e01';
%LET _CLIENTPROJECTPATH='D:\SAS\Day1.egp';
%LET _CLIENTPROJECTNAME='Day1.egp';
%LET _SASPROGRAMFILE='S:\workshop\p203e01.sas';

GOPTIONS ACCESSIBLE;
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

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
