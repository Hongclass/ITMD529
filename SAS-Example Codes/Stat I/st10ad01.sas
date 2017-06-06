/* st10ad01.sas */  /*Part A*/
proc surveyselect
    data= sasuser.Safety  /* sample from data table */
    seed=31475            /* recommended that you use this option */
    method=srs            /* simple random sample */
    sampsize=12           /* sample size */
    out=work.SafetySample /* sample stored in this data set */
;
run;

proc print data=work.SafetySample;
run;

/* st10ad01.sas */  /*Part B*/
proc surveyselect
    data= sasuser.Safety  /* sample from data table */
    seed=31475            /* recommended that you use this option */
    method=srs            /* simple random sample */
    samprate=0.05         /* sample size */
    out=work.SafetySample /* sample stored in this data set */
;
run;

proc print data=work.SafetySample;
run;


