
proc glimmix data=STAT2.scores;
   class material teacher;
   model score=material;
   random teacher(material);
   covtest 'Test Need for Random Effect' glm;
run;                                 *ST206d02.sas;

