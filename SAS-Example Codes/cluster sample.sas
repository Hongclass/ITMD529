title 'Cluster Analysis of Fisher (1936) Iris Data';
      proc format;
         value specname
            1='Setosa    '
            2='Versicolor'
            3='Virginica ';
      run;
   
   data iris;
      input SepalLength SepalWidth PetalLength PetalWidth Species @@;
      format Species specname.;
      label SepalLength='Sepal Length in mm.'
            SepalWidth ='Sepal Width in mm.'
            PetalLength='Petal Length in mm.'
            PetalWidth ='Petal Width in mm.';
      symbol = put(species, specname10.);
      datalines;
   50 33 14 02 1 64 28 56 22 3 65 28 46 15 2 67 31 56 24 3
   63 28 51 15 3 46 34 14 03 1 69 31 51 23 3 62 22 45 15 2
   59 32 48 18 2 46 36 10 02 1 61 30 46 14 2 60 27 51 16 2
   65 30 52 20 3 56 25 39 11 2 65 30 55 18 3 58 27 51 19 3
   68 32 59 23 3 51 33 17 05 1 57 28 45 13 2 62 34 54 23 3
   77 38 67 22 3 63 33 47 16 2 67 33 57 25 3 76 30 66 21 3
   49 25 45 17 3 55 35 13 02 1 67 30 52 23 3 70 32 47 14 2
   64 32 45 15 2 61 28 40 13 2 48 31 16 02 1 59 30 51 18 3
   55 24 38 11 2 63 25 50 19 3 64 32 53 23 3 52 34 14 02 1
   49 36 14 01 1 54 30 45 15 2 79 38 64 20 3 44 32 13 02 1
   67 33 57 21 3 50 35 16 06 1 58 26 40 12 2 44 30 13 02 1
   77 28 67 20 3 63 27 49 18 3 47 32 16 02 1 55 26 44 12 2
   50 23 33 10 2 72 32 60 18 3 48 30 14 03 1 51 38 16 02 1
   61 30 49 18 3 48 34 19 02 1 50 30 16 02 1 50 32 12 02 1
   61 26 56 14 3 64 28 56 21 3 43 30 11 01 1 58 40 12 02 1
   51 38 19 04 1 67 31 44 14 2 62 28 48 18 3 49 30 14 02 1
   51 35 14 02 1 56 30 45 15 2 58 27 41 10 2 50 34 16 04 1
   46 32 14 02 1 60 29 45 15 2 57 26 35 10 2 57 44 15 04 1
   50 36 14 02 1 77 30 61 23 3 63 34 56 24 3 58 27 51 19 3
   57 29 42 13 2 72 30 58 16 3 54 34 15 04 1 52 41 15 01 1
   71 30 59 21 3 64 31 55 18 3 60 30 48 18 3 63 29 56 18 3
   49 24 33 10 2 56 27 42 13 2 57 30 42 12 2 55 42 14 02 1
   49 31 15 02 1 77 26 69 23 3 60 22 50 15 3 54 39 17 04 1
   66 29 46 13 2 52 27 39 14 2 60 34 45 16 2 50 34 15 02 1
   44 29 14 02 1 50 20 35 10 2 55 24 37 10 2 58 27 39 12 2
   47 32 13 02 1 46 31 15 02 1 69 32 57 23 3 62 29 43 13 2
   74 28 61 19 3 59 30 42 15 2 51 34 15 02 1 50 35 13 03 1
   56 28 49 20 3 60 22 40 10 2 73 29 63 18 3 67 25 58 18 3
   49 31 15 01 1 67 31 47 15 2 63 23 44 13 2 54 37 15 02 1
   56 30 41 13 2 63 25 49 15 2 61 28 47 12 2 64 29 43 13 2
   51 25 30 11 2 57 28 41 13 2 65 30 58 22 3 69 31 54 21 3
   54 39 13 04 1 51 35 14 03 1 72 36 61 25 3 65 32 51 20 3
   61 29 47 14 2 56 29 36 13 2 69 31 49 15 2 64 27 53 19 3
   68 30 55 21 3 55 25 40 13 2 48 34 16 02 1 48 30 14 01 1
   45 23 13 03 1 57 25 50 20 3 57 38 17 03 1 51 38 15 03 1
   55 23 40 13 2 66 30 44 14 2 68 28 48 14 2 54 34 17 02 1
   51 37 15 04 1 52 35 15 02 1 58 28 51 24 3 67 30 50 17 2
   63 33 60 25 3 53 37 15 02 1
   ;
   run;

