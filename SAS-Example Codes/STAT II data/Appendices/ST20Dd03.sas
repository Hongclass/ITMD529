proc sgscatter data=sasuser.sales;
   plot sales*(date price promotion tvad);
run;
quit;      				*ST2Dd03.sas;

proc reg data=sasuser.sales plots(unpack)=all;
   model sales= price promotion tvad / dwprob;
   plot r.*obs.;
   title 'Using PROC REG for Autocorrelated Data';
run;
quit;  					 *ST2Dd03.sas;

proc autoreg data=sasuser.sales plots(unpack)=all;
   model sales=price promotion tvad / nlag=3 method=ml dwprob;
   title 'Using PROC AUTOREG for Autocorrelated Data';
run;
						 *ST2Dd03.sas;
