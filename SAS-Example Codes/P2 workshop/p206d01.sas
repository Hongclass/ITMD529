data _null_;
   set orion.donate end=lastObs;
   if _n_=1 then
      putlog 'First iteration';
   if lastObs then do;
      putlog 'Final values of variables:';
      putlog _all_;
   end; 
run;
