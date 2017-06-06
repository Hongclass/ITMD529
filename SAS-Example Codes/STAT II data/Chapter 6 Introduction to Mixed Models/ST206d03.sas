title 'Random Effect is Incorrectly Specified as Fixed Effect';
proc mixed data=sasuser.scores;
   class material teacher;
   model score=material teacher(material);
run;                                 *ST206d03.sas;

