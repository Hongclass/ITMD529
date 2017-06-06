

/*Forecasting Module*/

libname cidata 'B:\Modeling\Stress Testing Models\Assets\Commercial\C&I Originations Model\Data';
libname cilock 'B:\Modeling\Stress Testing Models\Assets\Commercial\C&I Originations Model\Data\Locked';


/*Indicate asset class*/
%let class = C+IOO;

/*Indicate desired start date of ex-ante forecast, in month_end terms*/
%let start_date = 201209;

/*Indicate desired rate scenario*/
/*DIFFERENT than other modules - this will change the applied average balance at origination for C&I and OO portions*/
%let scenario = MTB_Base;


/*Forecasting Module*/

/* This creates a PDF of Parameter Estimates, Adjustment Factor, and Graph of &Class. Ex-Post and Ex-Ante &Scenario. */

/* This module not only updates the model to include more recent data since model development (up to Sept 2012 here),
	but also creates a PDF with several points of interest:
		- Parameter Estimates for each independent variable included - still remaining constant from up-to-May 2012 data
		- Graphic of macroeconomic factors used, including the transformations utilized
		- Logistic Adjustment needed and recorded from model development code
		- Ex-Post and Ex-Ante Graphic in that macroeconomic scenario, updated with actuals until September 2012
		- Forecast Error Statistics and Graphic
		- Percentage Splits and Average Balance Assumptions - still remaining constant from up-to-May 2012
		- Yearly Originations and Originated Balance Sums for the model as a whole in that macroeconomic scenario
		- Yearly Originations and Originated Balance Sums for each product breakout in that macroeconomic scenario
*/

ods graphics on;
/* Statistical procedures produce integrated output with tables & graphs */

ods pdf file="B:\Modeling\Education and Training\MTBSUG Presentation\&Class. Forecast Module - &Scenario. Forecast.pdf";
/* Specify desired location of PDF output */
/* Notice macro name usage */

ods pdf startpage=now;
/* Startpage options include: "NO", "YES", "NOW", "NEVER" */

ods title "C&I Originations Model - Forecast Module Summary";
/* Specify desired title in ODS output and PDF output*/

ods text="This forecast module not only updates the model to include more recent data since model development, 
but also features several points of interest.  These include: parameter estimates from model development, graphics of macroeconomic 
factors, the necessary logarithmic adjustment, forecast error statistics and graphics, graphics of Ex-Post and Ex-Ante backtesting, 
percentage splits and average balances by product type from model development applied in forecasts, and yearly originations and 
originated balance sums for the model as a whole and for each product breakout."; 
/* Specify text string if desired - several style options available here with a template procedure */ 
/* Brief note added here explaining purpose of report*/


ods pdf startpage=now;
/* Beginning a new page after brief explanation about forecasting module */

ods noproctitle;
/* Suppresses the printing of procedure titles in ODS and PDF output - creates a less cluttered display */

title2 "&Class. Model - Final Parameter Estimates";
/* Subtitle with title2 specification, retains main title from above */
/* Notice macro name usage */
proc means data=cilock.param_est mean maxdec=5;
	var _MSE_ _SSE_ INTERCEPT lag_log_count	lag06dif12_unemp _jan _feb _jul _aug _sep _oct _nov _post_wtc  ;
	output out=ci_param;
run;



%macro graphs (var=);
proc sgplot data=candi_orig_merge_&scenario.;
	   inset "&Class. Model - Macroeconomic Variables Used - &var." / textattrs=GraphLabelText;
       series x=month y=&var.;
       refline '15Sep12'd / axis=x;
run;
%mend;
/* Notice inset and textattrs options, to place title strategically within graphing area */
/* Notice macro name usage, both &var. and &scenario. */
%graphs (var=lag06dif12_unemp);




title2 "&Class. Model - Final Logarithmic Adjustment";
/* Subtitle with title2 specification, retains main title from above */
/* Notice macro name usage */
proc tabulate data=ci_adj_lock;
variable Adjustment;
table mean*((Adjustment)*(f=6.5));
run;


ods pdf startpage=now;
/* Beginning a new page for forecast error metrics */


title2 "Forecasted &Class. Originations - Forecast Error Statistics";
/* Subtitle with title2 specification, retains main title from above */
/* Notice macro name usage */
proc tabulate data=cilock.Stat_table_Month;
	var mean_diff_abs mean_diff_sqr_sqrt per_diff_abs per_diff_sqr MASE_Mean;
	table mean='Mean of All Forecasts'*(mean_diff_abs='Mean Absolute Error' mean_diff_sqr_sqrt='Mean RMSE' per_diff_abs='Mean Percent Absolute Error' per_diff_sqr='Mean Percent RMSE' MASE_Mean='MASE');
