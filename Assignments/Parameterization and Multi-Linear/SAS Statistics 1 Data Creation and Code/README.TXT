The programs in this folder are for the class on Statistics 1: Introduction to ANOVA, Regression, and Logistic Regression.

The files st100d01.sas through st100d05.sas should be located in one folder or directory.  They contain the SAS DATA step code to create all SAS data sets and formats used in the the course for the demonstations, exercises, and all examples in the appendices.  Take note of the location of these files.  Copy and paste that location after the "=" sign in the statement "%let homefolder=" in the file, st100d05.sas.

Submit the file st100d05.sas, which will request the submission of the code in st100d01.sas through st100d04.sas.  All of the SAS data sets created will be written to and stored in the STAT1 library.
ST100d01.sas creates the SAS data set AmesHousing, described below.
ST100d02.sas creates AmesHousing2 through Ameshousing4.
ST100d03.sas creates SAS formats for use with the AmesHousing data sets.
ST100d04.sas creates all SAS data sets and SAS formats for the exercises and appendix examples in the course.

The data for the instructional demonstrations in this course were collected by Dr. Dean DeCock, of Truman State University in Kirksville, Missouri, USA. The full description of the data set is provided in the Journal of Statistics Education. The data set contains information about the sale of individual residential property in Ames, Iowa, from 2006 to 2010.

The data set AmesHousing contains all original data from Dr. DeCock, including 2,930 observations and a large number of explanatory variables involved in assessing home values. In addition, some summary variables were calculated, as well as a variable calculated as the natural log of the sale price of the home.
The data set AmesHousing2 is a subset of the full data set, for homes with normal sales conditions (to avoid analyzing foreclosure or distressed sales) and gross living area of 1,500 square feet or less (to focus on homes of modest size).
The data set AmesHousing3 is a random sample of 300 houses, which will be used for all of the demonstrations in the course.
The data set AmesHousing4 is a random sample of 300 houses, which will be used for demonstrations that require a validation data set.
AmesHousing3 and AmesHousing4 are disjoint samples from AmesHousing2.

The demonstration programs, solutions to the exercises, and the appendix programs are also provided.
                                                                                                                                                    
 ** For more information about your course data, contact your SAS Instructor. **

 =============================================================================

 Copyright (c) 2015 SAS Institute Inc.                                       
 Cary, N.C. USA 27513-8000                                                    
 all rights reserved                                                          
                                                                              
 THE INFORMATION CONTAINED IN THIS DISTRIBUTION IS PROVIDED BY THE INSTITUTE      
 "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING 
 BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
 A PARTICULAR PURPOSE.  RECIPIENTS ACKNOWLEDGE AND AGREE THAT THE INSTITUTE   
 SHALL NOT BE LIABLE WHATSOEVER FOR ANY DAMAGES ARISING OUT OF THEIR USE OF   
 THIS INFORMATION.                                                            
                                                                            
