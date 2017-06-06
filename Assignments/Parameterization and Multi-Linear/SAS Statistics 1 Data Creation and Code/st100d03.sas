proc format;

value $MS_SubClass

       "020"="1-STORY 1946 AND NEWER ALL STYLES"
       "030"="1-STORY 1945 AND OLDER"
       "040"="1-STORY W/FINISHED ATTIC ALL AGES"
       "045"="1-1/2 STORY - UNFINISHED ALL AGES"
       "050"="1-1/2 STORY FINISHED ALL AGES"
       "060"="2-STORY 1946 AND NEWER"
       "070"="2-STORY 1945 AND OLDER"
       "075"="2-1/2 STORY ALL AGES"
       "080"="SPLIT OR MULTI-LEVEL"
       "085"="SPLIT FOYER"
       "090"="DUPLEX - ALL STYLES AND AGES"
       "120"="1-STORY PUD (Planned Unit Development) - 1946 AND NEWER"
       "150"="1-1/2 STORY PUD - ALL AGES"
       "160"="2-STORY PUD - 1946 AND NEWER"
       "180"="PUD - MULTILEVEL - INCL SPLIT LEV/FOYER"
       "190"="2 FAMILY CONVERSION - ALL STYLES AND AGES"
       ;

value $MS_Zoning
       "A"="Agriculture"
       "C"="Commercial"
       "FV"="Floating Village Residential"
       "I"="Industrial"
       "RH"="Residential High Density"
       "RL"="Residential Low Density"
       "RP"="Residential Low Density Park"
       "RM"="Residential Medium Density"
       ;

value $Street
       "Grvl"="Gravel"
       "Pave"="Paved"
       ;

value $Alley

       "Grvl"="Gravel"
       "Pave"="Paved"
       "NA "="No alley access"
       ;

value $Lot_Shape

       "Reg"="Regular"
       "IR1"="Slightly irregular"
       "IR2"="Moderately Irregular"
       "IR3"="Irregular"
       ;

value $Land_Contour

       "Lvl"="Near Flat/Level"
       "Bnk"="Banked - Quick and significant rise from street grade to building"
       "HLS"="Hillside - Significant slope from side to side"
       "Low"="Depression"
       ;

value $Utilities

       "AllPub"="All public Utilities (E,G,W,AND S)"
       "NoSewr"="Electricity, Gas, and Water (Septic Tank)"
       "NoSeWa"="Electricity and Gas Only"
       "ELO"="Electricity only"
       ;

value $Lot_Config

       "Inside"="Inside lot"
       "Corner"="Corner lot"
       "CulDSac"="Cul-de-sac"
       "FR2"="Frontage on 2 sides of property"
       "FR3"="Frontage on 3 sides of property"
       ;

value $Land_Slope

       "Gtl"="Gentle slope"
       "Mod"="Moderate Slope"
       "Sev"="Severe Slope"
       ;

value $Neighborhood

       "Blmngtn"="Bloomington Heights"
       "Blueste"="Bluestem"
       "BrDale"="Briardale"
       "BrkSide"="Brookside"
       "ClearCr"="Clear Creek"
       "CollgCr"="College Creek"
       "Crawfor"="Crawford"
       "Edwards"="Edwards"
       "Gilbert"="Gilbert"
       "Greens"="Greens"
       "GrnHill"="Green Hills"
       "IDOTRR"="Iowa DOT and Rail Road"
       "Landmrk"="Landmark"
       "MeadowV"="Meadow Village"
       "Mitchel"="Mitchell"
       "Names"="North Ames"
       "NoRidge"="Northridge"
       "NPkVill"="Northpark Villa"
       "NridgHt"="Northridge Heights"
       "NWAmes"="Northwest Ames"
       "OldTown"="Old Town"
       "SWISU"="South AND West of Iowa State University"
       "Sawyer"="Sawyer"
       "SawyerW"="Sawyer West"
       "Somerst"="Somerset"
       "StoneBr"="Stone Brook"
       "Timber"="Timberland"
       "Veenker"="Veenker"
       ;

value $Condition

       "Artery"="Adjacent to arterial street"
       "Feedr"="Adjacent to feeder street"
       "Norm"="Normal"
       "RRNn"="Within 200' of North-South Railroad"
       "RRAn"="Adjacent to North-South Railroad"
       "PosN"="Near positive off-site feature--park, greenbelt, etc."
       "PosA"="Adjacent to postive off-site feature"
       "RRNe"="Within 200' of East-West Railroad"
       "RRAe"="Adjacent to East-West Railroad"
       ;