run;

ods pdf startpage=no;
/* Keep all error metric tables on the same page */

proc tabulate data=cilock.Stat_Table_T;
	var mean_diff_abs mean_diff_sqr_sqrt per_diff_abs per_diff_sqr Q_t_Mean;
	table mean='Mean of All Months Since Last Actual'*(mean_diff_abs='Mean Absolute Error' mean_diff_sqr_sqrt='Mean RMSE' per_diff_abs='Mean Percent Absolute Error' per_diff_sqr='Mean Percent RMSE' Q_t_Mean='Scaled Error Mean');
run;

ods pdf startpage=no;
/* Keep all error metric tables on the same page */

proc tabulate data=cilock.pred_vs_act_table;
	var diff_1y diff_2y;
	table mean*(diff_1y='Average % Difference in Predicted & Actual 1Yr Sum' diff_2y='Average % Difference in Predicted & Actual 2Yr Sum');
run;

ods pdf startpage=now;
/* Move 1Y and 2Y forecasting error graphs to the next page */

proc sgplot data=cilock.sum_data_avg;
inset 'Forecasted &Class. Originations - 1Y Sum Predicted/Actual Difference';
xaxis type=discrete fitpolicy=rotatethin;
series x=month y=actual_1y_sum_mean / legendlabel="1Y Actual Sum" lineattrs=(pattern=solid color=black);
series x=month y=pred_1y_sum_mean / legendlabel="1Y Predicted Sum" lineattrs=(pattern=dash color=blue);
yaxis label='Count';
xaxis label='Month';
run;

ods pdf startpage=no;
/* Keep 1Y and 2Y graphs on the same page */

proc sgplot data=cilock.sum_data_avg;
inset 'Forecasted &Class. Originations - 2Y Sum Predicted/Actual Difference';
xaxis type=discrete fitpolicy=rotatethin;
series x=month y=actual_2y_sum_mean / legendlabel="2Y Actual Sum" lineattrs=(pattern=solid color=black);
series x=month y=pred_2y_sum_mean / legendlabel="2Y Predicted Sum" lineattrs=(pattern=dash color=blue);
yaxis label='Count';
xaxis label='Month';
run;

ods pdf startpage=now;
/* Move predicted/actual % difference forecasting error graph to the next page */

proc sgplot data=cilock.pred_vs_act_graph;
inset 'Forecasted &Class. Originations - Predicted/Actual Percent Difference';
xaxis type=discrete fitpolicy=rotatethin;
refline 0;
series x=month y=diff_1y / legendlabel="1Y Sum % Difference" lineattrs=(pattern=dash color=blue);
series x=month y=diff_2y / legendlabel="2Y Sum % Difference" lineattrs=(pattern=dash color=red);
xaxis label='Month';
yaxis label='Percent Difference';
run;


ods pdf startpage=now;
/* Moves our "money shot" graph to the next page */

title2 "Forecasted &Class. Originations - &Scenario. Scenario";
proc sgplot data=adj_forecast_CI;
	inset "Forecasted &Class. Originations - &Scenario. Scenario" / textattrs=GraphLabelText;
	xaxis type=time interval=year;
	xaxis label='Month';
	yaxis label='Accounts Originated';

scatter x=month y=historicals / legendlabel='Actual' markerattrs=(color=green);

series x=month y=ci_ex_post / lineattrs=(color=black thickness=2px) 
				legendlabel="Ex-Post Forecast";

series x=month y=ci_&scenario._forecast /lineattrs=(color=black thickness=2px pattern=dash) 
				legendlabel="Ex-Ante &Scenario. Forecast";
			
band x=month lower=ci_ex_post_lcl upper=ci_ex_post_ucl / 
			transparency=.5 fillattrs=(color=gray) legendlabel="Ex-Post Confidence Band";

band x=month lower=ci_pred_&scenario._lcl upper=ci_pred_&scenario._ucl/ 
			transparency=.5 fillattrs=(color=green) legendlabel="Ex-Ante &Scenario. Confidence Band";
		
refline '15Sep12'd /axis=x;

keylegend / position=bottom down=5;

where month_end le 201512;
run;

