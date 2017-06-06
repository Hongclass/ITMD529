proc tabulate data=data.main_201206 out=cbr_summary missing;
class cbr ;
var dda mms sav tda ira sec trs mtg heq card ILN IND sln sdb ins bus com
    DDA_Amt MMS_amt sav_amt TDA_Amt IRA_amt sec_Amt trs_amt MTG_amt HEQ_Amt ccs_Amt iln_amt ind_amt sln_amt
	IXI_tot IXi_Annuity ixi_Bonds ixi_Funds ixi_Stocks ixi_Other ixi_Non_Int_Chk ixi_int_chk ixi_savings ixi_MMS ixi_tda
	clv_total clv_rem clv_rem_ten tenure_yr segment hh;
table cbr, N='HHs' pctsum<hh>='Product penetration'*(dda mms sav tda ira sec trs mtg heq card ILN IND sln sdb ins bus com)*f=pctfmt.
                   sum*(DDA_Amt)*f=dollar24. mean*(DDA_Amt)*f=dollar24. pctsum<dda>*(DDA_Amt)*f=div100fmt.;
format cbr cbr2012fmt.;
run;

proc fcmp outlib=sas.functions.smd;
   function fixpct(a);
   return (a/100);
   endsub;
run;

options cmplib=(sas.functions);
proc format;
   value fixpctfmt other=[fixpct()];
 run;

 proc format library=sas;
 picture div100fmt low-high='000,009' (mult=.01);
run;
 
proc print data=cbr_summary;
var cbr DDA_Amt_PctSum_1;
format cbr cbr2012fmt. DDA_Amt_PctSum_1 div100fmt.;
run;
