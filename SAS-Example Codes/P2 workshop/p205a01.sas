   /* Find and correct the syntax error */

data shoes;
  set orion.product_list;
  if substr(right(Product_Name,33,13))=
      'Running Shoes';
run;

   /* After you've corrected the syntax error and if there's time,
      read on to find out why the arguments 33 and 13 were used

      This program intends to keep only the observations
      with "Running Shoes" as the last part of the 
      Product_Name.   Product_name is 45 character long,
      and "Running Shoes" shoes is 13 characters.  So the
      program needs to check last 13 character in the right 
      justified Product_Name.  This works out to a starting 
      position of 33 in the SUBSTR function 

      An easy way to think through the starting position value 
      is to consider that the arguments would be 45 and 1 to get 
      the last character, 44 and 2 to get the last 2 characters,...,
      and 33 and 13 to get the last 13 characters. */


