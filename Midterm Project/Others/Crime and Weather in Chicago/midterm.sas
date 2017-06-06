/* MIDTERM Generated Code (IMPORT) */
/* Source File: air.csv */
/* Source Path: /folders/myshortcuts/sasuser.v94/ITMD529 */
/* Code generated on: 10/14/16, 8:50 PM */
/* SUBMITTED BY T V N B Suryanarayana, #A20191735-03, India  */

*%web_drop_table(itmd529.air);

ODS GRAPHICS ON;

FILENAME REFFILE '/folders/myshortcuts/sasuser.v94/ITMD529/air.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=itmd529.air;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=itmd529.air; 
RUN;

TITLE 'GET A SUBSET OF COLUMNS USING PROC SQL ALONG WITH SOME DATA CLEANING';
proc sql;
	CREATE TABLE ITMD529.AIR_SUBSET AS 		
		SELECT ID,CAT_ID,TIMING, TIME, DATE, YEAR(DATE)AS YEAR, MONTH(DATE) AS MONTH,FATALITIES,ABOARD,GROUND, OPERATOR,cn_in 
		FROM ITMD529.AIR WHERE YEAR(DATE) BETWEEN 2000 AND 2016;
	UPDATE ITMD529.AIR_SUBSET SET TIMING='MIDWAY' WHERE ID=5228;
	UPDATE ITMD529.AIR_SUBSET SET TIMING='TAKE OFF' WHERE TIMING='TAKEOFF';
	UPDATE ITMD529.AIR_SUBSET SET TIMING='MIDWAY' WHERE ID=5228;
	UPDATE ITMD529.AIR_SUBSET SET TIMING='TAKE OFF' WHERE TIMING='TAKEOFF';
	DELETE FROM ITMD529.AIR_SUBSET WHERE CAT_ID=6;
	DELETE FROM ITMD529.AIR_SUBSET WHERE OPERATOR LIKE '?';	
*quit;
run;

*this procedure is for conducting an analysis between the number of fatalities and CN_IN ;
proc sql;
	CREATE TABLE ITMD529.AIR_SUBSET2 AS 		
		SELECT SUM(fatalities) AS FATALS,CN_IN FROM ITMD529.AIR_SUBSET 
		WHERE year(date) between 2000 and 2016 
		GROUP BY CN_IN;
*QUIT;
run;

PROC CONTENTS DATA=ITMD529.AIR_SUBSET; 
RUN;

%web_open_table(ITMD529.AIR_SUBSET);
%web_open_table(ITMD529.AIR_SUBSET2);

/*TITLE 'FREQ ANALYSIS OF FATALS VERSUS CN_IN';
proc FREQ data=ITMD529.AIR_SUBSET2;
	TABLES FATALS*CN_IN /CHISQ ;
run;*/

*FATALITIES= TIME ABOARD GROUND CAT_ID TIMING MONTH YEAR /SOLUTION SS3;
*CLASS TIMING CAT_ID MONTH YEAR; *OPERATOR ;

/*TITLE 'PLOT OF CN_IN VERSUS FATALITIES';
PROC SGPLOT DATA= ITMD529.AIR_SUBSET;
	VBAR CN_IN/RESPONSE=FATALITIES;
RUN;*/

*TITLE 'FREQ ANALYSIS OF FATALITIES OPERATOR WISE';
*PROC FREQ DATA=ITMD529.AIR_SUBSET;
*	TABLES FATALITIES*OPERATOR /CHISQ;
*RUN;

/*TITLE 'FREQ ANALYSIS OF CAT_ID YEARWISE';
PROC FREQ DATA=ITMD529.AIR_SUBSET;
	TABLES CAT_ID*YEAR /CHISQ;
RUN;*/

/*TITLE 'FREQ ANALYSIS OF CAT_ID VERSUS OPERATOR';
PROC FREQ DATA=ITMD529.AIR_SUBSET;
	TABLES CAT_ID*OPERATOR /CHISQ;
RUN;*/

TITLE 'FREQ ANALYSIS OF CAT_ID VERSUS TIMING ';
proc FREQ data=ITMD529.AIR_SUBSET;
	TABLES CAT_ID*TIMING /CHISQ ;
run;

TITLE 'FREQ ANALYSIS OF FATALITIES VERSUS CAT_ID';
proc FREQ data=ITMD529.AIR_SUBSET;
	TABLES FATALITIES*CAT_ID /CHISQ;
run;

TITLE 'FREQ ANALYSIS OF FATALITIES VERSUS TIMING ';
proc FREQ data=ITMD529.AIR_SUBSET;
	TABLES FATALITIES*TIMING /CHISQ ;
run;

TITLE 'FREQ ANALYSIS OF FATALITIES VERSUS MONTH ';
proc FREQ data=ITMD529.AIR_SUBSET;
	TABLES FATALITIES*MONTH /CHISQ ;
RUN;

/*TITLE 'FREQ ANALYSIS OF FATALITIES VERSUS YEAR ';
proc FREQ data=ITMD529.AIR_SUBSET;
	TABLES FATALITIES*YEAR /CHISQ ;
run;*/

