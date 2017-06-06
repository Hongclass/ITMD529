data hrdata(drop=CharGross);
   set orion.convert(rename=(GrossPay=
                             CharGross));            
   GrossPay=input(CharGross,comma6.);
run;

proc contents data=hrdata;
run;

proc print data=hrdata noobs;
run;



