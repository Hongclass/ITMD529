title1 "Distribution of Scores by Materials";
proc sgpanel data=sasuser.scores;
  panelby material / columns=4;
  vbox score;
run; 					*ST206d01.sas;
