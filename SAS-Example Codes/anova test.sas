proc contents data=data.contrib_201212 varnum short;
run;

data  data.contrib_201212 ;
set data.contrib_201212 ;
contrib = sum(DDA_CON, MMS_CON, SAV_CON, TDA_CON, IRA_CON, SEC_CON, TRS_CON, mtg_con, heq_con, card_con, ILN_CON ,SLN_CON, IND_con );
run;


data data.main_201212;
merge data.main_201212 (in=a) data.contrib_201212 (in=b keep=hhid contrib);
by hhid;
if a;
run;




proc glm data=data.main_201212 order=formatted
      plots(only)=(controlplot diffplot(center));
class segment;
model contrib = segment;
lsmeans segment / pdiff=all adjust=tukey;
format segment segfmt.;
run;


proc setinit(); run;
