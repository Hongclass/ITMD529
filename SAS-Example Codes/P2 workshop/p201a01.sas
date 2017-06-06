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

