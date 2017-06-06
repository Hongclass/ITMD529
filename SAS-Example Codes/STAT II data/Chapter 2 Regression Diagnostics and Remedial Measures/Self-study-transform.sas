*-------------------------------------------------------------------
 - Create 20 groups based on PRICE 
 - Calculate the group means and variances 
 - Use a data step to calculate the ratio of standard deviation 
       divided by powers of the mean
 - Use SQL to stability of relationship by comparing max to min 
       for each group
----------------------------------------------------------------------;

proc rank data=sasuser.cars out=partitioned groups=20;
  var price;
  ranks group;
run;
proc means data=partitioned nway noprint;
   class group;
   var price;
   output out=check_transform mean=Mean std=std n=N;
run;

data check_transform;
   set check_transform;
   ID_Transform=std;
   Sqrt_Transform=std/mean;
   Log_Transform=std/(mean**2);
   Inverse_Transform=std/(mean**4);
run;

proc sql;
   select max(ID_transform)/min(ID_transform) as IDQuotient,
          max(sqrt_transform)/min(sqrt_transform) as SqrtQuotient,
          max(log_transform)/min(log_transform) as LogQuotient,
          max(inverse_transform)/min(inverse_transform) as InverseQuotient 
   from check_transform;
quit;
 
