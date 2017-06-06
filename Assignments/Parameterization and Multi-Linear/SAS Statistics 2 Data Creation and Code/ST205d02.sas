
proc genmod data=STAT2.crab;
   class color spine;
   model satellites=width weight color spine 
        / dist=negbin link=log type3 ;
   title 'Negative Binomial to Account for Overdispersion';
run;							*ST205d02.sas;

/* Final model has only weight*/
ods graphics / reset=all imagemap=on;
ods html style=analysis;
proc genmod data=STAT2.crab plots(unpack )=all;
   model satellites= weight  / dist=negbin link=log type3 diagnostics;
title2 'Reduced Model';
run;			
									*ST205d02.sas;
