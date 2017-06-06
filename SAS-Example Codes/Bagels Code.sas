
	 libname IXI_NEw oledb init_string="Provider=SQLOLEDB.1;
     Password=Reporting2;
     Persist Security Info=True;
     User ID=reporting_user;
     Initial Catalog=IXI;
     Data Source=bagels"  schema=dbo; 

/* this creates a table with the tables */


proc contents data=IXI_new.MTB_Postal;
run;




