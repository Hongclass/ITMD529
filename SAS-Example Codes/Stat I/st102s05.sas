/*st102s05.sas*/  /*Part A*/
proc means data=sasuser.concrete
           mean var std nway;
    class Brand Additive;
    var Strength;
    output out=means mean=Strength_Mean;
    title 'Selected Descriptive Statistics for Concrete Data Set';
run;

proc sgplot data=means;
    series x=Additive y=Strength_Mean / group=Brand markers;
    xaxis integer;
    title 'Plot of Stratified Means in Concrete Data Set';
run;


/*Alternative code that will also generate the image.*/
proc sgplot data=sasuser.concrete;
    vline additive / group=brand stat=mean response=strength;
run;


/*st102s05.sas*/  /*Part B*/
proc glm data=sasuser.concrete;
    class Additive Brand;
    model Strength=Additive Brand Additive*Brand;
    title 'Analyze the Effects of Additive and Brand';
    title2 'on Concrete Stength';
run;
quit;

/*st102s05.sas*/  /*Part C*/
ods graphics off;
proc glm data=sasuser.concrete;
    class Additive Brand;
    model Strength=Additive Brand;
    lsmeans Additive;
    title 'Analyze the Effects of Additive and Brand';
    title2 'on Concrete Stength without Interaction';
run;
quit;

ods graphics on;
