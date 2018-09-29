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

* load external file that generates analytic dataset COTW_analytic_file ;
%include '.\STAT660-01_f18-team-3_project1_data_preparation.sas';


 
title1 
    "Research Question: What are the top 20 countries with the highest values of GDP"? 
    ; 

title2 
    "Rationale: This should help identify contries with the highest GDP - GDP represents the health of a country's economy. It also represents the standard of living of the country." 
    ;

footnote1 
    "Based on the above output, except for USA at rank 3, 9 of the 10 countries having the highest GDP are small-sized countries in Europe,with Luxembourg ranked no.1."
    ;

footnote2
    "These top 10 highest-GDP countries have the minimum GDP value of 30000(USD)per capita."
    ;
*  
Methodology: Use PROC PRINT to print just the first twenty observations from 
the temporary dataset created in the corresponding data-prep file
 
Limitations: Missing data for some countries. The methodology does not account 
for countries with missing data, nor does it attempt to validate data in any way,
like filtering for percentages between 0 and 1.
 
Possible Follow-up Steps: More carefully clean the values of the variable GDP 
so that the means computed do not include any possible illegal values. 
;  
proc print 
        noobs
        data=COTW_analytic_file_temp(obs=20) 
    ; 
    id 
        Country
    ; 
    var 
        GDP
    ; 
run;
title;
footnote;



title1 
    "Research Question: Is there a correlation between GDP and net_migration?"
    ; 

title2 
    "Rationale: This should help identify correlations between GDP and net_migration." 
    ;

footnote1
    "Pearson Chi-Sq Test shows p-value <0.001 therefore we could accept Ho and can safely conclude that there is a significant correlation between GDP and net migration."
    ;
* 
Methodology: Use PROC CORR can to compute Pearson product-moment correlation  
coefficient between net_migration and GDP, as well as Spearman's rank-order 
correlation, a nonparametric measures of association. PROC CORR also computes 
simple descriptive statistics.   
 
Limitations: Data dictionary is limited. Missing values for some countries.

Possible Follow-up Steps: More carefully clean the values of the variable 
net_migration so that the means computed do not include any possible 
illegal values. 
; 
proc corr 
        data = COTW_analytic_file 
        PEARSON 
        SPEARMAN
    ; 
    var 
        net_migration 
        GDP 
    ; 
run;
title;
footnote; 



title1 
    "Research Question: What's the percentage of the countries with literacy rate of 50% or less ? What's the percentage of the countries with complete literacy(100%) ? "
    ; 

title2 
    "Rationale: This would help inform the portion of low-literacy countries and the overall literacy status of the world. " 
    ;

footnote1
    "Based on the above output, we could see that there's a fraction of 10% countries of the world that still have a very low literacy rate of less than 50%"
    ; 
    
footnote2
    "Meanwhile, 86.6% of countries have the literacy rate of above 50%"
    ;

footnote3
    "Only 3.35% of countries reaching the complete Literacy rate of 100%"
    ;
* 
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Literacy based upon their 
spread, and use proc freq to cross-tabulate bins.

Limitations: Data dictionary is limited. Missing values for some countries.

Possible Follow-up Steps: More carefully clean the values of the variable 
net_migration so that the means computed do not include any possible illegal 
values. 
;
proc means
        min q1 median q3 max
        data= COTW_analytic_file
    ;
    var 
        Literacy
    ;
run;

proc freq
         data=COTW_analytic_file
    ;
    table
         Literacy
    ;
    format
         Literacy Literacy_bin.
    ;
run;
title;
footnote;

