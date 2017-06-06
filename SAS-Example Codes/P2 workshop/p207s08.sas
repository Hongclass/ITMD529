data passed failed; 
    set orion.test_answers;   
	drop i;

   array Response{10} Q1-Q10;   
   array Answer{10} $ 1 _temporary_ ('A','C','C','B','E',
                                    'E','D','B','B','A');
   Score=0;
   do i=1 to 10;
      if Answer{i}=Response{i} then Score+1;
   end; 
   if Score ge 7 then output passed;
   else output failed;
run;

title 'Passed';
proc print data=passed;
run;
title;

title 'Failed';
proc print data=failed;
run;
title;
