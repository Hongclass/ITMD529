PROC IMPORT OUT= WORK.award 
            DATAFILE= "C:\Documents and Settings\Administrator\����\Book
1.xls" 
            DBMS=EXCEL2000 REPLACE;
     GETNAMES=YES;
RUN;
