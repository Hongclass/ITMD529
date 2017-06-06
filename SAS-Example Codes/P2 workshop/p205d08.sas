data find;
   Text='AUSTRALIA, DENMARK, US';
   Pos1=find(Text,'US');
   Pos2=find(Text,' US');
   Pos3=find(Text,'us');
   Pos4=find(Text,'us','I');
   Pos5=find(Text,'us','I',10);
run;

proc print data=find noobs;
run;
