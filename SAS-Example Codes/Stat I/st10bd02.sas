/*st10bd02.sas*/
proc ttest data=sasuser.TestScores 
           plots(only shownull)=interval h0=0 sides=U;
    class Gender;
    var SATScore;
    title "One-Sided t-test Comparing Girls to Boys";
run;
