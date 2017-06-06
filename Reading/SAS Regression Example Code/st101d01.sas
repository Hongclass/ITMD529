/*st101d01.sas*/  /*Part A*/

/*Exploration of all variables that are available for analysis.*/
/*%let statements define macro variables containing lists of */
/*dataset variables*/
%let categorical=House_Style Overall_Qual Overall_Cond Year_Built 
         Fireplaces Mo_Sold Yr_Sold Garage_Type_2 Foundation_2 
         Heating_QC Masonry_Veneer Lot_Shape_2 Central_Air;
%let interval=SalePrice Log_Price Gr_Liv_Area Basement_Area 
         Garage_Area Deck_Porch_Area Lot_Area Age_Sold Bedroom_AbvGr 
         Full_Bathroom Half_Bathroom Total_Bathroom ;

/*st101d01.sas*/  /*Part B*/
/*PROC FREQ is used with categorical variables*/
ods graphics;

proc freq data=STAT1.ameshousing3;
    tables &categorical / plots=freqplot ;
    format House_Style $House_Style.
           Overall_Qual Overall.
           Overall_Cond Overall.
           Heating_QC $Heating_QC.
           Central_Air $NoYes.
           Masonry_Veneer $NoYes.
           ;
    title "Categorical Variable Frequency Analysis";
run; 

/*st101d01.sas*/  /*Part C*/
/*PROC UNIVARIATE provides summary statistics and plots for */
/*interval variables.  The ODS statement specifies that only */
/*the histogram be displayed.  The INSET statement requests */
/*summary statistics without having to print out tables.*/
ods select histogram;
proc univariate data=STAT1.ameshousing3 noprint;
    var &interval;
    histogram &interval / normal kernel;
    inset n mean std / position=ne;
    title "Interval Variable Distribution Analysis";
run;

title;
