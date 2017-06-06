data calcium;
   set sasuser.calcium;
   Trans=-log((1-(calcium/5)));
run;

proc reg data=calcium;
   model trans=time / noint;
run;    
quit;						*ST20Dd01.sas;

proc nlin data=sasuser.calcium hougaard;
   parms a=5 b=0 c=.14 d=1;
   model calcium=a+(b-a)*exp(-(c*time)**d);
   output out=check p=est;
run;

proc sgplot data=check;
   scatter y=calcium x=time;
   series y=est x=time / lineattrs=(color=blue pattern=1);
run;
quit;      					 *ST20Dd01.sas;


proc nlin data=sasuser.calcium hougaard;
   parms a=4.25 b=0.08 c=.21;
   model calcium=a+(b-a)*exp(-(c*time));
run;   						*ST20Dd01.sas;

proc nlin data=sasuser.calcium hougaard;
   parms a=4.31 c=.21;
   model calcium=a+(-a)*exp(-(c*time));
run;         				*ST20Dd01.sas;  

proc nlin data=sasuser.calcium hougaard;
   parms a=4.31 c=.21;
   model calcium=a+(-a)*exp(-(c*time));
   output out=ac parms=A C;
run;

data _null_;
   set ac(obs=1);
   call symput('ap',1/a**2);
   call symput('cp',c**(1/3));
run;

ods output ParameterEstimates=est;
proc nlin data=sasuser.calcium hougaard;
   parms ap=&ap cp=&cp;
   a=1/sqrt(ap);
   c=cp**3;
   model calcium=a+(-a)*exp(-(c*time));
   output out=check r=residual p=predicted;
run;  						*ST20Dd01.sas;

data est;
   set est;
   if parameter='ap' then do;
      Orig_Parameter='a';
      Orig_Estimate=1/sqrt(estimate);
      Orig_LowerCL=1/sqrt(upperCL);
      Orig_UpperCL=1/sqrt(lowerCL);
      output;
   end;

   if parameter='cp' then do;
      Orig_Parameter='c';
      Orig_Estimate=estimate**3;
      Orig_LowerCL=lowerCL**3;
      Orig_UpperCL=upperCL**3;
      output;
   end;
run;
proc print data=est;
   var orig_parameter orig_estimate orig_lowerCL orig_upperCL;
run;                     	*ST20Dd01.sas;

proc sgplot data=check;
   scatter y=calcium x=time;
   series y=predicted x=time / lineattrs=(color=blue pattern=1);
run;
quit;      					 *ST20Dd01.sas;

proc sgplot data=check;
   scatter y=residual x=predicted;
   refline 0;
run;						 *ST20Dd01.sas;

proc univariate data=check;
   var residual;
   histogram / normal;
   probplot / normal(mu=est sigma=est);
run;                         *ST20Dd01.sas;


