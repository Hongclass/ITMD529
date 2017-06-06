options fmtsearch=(SAS);
options MSTORED SASMSTORE = sas;
options cmplib=(sas.functions);

libname ach 'C:\Documents and Settings\ewnym5s\My Documents\ACH';
libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
libname virtual 'C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled';
libname branch 'C:\Documents and Settings\ewnym5s\My Documents\Network Planning';
libname wip 'C:\Documents and Settings\ewnym5s\My Documents\temp_sas_files';
libname data 'C:\Documents and Settings\ewnym5s\My Documents\Data';
libname attr 'C:\Documents and Settings\ewnym5s\My Documents\Validate Attrition';
