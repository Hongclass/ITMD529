data sample_atms;
input ID1 group $ x1 y1;
datalines;
0010 Branch -77.1537 39.0901
0013 Branch -77.2083 39.0177
0014 Branch -77.0303 38.998
0015 Branch -77.086 38.9612
0016 Branch -77.1654 39.1562
0019 Branch -76.2499 39.1169
0021 Offsite -77.6322 43.0954
0023 Branch -76.8493 39.0965
0055 Branch -77.3517 38.8492
0064 Branch -77.5524 39.109
0073 Branch -77.5161 38.2467
0075 Branch -77.389 37.6268
0079 Branch -77.4744 37.5659
0081 Branch -76.4571 39.2336
0083 Branch -76.6332 39.3311
0084 Branch -76.5228 39.2578
0086 Branch -76.5743 39.2804
0088 Branch -76.5525 39.3375
0089 Branch -76.6932 39.2935
0092 Branch -76.7055 39.3584
0093 Branch -76.4871 39.3361
0095 Branch -76.6982 39.265
0098 Branch -76.7518 39.3294
0102 Branch -76.577799 39.38354
0103 Branch -76.7807 39.3622
0104 Branch -76.3271 39.5033
0105 Branch -76.482 39.3986
0107 Branch -76.6095 39.4106
0108 Branch -76.5391 39.3782
0109 Branch -76.6697 39.4198
0112 Branch -76.7628 39.3554
0113 Branch -76.5452 39.3993
0138 Branch -76.6248 39.1652
0159 Branch -76.5525 39.3375
0171 Branch -77.8094 43.1905
0180 Branch -76.6932 39.2935
0181 Branch -76.355885 43.15152
0186 Branch -76.6246 39.1654
0187 Branch -76.4871 39.3361
0189 Branch -76.577799 39.38354
0191 Branch -76.117496 43.167947
0201 Branch -76.136663 43.126701
0204 Offsite -76.5931 39.2831
0210 Branch -76.5391 39.3782
0213 Branch -76.482 39.3986
0219 Offsite -76.6094 39.3269
0220 Branch -76.6982 39.264
0221 Branch -78.872511 42.983413
0222 Branch -78.457158 42.077063
0223 Branch -76.681617 39.960469
0224 Branch -76.681617 39.960469
0226 Branch -76.910842 40.95735
0227 Branch -76.34918 39.53565
0228 Branch -76.34918 39.53565
0229 Branch -76.5383 40.0241
0230 Branch -76.79191 39.97574
0231 Branch -76.35217 39.52699
0232 Branch -76.35217 39.52699
0233 Branch -78.393527 40.335695
0234 Branch -76.859933 39.220265
0235 Branch -76.859933 39.220265
0236 Branch -76.6784 39.7534
0237 Branch -76.62212 39.89584
0238 Branch -75.545063 39.99433
0239 Branch -75.075948 40.040725
0240 Branch -79.044981 39.485519
0241 Branch -77.408517 39.142622
0242 Branch -76.82335 39.45714
0244 Branch -77.759349 40.914432
0247 Branch -78.000862 42.719572
0249 Branch -76.8623 39.2797
0250 Branch -76.6084 39.3789
0254 Branch -76.5805 39.2939
0255 Branch -75.3402 39.8642
0257 Branch -77.2402 40.7616
0259 Branch -76.573802 40.967937
0260 Branch -76.886071 40.963469
0261 Branch -76.1022 42.8885
0262 Branch -76.833103 41.24022
0263 Branch -77.046244 40.791839
0264 Branch -76.194972 40.684914
0265 Branch -75.323581 39.879061
0268 Branch -76.40225 41.5247
0270 Branch -76.558397 40.790801
0271 Branch -77.052855 41.239542
0326 Branch -77.7388 40.8715
0327 Branch -78.379326 40.509692
0328 Branch -76.76709 39.97636
0329 Branch -77.423835 41.143106
0330 Branch -76.77816 42.935044
0331 Branch -75.844869 43.153628
0332 Offsite -73.7914 42.9025
0334 Branch -78.324878 40.311088
0336 Branch -76.4647 41.7582
0338 Branch -78.388532 43.321107
0339 Branch -76.65941 38.71599
0340 Branch -78.183576 43.094141
0341 Branch -76.136663 43.126701
0343 Branch -78.083301 42.659071
0345 Branch -78.271425 43.066454
;
run;

proc sort data=sample_atms;
by y1 x1;
run;


data atm_view1 / view=atm_view1;
set sample_atms( where=( x1 ne . or y1 ne .));
keep id1 x1 y1 group;
run;

data atm_view2 / view=atm_view2;
set sample_atms( where=( (x1 ne . or y1 ne .) and group ne 'Offsite') );
rename id1=id2 x1=x2 y1=y2;
keep id1 x1 y1 ;
run;



data Closest_ATMs;
	length best_id $ 8 best_distance 8;
	*define the variables for hash objects, line only executes at compilation;
	if 0 then set atm_view2 ;

	*at beginning of execution, load atm_view into hash and also define the iterator;
	if _N_ eq 1 then do;
		dcl hash h(dataset: "atm_view2",ordered:'a');
		h.definekey('x2','y2');
		h.definedata(all: 'yes');
		h.definedone();
	    
		dcl hiter hi('h');
	end;

	*load the atm_data for which we want to find the nearest atm and calculate the distance;
	set atm_view1;

	best_distance = 999999; *initialize best distance to a large value;
	best_id=''; *initialize best match ID;

	rc=hi.first();

	rc1=0;
	do while (rc1=0);
		current = geodist(y1,x1,y2,x2,'DM');
		if current lt best_distance and id1 ne id2 and (x1 ne x2 and y1 ne y2) then do; 
		*do not set best_distance to be distance to self or to a co-located ATM;
		    best_distance = current; 
			best_id = id2;
		end;
		rc1=hi.next();
	end;

	keep id1 group best_id best_distance;
run;

*this is all hash, except for4 writign the table;
data Closest_ATM1;
	*define the variables for hash objects, line only executes at compilation;
	if 0 then set atm_view1 atm_view2 ;
	*define variables to store best distance and associated ATM ID;
	length best_id $ 8 best_distance 8;

	*at beginning of execution, load atm_views with dasta into hash objects and also define their iterators;
	if _N_ eq 1 then do;
		dcl hash list(dataset: "atm_view1");
		list.definekey('y1','x1');
		list.definedata(all: 'yes');
		list.definedone();
		dcl hiter hi_list('list');

		dcl hash lookup(dataset: "atm_view2");
		lookup.definekey('y2','x2');
		lookup.definedata(all: 'yes');
		lookup.definedone();
		dcl hiter hi_lookup('lookup');
	end;

	*load the atm_data for which we want to find the nearest atm and calculate the distance;
	rc=hi_list.first();
	do while (rc=0);
		best_distance = 999999; *initialize best distance to a large value;
		best_id=''; *initialize best match ID;

		rc=hi_lookup.first();
		rc1=0;
		do while (rc1=0);
			current = geodist(y1,x1,y2,x2,'DM');
			if current lt best_distance and id1 ne id2 and (x1 ne x2 and y1 ne y2) then do; 
			*do not set best_distance to be distance to self or to a co-located ATM;
			    best_distance = current; 
				best_id = id2;
			end;
			rc1=hi_lookup.next();
		end;
		output;
		rc=hi_list.next();
	end;

	keep id1 group best_id best_distance;
run;
