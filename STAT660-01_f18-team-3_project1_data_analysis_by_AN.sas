*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding GDP and Literacy of countries in the world.

Dataset Name: COTW_analytic_file created in external file
STAT660-01_f18-team-3_project1_data_preparation.sas, which is assumed to be
in the same directory as this file.

Please see included file for dataset properties ;


* environmental setup;

* set relative file import path to current directory (using standard SAS trick;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT660-01_f18-team-3_project1_data_preparation.sas';


 
 
 
*******************************************************************************; 
 
* 
 
Research Question: What are the top 20 countries with the highest values of  
"Highest GDP"?  
 
Rationale: This should help identify contries with the highest GDP - It 
represents the standard of living of the countries. The higher GDP, the higher 
standard of living seems to be.
 
Methodology: Use PROC MEANS to compute the mean of GDP for countries, and output 
the results to a temporary dataset. Use PROC SORT extract and sort just the means 
the temporary dataset, and use PROC PRINT to print just the first twenty 
observations from the temporary dataset. 
 
Limitations: Missing data for some countries. The methodology does not account 
for countries with missing data, nor does it attempt to validate data in any way,
like filtering for percentages between 0 and 1.
 
Possible Follow-up Steps: More carefully clean the values of the variable GDP 
so that the means computed do not include any possible illegal values. 
 
; 
 
 
 
proc means mean noprint data=COTW_analytic_file; 
    class Country; 
    var GDP; 
    output out=COTW_analytic_file_temp; 
run; 

proc sort data=COTW_analytic_file_temp (where=(_STAT_="MEAN")); 
    by descending GDP; 
run; 
title1 "STAT 660: Team 3 Project 1 AN";
title2 "Top 20 Countries with Highest GDP";
footnote2 "Based on the above output, except for USA at rank 3, the 10 
    countries having the highest GDP are small-sized countries in Europe,
    with Luxembourg ranked no.1.These top 10 highest-GDP countries have the minimum 
    GDP value of 30000(USD)per capita.";
 
proc print data=COTW_analytic_file_temp (obs=20) ; 
    id Country; 
    var GDP; 
run;
title1;
title2;
footnote2;




*******************************************************************************; 
 
* 
 
Research Question: Is there a correlation between GDP and net_migration?
 
Rationale: Identify correlations between GDP and net_migration. 

Methodology: Use PROC CORR can to compute Pearson product-moment correlation  
coefficient between net_migration and GDP, as well as Spearman's rank-order 
correlation, a nonparametric measures of association. PROC CORR also computes 
simple descriptive statistics.   
 
Limitations: Data dictionary is limited. Missing values for some countries.

Possible Follow-up Steps: More carefully clean the values of the variable 
net_migration so that the means computed do not include any possible 
illegal values. 
 
; 

title2 "Correlation Between Net Migration and GDP"; 
footnote2 "Pearson Chi-Sq Test shows p-value <0.001 therefore we could accept  
    Ho and can safely conclude that there is a significant correlation between 
    GDP and net migration ";
proc corr data = COTW_analytic_file PEARSON SPEARMAN; 
    var net_migration GDP ; 
run;
title2;
footnote2; 




*******************************************************************************; 
 
* 
 
Research Question:   What the percentage of the countries with literacy rate of 
50% or less ?  

Rationale: This would help inform the portion of low-literacy countries and the 
overall literacy status of the world. 
 
Methodology: Compute five-number summaries by Literacy rate indicator
variable. Create formats to bin values of Literacy bin, categorize
the variable "Literacy" into 3 groups, "100 percent", "over 50-high" and "under 
50”. And use proc freq to cross-tabulate bins.

Limitations: Data dictionary is limited. Missing values for some countries.

Possible Follow-up Steps: More carefully clean the values of the variable 
net_migration so that the means computed do not include any possible illegal 
values. 
;
 
title2 "Literacy rates by countries";
footnote2 "Quartile Values";
proc means
    min q1 median q3 max
    data= COTW_analytic_file
    ;
    var Literacy
    ;
run;
title2;
footnote2;

proc format;
    value Literacy_bin
    1-<50 = "under50"
    50-99.9 = "over50-high"
    100 = "100 percent"
    ;
run;

title2 "Literacy rate by countries";
footnote2 "Based on the above output, we could see that there's a fraction
    of 10% countries of the world that still have a very low literacy rate of 
    less than 50%. Meanwhile, 86.6% of countries have the literacy rate of 
    above 50% and only 3.35% of countries reaching the complete Literacy rate 
    of 100% "; 
proc freq
    data=COTW_analytic_file;
    table Literacy;
    format
    Literacy Literacy_bin.;
run;
title2;
footnote2;

 
 
*******************************************************************************; 
