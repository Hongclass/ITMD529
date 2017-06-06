%let d1=fjc.shuini;
%let d2=fjc.xiaoliang;
%let c1=x1 x2 x3 x4 x5;
%let c2=y x1 x2 x3 x4;



%macro driver;
%do i=1 %to 2;
proc iml;
use &&d&i;
read all into mymatrix;
y=mymatrix;
print y;
n=nrow(y);
p=ncol(y);
dfchi=p*(p+1)*(p+2)/6;
q=i(n)-(1/n)*j(n,n,1);
s=(1/n)*y`*q*y; s_inv=inv(s);
g_matrix=q*y*s_inv*y`*q;
beta1hat=(sum(g_matrix#g_matrix#g_matrix))/(n*n);
beta2hat=trace(g_matrix#g_matrix)/n;
kappa1=n*beta1hat/6;
kappa2=(beta2hat-p*(p+2))/sqrt(8*p*(p+2)/n);
pvalskew=1-probchi(kappa1,dfchi);
pvalkurt=2*(1-probnorm(abs(kappa2)));
print s;
print s_inv;
print beta1hat kappa1 pvalskew;
print beta2hat kappa2 pvalkurt;
quit;
%end;
%mend;

%driver;




