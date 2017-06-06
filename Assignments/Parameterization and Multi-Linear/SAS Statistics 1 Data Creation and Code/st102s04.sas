/*st102s04.sas*/
ods graphics on;

proc reg data=STAT1.BodyFat2;
    model PctBodyFat2=Weight;
    title "Regression of % Body Fat on Weight";
run;
quit;

title;

