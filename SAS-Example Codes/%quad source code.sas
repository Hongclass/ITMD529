%macro quad(source=,dest=,vars=);

     %let nvars = %sysfunc(countw(&vars));
     %let nvars1 = %eval((&nvars**2+&nvars)/2);

	 data &dest;
	 set &source;
	 array vars{&nvars} &vars;
	 array new{&nvars1};
     k=1;
	 do i = 1 to &nvars ;
	 	do j = i to &nvars;
			new(k) = vars{i}*vars{j};
			call symputx(vname(new(k)),cats(vname(vars(i)),"_",vname(vars(j))));
			k+1;
		end;
	 end;
     drop i j k;
     run;

	 proc datasets ;
	 modify &dest;
	 	 
		%let k = 1;
		rename
		%do i = 1 %to &nvars;
		    %do j = &i %to &nvars;
			  new&k = &&new&k  
			  %let k = %eval(&k+1);
			%end;
		%end;
		;
	run;
	
%mend quad;
