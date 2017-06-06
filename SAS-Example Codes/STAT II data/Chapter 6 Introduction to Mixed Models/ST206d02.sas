options formdlim="_";
proc mixed data=sasuser.scores;
   class material teacher;
   model score=material;
   random teacher(material);
run;                                 *ST6d02.sas;
