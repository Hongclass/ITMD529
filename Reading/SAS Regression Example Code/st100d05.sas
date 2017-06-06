/*st100d05.sas*/
ods noproctitle;

/*Change the path in the %let statement to point to the place where you */
/*saved the files st100d01.sas through st100d04.sas.*/


*%let homefolder=S:\WORKSHOP;
%let homefolder=/folders/myfolders;     *SAS University Edition Users;

/*Users of SAS University Edition, an example of the path needed is "/folders/myfolders/" */
/*Additional subfolder directories within myfolders can be specified if needed.  */ 


libname STAT1 "&homefolder";

%include "&homefolder/regression_I/st100d01.sas";
%include "&homefolder/regression_I/st100d02.sas";
%include "&homefolder/regression_I/st100d03.sas";
%include "&homefolder/regression_I/st100d04.sas";
