title 'Expected Mean Squares for the Correct Model';
proc mixed data=sasuser.scores method=type3;
   class material teacher;
   model score=material;
   random teacher(material);
run;                          *ST206d04.sas;

title 'Expected Mean Squares for the Incorrect Model';
proc mixed data=sasuser.scores method=type3;
   class material teacher;
   model score=material teacher(material);
run;
title;                        *ST206d04.sas;
