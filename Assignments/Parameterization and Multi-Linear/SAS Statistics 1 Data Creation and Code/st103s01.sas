/*st103s01.sas*/  /*Part A*/
proc sgplot data=STAT1.drug;
    vline DrugDose / group=Disease 
                     stat=mean 
                     response=BloodP 
                     markers;
    format DrugDose dosefmt.;
run; 

/*st103s01.sas*/  /*Part B*/
ods graphics on;

proc glm data=STAT1.drug plots(only)=intplot;
    class DrugDose Disease;
    model BloodP = DrugDose|Disease;
    lsmeans DrugDose*Disease / slice=Disease;
run;
quit;

title;

