Data seminar_ratings;
   infile 'seminar.dat'; *PC and Unix;
   *infile '.workshop.rawdata(seminar)'; *Z/OS Mainframe;
   input Name $15.  @'Rating:' Rating 1.;
run;

title 'Names and Ratings';
proc print data=seminar_ratings;
run;
title;
