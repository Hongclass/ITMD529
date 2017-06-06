data atm_view1 / view=atm_view1;
set atm.atm_coords( where=(wsid ne '' and (x1 ne . or y1 ne .) and group ne 'Sheetz') );
rename wsid=wsid1 x1=x2 y1=y2;
keep wsid x1 y1 ;
run;

data atm_view2 / view=atm_view2;
set atm.atm_coords( where=(wsid ne '' and (x1 ne . or y1 ne .) ));
keep wsid x1 y1 ;
run;

data closest_non_sheetz;
retain m n;
length error_code $ 10 best_id $ 8;
*define the variables for hash objects, line only executes at compilation;
if 0 then set atm_view1 ;
*at beginning of execution, load atm_view into hash and also define the iterator;
if _N_ eq 1 then do;
	dcl hash h(dataset: "atm_view1",ordered:'a');
	h.definekey('x2','y2');
	h.definedata(all: 'yes');
	h.definedone();
    
	dcl hiter hi('h');
end;
*load the atm_data to find the nearest atm and calculate the distance;
set atm_view2;
*n=_n_;

best = 999999; *initialize best distance to a ridiculous large value;
best_id=''; *initialize if of best match;

rc=hi.first();

q = 1; 
rc2=0;
do while (rc2=0);
	current = geodist(y1,x1,y2,x2,'DM');
	if current lt best and wsid ne wsid1 and (x1 ne x2 and y1 ne y2) then do; *do not set best to be distance to self or to a colocated ATM;
	    best = current; 
		best_id = wsid1;
	end;
	rc2=hi.next();
	q+1;
end;


keep x1 y1 best best_id wsid x2 y2 group terminal_:;
rename wsid=atm_id ;
run;
