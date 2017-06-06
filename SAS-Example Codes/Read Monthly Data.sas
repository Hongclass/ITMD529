libname online 'C:\Documents and Settings\ewnym5s\My Documents\Online';
libname data 'C:\Documents and Settings\ewnym5s\My Documents\Data';
libname sas 'C:\Documents and Settings\ewnym5s\My Documents\SAS';
options fmtsearch=(SAS);

options MSTORED SASMSTORE = mjstore;
libname mjstore 'C:\Documents and Settings\ewnym5s\My Documents\SAS';

options mcompilenote=all;

%read_monthly_data (source=main.txt,identifier=201303,directory=C:\Documents and Settings\ewnym5s\My Documents\,first=2)
options compress=yes;
%SQUEEZE( data.main_201303, data.main_201303_new )
%replace(dir=data,source=main_201303_new,dest=main_201303);

%read_contr_data (source=contrib.txt,identifier=201303,directory=C:\Documents and Settings\ewnym5s\My Documents\)
options compress=yes;
%SQUEEZE( data.contrib_201303, data.contrib_201303_new )
%replace(dir=data,source=contrib_201303_new,dest=contrib_201303);




%macro replace(dir=,source=,dest=) / store;
	options compress=yes;
	proc datasets library=&dir;
		delete &dest;
		change &source=&dest;
	run;

%mend replace;


/*filename mymacros 'C:\Documents and Settings\ewnym5s\My Documents\SAS\Macros';*/
/*options mautolocdisplay mautosource sasautos = (mymacros) ;*/


/*filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\data.txt';*/

%macro read_monthly_data (source=,identifier=,directory=,first=) / store source des='get read_monthly_data macro';

filename mydata "&directory&source";

data data.Main_&identifier;
length HHID $ 9 STATE $ 2 ZIP $ 5 RM $ 1 clv_flag $ 1 clv_steady $ 1;
infile mydata DLM='09'x firstobs=&first lrecl=4096 dsd missover;

	  INPUT hhID $                                                         
         STATE $ 
         ZIP $                                                  
         BRANCH $                                           
         CBR                                     
         MARKET 
         dda                                                            
         mms                                                            
         sav                                                            
         tda                                                             
         ira                                                             
         sec                                                            
         trs                                                             
         mtg                                                            
         heq                                                             
         card                                                       
         ILN                                                             
         sln                                                           
         sdb                                                             
         ins                                                            
         bus                                                             
         com                                                             
         DDA_Amt                                                    
         MMS_amt                                                      
         sav_amt                                                       
         TDA_Amt                                                 
         IRA_amt                                         
         sec_Amt                                              
         trs_amt                                              
         MTG_amt                                                  
         HEQ_Amt                                               
         ccs_Amt                                               
         iln_amt                                                      
         sln_amt                                                   
         IXI_tot                                            
         IXi_Annuity                                            
         ixi_Bonds                                                       
         ixi_Funds                                                      
         ixi_Stocks                                                    
         ixi_Other                                              
         ixi_Non_Int_Chk                                                
         ixi_int_chk                                                   
         ixi_savings                                                    
         ixi_MMS                                                     
         ixi_tda                                                        
         source $                                                   
         WAS                                                        
         WFO                                                          
         segment                                                    
         clv_total                                                
         clv_rem                                                   
         clv_rem_ten                                              
         cqi_bp                                                            
         cqi_DD                                                            
         cqi_deb                                                          
         cqi_odl 
         cqi_web 
         web                                                      
         VPOS_AMT 
         vpos_num                                                      
         mpos_amt                                                      
         mpos_num                                                      
         ATMO_AMT 
         ATMO_NUM 
         ATMT_AMT 
         ATMT_NUM 
         web_signon 
         BP_NUM 
         BP_AMT 
         BR_TR_NUM 
         BR_TR_amt 
         VRU_NUM 
         SMS_NUM 
         WAP_NUM 
         fico_num 
         bp 
         WAP 
         SMS 
         edeliv 
         estat 
         fico 
         FWorks 
         fworks_num
		 band $
		 band_yr $
		 IND
		 IND_AMT
		 chk_num
		 dd_amt
         distance
		 RM
		 tenure
		 tran_code $
		 clv_flag $
		 clv_steady $
		 svcs
		 age;
		 if tenure lt 0 then tenure=.;
		 tenure_yr = divide(tenure,365);
		 hh=1;
		 grp = 1;
run;

%mend;

/*why did rm and tenure not work */



/*filename mydata 'C:\Documents and Settings\ewnym5s\My Documents\Data\contrib.txt';*/

%macro read_contr_data (source=,identifier=,directory=) / store source des='get read_monthly_data macro';

filename mydata "&directory&source";

data data.Contrib_&identifier;
length HHID $ 9 STATE $ 2 ZIP $ 5;
infile mydata DLM='09'x firstobs=2 lrecl=4096 dsd;
	  INPUT hhID $
		STATE $ 
         ZIP $                                                  
         BRANCH $                                           
         CBR                                     
         MARKET  
		 DDA_CON
		 MMS_CON
		 SAV_CON
		 TDA_CON
		 IRA_CON
		 SEC_CON
		 TRS_CON
		 mtg_con
		 heq_con
		 card_con
		 ILN_CON
		 SLN_CON
		 band $
		 band_yr $
		 IND_con;
run;
%mend;



PROC CATALOG catalog=mjstore.sasmacr;
Contents;
run;


filename mydata "C:\Documents and Settings\ewnym5s\My Documents\Virtually Domiciled\cbdist.txt";

data distance;
length HHID $ 9;
infile mydata DLM='09'x firstobs=2  lrecl=4096 dsd;

	  INPUT hhID $                                                         
        distance;
run;
 

data tempx;
merge data.main_201111 (in=a) distance (in=b);
by HHID;
if a;
run;


data data.main_201111;
set tempx;
run;


proc freq data=tempx ;
table distance /missing out=;
run;

proc gchart data=wip.&table ;
vbar &class_var / type=sum sumvar=&analysis_var
noframe outside=sum subgroup=&class_var
group= &group_var
gspace = 1 
raxis = axis1 maxis=axis2 gaxis = axis3
/*PATTERNID=MIDPOINT*/
legend=legend1
autoref clipref cref=graybb;
format &analysis_var &value_format &group_var &group_format;
run;
