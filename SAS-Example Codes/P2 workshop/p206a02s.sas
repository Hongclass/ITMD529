data _null_;
   set orion.donate;
   if _n_ <= 3 then 
      putlog _n_= _error_=;
run;

  /* alternate solution */

data _null_;
   set orion.donate (obs=3);
   putlog _n_=  _error_=;
run;
