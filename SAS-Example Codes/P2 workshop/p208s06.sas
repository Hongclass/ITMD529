 /* Step1 - Transpose the amount variable */
proc transpose data=orion.monthly_donations 
               out=donations(drop=_name_ _label_)
               prefix=Qtr;
	 var amount ;
	 id qtr;
   by employee_id ;
run;
proc print data=donations;
run;

 /* Step 2 - Transpose the acct_code variable. */
proc transpose data=orion.monthly_donations 
               out=accts(drop=_name_ _label_) 
               prefix=Account;
    var acct_code;
	by employee_id;
	id qtr;
run;
proc print data=accts;
run;

 /* Step 3 - Merge the two transposed datasets to get the final result */
data final;
   merge donations accts;
   by employee_id;
run;
proc print data=final noobs;
  var Employee_id Qtr1-Qtr4 Account1-Account4;
run;
