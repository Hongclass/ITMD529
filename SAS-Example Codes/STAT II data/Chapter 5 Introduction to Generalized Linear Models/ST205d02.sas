proc genmod data=sasuser.crab;
   class color spine;
   model satellites=width weight color spine 
        / dist=negbin link=log type3 ;
   title 'Negative Binomial to Account for Overdispersion';
run;							*ST205d02.sas;

/* Final model has only weight*/
ods graphics / reset=all imagemap=on;
ods html style=analysis;
proc genmod data=sasuser.crab plots(unpack )=all;
   model satellites= weight  / obstats dist=negbin link=log type3 diagnostics ;
      title2 'Reduced Model';
run;			
									*ST205d02.sas;
