%******************************************************************************;
%* SAS macro SAStSQLt vs. 0.1.0 , 09 Aug 2010, by Jim Groeneveld, Netherlands *;
%******************************************************************************;
%*                                                                            *;
   %MACRO   SAStSQLt   /* transfer SAS dataset data to existing MS SQL table  */
/* -------------------------------------------------------------------------- */
/* Argument Default       Description and remarks      Required/Optional: R/O */
/* -------- --------      --------------------------------------------------- */
(  Dataset = /*_LAST_*//* Input SAS dataset name, including its libname     R */
,  MSSQLlib= MSSQLsrv  /* Name of library in SAS terms with ODBC engine     R */
,  SQLtable=           /* SQL table for which write permission to overwrite R */
,  DSN     =           /* Data Source Name of SQL database                  R */
,  UserName=           /* UserName for write access to SQL table            R */
,  Password=           /* Password for write access to SQL table            R */  
,  Dummy   = _Dummy_   /* Dummy variable name to store in 'empty' SQL table R */
)/ DES     =             'copy SAS data to existing MS SQL table' /* STORE */  ;
%*                                                                            *;
%******************************************************************************;

  %LOCAL    /* Define internal macro variables explicitely local */
  Database  /* Name of SQL table in SAS terms: library.dataset   */
  DtTm_Fmt  /* Comprehensive list of all valid DATETIME formats  */
  Date_Fmt  /* Comprehensive list of all valid DATE     formats  */
  Time_Fmt  /* Comprehensive list of all valid TIME     formats  */
  MoneyFmt  /* List of all valid currency formats: only DOLLAR   */
  DataBase  /* Name of SQL table in SQL database in SAS terms    */
  SQLvars   /* List of all columns (variables) in SQLtable       */
  SASvars   /* List of all variables in SAS dataset              */
  ;

%*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
%* To interpret variables as representing special types like DATE, TIME and DATETIME ;
%* all concerning formats have to be checked in order to interpret variables correct.;
%*___________________________________________________________________________________;

%* Format type lists;
  %LET DtTm_Fmt = 'DATETIME' 'DATEAMPM';
  %LET Date_Fmt = 'DATE' 'DAY' 'DDMMYY' 'DOWNAM' 'EURDFD'
        'EURDFM' 'EURDFW' 'HDATE' 'HEBDAT' 'JULDAY' 'JULIAN' 'MINGUO' 'MMDDYY' 'MMYY'
        'MONNAM' 'MONTH' 'MONYY' 'NENGO' 'NLDATE' /*'NLDATM'*/ 'PDJULG' 'PDJULI' 'QTR'
         'WEEK' /*'WEEKDA'*/ 'WORDDA' 'YEAR' 'YYMM' 'YYMMDD' 'YYMON' 'YYQ';
  %LET Time_Fmt = 'TIME' 'TOD' 'HHMM' 'HOUR' 'MMSS' /*'TIMEAMPM'*/;
  %LET MoneyFmt = 'DOLLAR' ;
%* These lists may need adaptation with newer SAS versions;
%* Most macro variables are needed both inside and outside macro Var_List;

  LIBNAME &MSSQLlib ODBC DSN=&DSN USER=&username PWD=&password;  * MS SQL lib ODBC engine;
  %LET DataBase = &MSSQLlib..&SQLtable;

%* Create existing variable list from MS SQL database table (to be removed);
  %LET SQLvars = ; %* create the macro variable with empty contents;
  %Var_List (DATA=&Database, StoreVar=SQLvars, Delim=%STR(,)) /* (semicolon redundant) */
  %PUT SQLvars=&SQLvars; %* feedback of existing columns in MS SQL table;

%* Create variable list from SAS dataset;
  %LET SASvars = ; %* create the macro variable with empty contents;
  %Var_List (DATA=&Dataset, StoreVar=SASvars, Delim=%STR(,), Type=SQL) /* (no semicolon) */
  %PUT SASvars=&SASvars; %* feedback of existing variables (and MS SQL attr) in SAS dataset;

* Preprocess data, mainly DATE value conversion;
  DATA _Dataset;
    SET &Dataset;
* = = = = = = = = = = = = = = = Auto-Date Conversion = = = = = = = = = = = = = = = ;
*** Avoid the use of TIME variables (they will become DATETIME on date 01jan1960). ;
*** Avoid the use of DATE variables (they will become DATETIME with times 00:00:00);
*** DATE variables and related TIME variables should preferably be combined into   ;
*** a DATETIME variable as (86400 * Date + Time) or from the DHMS SAS function.    ;
*** Without a TIME variable the DATE should in any case be converted to DATETIME,  ;
*** by multiplying it by 86400 (seconds a day) as automatically done by SAS SQL    ;
*** CREATE or the data step. Below this is done explicitly using all date formats. ;
* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =;
    ARRAY ChronoVar _NUMERIC_;
    DO OVER ChronoVar; /* below no VFORMATN because of colon modifier */
      IF      (VFORMAT(ChronoVar) IN: (&DtTm_Fmt)) THEN /* exclude date format */ ;
      ELSE IF (VFORMAT(ChronoVar) IN: (&Date_Fmt)) THEN ChronoVar = 86400 * ChronoVar;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
