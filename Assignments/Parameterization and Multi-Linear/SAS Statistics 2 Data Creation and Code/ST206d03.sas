
title 'Random Effect is Incorrectly Specified as Fixed Effect';
proc glimmix data=STAT2.scores;
   class material teacher;
   model score=material teacher(material);
   output out=checkvar variance=ResidualVariance;
run;                                 

proc print data=checkvar (obs=1);
   var ResidualVariance;
run;						*ST206d03.sas;
