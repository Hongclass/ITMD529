data input_quiz;
   SharePrice = "$130.25"; 
   MyShares = 125;
   TotalValue = input(SharePrice,comma7.)*        
                MyShares;
run;

proc contents data=input_quiz;
run;

proc print data=input_quiz noobs;
run;
