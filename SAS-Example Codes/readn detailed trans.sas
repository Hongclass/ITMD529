filename myfile 'C:\Documents and Settings\ewnym5s\My Documents\Data\small.txt';

data data.trans_detail_201203;
length hhid $ 9;
infile myfile dsd dlm='09'x firstobs=2 lrecl=4096;
input hhid $  csw_inq  csw_from  csw_to  vru_inq  vru_from  vru_to  bp_mtb  bp_non  bp_mtb_amt  bp_non_amt  ATMO_wdral  atmo_dep  
atmo_trsf  atmo_cshck  atmo_inq  atmo_zcash  atmo_with_amt  atmo_dep_amt  atmo_trsf_amt  atm_cshck_amt  atmo_inqry_amt  atmo_zcash_amt  atmt_wdral  
AtMt_inqry  atmt_xfer  atmt_zcash  atmt_wdral_amt  atmr_inqry_amt  atmt_xfer_amt  atmt_zcash_amt  lobby_dep  drv_dep  nite_dep  lobby_dep_amt  drvin_dep_amt  
nite_dep_amt  lobby_sav_with  lobby_sav_amt  drive_sav  drive_sav_amt  sign_ons  wap_balreq  wap_hist  wap_schtran  wap_cantran  wap_trans  wap_bpay  
sms_bal  sms_hist  b2b_deb  b2b_cred  b2b_debit_amt  b2b_credit_amt;
run;


proc sql;
   connect to oledb as myconn (init_string='Provider=SQLOLEDB;Password=Reporting2;Persist
Security Info=True;User ID=reporting_user;Initial Catalog=Mario1;
Data Source=Bagels'); 

execute (create table chk_201203(acountkey char(15), stype char(3));) by myconn;
disconnect from myconn;
quit;
