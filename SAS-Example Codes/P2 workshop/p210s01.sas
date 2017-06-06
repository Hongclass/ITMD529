proc sql;
  select d.Product_ID, Product_Name, Start_Date, End_Date, Discount
    from orion.discount as d, orion.product_dim as p
    where d.Product_ID=p.Product_ID and Discount >= .6;
quit;
