
proc template; 

   define style styles.MTB;
   parent=styles.LISTING;

/*   class GraphDataDefault / */
/*   endColor = CXDD6060*/
/*   neutralColor = CXFFFFFF*/
/*   startColor = CX6497EB*/
/*     lineStyle = 1*/
/*     lineThickness = 1px*/
/*     markerSize = 7px*/
/*     markerSymbol = "circle"*/
/*   color = CXFFC000*/
/*   contrastColor = CX000000;*/

   class GraphData1 / 
     lineStyle = 1
     markerSymbol = "circle"
   color = CXFFC000
   contrastColor = CX000000;

   class GraphData2 / 
     lineStyle = 4
     markerSymbol = "plus"
   color = CX007850
   contrastColor = CX000000;

   class GraphData3 / 
     lineStyle = 8
     markerSymbol = "X"
   color = CX92D050
   contrastColor = CX000000;

   class GraphData4 / 
     lineStyle = 5
     markerSymbol = "triangle"
   color = CX86499D
   contrastColor = CX000000;
end;
run;
