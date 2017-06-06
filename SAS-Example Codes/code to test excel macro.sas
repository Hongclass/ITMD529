
proc freq data=data.main_201209;
table prod1;
run;




options compress=yes;
data data.main_201209;
set  data.main_201209;
if products eq 1 then prod1 = 'Single';
if products gt 1 then prod1 = 'Multi';
if products in (0 .) then prod1 = 'Weird';
svcs = products;
run;


%profile2 (classvars= prod1 ,period = 201209, data_library = data,condition = dda eq 1, name=test_analysis)
;

proc format;
value $ ordera (notsorted) 'Single' = 'Single'
				'Multi' = 'Multi'
				'Weird' = 'Weird';
run;






%prepare_for_ppt(group=prod1,gfmt=$ordera.)