/* Subtitle with title2 specification, retains main title from above */
/* Notice macro name usage - &class. and &scenario. */
/* Several options invoked here - insets, labels, scatter, series, band, refline, keylegend */
/* All translate to more intuitive, understandable output */


ods pdf startpage=now;
/* Moves asset class percent split assumptions to next page */

ods title "&Class. Model - Origination Count Percentages - Without All Other Loans and Leases";
proc tabulate data=counts2;
class Asset_Class;
var Percent_Split;
table Asset_Class,mean*(Percent_Split)*(format=percent10.1);
	where Asset_Class in ("count_CI_pct_Mean",
							"count_OO_pct_Mean",
							"count_BALOC_pct_Mean",
							"count_BIL_pct_Mean",
							"count_CARD_pct_Mean"); 	
run;

ods pdf startpage=no;
/* Keeps all percent split assumptions on the same page */ 

proc tabulate data=counts2;
class Asset_Class;
var Percent_Split;
table Asset_Class,mean*(Percent_Split)*(format=percent10.1);
	where Asset_Class in ("count_CI_pct_Mean",
								"count_CI_MM_LINE_pct_mean",
								"count_CI_MM_LOAN_pct_mean",
								"count_CI_BB_LINE_pct_mean",
								"count_CI_BB_LOAN_pct_mean"); 	
run;

ods pdf startpage=now;
/* Moves asset class average balance assumptions to next page */

ods title "&Class. Model - Average Balance by Asset Class - Without All Other Loans and Leases";
proc tabulate data=bals2;
class Asset_Class;
var Average_Balance;
table Asset_Class,mean*(Average_Balance)*(format=dollar20.0);
	where Asset_Class in ("avg_bal_CI_mean",
							"avg_bal_OO_mean",
							"avg_bal_BALOC_Mean",
							"avg_bal_BIL_Mean",
							"avg_bal_CARD_Mean"); 
run;

ods pdf startpage=no;
/* Keeps all average balance assumptions on same page */

proc tabulate data=bals2;
class Asset_Class;
var Average_Balance;
table Asset_Class,mean*(Average_Balance)*(format=dollar20.0);
	where Asset_Class in ("avg_bal_CI_mean",
								"avg_bal_CI_MM_LINE_mean",
								"avg_bal_CI_MM_LOAN_mean",
								"avg_bal_CI_BB_LINE_mean",
								"avg_bal_CI_BB_LOAN_mean"); 
run;

ods pdf startpage=now;
/* Yearly originations forecast counts and balances on one page */

ods title "&Class. Yearly Forecast - Last Actual Set at &start_date. - Total Originations & Originated Balances - Without All Other Loans & Leases";
/* With only one table on this page, no subtitle specification necessary */
proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var count sum_bal;
	table year, SUM*(count sum_bal)*(f=comma20.);
run;

ods pdf startpage=now;
/* Yearly originations forecast counts broken out by asset class on one page */

ods title "&Class. Yearly Forecast - Last Actual Set at &start_date. - Originations by Product Type - Without All Other Loans & Leases";
/* With only one table on this page, no subtitle specification necessary */
proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var count_CI count_OO count_BALOC count_BIL count_CARD;
	table year, SUM*(count_CI count_OO count_BALOC count_BIL count_CARD)*(f=comma20.);
run;

ods pdf startpage=now;
/* Yearly originations forecast counts broken out by sub-asset class on one page */

proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var count_CI count_CI_MM_LOAN count_CI_MM_LINE count_CI_BB_LOAN count_CI_BB_LINE;
	table year, SUM*(count_CI count_CI_MM_LOAN count_CI_MM_LINE count_CI_BB_LOAN count_CI_BB_LINE)*(f=comma20.);
run;


ods pdf startpage=now;
/* Yearly originations forecast balances broken out by asset class on one page */

ods title "&Class. Yearly Forecast - Last Actual Set at &start_date. - Origination Balances by Product Type - Without All Other Loans & Leases";
proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var sum_bal_CI sum_bal_OO sum_bal_BALOC sum_bal_BIL sum_bal_CARD ;
	table year, SUM*(sum_bal_CI sum_bal_OO sum_bal_BALOC sum_bal_BIL sum_bal_CARD)*(f=comma20.);
run;

ods pdf startpage=now;
/* Begins new page for originations forecasted balances by sub-asset class */

proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var sum_bal_CI sum_bal_CI_MM_LOAN sum_bal_CI_MM_LINE sum_bal_CI_BB_LOAN sum_bal_CI_BB_LINE;
	table year, SUM*(sum_bal_CI sum_bal_CI_MM_LOAN sum_bal_CI_MM_LINE sum_bal_CI_BB_LOAN sum_bal_CI_BB_LINE)*(f=comma20.);
run;


ods pdf startpage=now;
/* Begin new page with "All Other Loans and Leases" Y9C category gross-up addition */

ods title "&Class. Model - Origination Count Percentages - All Other Loans and Leases as Gross-Up to &Class.";
/* With only two related tables on this page, no subtitle specification necessary */
proc tabulate data=counts2;
class Asset_Class;
var Percent_Split;
table Asset_Class,mean*(Percent_Split)*(format=percent10.1);
	where Asset_Class in ("count_OTHER_pct_Mean"); 	
run;

ods pdf startpage=no;
/* Keep percent split assumptions by sub-asset class on the same page*/

proc tabulate data=counts2;
class Asset_Class;
var Percent_Split;
table Asset_Class,mean*(Percent_Split)*(format=percent10.1);
	where Asset_Class in ("count_OTHER_LEASES_pct_mean",
							"count_OTHER_LOANS_pct_mean",
							"count_OTHER_PERAFS_pct_mean",
							"count_OTHER_DEPFIN_pct_mean",
							"count_OTHER_PURSEC_pct_mean"); 	
run;

ods pdf startpage=now;
/* Begin new page for average balance assumptions */

ods title "&Class. Model - Average Balance by Asset Class - Originations - All Other Loans and Leases as Part of &Class.";
/* With only two related tables on this page, no subtitle specification necessary */
proc tabulate data=bals2;
class Asset_Class;
var Average_Balance;
table Asset_Class,mean*(Average_Balance)*(format=dollar20.0);
	where Asset_Class in ("avg_bal_OTHER_Mean"); 	
run;

ods pdf startpage=no;
/* Keep average balance assumptions on the same page*/

proc tabulate data=bals2;
class Asset_Class;
var Average_Balance;
table Asset_Class,mean*(Average_Balance)*(format=dollar20.0);
	where Asset_Class in ("avg_bal_OTHER_LEASES_mean", 
							"avg_bal_OTHER_LOANS_mean", 
							"avg_bal_OTHER_PERAFS_mean", 
							"avg_bal_OTHER_DEPFIN_mean", 
							"avg_bal_OTHER_PURSEC_mean"); 	
run;

ods pdf startpage=now;
/* Begin new page for forecasted origination counts by asset class, with gross-up addition */

ods title "&Class. Yearly Forecast - Data Available Beginning in 201207, Last Actual Set at &start_date. - 
Total Originations - All Other Loans & Leases";
/* With only one table on this page, no subtitle specification necessary */
proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var count_OTHER;
	table year, SUM*(count_OTHER)*(f=comma20.);
run;

ods pdf startpage=now;
/* Begin new page for forecasted origination counts by sub-asset class, with gross-up addition */

proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var count_OTHER_LEASES count_OTHER_LOANS count_OTHER_PERAFS count_OTHER_DEPFIN count_OTHER_PURSEC;
	table year, SUM*(count_OTHER_LEASES count_OTHER_LOANS count_OTHER_PERAFS count_OTHER_DEPFIN count_OTHER_PURSEC)*
									(f=comma20.);
run;

ods pdf startpage=now;
/* Begin new page with "All Other Loans and Leases" Y9C category gross-up addition - originated balances rather than counts */

ods title "&Class. Yearly Forecast - Data Available Beginning in 201207, Last Actual Set at &start_date. - 
Total Originated Balances - All Other Loans & Leases";
/* With only two related tables on this page, no subtitle specification necessary */
proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var sum_bal_OTHER ;
	table year, SUM*(sum_bal_OTHER)*(f=comma20.);
run;

ods pdf startpage=now;
/* Begin new page for forecasted origination balances by sub-asset class, with gross-up addition */

proc tabulate data=year_sum;
	class year;
	where year>=2008;
	var sum_bal_OTHER_LEASES sum_bal_OTHER_LOANS sum_bal_OTHER_PERAFS sum_bal_OTHER_DEPFIN sum_bal_OTHER_PURSEC;

	table year, SUM*(sum_bal_OTHER_LEASES sum_bal_OTHER_LOANS sum_bal_OTHER_PERAFS sum_bal_OTHER_DEPFIN sum_bal_OTHER_PURSEC)*
									(f=comma20.);
run;

ods pdf close;
ods graphics off;