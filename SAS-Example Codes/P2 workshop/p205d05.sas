data Scan_Quiz;
  Text = "New Year's Day, January 1st, 2007"; 
  Year1 = scan(Text,-1);
  Year2 = scan(Text,6);
  Year3 = scan(Text,6,', ');
run;

proc print data=Scan_Quiz;
run;
