libname bagels oledb init_string="Provider=SQLOLEDB.1;
     Password=Reporting2;
     Persist Security Info=True;
     User ID=reporting_user;
     Initial Catalog=Mario1;
     Data Source=Bagels"  schema=dbo; 



data ;
set bagels.main_201112;
where segment eq 1;
run;

data bagels.test1;
set bagels.main_201112;
where segment eq 1;
run;

proc sql;
create table bagels.test2 as
select * from bagels.main_201112 where segment = 1;
quit;

proc sql;
create table data.test2 as
select * from data.main_201112 where segment = 1;
quit;

proc sql;
connect to oledb as bagels1 (user=reporting_user password=Reporting2 datasource=Bagels
   provider=sqloledb );
   
	 create table test as select * from connection to bagels1(select hhid, hh, dda from MAIN_201112 where sdb=1); 
quit;


proc sql;
connect to oledb as bagels1 (user=reporting_user password=Reporting2 datasource=Bagels
   provider=sqloledb );
   
	 create table test as select * from connection to bagels1(select hhid, hh, dda from MAIN_201112 where sdb=1); 
quit;
