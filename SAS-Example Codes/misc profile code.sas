/*options fmtsearch=(SAS);*/
/*libname SAS 'C:\Documents and Settings\ewnym5s\My Documents\SAS';*/
/**/
/**/
/*proc format library=SAS;*/
/*value $segfmt '1' = 'Building their Future'*/
/*			   '2' = 'Mass Affluent no Kids'*/
/*			   '3' = 'Mainstream Families'*/
/*			   '4' = 'Mass Affluent Families'*/
/*			   '5' = 'Mainstream Retired'*/
/*			   '6' = 'Mass Affluent Retired'*/
/*			   '7' = 'Not Coded'*/
/*			   '.' = 'Not Coded'*/
/*			   '8' = 'Building their Future'*/
/*			   '9' = 'Mass Affluent Families'*/
/*			  NULL =  'Not Coded';*/
/*run;*/
/**/
/**/
/*proc format library=SAS;*/
/*value cbrfmt   1 = 'WNY'*/
/*			   2 = 'Rochester'*/
/*			   3 = 'Syracuse'*/
/*			   4 = 'Souther'*/
/*			   5 = 'Albany/HVN'*/
/*			   6 = 'Tarrytown'*/
/*			   7 = 'NYC'*/
/*			   8 = 'Philadelphia'*/
/*			   9 = 'PA North'*/
/*			   10 = 'C&W PA'*/
/*			   11 = 'SEPA'*/
/*			   12 = 'Baltimore'*/
/*			   13 = 'Chesapeake A'*/
/*			   14 ='Washington'*/
/*			   15 = 'Chesapeake B'*/
/*			   16 = 'Central VA'*/
/*			   17 = 'Delaware'*/
/*			  . =  'Out of Market';*/
/*run;*/
/**/
/**/
/*proc format library=SAS;*/
/*value $cbrfmtb   '    1' = 'WNY'*/
/*			   '    2' = 'Rochester'*/
/*			   '    3' = 'Syracuse'*/
/*			   '    4' = 'Souther'*/
/*			   '    5' = 'Albany/HVN'*/
/*			   '    6' = 'Tarrytown'*/
/*			   '    7' = 'NYC'*/
/*			   '    8' = 'Philadelphia'*/
/*			   '    9' = 'PA North'*/
/*			   '   10' = 'C&W PA'*/
/*			   '   11' = 'SEPA'*/
/*			   '   12' = 'Baltimore'*/
/*			   '   13' = 'Chesapeake A'*/
/*			   '   14' ='Washington'*/
/*			   '   15' = 'Chesapeake B'*/
/*			   '   16' = 'Central VA'*/
/*			   '   17' = 'Delaware'*/
/*			  '   99' =  'Out of Market'*/
/*			  'Total' = 'Total';*/
/*/*			  ' CBR1' = 'WNY'*/*/
/*/*			   ' CBR2' = 'Rochester'*/*/
/*/*			   ' CBR3' = 'Syracuse'*/*/
/*/*			   ' CBR4' = 'Souther'*/*/
/*/*			   ' CBR5' = 'Albany/HVN'*/*/
/*/*			   ' CBR6' = 'Tarrytown'*/*/
/*/*			   ' CBR7' = 'NYC'*/*/
/*/*			   ' CBR8' = 'Philadelphia'*/*/
/*/*			   ' CBR9' = 'PA North'*/*/
/*/*			   'CBR10' = 'C&W PA'*/*/
/*/*			   'CBR11' = 'SEPA'*/*/
/*/*			   'CBR12' = 'Baltimore'*/*/
/*/*			   'CBR13' = 'Chesapeake A'*/*/
/*/*			   'CBR14' ='Washington'*/*/
/*/*			   'CBR15' = 'Chesapeake B'*/*/
/*/*			   'CBR16' = 'Central VA'*/*/
/*/*			   'CBR17' = 'Delaware'*/*/
/*/*			  'CBR99' =  'Out of Market';*/*/
/*run;*/
/**/
/*data data.cbr_class;*/
/*input cbr;*/
/*datalines;*/
/*. */
/*1 */
/*2 */
/*3 */
/*4 */
/*5 */
/*6 */
/*7 */
/*8 */
/*9 */
/*10*/
/*11 */
/*12*/
/*13*/
/*14*/
/*15*/
/*16*/
/*17*/
/*;*/
/*run;*/
/**/
/**/
/*data data.segment_class;*/
/*input segment;*/
/*datalines;*/
/*. */
/*1 */
/*2 */
/*3 */
/*4 */
/*5 */
/*6 */
/*7 */
/*8*/
/*9*/
/*;*/
/*run;*/
/**/
/*data data.band_class;*/
/*input band $ 1;*/
/*datalines;*/
/*A*/
/*B*/
/*C*/
/*D*/
/*E*/
/**/
/*;*/
/*run;*/
/**/
/**/
/*data data.band_yr_class;*/
/*input band $ 1;*/
/*datalines;*/
/*A*/
/*B*/
/*C*/
/*D*/
/*E*/
/**/
/*;*/
/*run;*/
/**/
/*data data.market_class;*/
/*input market;*/
/*datalines;*/
/*1*/
/*2*/
/*3*/
/*4*/
/*6*/
/*7*/
/*8*/
/*99*/
/*;*/
/*run;*/
/**/
/*data data.test1_class;*/
/*input test1 $;*/
/*datalines;*/
/*N*/
/*I*/
/*L*/
/*M*/
/*H*/
/*;*/
/*run;*/

/*data cbr2;*/
/*length Name $ 5;*/
/*set cbr1;*/
/*retain tot tot1;*/
/*tot+hh_sum;*/
/*tot1+hh_PCTN_0;*/
/*if hh_sum eq . then do*/
/*	hh_sum = 0;*/
/*end;*/
/*if cbr ne . then do;*/
/*	Name = CBR;*/
/*end;*/
/*else if cbr eq .  then do;*/
/*	Name = '   99';*/
/*end;*/
/*hh_PCTN_0=hh_PCTN_0/100;*/
/*output;*/
/*if _N_ = 18;*/
/*	Name='Total';*/
/*	hh_sum=tot;*/
/*	hh_PCTN_0=tot1/100;*/
/*	output;*/
/*drop tot tot1 segment cbr;*/
/*run;*/

/*proc sort data=cbr2;*/
/*by name;*/
/*run;*/


/*title "CBR Report for " &TitleName;*/
/*proc print data=cbr4 split=' ' noobs;*/
/*var Name hh_Sum hh_pctn_0;*/
/*label Name ='Community Bank Region'*/
/*      hh_sum='Number of HHs'*/
/*	  hh_pctn_0='Percent of HHs';*/
/*format Name $cbrfmtb. HH_Sum comma12.0 hh_pctn_0 percent8.1;*/
/*run;*/
/*title;*/


