  /* This program will only execute on the Windows platform */
libname Excel 'Orion.xls';
options ls=120;
proc transpose data=Excel.'Order Summary$'n (where=(Customer_ID is not missing))
               out=Cust_Orders (drop=_name_ _label_) 
               prefix=Month;
   by Customer_Id;
	id Order_Month;
   var Sale_Amt;
run;
proc print data=Cust_Orders;
   var customer_id month1-month12;
run;
options ls=97;
libname Excel clear;
