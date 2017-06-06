proc format library=sas;
value mycolor 1 = 'Blue'
	          2 = 'Green'
			  3 = 'Red'
			  4 = 'Orange'
			  5 = 'Yellow'
			  6 = 'Lilac'
			  7 = 'Violet'
			  8 = 'Steel'
			  9 = 'Olive'
			  10 = 'Lime';
run;




data tran_cluster;
set data.main_201206;
where dda = 1;
keep VPOS_AMT vpos_num mpos_amt mpos_num ATMO_AMT ATMO_NUM ATMT_AMT ATMT_NUM web_signon BP_NUM BP_AMT BR_TR_NUM BR_TR_amt 
     VRU_NUM SMS_NUM WAP_NUM fico_num fworks_num chk_num ;
run;

data tran_sample;
set tran_cluster;
ATM_num = ATMT_num + ATMO_num;
ATM_AMT = ATMO_AMT + atmt_amt;
debit = vpos_num + mpos_num;
debit_amt = vpos_amt + mpos_amt;
total = atm_amt + debit + bp_amt;
atm_P = atm_amt / total;
deb_p = debit / total;
bp_p = bp_amt / total;
if mod(_n_,500) eq 7 then output;
run;

proc fastclus data=tran_sample out=Clust1 outseed=seeds1
                 maxclusters=25 maxiter=0 ;
      var atm_p deb_p bp_p ;
run;

proc sql;
select sum(_freq_) into :total from seeds1 ;
quit;

data seeds_clean;
set seeds1;
p = _freq_ / &total;
if p ge .05 then output;
format p percent6.1;
run;


proc sql;
select count(_freq_) into :clust_num from seeds_clean ;
quit;

proc fastclus data=tran_sample out=Clust2 seed=seeds_clean
                 maxclusters=&clust_num maxiter=0 strict=4;
      var atm_p deb_p bp_p ;
run;

proc sort data=clust2;
by cluster;
run;

data chartdata;
set clust2;
color = put(cluster,mycolor.);
run;

proc g3d data=chartdata ;
scatter  atm_p*deb_p=bp_p/ noneedle color=color;
format atm_p deb_p bp_p percent6.0;
run;
quit;

proc candisc data=chartdata  out=can2;
   class cluster;
   var atm_p deb_p bp_p;
run;

proc gplot data=can2;
plot can2*can1=cluster;
run;
quit;

*I need to add the check_amt and add to that the converted back office achs and the pos achs (where people use a papoer check), then create
a new category with the real ach payments; 