value $Bldg_Type

       "1Fam"="Single-family Detached"
       "2FmCon"="Two-family Conversion; originally built as one-family dwelling"
       "Duplx"="Duplex"
       "TwnhsE"="Townhouse End Unit"
       "TwnhsI"="Townhouse Inside Unit"
       ;

value $House_Style

       "1Story"="One story"
       "1.5Fin"="One and one-half story: 2nd level finished"
       "1.5Unf"="One and one-half story: 2nd level unfinished"
       "2Story"="Two story"
       "2.5Fin"="Two and one-half story: 2nd level finished"
       "2.5Unf"="Two and one-half story: 2nd level unfinished"
       "SFoyer"="Split Foyer"
       "SLvl"="Split Level"
       ;

value Overall

       10="10 Very Excellent"
       9="09 Excellent"
       8="08 Very Good"
       7="07 Good"
       6="06 Above Average"
       5="05 Average"
       4="04 Below Average"
       3="03 Fair"
       2="02 Poor"
       1="01 Very Poor"
       ;

value $Roof_Style

       "Flat"="Flat"
       "Gable"="Gable"
       "Gambrel"="Gabrel (Barn)"
       "Hip"="Hip"
       "Mansard"="Mansard"
       "Shed"="Shed"
       ;

value $Roof_Matl

       "ClyTile"="Clay or Tile"
       "CompShg"="Standard (Composite) Shingle"
       "Membran"="Membrane"
       "Metal"="Metal"
       "Roll"="Roll"
       "TarANDGrv"="Gravel AND Tar"
       "WdShake"="Wood Shakes"
       "WdShngl"="Wood Shingles"
       ;

value $Exterior

       "AsbShng"="Asbestos Shingles"
       "AsphShn"="Asphalt Shingles"
       "BrkComm"="Brick Common"
       "BrkFace"="Brick Face"
       "CBlock"="Cinder Block"
       "CemntBd"="Cement Board"
       "HdBoard"="Hard Board"
       "ImStucc"="Imitation Stucco"
       "MetalSd"="Metal Siding"
       "Other"="Other"
       "Plywood"="Plywood"
       "PreCast"="PreCast"
       "Stone"="Stone"
       "Stucco"="Stucco"
       "VinylSd"="Vinyl Siding"
       "Wd Sdng"="Wood Siding"
       "WdShing"="Wood Shingles"
       ;

value $Mas_Vnr_Type

       "BrkCmn"="Brick Common"
       "BrkFace"="Brick Face"
       "CBlock"="Cinder Block"
       "None"="None"
       "Stone"="Stone"
       ;

value $Exter_Qual 

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Average/Typical"
       "Fa"="Fair"
       "Po"="Poor"
       ;

value $Exter_Cond

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Average/Typical"
       "Fa"="Fair"
       "Po"="Poor"
       ;

value $Foundation

       "BrkTil"="Brick AND Tile"
       "CBlock"="Cinder Block"
       "PConc"="Poured Contrete"
       "Slab"="Slab"
       "Stone"="Stone"
       "Wood"="Wood"
       ;

value $Bsmt_Qual

       "Ex"="Excellent (100+ inches)"
       "Gd"="Good (90-99 inches)"
       "TA"="Typical (80-89 inches)"
       "Fa"="Fair (70-79 inches)"
       "Po"="Poor (<70 inches"
       "NA"="No Basement"
       ;

value $Bsmt_Cond

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Typical - slight dampness allowed"
       "Fa"="Fair - dampness or some cracking or settling"
       "Po"="Poor - Severe cracking, settling, or wetness"
       "NA"="No Basement"
       ;

value $Bsmt_Exposure

       "Gd"="Good Exposure"
       "Av"="Average Exposure (split levels or foyers typically score average or above)"
       "Mn"="Mimimum Exposure"
       "No"="No Exposure"
       "NA"="No Basement"
       ;

value $BsmtFinType

       "GLQ"="Good Living Quarters"
       "ALQ"="Average Living Quarters"
       "BLQ"="Below Average Living Quarters"
       "Rec"="Average Rec Room"
       "LwQ"="Low Quality"
       "Unf"="Unfinshed"
       "NA"="No Basement"
       ;