TITLE 'FREQ ANALYSIS OF ACCIDENTS W.R.T TIMING';
PROC FREQ DATA=ITMD529.AIR_SUBSET;
	TABLES TIMING;
RUN;

TITLE 'FREQ ANALYSIS OF SUM OF FATALITIES W.R.T CN_IN';
proc SGSCATTER data=itmd529.air_SUBSET2;
	COMPARE Y=FATALS 
		X=(CN_IN) /GROUP=CN_IN;	
run;

TITLE 'SCATTER PLOT OF FATALITIES VERSUS TIME';
proc SGSCATTER data=itmd529.air_SUBSET;
	COMPARE Y=FATALITIES 
		X=(TIME) /GROUP=FATALITIES ;*CAT_ID;	
run;

/*TITLE 'SCATTER PLOT OF FATALITIES VERSUS ABOARD';
proc SGSCATTER data=itmd529.air_SUBSET;
	COMPARE Y=FATALITIES 
		X=(ABOARD);* /GROUP=CAT_ID;	
run;*/

TITLE 'SCATTER PLOT OF FATALITIES VERSUS GROUND';
proc SGSCATTER data=itmd529.air_SUBSET;
	COMPARE Y=FATALITIES 
		X=(GROUND);* /GROUP=CAT_ID;	
run;

TITLE 'SCATTER PLOT OF CAT_ID VERSUS TIME ';
proc SGSCATTER data=itmd529.air;
	COMPARE Y=CAT_ID X=(TIME) ;*/GROUP=CAT_ID;	
run;


TITLE 'SCATTER PLOT OF FATALITIES VERSUS CAT_ID';
proc sgplot data=ITMD529.AIR;
	scatter x=CAT_ID y=FATALITIES / transparency=0.0 name='Scatter'GROUP=FATALITIES;
	xaxis grid;
	yaxis grid;
run;

TITLE 'PLOT OF FATALITIES vis-a-vis THOSE WHO ARE ON BOARD (ABOARD) ALONG WITH A REGRESSION LINE';
proc sgscatter data=itmd529.air_SUBSET;
	PLOT FATALITIES*ABOARD/REG;
run;

TITLE 'CORRELATION ANALYSIS BETWEEN ALL VARIABLES';
proc corr data=ITMD529.AIR_SUBSET;
	var cat_id TIME fatalities aboard ground year month ;
run;


TITLE 'ITERATION#1-PROC GLM WITH TIME, ABOARD, CAT_ID, MONTH, TIMING, CN_IN AS PREDICTOR VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	CLASS TIMING CAT_ID CN_IN OPERATOR MONTH;
	MODEL FATALITIES= TIME ABOARD CAT_ID MONTH TIMING CN_IN /SOLUTION SS3;
RUN;

TITLE 'ITERATION#2-PROC GLM WITH CAT_ID, ABOARD, TIMING, CN_IN AS PREDICTOR VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	CLASS TIMING CAT_ID CN_IN OPERATOR ;*MONTH YEAR;* OPERATOR ;
	MODEL FATALITIES= CAT_ID ABOARD TIMING CN_IN /SOLUTION SS3;
RUN;

TITLE 'ITERATION#3 - PROC GLM WITH ABOARD, CN_IN AS PREDICTOR VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	CLASS CN_IN ;
	MODEL FATALITIES= ABOARD CN_IN /SOLUTION SS3;
RUN;


/*proc sgscatter data=itmd529.air_SUBSET;
	matrix CAT_ID TIME YEAR MONTH ID fatalities aboard ground /group =cat_id ;
run;*/

/*TITLE 'Freq plot of CAT_ID';
proc freq data=ITMD529.AIR_SUBSET;
	tables CAT_ID / plots=(freqplot cumfreqplot);
run;
*/

/*TITLE 'CAT_ID VERSUS FATALITIES';
PROC SGPLOT DATA= ITMD529.AIR_SUBSET;
	VBAR CAT_ID/RESPONSE=FATALITIES;
RUN;*/

/*
TITLE 'CAT_ID VERSUS FATALITIES';
PROC SGPLOT DATA= ITMD529.AIR_SUBSET;
	VBAR OPERATOR/RESPONSE=FATALITIES;
RUN;

TITLE 'FATALITIES VERSUS TIMING';
PROC SGPLOT DATA= ITMD529.AIR;
	VBOX FATALITIES/CATEGORY=TIMING CONNECT=MEAN;
RUN;*/



/*
TITLE 'SCATTER PLOTS OF CAT_ID, FATALITIES, ABOARD, GROUND, TIME, YEAR, MONTH GROUPED BY CAT_ID';
proc sgscatter data=itmd529.air_SUBSET;
	MATRIX FATALITIES CAT_ID ABOARD GROUND TIME YEAR MONTH /group =cat_id ;
run;*/

/*TITLE 'SCATTER PLOT OF FATALITIES VERSUS TIME';
proc sgplot data=ITMD529.AIR;
	scatter x=time y=FATALITIES / transparency=0.0 name='Scatter'GROUP=FATALITIES;
	xaxis grid;
	yaxis grid;
run;*/

