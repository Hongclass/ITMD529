data states;
  set orion.contacts;
  keep ID Name Location;
  Location = zipnamel(substr(right(address2),20,5));
run;

proc print data=states noobs;
run;
