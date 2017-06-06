*read data;

data a;
length hhid $ 9 band band_yr $ 3 pb $ 3;
infile 'My Documents\BB_MAIN.TXT' dsd dlm='09'x firstobs=2 obs=max lrecl=4096 missover;
input hhid $ branch cbr market state $ dda mms sav tda ira trs mtg  heqb heqc cln card boloc baloc cls wbb deb mcc lckbx rcd bbfb 
      dda_amt mms_amt sav_amt tda_amt ira_amt mtg_amt heqb_amt heqc_amt cln_amt card_amt boloc_amt baloc_amt cls_amt mcc_amt con com web_info pb $ svcs
	  tenure sic sign_ons checks atmo_num atmt_num atmo_amt atmt_amt vpos_num mpos_num vpos_amt mpos_amt deptkt curdep_num curdep_amt
	  chkpd ACH rcd_num winfo_num lckbox top40 RM band $  band_yr $ cb_dist cv0 cr6 com_dda br_tran_num br_tran_amt vru_num nsf chks_dep cash_mgmt wire_in wire_out;
run;


proc freq data=a;
table dda mms sav tda ira trs mtg  heqb heqc cln card boloc baloc cls wbb deb mcc lckbx rcd bbfb  ;
run;

/*%null_to_zero(a, a )*/

options compress=binary;
%squeeze(a,bb.bbmain_201212);

data a;
length hhid $ 9;
infile 'My Documents\BB_CONTR.TXT' dsd dlm='09'x firstobs=2 obs=max lrecl=4096 missover;
input   hhid $    	DDA_con         MMS_con        sav_con    TDA_con      	IRA_con   MTG_con    	HEQB_con    	HEQC_con     	CLN_con      Card_con      	BOLoc_con   	BALOC_con  CLS_con   MCC_con ;
run;

/*%null_to_zero(a, a )*/


data bb.bbmain_201212 (compress=binary);
merge bb.bbmain_201212(in=a) a (in=b) end=eof;
retain miss;
by hhid;
if a then output;
if a and not b then miss+1;
if eof then do;
	put 'WARNING: There are ' miss ' Records on A not on B';
end;
drop miss;
run;

data a;
length hhid $ 9;
infile 'My Documents\BB_EXTRA.TXT' dsd dlm='09'x firstobs=2 obs=max lrecl=4096 missover;
input hhid $ a $ b $ contrib ;
run;


data bb.bbmain_201212 (compress=binary);
merge bb.bbmain_201212(in=a) a (in=b keep=hhid contrib) end=eof;
retain miss;
by hhid;
if a then output;
if a and not b then miss+1;
if eof then do;
	put 'WARNING: There are ' miss ' Records on A not on B';
end;
drop miss;
run;

proc contents data=bb.bbmain_201212 varnum short;
run;

%as_logical(bb.bbmain_201212,bb.bbmain_201212(compress=binary), dda mms sav tda ira trs mtg heqb heqc cln card boloc baloc cls )
