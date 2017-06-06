data STAT1.ameshousing2;
    set STAT1.ameshousing(where=(Sale_Condition='Normal' and Gr_Liv_Area<= 1500));

    keep PID SalePrice Log_Price Gr_Liv_Area Bedroom_AbvGr Full_Bathroom 
         Half_Bathroom Total_Bathroom Deck_Porch_Area Age_Sold Lot_Area
         Basement_Area Garage_Area 
         House_Style Overall_Qual Overall_Cond Year_Built Fireplaces 
         Mo_Sold Yr_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air Season_Sold 
         House_Style2 Overall_Qual2 Overall_Cond2 Bonus;

run;

proc surveyselect data=STAT1.ameshousing2 out=temp outall
                  sampsize=300 method=srs seed=902101 noprint;
run;

data STAT1.ameshousing3 temp2;
    set temp;
    if selected then output STAT1.ameshousing3;
    else do;
        score = round(10000-(2*Gr_Liv_Area + 5*Basement_Area),10);
        output temp2;
    end;
    drop selected;
run;

proc surveyselect data=temp2 out=STAT1.ameshousing4 
                  sampsize=300 method=srs seed=902101 noprint;
run;

data STAT1.amesaltuse;
    set STAT1.ameshousing;

    score = round(10000-(2*Gr_Liv_Area + 5*Basement_Area),10);

    keep PID score;
run;