ods graphics on ;   
   proc cluster data=iris method=ward print=15 ccc pseudo;
      var petal: sepal:;
      copy species;
   run;
   
   proc tree noprint ncl=3 out=out;
      copy petal: sepal: species;
   run;
%show

      %macro show;
      proc freq;
         tables cluster*species / nopercent norow nocol plot=none;
      run;
      proc candisc  out=can;
         class cluster;
         var petal: sepal:;
      run;
      proc sgplot data=can ;
         scatter y=can2 x=can1 / group=cluster ;
      run;
   %mend;



   title2 'By Two-Stage Density Linkage';
   ods graphics on ;   
   proc cluster data=iris method=twostage k=8 print=15 ccc pseudo;
      var petal: sepal:;
      copy species;
   run;
   
   proc tree noprint ncl=3 out=out;
      copy petal: sepal: species;
   run;
   
   %show;


   *#############################################################################################;
proc contents data=data.main_201206 varnum short;
run;


data tran_cluster;
set data.main_201206;
where dda = 1;
keep VPOS_AMT vpos_num mpos_amt mpos_num ATMO_AMT ATMO_NUM ATMT_AMT ATMT_NUM web_signon BP_NUM BP_AMT BR_TR_NUM BR_TR_amt 
     VRU_NUM SMS_NUM WAP_NUM fico_num fworks_num chk_num ;
run;

data tran_sample;
set tran_cluster;
ATM_num = ATMT_num + ATMO_num;
ATM_AMT = ATMO_AMT + atmt_amt;
debit = vpos_num + mpos_num;
debit_amt = vpos_amt + mpos_amt;
if mod(_n_,500) eq 34 then output;
run;


/*proc surveyselect data = hsb25 method = SRS rep = 1 */
/*                         sampsize = 10 seed = 12345 out = hsbs1;*/
/*  id _all_;*/
/*run;*/


proc standard data=tran_sample out=tran_std mean=0 std=1 replace;
   var _ALL_ ;
run;

proc fastclus data=tran_std out=Clust
                 maxclusters=3 maxiter=10000 ;
      var ATM_amt debit_amt bp_amt;
run;

proc fastclus data=tran_sample out=Clust1
                 maxclusters=7 maxiter=10000 ;
      var ATM_amt debit_amt bp_amt;
run;

proc sort data=clust1;
by cluster;
run;

title;

data chartdata;
length color $ 10;
set clust1;
select (cluster);
	when (1) color='red';
	when (2) color = 'blue';
	when (3) color= 'green';
	when (4) color= 'black';
	when (5) color='yellow';
	when (6) color='grey';
	when(7) color = 'purple';
end;
keep cluster color atm_amt bp_amt debit_amt;
run;
	

proc g3d data=chartdata (where=(cluster in(3,4,6,7)));
scatter atm_amt*debit_amt=bp_amt / noneedle color=color;
run;

proc candisc data=chartdata ncan=3 out=data1;
   class cluster;
   var atm_amt bp_amt debit_amt;
run;

proc g3d data=data1;
scatter can1*can2=can3/ noneedle color=color;
run;

proc tabulate data=data1;
var atm_amt bp_amt debit_amt;
class cluster;
table cluster, N sum*(atm_amt bp_amt debit_amt) mean*(atm_amt bp_amt debit_amt) / nocellmerge;
run;

proc candisc data=chartdata ncan=2 out=data2;
   class cluster;
   var atm_amt bp_amt debit_amt;
run;


proc sgplot  data=data2;
scatter x=can1 y=can2 /group=cluster;
run;



proc gplot data= tran_std;
plot chk_num * debit;
run;

proc cluster data=tran_std method=ward ccc pseudo print=15 out=tree
   plots=den(height=rsq);
   var Atm_num debit chk_num;
run;

*seems like it may work, I need some guidance and I need the checks, as it is mostly splitting by overal spend, but it does seem to identify people who 
do bpay to those who do not, I wonder if the checks muddle it up or clarify it;




proc cluster data=tran_sample method=ward  print=15 ccc pseudo;
   var Atm_num debit chk_num;
   copy Atm_num debit chk_num;
run;

proc candisc data=data1 noprint out=can;
      class cluster;
      var Atm_num debit chk_num;
   run;

   proc sgplot data=can;
      scatter y=can2 x=can1 / group=cluster;
   run;
*how do you interpet the resulkts from cluster;
