
LIBNAME sqldb ODBC DSN=SQl_Datamart schema=dbo;

*test how easy it is to do a penetration and balances report;

proc sql;
create table a as 
select a.account_id,a.account_key_1, a.ptype, a.stype, a.sbu_group, (b.Amt_BAL_current + b.market_value) as balance, 
       b.CONTR_NET_CONTRIBUTION_MTD as contrib
from sqldb.account_info as a, sqldb.account_amt_trans as b where a.status_for_prime ne "X" and a.account_key_1 = b.account_key_1 
order by a.account_id, a.ptype;
quit;

proc sql;
select count(*) from sqldb.account_info;
quit;


proc sql;
connect to odbc as mycon (DSN=SQl_Datamart);

create table b as select *
   from connection to mycon
      (select a.account_id,a.account_key_1, a.ptype, a.stype, a.sbu_group, (b.Amt_BAL_current + b.market_value) as balance, 
       b.CONTR_NET_CONTRIBUTION_MTD as contrib
       from dbo.account_info as a, dbo.account_amt_trans as b where a.status_for_prime <> 'X'  and a.account_key_1 = b.account_key_1  
	  order by a.account_id, a.ptype);

	  create table hh as select *
   from connection to mycon
      (select a.household_id as account_id, a.COMMUNITY_BANK_MARKET as cbr, a.Market as mkt, b.life_cycle_segment as segment
       from dbo.hhld_info as a, dbo.hhld_amt_trans as b where a.household_id = b.household_id  
	  order by a.household_id);

disconnect from mycon;
quit;

data b;
set b;
if ptype="CCS" and stype in ("NOR","REW","SIG") then PTYPE = "CRD";
if ptype ="ILN" and stype in ( "ICA" , "IDS" , "IHI" , "ILL" , "IMH" , "ISM" , 
                                 "CMT" , "LCC" , "LC1" , "RWI" , "SIA" , "SIH" , "SIS" , 
                                 "CGS" , "LCR" , "SCG" , "CSI" , "CGV" )  then ptype = "IND";
run;

proc sort data=b;
by account_id ptype;
run;


proc summary data=b;
where (ptype in ("DDA","MMS","SAV","TDA","IRA") and substr(stype,1,1)="R") or (ptype not in ("DDA","MMS","SAV","TDA","IRA") and sbu_group="CON" );
where also PTYPE not in ("DEB","WEB","HBK","ATM");
by account_id ptype ;
output out=summary (drop=_:)
       sum(contrib) = contrib
	   sum(balance) = balance;
run;


data summary;
set summary;
by account_id ;
hh=0;
if first.account_id  then hh =1;
x = 1;
run;

data hh;
length segment 3;
set hh;
segment = life_cycle_segment;
run;

data summary;
merge summary (in=a) hh (in=b);
by account_id;
if a;
run;


proc tabulate data=summary;
class ptype ;
var balance contrib hh x;
table sum*hh='HHs'*f=comma12. ptype='Product HHs'*x=' '*(sum*f=comma12.) , all;
table sum*hh='HHs'*f=comma12. ptype='Product Penetration'*x=' '*colpctsum<hh>*f=pctfmt., all;
keylabel sum=' ';
run;

proc tabulate data=summary order=data;
class ptype segment / preloadfmt ;
var balance contrib hh x;
table segment all, sum*hh='HHs'*f=comma12. ptype='Product HHs'*x=' '*(sum*f=comma12.) ptype='Product Penetration'*x=' '*rowpctsum<hh>*f=pctfmt.;
table segment all, sum*hh='HHs'*f=comma12. ptype='Average Balances'*balance=' '*colPCTsum<x>*f=pctdoll.;
table segment all, sum*hh='HHs'*f=comma12. ptype='Product Contribution'*contrib=' '*rowpctsum<hh>*f=pctdoll.;
keylabel sum=' ' rowpctsum=' ' rowpctN=' ';
format ptype $ptypefmt. segment segfmt. ;
run;


proc sql;
select ptype, count(ptype) format comma12., sum(balance) format dollar24. from summary group by ptype;
;
quit;


