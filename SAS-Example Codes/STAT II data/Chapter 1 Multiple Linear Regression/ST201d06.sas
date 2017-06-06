*------------------------------------------------------------------------
	Use PROC STDIZE to center AMOUNT in the sasuser.paper data set
	and use a DATA step to compute the squared and cubed terms
	of the centered variable .
------------------------------------------------------------------------------;
options formdlim="_";
proc stdize data=sasuser.paper method=mean out=paper1(rename=(amount=mcamount));
   var amount;
run;

data paper1;
   set paper1;
   mcamount2 = mcamount**2;
   mcamount3 = mcamount**3;
run;                               *ST201d06.sas;      


/***altertanively, use a SQL and a DATA step to center the variable*/
proc sql;
   select mean(amount) into: mamount
   from sasuser.paper;
run;

data paper2;
   set sasuser.paper;
   mcamount=amount-&mamount;
   mcamount2 = mcamount**2;
   mcamount3 = mcamount**3;
run;      						*ST201d06.sas;             


	
										

