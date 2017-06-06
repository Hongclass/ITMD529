/*st107s04.sas*/
ods graphics on;
proc logistic data=STAT1.safety plots(only)=(effect oddsratio);
     class Region (param=ref ref='Asia')
	       Size (param=ref ref='Small');
	 model Unsafe(event='1') = Weight Region Size
	               / clodds=pl selection=backward;
	 units Weight = -1;
	 store isSafe;
     format Size sizefmt.;
	 title 'Logistic Model: Backwards Elimination';
run;

data checkSafety;
     length Region $9.;
	 input Weight Size Region $ 5-13;
	 datalines;
4 1 N America
3 1 Asia     
5 3 Asia     
5 2 N America
	 ;
run;

proc plm restore=isSafe;
	score data=checkSafety out=scored_cars / ILINK;
	title 'Safety Predictions using PROC PLM';
run;

proc print data=scored_cars;
run;



