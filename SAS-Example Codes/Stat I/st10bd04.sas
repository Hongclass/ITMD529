/*st10bd04.sas*/
proc print data=sasuser.ven;
    title 'Wood Veneer Wear Data';
run;          

proc npar1way data=sasuser.ven wilcoxon;
    class brand;
    var wear;
    exact;
run;          
