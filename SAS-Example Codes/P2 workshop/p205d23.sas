data hrdata;
    keep EmpID GrossPay Bonus Phone HireDate;
    set orion.convert(rename=(GrossPay=
                              CharGross));
    EmpID = input(ID,5.)+11000;
    GrossPay=input(CharGross,comma6.);
    Bonus = GrossPay*.10;
    HireDate = input(Hired,mmddyy10.);
    Phone = cat('(',Code,') ',Mobile);
run;

proc print data=hrdata noobs;
    var EmpID GrossPay Bonus Phone HireDate;
    format HireDate mmddyy10.;
run;
