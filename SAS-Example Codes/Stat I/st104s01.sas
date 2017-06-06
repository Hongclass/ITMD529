/*st104s01.sas*/
ods graphics / imagemap=on;

proc reg data=sasuser.BodyFat2 
         plots(only)=(QQ RESIDUALBYPREDICTED RESIDUALS);
    FORWARD: model PctBodyFat2 
                  = Abdomen Weight Wrist Forearm;
    id Case;
    title 'FORWARD Model - Plots of Diagnostic Statistics';
run;
quit;
