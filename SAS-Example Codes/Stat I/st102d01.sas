/*st102d01.sas*/
proc ttest data=sasuser.TestScores plots(shownull)=interval;
    class Gender;
    var SATScore;
    title "Two-Sample t-test Comparing Girls to Boys";
run;
