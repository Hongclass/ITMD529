/*st104s01.sas*/ /*Part A*/
ods graphics on;
proc glmselect data=STAT1.bodyfat2 plots=all;
	STEPWISESL: model PctBodyFat2 = Age Weight Height Neck Chest Abdomen
                                    Hip Thigh Knee Ankle Biceps Forearm Wrist
                                    / SELECTION=STEPWISE SELECT=SL;
	title 'SL STEPWISE Selection with PctBodyFat2';
run;

/*st104s01.sas*/ /*Part B*/
proc glmselect data=STAT1.bodyfat2 plots=all;
	FORWARDSL: model PctBodyFat2 = Age Weight Height Neck Chest Abdomen
                                    Hip Thigh Knee Ankle Biceps Forearm Wrist
                                    / SELECTION=FORWARD SELECT=SL;
	title 'SL FORWARD Selection with PctBodyFat2';
run;

/*st104s01.sas*/ /*Part C*/
proc glmselect data=STAT1.bodyfat2 plots=all;
	FORWARDSL: model PctBodyFat2 = Age Weight Height Neck Chest Abdomen
                                    Hip Thigh Knee Ankle Biceps Forearm Wrist
                                    / SELECTION=FORWARD SELECT=SL SLENTRY=0.05;
	title 'SL FORWARD (0.05) Selection with PctBodyFat2';
run;
