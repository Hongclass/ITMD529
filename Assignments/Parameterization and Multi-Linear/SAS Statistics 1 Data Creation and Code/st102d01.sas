/*st102d01.sas*/  /*Part A*/
proc sgscatter data=STAT1.ameshousing3;
    plot SalePrice*Gr_Liv_Area / reg;
    title "Associations of Above Grade Living Area with Sale Price";
run;

/*st102d01.sas*/  /*Part B*/
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

/*PROC SGSCATTER is used to explore relationships among continuous variables*/
/*using scatter plots*/
options nolabel;
proc sgscatter data=STAT1.ameshousing3;
    plot SalePrice*(&interval) / reg;
    title "Associations of Interval Variables with Sale Price";
run;

/*st102d01.sas*/  /*Part C*/
proc sgplot data=STAT1.ameshousing3;
    vbox SalePrice / category=Central_Air 
                     connect=mean;
    title "Sale Price Differences across Central Air";
run;

/*st102d01.sas*/  /*Part D*/
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
         Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air;

/*PROC SGPLOT is used here with the VBAR statement to produce vertical bar charts*/
/*PROC SGPLOT can only produce one plot at a time and so the macro is written to*/
/*produce one plot for each member in the list of the &categorical macro variable.*/
/*
      Macro Usage:
      %box(DSN = <data set name>,
           Response = <response variable name>,
           CharVar = <bar chart grouping variable list>)
*/
%macro box(dsn      = ,
           response = ,
           Charvar  = );

%let i = 1 ;

%do %while(%scan(&charvar,&i,%str( )) ^= %str()) ;

    %let var = %scan(&charvar,&i,%str( ));

    proc sgplot data=&dsn;
        vbox &response / category=&var 
                         grouporder=ascending 
                         connect=mean;
        title "&response across Levels of &var";
    run;

    %let i = %eval(&i + 1 ) ;

%end ;

%mend box;

%box(dsn      = STAT1.ameshousing3,
     response = SalePrice,
     charvar  = &categorical);

title;

options label;
