proc template;
     define style mtb;
     parent=STYLES.PRINTER;
	 style Body from Document / background=cx000000 BACKGROUNDCOLOR= cx000000 ;
	 style graphdata0 from graphdata1 / color=cx007856 contrastcolor=black;
     style graphdata1 from graphdata1 / color=cx007856 contrastcolor=black;
     style graphdata2 from graphdata2 / color=cx7AB800 contrastcolor=black;
	 style graphdata3 from graphdata2 / color=cxFFB300 contrastcolor=black;
	 style graphdata4 from graphdata2 / color=cx86499D contrastcolor=black;
	 style graphdata5 from graphdata2 / color=cx003359 contrastcolor=black;
	 style graphdata6 from graphdata2 / color=cxAFAAA3 contrastcolor=black;
     end;
   run;
   ods html style=mtb;
   

proc template;
  edit styles.mtb as style.mtb;
      style fonts /
         'TitleFont' = ('Arial, Helvetica, Helv',5,Bold)
         'headingFont' = ('Arial, Helvetica, Helv',4,Bold)
         'docFont' = ('Arial, Helvetica, Helv',3);

 end;
run;
 color=cx007856;
 color=cx7AB800;
 color=cxFFB300;
 color=cx86499D;
 color=cx003359;
 color=cxAFAAA3;



 proc template;
     define style mtbnew;
     parent=styles.printer;
	 style graphdatadefault  / color=cx007856 contrastcolor=black;
     style graphdata1 from graphdata1 / color=cx007856 contrastcolor=black;
     style graphdata2 from graphdata2 / color=cxC3E76F contrastcolor=black;
	 style graphdata3 from graphdata3 / color=cxFFB300 contrastcolor=black;
	 style graphdata4 from graphdata4 / color=cx86499D contrastcolor=black;
	 style graphdata5 from graphdata5 / color=cx003359 contrastcolor=black;
	 style graphdata6 from graphdata6 / color=cxAFAAA3 contrastcolor=black;
	 style graphdata7 from graphdata7 / color=cx7AB800 contrastcolor=black;
	 style graphdata8 from graphdata8 / color=cx23A491 contrastcolor=black;
	 style graphdata9 from graphdata9 / color=cx144629 contrastcolor=black;
	  style graphdata10 from graphdata10 / color=cxFFFFFF contrastcolor=black;

	 style fonts /
      'TitleFont2' = ('Arial, Helvetica, Helv',12pt,bold italic)
      'TitleFont' = ('Arial, Helvetica, Helv',13pt,bold italic)
      'StrongFont' = ('Arial, Helvetica, Helv',10pt,bold)
      'EmphasisFont' = ('Arial, Helvetica, Helv',10pt,italic)
      'FixedEmphasisFont' = ('Arial, Helvetica, Helv',9pt,italic)
      'FixedStrongFont' = ('Arial, Helvetica, Helv',9pt,bold)
      'FixedHeadingFont' = ('Arial, Helvetica, Helv',9pt,bold)
      'BatchFixedFont' = ("SAS Monospace, <MTmonospace>, Courier",6.7pt)
      'FixedFont' = ('Arial, Helvetica, Helv',9pt)
      'headingEmphasisFont' = ('Arial, Helvetica, Helv',11pt,bold italic)
      'headingFont' = ('Arial, Helvetica, Helv',11pt,bold)
      'docFont' = ('Arial, Helvetica, Helv',10pt);
   style GraphFonts /
      'GraphDataFont' = ('Arial, Helvetica, Helv',7pt)
      'GraphUnicodeFont' = ('Arial, Helvetica, Helv',9pt)
      'GraphValueFont' = ('Arial, Helvetica, Helv',9pt)
      'GraphLabel2Font' = ('Arial, Helvetica, Helv',10pt)
      'GraphLabelFont' = ('Arial, Helvetica, Helv',10pt)
      'GraphFootnoteFont' = ('Arial, Helvetica, Helv',10pt)
      'GraphTitleFont' = ('Arial, Helvetica, Helv',11pt,bold)
      'GraphTitle1Font' = ('Arial, Helvetica, Helv',14pt,bold)
      'GraphAnnoFont' = ('Arial, Helvetica, Helv',10pt);


	 style header  from header / background=cx007856 foreground=white;
	 style ProcTitle from proctitle / foreground=cx007856 ;
	 style SystemTitle from systemtitle / foreground=cx007856 ;
     
	end;
   run;


   proc template;
     define style mtbhtml;
	     parent=styles.Default;
		style header  from header / background=cx007856 foreground=white;
		 style ProcTitle from proctitle / foreground=cx007856 ;
		 style SystemTitle from systemtitle / foreground=cx007856 ;


     style table from table / BACKGROUND=cx007856 FOREGROUND=white FRAME=BOX RULES=ALL;


	 style graphbackground from graphbackground / color=white;
     style body from body / color=white;
	 style graphwalls from graphwalls / color=white;
      style graphdatadefault  / color=cx007856 contrastcolor=black;
     style graphdata1 from graphdata1 / color=cx007856 contrastcolor=black;
     style graphdata2 from graphdata2 / color=cxC3E76F contrastcolor=black;
	 style graphdata3 from graphdata3 / color=cxFFB300 contrastcolor=black;
	 style graphdata4 from graphdata4 / color=cx86499D contrastcolor=black;
	 style graphdata5 from graphdata5 / color=cx003359 contrastcolor=black;
	 style graphdata6 from graphdata6 / color=cxAFAAA3 contrastcolor=black;
	 style graphdata7 from graphdata7 / color=cx7AB800 contrastcolor=black;
	 style graphdata8 from graphdata8 / color=cx23A491 contrastcolor=black;
	 style graphdata9 from graphdata9 / color=cx144629 contrastcolor=black;
	  style graphdata10 from graphdata10 / color=cxFFFFFF contrastcolor=black;

	 style fonts /
      'TitleFont2' = ('Arial, Helvetica, Helv',12pt,bold italic)
      'TitleFont' = ('Arial, Helvetica, Helv',13pt,bold italic)
      'StrongFont' = ('Arial, Helvetica, Helv',10pt,bold)
      'EmphasisFont' = ('Arial, Helvetica, Helv',10pt,italic)
      'FixedEmphasisFont' = ('Arial, Helvetica, Helv',9pt,italic)
      'FixedStrongFont' = ('Arial, Helvetica, Helv',9pt,bold)
      'FixedHeadingFont' = ('Arial, Helvetica, Helv',9pt,bold)
      'BatchFixedFont' = ("SAS Monospace, <MTmonospace>, Courier",6.7pt)
      'FixedFont' = ('Arial, Helvetica, Helv',9pt)
      'headingEmphasisFont' = ('Arial, Helvetica, Helv',11pt,bold italic)
      'headingFont' = ('Arial, Helvetica, Helv',11pt,bold)
      'docFont' = ('Arial, Helvetica, Helv',10pt);
   style GraphFonts /
      'GraphDataFont' = ('Arial, Helvetica, Helv',7pt)
      'GraphUnicodeFont' = ('Arial, Helvetica, Helv',9pt)
      'GraphValueFont' = ('Arial, Helvetica, Helv',9pt)
      'GraphLabel2Font' = ('Arial, Helvetica, Helv',10pt)
      'GraphLabelFont' = ('Arial, Helvetica, Helv',10pt)
      'GraphFootnoteFont' = ('Arial, Helvetica, Helv',10pt)
      'GraphTitleFont' = ('Arial, Helvetica, Helv',11pt,bold)
      'GraphTitle1Font' = ('Arial, Helvetica, Helv',14pt,bold)
      'GraphAnnoFont' = ('Arial, Helvetica, Helv',10pt);

	end;

filename temp1 'C:\Documents and Settings\ewnym5s\My Documents\Underbanked\temp1.tpl' lrecl=100;
proc template;
   source styles.printer    / file=temp1;

run;
