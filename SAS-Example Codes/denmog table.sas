data dda;
set data.main_201206;
where dda eq 1;
keep hhid;
run;

data a;
merge data.demog_201206 (in=a) dda (in=b);
by hhid;
if a and b;
run;


proc tabulate data=a missing;
class dwelling education income ethnic_rollup home_owner marital poc: gender age_hoh religion languag length_resid ;
var hh;
table (dwelling all) (education all) (income all) (ethnic_rollup all) (home_owner all) (marital all) (poc="Children" all)  
      (gender all) (age_hoh all) (religion all) (languag all)
      (length_resid all),hh*N*f=comma12. / nocellmerge misstext='0';
format dwelling $dwelling. education $educfmt. income $incmfmt.  home_owner $homeowner.  marital $marital.  
       religion $religion. languag $language. length_resid $residence.   age_hoh ageband.;
run;
