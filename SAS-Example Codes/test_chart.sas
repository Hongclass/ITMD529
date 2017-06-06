axis2 label=(f="Arial/Bold" "Product") order=('Checking' 'Money Market' 'Savings' 'Time Deposits' 'IRAs' 'Securities' 'Trust' 'Insurance' 
'Mortgage' 'Home Equity' 'Dir. Inst. Loan' 'Ind. Inst. Loan' 'Credit Card' 'Student Loan' 'Safe Deposit Box') ;
axis1 major=None minor=NOne color=black value=None label=(f="Arial/Bold" "Product Penetration") split=" ";
%hbar_grouped (analysis_var=Penetration,group_var=Product,class_var=&class1,table=Prod3 (where=(Product ne 'Total')),title_str=&title,format_name=Percent8.1);

data wip.prod4;
set wip.prod3;
where Product ne 'Total';
run;

%let table= prod4;
%let analysis_var=Penetration;
%let group_var=Product;
%let class_var=&class1;
%let title_str=&title;
%let format_name=Percent8.1;

option symbolgen;

/*%macro hbar_grouped (analysis_var=,group_var=,class_var=,table=,title_str=,format_name=) / store source des='create hbar chart macro';*/

/*axis2 label=(f="Arial/Bold" "Product") order=("Checking" "Money Market" "Savings" "Time Deposits" "IRAs" "Securities" "Trust" "Insurance" */
/*"Mortgage" "Home Equity" "Dir. Inst. Loan" "Ind. Inst. Loan" "Credit Card" "Student Loan" "Safe Deposit Box") ;*/

axis2 label=(f="Arial/Bold" "Product");
axis1 major=None minor=NOne color=black value=None label=(f="Arial/Bold" "Product Penetration") split=" ";
legend1 label=("Segment:") position=(bottom center outside) mode=protect across=1 ; 

goptions reset=goptions;

proc gchart data=wip.&table ;
hbar &class_var / type=sum sumvar=&analysis_var
/*midpoints=  "Branch" "Inactive" "Virtual"*/
/*raxis=axis1 maxis=axis2 */
noframe
group= &group_var
gspace = 1
PATTERNID=MIDPOINT
;
format &analysis_var &format_name;
run;

vbar &class_var / outside = sum type=sum sumvar=&analysis_var
raxis=axis1  noframe
group= &group_var 
PATTERNID=MIDPOINT
legend=legend1;
format &analysis_var &format_name;
run;
quit;

%vbar_grouped (analysis_var=Penetration,group_var=Product,class_var=&class1,table=Prod3,title_str=&title,format_name=Percent8.1);

axis1 split=" ";
legend1 label=none shape=bar(.15in,.15in) cborder=black position=(inside top right) mode=reserve;
proc gchart data=wip.&table ;
vbar &class_var / type=sum sumvar=&analysis_var
noframe outside=sum maxis=axis1
group= &group_var
gspace = 1 
PATTERNID=MIDPOINT
autoref clipref cref=graybb
legend=legend1;
format &analysis_var &format_name &group_var $ptype.;
run;

axis1 split=" ";
legend1 label=none shape=bar(.15in,.15in) cborder=black position=(outside bottom center) mode=reserve;
proc gchart data=wip.&table ;
hbar &class_var / type=sum sumvar=&analysis_var
noframe maxis=axis1
group= &group_var
gspace = 1 
PATTERNID=MIDPOINT
legend=legend1
autoref clipref cref=graybb;
format &analysis_var &format_name;
run;


libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
options fmtsearch=(SAS);
proc format library=SAS;
value $PTYPE 'Checking' = 'DDA'
             'Money Market' = 'MMS'
			 'Savings' = 'SAV'
			 'Time Deposits' = 'TDA'
			 'IRAs' = 'IRA'
			 'Mortgage' = 'MTG'
			 'Home Equity' = 'HEQ'
			 'Credit Card' = "Card"
			 'Safe Deposit Box' = 'SDB'
			 'Student Loan' = 'SLN'
			 'Dir. Inst. Loan' = 'ILN'
			 'Ind. Inst. Loan' = 'IND'
			 'Securities' = 'SEC'
			 'Trust' = 'TRS'
			 'Insurance' = 'INS';
run;



proc format library=SAS;
value mktfmt 1 = 'WNY'
 		     2 = 'Ctl NY/E PA'
			 3 = 'Estrn/Metro'
			 4 = 'Ctl PA/W MD'
			 6 = 'G Balt'
			 7 = 'G Wash'
			 8 = 'G Del'
			 98 = 'NATL'
			 99 = 'Out of Mkt';

value cbrfmt 1 = 'WNY'
			 2 = 'Roch'
			 3 = 'Ctl NY'
			 4 = 'S NY'
			 5 = 'Alb HVN'
			 6 = 'Tarry'
			 7 = 'NYC'
			 8 = 'Philly'
  			 9 = 'PA N'
        	10 = 'C&W PA'
			11 = 'SE PA'
			12 = 'Balt'
			13 = 'G Wash'
			14 = 'Ches A'
			15 = 'Ches B'
			16 = 'Ctl VA'
			17 = 'Ches DE'
			99 = 'Out of Mkt';

value $mktfmt '1' = 'WNY'
 		     '2' = 'Ctl NY/E PA'
			 '3' = 'Estrn/Metro'
			 '4' = 'Ctl PA/W MD'
			 '6' = 'G Balt'
			 '7' = 'G Wash'
			 '8' = 'G Del'
			 '98' = 'NATL'
			 '99' = 'Out of Mkt';

value $cbrfmt '1' = 'WNY'
			 '2' = 'Roch'
			 '3' = 'Ctl NY'
			'4' = 'S NY'
			 '5' = 'Alb/HVN'
			 '6' = 'Tarry'
			 '7' = 'NYC'
			 '8' = 'Philly'
  			 '9' = 'PA N'
        	'10' = 'C&W PA'
			'11' = 'SE PA'
			'12' = 'Balt'
			'13' = 'G Wash'
			'14' = 'Ches A'
			'15' = 'Ches B'
			'16' = 'Ctl VA'
			'17' = 'Ches DE'
			'99' = 'Out of Mkt';

RUN;