value $Heating

       "Floor"="Floor Furnace"
       "GasA"="Gas forced warm air furnace"
       "GasW"="Gas hot water or steam heat"
       "Grav"="Gravity furnace"
       "OthW"="Hot water or steam heat other than gas"
       "Wall"="Wall furnace"
       ;

value $Heating_QC

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Average/Typical"
       "Fa"="Fair"
       "Po"="Poor"
       ;

value $NoYes

       "N"="No"
       "Y"="Yes"
       ;

value $Electrical

       "SBrkr"="Standard Circuit Breakers AND Romex"
       "FuseA"="Fuse Box over 60 AMP and all Romex wiring (Average)"
       "FuseF"="60 AMP Fuse Box and mostly Romex wiring (Fair)"
       "FuseP"="60 AMP Fuse Box and mostly knob AND tube wiring (poor)"
       "Mix"="Mixed"
       ;

value $KitchenQual

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Typical/Average"
       "Fa"="Fair"
       "Po"="Poor"
       ;

value $Functional

       "Typ"="Typical Functionality"
       "Min1"="Minor Deductions 1"
       "Min2"="Minor Deductions 2"
       "Mod"="Moderate Deductions"
       "Maj1"="Major Deductions 1"
       "Maj2"="Major Deductions 2"
       "Sev"="Severely Damaged"
       "Sal"="Salvage only"
       ;

value $FireplaceQu

       "Ex"="Excellent - Exceptional Masonry Fireplace"
       "Gd"="Good - Masonry Fireplace in main level"
       "TA"="Average - Prefabricated Fireplace in main living area or Masonry Fireplace in basement"
       "Fa"="Fair - Prefabricated Fireplace in basement"
       "Po"="Poor - Ben Franklin Stove"
       "NA"="No Fireplace"
       ;

value $Garage_Type

       "2Types"="More than one type of garage"
       "Attchd"="Attached to home"
       "Basment"="Basement Garage"
       "BuiltIn"="Built-In (Garage part of house - typically has room above garage)"
       "CarPort"="Car Port"
       "Detchd"="Detached from home"
       "NA"="No Garage"
       ;

value $Garage_Finish

       "Fin"="Finished"
       "RFn"="Rough Finished"
       "Unf"="Unfinished"
       "NA"="No Garage"
       ;

value $Garage_Qual

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Typical/Average"
       "Fa"="Fair"
       "Po"="Poor"
       "NA"="No Garage"
       ;

value $Garage_Cond

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Typical/Average"
       "Fa"="Fair"
       "Po"="Poor"
       "NA"="No Garage"
       ;

value $Paved_Drive

       "Y"="Paved "
       "P"="Partial Pavement"
       "N"="Dirt/Gravel";
    
value $Value_Pool_QC

       "Ex"="Excellent"
       "Gd"="Good"
       "TA"="Average/Typical"
       "Fa"="Fair"
       "NA"="No Pool";

value $Value_Fence

       "GdPrv"="Good Privacy"
       "MnPrv"="Minimum Privacy"
       "GdWo"="Good Wood"
       "MnWw"="Minimum Wood/Wire"
       "NA"="No Fence"
       ;

value $Misc_Feature

       "Elev"="Elevator"
       "Gar2"="2nd Garage (if not described in garage section)"
       "Othr"="Other"
       "Shed"="Shed (over 100 SF)"
       "TenC"="Tennis Court"
       "NA"="None"
       ;

value $Sale_Type

       "WD "="Warranty Deed - Conventional"
       "CWD"="Warranty Deed - Cash"
       "VWD"="Warranty Deed - VA Loan"
       "New"="Home just constructed and sold"
       "COD"="Court Officer Deed/Estate"
       "Con"="Contract 15% Down payment regular terms"
       "ConLw"="Contract Low Down payment and low interest"
       "ConLI"="Contract Low Interest"
       "ConLD"="Contract Low Down"
       "Oth"="Other"
       ;

value $Sale_Condition

       "Normal"="Normal Sale"
       "Abnorml"="Abnormal Sale - trade, foreclosure, short sale"
       "AdjLand"="Adjoining Land Purchase"
       "Alloca"="Allocation - two linked properties with separate deeds, typically condo with a garage unit"
       "Family"="Sale between family members"
       "Partial"="Home was not completed when last assessed (associated with New Homes)"
       ;

value season 
       1="Winter"
       2="Spring"
       3="Summer"
       4="Fall"
       ;
run;
