
title1 "Distribution of Scores by Materials";
proc sgpanel data=STAT2.scores;
  panelby material / columns=4;
  vbox score;
run; 					*ST206d01.sas;
