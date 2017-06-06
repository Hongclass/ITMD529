/*st105d04.sas*/
ods graphics off;
proc freq data=sasuser.Titanic;
    tables Class*Survived / chisq measures cl;
    format Survived survfmt.;
    title1 'Ordinal Association between CLASS and SURVIVAL?';
run;

ods graphics on;
