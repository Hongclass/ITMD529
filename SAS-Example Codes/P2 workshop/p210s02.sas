title 'Detail Information for Ordered Products and Quantities';
proc sql;
  select Order_ID, o.Product_ID, Product_Name, Quantity
    from orion.order_fact as o, orion.product_dim as p
    where o.Product_ID=p.Product_ID;
quit;
title;

  /* Alternate solution: */

title 'Detail Information for Ordered Products and Quantities';
proc sql;
  select Order_ID, o.Product_ID, Product_Name, Quantity
    from orion.order_fact as o
      INNER JOIN
    orion.product_dim as p
    on o.Product_ID=p.Product_ID;
quit;
title;
