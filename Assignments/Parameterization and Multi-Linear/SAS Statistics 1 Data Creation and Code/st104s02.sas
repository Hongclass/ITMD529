/*st104s02.sas*/ /*Part A*/
ods graphics on;
proc glmselect data=STAT1.bodyfat2 plots=all;
	STEPWISESBC: model PctBodyFat2 = Age Weight Height Neck Chest Abdomen
                                    Hip Thigh Knee Ankle Biceps Forearm Wrist
                                    / SELECTION=STEPWISE SELECT=SBC;
	title 'SBC STEPWISE Selection with PctBodyFat2';
run;

/*st104s02.sas*/ /*Part B*/
proc glmselect data=STAT1.bodyfat2 plots=all;
	STEPWISEAIC: model PctBodyFat2 = Age Weight Height Neck Chest Abdomen
                                    Hip Thigh Knee Ankle Biceps Forearm Wrist
                                    / SELECTION=STEPWISE SELECT=AIC;
	title 'AIC STEPWISE Selection with PctBodyFat2';
run;
