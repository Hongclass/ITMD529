/*
/ Program   : hashmerge.sas    http://www2.sas.com/proceedings/forum2008/107-2008.pdf
/ Version   : 1.0
/ Author    : Gregg P. Snell   gsnell@datasavantconsulting.com
/ Date      : 03-Apr-2008
/ Purpose   : %HASHMERGE was written with the SAS® 9 Macro Language Facility 
/             and DATA step Component Object Interface, or "hashing".  
/             This macro programmatically ascertains if the two datasets to 
/             be merged could be completed with hashing in the current SAS session.  
/             If so, it generates the appropriate hashing code and if not, it 
/             generates the old-fashioned sort-n-merge code. 
/ SubMacros : none
/
/ Limitations/Assumptions 
/ 1.  Only one table can be created as a result of the merge.   
/ 2.  Only two tables can be merged at one time.   
/ 3.  The merge must be one-one or many-one. (recall that hash objects auto-dedupe) 
/ 4.  Table names are passed without any dataset options (i.e. rename or keep).   SAS® 9.1.3 has 
      38 different dataset options that could be specified in any order and in virtually any combination.  
/ 5.  The passed variables must be single variable names space-separated.  In other words, no 
      colon modifiers or range specifications (i.e. var1: or var1-var10) 
/ 6.  All tables are SAS datasets (i.e. no RDBMS tables) 
/
/ Usage     : %hashmerge(data=test2, 
/                      data_a=small, 
/                      data_b=large, 
/                      vars_b=largevar1 largevar22 largevar300, 
/                          by=keyvar, 
/                          if=a); 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ data              table name (with no dataset options) being created by the merge
/ data_a            name of first table to merge and typically specified with the option (in=a)
/ vars_a            space-separated list of variables to keep from data_a where blank indicates all
/ data_b            name of second table to merge and typically specified with the option (in=b)
/ vars_b            space-separated list of variables to keep from data_b where blank indicates all 
/ by                space-separated list of variables to match-merge the two tables
/ if                valid options are: blank, a, b, a or b, a and b 
/===============================================================================
/ AMENDMENT HISTORY:
/ --date-- ----------------------description------------------------
/ 
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk. 
/=============================================================================*/

%macro hashmerge(data=,
                 data_a=,
                 vars_a=,
                 data_b=,
                 vars_b=,
		           by=,
                 if=);                 

/* remove case-sensitive ambiguity */
%let data=%upcase(&data);
%let data_a=%upcase(&data_a);
%let vars_a=%upcase(&vars_a);
%let data_b=%upcase(&data_b);
%let vars_b=%upcase(&vars_b);
%let by=%upcase(&by);
%let if=%upcase(&if);

/* the macro may have been called with: data_a=mylib.new, or data_a=test (implying work.test)
/* parse the passed values for data_a into data_a_lib and data_a_data, ditto data_b */
data _null_;
   if index("&data_a",'.') then do;
      call symput('data_a_lib',scan("&data_a",1,'.'));
      call symput('data_a_data',scan("&data_a",2,'.'));
   end;
   else do;
      call symput('data_a_lib','WORK');
      call symput('data_a_data',"&data_a");
   end;
   
   if index("&data_b",'.') then do;
      call symput('data_b_lib',scan("&data_b",1,'.'));
      call symput('data_b_data',scan("&data_b",2,'.'));
   end;
   else do;
      call symput('data_b_lib','WORK');
      call symput('data_b_data',"&data_b");
   end;
run;

/* the by=, vars_a=, vars_b= values were passed as space-separated variables */
/* create a quote-comma separated list of each for subsequent where clauses and hashing lists */
data _null_;
   length newvars $2000;
      byvars=compbl("&by");
      words=countc(byvars,' ')+1;
      do i=1 to words;
         if i=1 then newvars=scan(byvars,i,' ');
		   else newvars=catx('","',newvars,scan(byvars,i,' '));
      end;
      call symput('by_vars',trim(newvars)); 	   

   %if %str(&vars_a) ne %str() %then %do;
      vars=compbl("&vars_a");
      words=countc(vars,' ')+1;
      do i=1 to words;
         if i=1 then newvars=scan(vars,i,' ');
		   else newvars=catx('","',newvars,scan(vars,i,' '));
      end;
      call symput('data_vars_a',trim(newvars)); 	   
   %end;

   %if %str(&vars_b) ne %str() %then %do;
      vars=compbl("&vars_b");
      words=countc(vars,' ')+1;
      do i=1 to words;
         if i=1 then newvars=scan(vars,i,' ');
		   else newvars=catx('","',newvars,scan(vars,i,' '));
      end;
      call symput('data_vars_b',trim(newvars)); 	   
   %end;
run;

/* initialize these macro vars here in case nothing selected below */
%let init_vars_a=;
%let init_vars_b=;

