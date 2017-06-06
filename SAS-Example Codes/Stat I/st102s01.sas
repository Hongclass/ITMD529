/*st102s01.sas*/

proc ttest data=sasuser.German plots(shownull)=interval;
    class Group;
    var Change;
    title "German Grammar Training, Comparing Treatment to Control";
run;
