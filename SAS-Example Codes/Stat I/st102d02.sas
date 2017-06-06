/*st102d02.sas*/  /*Part A*/
proc print data=sasuser.MGGarlic (obs=10);
   title 'Partial Listing of Garlic Data';
run;

/*st102d02.sas*/  /*Part B*/
proc means data=sasuser.MGGarlic printalltypes maxdec=3;
    var BulbWt;
    class Fertilizer;
    title 'Descriptive Statistics of Garlic Weight';
run;

/*st102d02.sas*/  /*Part C*/
proc sgplot data=sasuser.MGGarlic;
    vbox BulbWt / category=Fertilizer datalabel=BedID;
    format BedID 5.;
    title "Box and Whisker Plots of Garlic Weight";
run;
