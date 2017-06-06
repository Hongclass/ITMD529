*#########################################;
*#####  SAS STAT I, Day 3 Exercises  #####;
*#########################################;

*###### EXERCISE 5.1a ######;
proc freq data=sasuser.safety;
table unsafe type region weight size / missing;
run;


*###### EXERCISE 5.1b ######;

proc format ;
value safefmt 0='Average or Above'
              1 = 'Below Average';
run;

title '5.1b';
proc freq data=sasuser.safety;
table region*unsafe / missing cellchi2 chisq expected relrisk;
format unsafe safefmt.;
run;

*###### EXERCISE 5.1c ######;
title '5.1c';
proc freq data=sasuser.safety;
table size*unsafe /   chisq measures cl;
format unsafe safefmt.;
run;


*###### EXERCISE 5.2 ######;
proc logistic data=sasuser.safety plots(only)=(effect oddsratio);
model unsafe(event='Below Average')=weight   / clodds=pl;
title 'Logistic Model for Safety 5.2';
format unsafe safefmt.;
run;


*###### EXERCISE 5.3 ######;

proc format;
value size (notsorted)
      1='Small or Sports'
	  2 ='Medium'
	  3='Large or SUV';
run;

proc logistic data=sasuser.safety plots(only)=(effect oddsratio);
class  region(ref='Asia') size(ref='Large or SUV') / param=ref;
model unsafe(event='Below Average')=weight region size  / clodds=pl;
title 'Logistic Model for Safety 5.3';
format unsafe safefmt. size size.;
run;

*###### EXERCISE 5.3 ######;
