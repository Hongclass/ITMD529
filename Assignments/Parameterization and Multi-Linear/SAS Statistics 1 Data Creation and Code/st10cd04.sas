/*st10cd04.sas*/  /*Part A*/
proc print data=STAT1.ven;
    title 'Wood Veneer Wear Data';
run;

/*st10cd04.sas*/  /*Part B*/
proc npar1way data=STAT1.ven wilcoxon;
    class brand;
    var wear;
    exact;
run;