* Likewise if it unfortunately occurs that any time variable has negative values   ;
* or values GE 86400 then the remaining after division by 86400 has to be taken,   ;
* if that is negative then 86400 should be added to obtain a value 0<=time<86400 . ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
      ELSE IF (VFORMAT(ChronoVar) IN: (&Time_Fmt)) THEN /* in all cases */
                           ChronoVar = MOD(ChronoVar,86400) + (ChronoVar LT 0)*86400 ;
    END;
* = = = = = = = = = = = = = end of auto-date conversion = = = = = = = = = = = = = =;
  RUN;

/* ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ */
%macro disable;
not necessary because of PROC SORT &Contents BY Varnum in the macro Var_List

* Optionally force (different) order of variables for MS SQL table (if not yet);
  %LOCAL Ordered /* List of variables in order of original SAS dataset */ ;
%* Macro call: Create the variable list from the SAS dataset without attributes;
  %LET Ordered = ; %* create the macro variable with empty contents;
  %Var_List (DATA=_Dataset, StoreVar=Ordered, Delim=%STR( )) /* (no semicolon) */
  %PUT Ordered=&Ordered; %* feedback of existing variables in SAS dataset;

* Force the variables in the dataset in that order by reordering them using RETAIN;
  DATA _Dataset;
    RETAIN &Ordered;
    SET _Dataset;
  RUN;
  * End of optionally forcing variable order;
  %mend disable;
/* v v v v v v v v v v v v v v v v v v v v */

  PROC SQL;
    CONNECT TO ODBC (DSN=&DSN USER=&username PWD=&password);    * Pass-Through Facility;
    EXEC (DELETE FROM &SQLtable) BY ODBC;                       * remove existing data;
    EXEC (ALTER TABLE &SQLtable ADD &Dummy FLOAT) BY ODBC;      * add a Dummy variable;
    EXEC (ALTER TABLE &SQLtable DROP COLUMN &SQLvars) BY ODBC;  * remove old structure;
    EXEC (ALTER TABLE &SQLtable ADD &SASVars) BY ODBC;          * define new structure;
    EXEC (ALTER TABLE &SQLtable DROP COLUMN &Dummy) BY ODBC;    * remove Dummy variable;
    DISCONNECT FROM ODBC;
    INSERT INTO &DataBase SELECT * FROM _Dataset;               * export data via ODBC;
  QUIT;

  PROC DATASETS NOLIST; DELETE _Dataset; RUN;

%*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
%MEND SAStSQLt;
%*___________________________________________________________________;

%*~~~~~~~~~~~~~~~~~~;
%* Auxiliary macros ;
%*__________________;

%* = = = = = = = =;
%* Macro Var_List ; %* Determination of variable type for MS SQL table ;
%* = = = = = = = =;
%MACRO Var_List (DATA=_LAST_, StoreVar=Var_List /* &Storevar should exist*/,
                Delim=%STR( ), Type=/*SAS/SQL*/);
  %LOCAL Contents;
  %LET Contents = ____List;
  PROC CONTENTS DATA=&Data OUT=&Contents (KEEP=NAME TYPE FORMAT VARNUM LENGTH) NOPRINT; RUN;
  PROC SORT DATA=&Contents; BY VarNum; RUN; * forcing variables in occurring order;
  DATA _NULL_;
    SET &Contents;
    LENGTH Attr $ 48;
    Attr = Name; * initialize with the variable (column) name;
    %IF (%UPCASE(&Type) EQ SAS) %THEN %DO;
      IF (Type EQ 2) THEN Attr = TRIM(Attr) || ' CHAR';
      ELSE IF (Type EQ 1) THEN Attr = TRIM(Attr) || ' NUM';
    %END;
    %ELSE %IF (%UPCASE(&Type) EQ SQL) %THEN %DO; %* deduce date and time variables;
      IF (Type EQ 2) THEN DO;
        IF (Length LE 8000) THEN Attr = TRIM(Attr) || ' VARCHAR(' ||
                                             TRIM(LEFT(PUT(Length,5.))) || ')';
        ELSE Attr = TRIM(Attr) || ' VARCHAR(MAX)';  * if allowed ; * at least 1024;
      END;
      ELSE IF (Type EQ 1) THEN DO;
        IF      (Format IN: (&DtTm_Fmt)) THEN Attr = TRIM(Attr) || ' DATETIME';
        ELSE IF (Format IN: (&Date_Fmt)) THEN Attr = TRIM(Attr) || ' DATETIME';
        ELSE IF (Format IN: (&Time_Fmt)) THEN Attr = TRIM(Attr) || ' DATETIME';
        ELSE IF (Format IN: (&MoneyFmt)) THEN Attr = TRIM(Attr) || ' MONEY';
        ELSE /* just numeric */               Attr = TRIM(Attr) || ' FLOAT';
      END;
    %END;
%*  else if &Type is neither SAS nor SQL then no attributes added to the names;
%* Build the column name+attr list in a single macro variable &StoreVar; 
    CALL EXECUTE ('%LET &StoreVar = &&&StoreVar.&Delim.'||TRIM(Attr)||';');
  RUN;
%* remove initial delimiter &Delim;
  %LET &StoreVar = %SUBSTR(&&&StoreVar,2);

  PROC DATASETS NOLIST; DELETE &Contents; RUN;
%* = = = = = = ;
%MEND Var_List ;
%* = = = = = = ;
