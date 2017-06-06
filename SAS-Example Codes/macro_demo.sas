
filename mprint "C:\Documents and Settings\ewnym5s\My Documents\SAS\test_super_macro_new.sas" ;
data _null_ ; file mprint ; run ;
options mprint mfile nomlogic ;

%create_report(class1 = band, fmt1 = $band,out_dir = C:\Documents and Settings\ewnym5s\My Documents\SAS, 
                main_source = data.main_201212,  contrib_source = data.contrib_201212, condition = sec eq 1 and cbr eq 17,
                out_file=myreport_new2,
                logo_file= C:\Documents and Settings\ewnym5s\My Documents\Tools\logo.png)


%segments(class1=segment,class2=band,fmt1=segfmt,where=bus eq 1,main_source=wip.main,out=test1)

%contribution(where=bus eq 1,contrib_source=wip.contrib,out=test2)