/*
TITLE 'SCATTER PLOT OF TIME VERSUS OPERATOR GROUP BY OPERATOR';
proc sgplot data=ITMD529.AIR;
	scatter x=time y=operator / transparency=0.0 name='Scatter' GROUP=FATALITIES;
	xaxis grid;
	yaxis grid;
run;

proc sgplot data=ITMD529.AIR;
	vbar CAT_ID / response=fatalities group=CAT_ID groupdisplay=Cluster stat=Mean 
		name='Bar';

	yaxis grid;
run;

PROC SGPLOT DATA = ITMD529.AIR_SUBSET; 
   VBAR CAT_ID /  RESPONSE  = FATALITIES STAT=SUM ;
   TITLE 'FATALITIES BY CATEGORY'; 
RUN;*/ 

/*
TITLE 'PLOT OF FATALITIES vis-a-vis THE OPERATOR OF THE AIRCRAFT';
proc sgscatter data=itmd529.air_SUBSET;
	PLOT FATALITIES*OPERATOR / GROUP=OPERATOR REG;
run;*/



/*
TITLE 'PROC GLM WITH Y AND X VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	CLASS TIMING CAT_ID MONTH CN_IN OPERATOR;
	MODEL FATALITIES= CAT_ID TIME TIMING DATE ABOARD GROUND MONTH CN_IN OPERATOR;
RUN;


TITLE 'PROC GLM WITH TIME, ABOARD, GROUND, CAT_ID, TIMING, MONTH, CN_IN, OPERATOR AS PREDICTOR VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	*TIMING , CAT_ID, MONTH AND OPERATOR ARE NOMINAL CATAGORICAL VARIABLES ;
	*SO USE THE CLASS KEYWORD TO CREATE DUMMY VARIABLES FOR ANALYSIS;
	
	CLASS TIMING CAT_ID MONTH YEAR CN_IN OPERATOR ;
	*MODEL FATALITIES= TIME aboard ground cat_id TIMING OPERATOR CAT_ID*TIME TIME*ABOARD ABOARD*GROUND CAT_ID*TIMING CAT_ID*ABOARD/SOLUTION SS3;
	MODEL FATALITIES= TIME ABOARD GROUND CAT_ID TIMING MONTH CN_IN OPERATOR /SOLUTION SS3;
RUN;

TITLE 'HIHIHI -PROC GLM WITH TIME, ABOARD, CAT_ID, TIMING,MONTH, CN_IN, cn_in*operator AS PREDICTOR VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	*TIMING , CAT_ID, MONTH AND OPERATOR ARE NOMINAL CATAGORICAL VARIABLES ;
	*SO USE THE CLASS KEYWORD TO CREATE DUMMY VARIABLES FOR ANALYSIS;
	
	CLASS TIMING CAT_ID CN_IN OPERATOR MONTH;
	MODEL FATALITIES= TIME ABOARD CAT_ID TIMING MONTH CN_IN cn_in*operator/SOLUTION SS3;
RUN;
*/
/*PERSONAL NOTES-NOT WORKING - NO CORRELATION
TITLE 'PROC GLM WITH CAT_ID, TIMING, OPERATOR AS PREDICTOR VARIABLES';
PROC GLM DATA=ITMD529.AIR_SUBSET PLOTS=DIAGNOSTICS;
	*TIMING , CAT_ID, MONTH AND OPERATOR ARE NOMINAL CATAGORICAL VARIABLES ;
	*SO USE THE CLASS KEYWORD TO CREATE DUMMY VARIABLES FOR ANALYSIS;
	
	CLASS TIMING CAT_ID CN_IN OPERATOR;*MONTH YEAR;* OPERATOR ;
	MODEL FATALITIES= CAT_ID TIMING OPERATOR/SOLUTION SS3;
RUN;*/


/*
TITLE 'PROC GLMSELECT WITH PREDICTORS OF TIME, ABOARD, GROUND,CAT_ID, TIMING';
PROC GLMSELECT DATA=ITMD529.AIR_SUBSET ;
	*TIMING , CAT_ID, MONTH AND OPERATOR ARE NOMINAL CATAGORICAL VARIABLES ;
	*SO USE THE CLASS KEYWORD TO CREATE DUMMY VARIABLES FOR ANALYSIS;
	CLASS TIMING CAT_ID MONTH YEAR CN_IN OPERATOR ;
	*MODEL FATALITIES= TIME aboard cat_id TIMING OPERATOR CAT_ID*TIME TIME*ABOARD ABOARD*GROUND CAT_ID*TIMING CAT_ID*ABOARD /SELECTION=NONE;
	MODEL FATALITIES= TIME ABOARD GROUND CAT_ID TIMING CN_IN OPERATOR /SELECTION=NONE;
	OUTPUT OUT=OUT r=RESIDUALS;
RUN;*/


%web_open_table(itmd529.air_SUBSET);

ods graphics off;
