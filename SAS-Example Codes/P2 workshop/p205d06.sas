data labels;
   set orion.contacts;
   length FMName LName $ 15;
   FMName = scan(Name,2,',');            
   LName = scan(Name,1,',');
run;

proc print data=labels noobs;
   var ID Name Title FMName LName;
run;
