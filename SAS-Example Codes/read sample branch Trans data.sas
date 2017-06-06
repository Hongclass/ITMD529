data data.Br_trans_201206;
length hhid $ 9 ;
infile 'C:\Documents and Settings\ewnym5s\My Documents\Data\qtrans.txt' dsd dlm='09'x lrecl=4096 firstobs=2 obs=max;
input hhid $ branch lobby_svg_with_nbr lobby_loc_adv_nbr lobby_dep_nocash_nbr lobby_dep_cash_nbr 
                    lobby_svg_with_amt lobby_loc_adv_amt lobby_dep_nocash_amt 
					drive_svg_with_nbr drive_dep_nocash_nbr drive_dep_cash_nbr
					drive_svg_with_amt drive_dep_nocash_amt 
					night_dep_nocash_nbr night_dep_cash_nbr
					night_dep_nocash_amt ;
run;

data data.ATMO_trans_201206;
length hhid $ 9 a $ 30 b $ 30 c $ 30 d $ 30 e $ 30;
infile 'C:\Documents and Settings\ewnym5s\My Documents\Data\qatmo.txt' dsd dlm='09'x lrecl=4096 firstobs=2 obs=max;
input  hhid $ a $ b $ ptype $ c $ card_type $ d $ channel $ wsid $ type $ count amt e $ branch;
drop a b c d e;
run;

