/* Please refer to the DETAILS tab for syntax information regarding %SYMDEL. */

%let x=1;
%let y=2;
%let z=3;

/* Write macro variable values to the log to show they do have values. */
%put &x &y &z;

/* VMACRO is a SASHELP view that contains information about currently */
/* defined macros.  Create a data set from SASHELP.VMACRO to avoid a  */
/* macro symbol table lock.                                           */

%macro delvars / store;
  data vars;
    set sashelp.vmacro;
  run;

  data _null_;
    set vars;
    temp=lag(name);
    if scope='GLOBAL' and substr(name,1,3) ne 'SYS' and temp ne name then
      call execute('%symdel '||trim(left(name))||';');
  run;

%mend;

%delvars

