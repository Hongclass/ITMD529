proc sql;
  select Product_Name, Supplier_Country,  Start_Date
    from orion.discount as d, orion.product_dim as p
    where d.Product_ID=p.Product_ID;
quit;
