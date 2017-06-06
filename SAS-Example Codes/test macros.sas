%profile2 (classvars= source,period = 201209, data_library = data,condition = cbr eq 17, name=test_analysis)
;

proc format ;
value $ myfmt (notsorted) 'ALLMNT' = 'ALLMNT'
						  'ALLWLMNT' = 'ALLWLMNT'
							'COMBO' = 'COMBO';
run;
	
filename mprint "C:\Documents and Settings\ewnym5s\My Documents\Data\transform.sas" ;
data _null_ ; file mprint ; run ;
options  mprint mfile nomlogic ;
%prepare_for_ppt(group=source,gfmt=$myfmt,filename=test_new)