proc sql noprint;
   /* if no vars passed, create quote-comma list of all */
   %if %str(&vars_a) = %str() %then %do;
      select upcase(trim(name)) into :data_vars_a separated by '","'
         from sashelp.vcolumn 
         where libname="&data_a_lib" and memname="&data_a_data" and 
               upcase(name) not in("&by_vars");
   %end;
   %if %str(&vars_b) = %str() %then %do;
      select upcase(trim(name)) into :data_vars_b separated by '","'
         from sashelp.vcolumn 
         where libname="&data_b_lib" and memname="&data_b_data" and 
               upcase(name) not in("&by_vars");
   %end;
   
   /* create keep var list */
   select upcase(trim(name)) into :keep_a separated by ' '
      from sashelp.vcolumn
      where libname="&data_a_lib" and memname="&data_a_data" and 
            upcase(name) in("&by_vars","&data_vars_a");
   select upcase(trim(name)) into :keep_b separated by ' '
      from sashelp.vcolumn
      where libname="&data_b_lib" and memname="&data_b_data" and 
            upcase(name) in("&by_vars","&data_vars_b");
      
   
   /* calculate mem (in megabytes) requirement for each dataset */
   select floor(y.nobs*sum(z.length)/1000000) into :mem_a
      from sashelp.vtable as y,
           sashelp.vcolumn as z
      where y.libname="&data_a_lib" and y.memname="&data_a_data" and 
            upcase(z.name) in("&by_vars","&data_vars_a") and
            y.libname=z.libname and y.memname=z.memname;
   select floor(y.nobs*sum(z.length)/1000000) into :mem_b
      from sashelp.vtable as y,
           sashelp.vcolumn as z
      where y.libname="&data_b_lib" and y.memname="&data_b_data" and 
            upcase(z.name) in("&by_vars","&data_vars_b") and
            y.libname=z.libname and y.memname=z.memname;

   /* create init vars for each dataset */
   select upcase(trim(name)) into :init_vars_a separated by ','
          from sashelp.vcolumn
          where libname="&data_a_lib" and memname="&data_a_data" and 
                upcase(name) in("&data_vars_a") and upcase(name) not in("&by_vars");
   select upcase(trim(name)) into :init_vars_b separated by ','
          from sashelp.vcolumn
          where libname="&data_b_lib" and memname="&data_b_data" and 
                upcase(name) in("&data_vars_b") and upcase(name) not in("&by_vars");
quit;
%put mem_a=&mem_a;
%put mem_b=&mem_b;

%let maxmem = %sysfunc(getoption(memsize));
%if &maxmem = 0 %then %do;
    %if &sysscp = WIN %then %do; /* In Windows, memsize is usually 0 so get maxmem from sysinfo command */
       filename mem pipe 'systeminfo';
       data _null_;
          infile mem lrecl=256 pad;
          input;
          if substr(_infile_,1,26)='Available Physical Memory:' then do;
             maxmem = input(compress(trim(scan(_infile_,4,' ')),','),best.);
             gb_mb_kb=scan(_infile_,-1,' ');
             /* convert to megabytes */
             if gb_mb_kb='GB' then maxmem=maxmem*1000;
             else if gb_mb_kb='KB' then maxmem=floor(maxmem/1000);
             call symput('maxmem',put(maxmem,best.));
          end;
       run;
    %end;
    /* if not Windows or the above fails for some reason, set a default value */
    %if &maxmem = 0 %then %let maxmem=500; 
%end;
%put maxmem=&maxmem;

/* pick hashdsn and nohashdsn */
%let hash=NO;
%if %str(&if) = A %then %do;
   %let hashdsn=B;
   %let nohashdsn=A;
   %if &maxmem > &mem_b %then %let hash=YES;
%end;
%else %if %str(&if) = B %then %do;
   %let hashdsn=A;
   %let nohashdsn=B;
   %if &maxmem > &mem_a %then %let hash=YES;
%end;
/* following is for 'a or b', 'a and b' */
%else %if &mem_a ge &mem_b %then %do;
   %let hashdsn=B;
   %let nohashdsn=A;
   %if &maxmem > &mem_b %then %let hash=YES;
%end;
%else %if &mem_a < &mem_b %then %do;
   %let hashdsn=A;
   %let nohashdsn=B;
   %if &maxmem > &mem_a %then %let hash=YES;
%end;

%if %str(&hash) = %str(YES) %then %do;
data &data;
   if 0 then set &data_a (keep=&keep_a)
                 &data_b (keep=&keep_b);
   declare hash h_merge(dataset:"&&data_&hashdsn");
   rc=h_merge.DefineKey("&by_vars");
   rc=h_merge.DefineData("&&data_vars_&hashdsn");
   rc=h_merge.DefineDone();
   do while(not eof);
      set &&data_&nohashdsn (keep=&&keep_&nohashdsn) end=eof;
      %if %str(&&init_vars_&hashdsn) ne %str() %then %do;
      call missing(&&init_vars_&hashdsn);
      %end;
      rc=h_merge.find();
      %if %str(&if) = &hashdsn %then if rc=0 then;
         output;
   end;
   drop rc;
   stop;
run;
%end;

%else %do;
proc sort data=&data_a (keep=&keep_a) out=a_sorted; by &by; run;
proc sort data=&data_b (keep=&keep_b) out=b_sorted; by &by; run;
data &data;
   merge a_sorted (in=a)
         b_sorted (in=b);
   by &by;
   %if %str(&if) ne %str() %then %do;        
      if &if;
   %end;
run;
%end;

%mend hashmerge;
