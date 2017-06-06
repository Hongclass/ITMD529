/*st105d02.sas*/
ods graphics off;
proc freq data=sasuser.Titanic;
    tables (Gender Class)*Survived
          / chisq expected cellchi2 nocol nopercent 
            relrisk;
    format Survived survfmt.;
    title1 'Associations with Survival';
run;

ods graphics on;
