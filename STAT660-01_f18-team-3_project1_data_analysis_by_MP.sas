*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding net migration.

Dataset Name: COTW_analytic_file created in external file
STAT660-01_f18-team-3_project1_data_preparation.sas, which is assumed to be
in the same directory as this file.

Please see included file for dataset properties 
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic dataset COTW_analytic_file;
%include '.\STAT660-01_f18-team-3_project1_data_preparation.sas';

*******************************************************************************;

title1 
    "Research Question: What are the top 20 countries with the highest values of Net Migration?"
    ; 

title2 
    "Rationale: This should help identify least attractive countries."
    ;

footnote1 
    "Based on the above output, Afghanistan has the highest net migration."
    ;

footnote2
    "8 other countries have at least 10% net migration rate."
    ;

footnote3
    "Both war torn countries and countries with well established economy exhibited high net migration rate of above 10%."
    ;

*
Methodology: Use PROC MEANS to compute the mean of Net_Migration
for Country, and output the results to a temporary dataset. Use PROC
SORT extract and sort just the means the temporary dataset, and use PROC PRINT
to print just the first twenty observations from the temporary dataset.

Limitations: Data dictionary is limited.  We assume positive net_migration
value indicates migrating out of the country and negative net_migration is
entering the country. The methodology does not account for countries with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Steps: More carefully clean the values of the variable
net_migration so that the means computed do not include any possible
illegal values.
;
  
proc print 
        noobs
        data=COTW_analytic_file_temp_mp (obs=20) 
    ;
    id 
        Country
    ;
    var 
        net_migration
    ;
run;
title;
footnote;

  
*******************************************************************************;

title1 
    "Research Question: Is there a correlation between net migration and death rate?"
    ;

title2 
    "Rationale: Identify correlations between net migration and death rate."
    ;

footnote1 
    "Pearson Chi-Sq Test shows p-value > 0.05, therefore failed to reject Ho s.t. there is not enough evidence to show significant correlation between net migration and death rate."
    ;

*
Methodology: Use PROC CORR can to compute Pearson product-moment correlation 
coefficient between net_migration and deathrate, as well as Spearman's 
rank-order correlation, a nonparametric measures of association. PROC CORR 
also computes simple descriptive statistics.  

Limitations: Data dictionary is limited.  We assume positive net_migration
value indicates migrating out of the country and negative net_migration is
entering the country. The methodology does not account for countries with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Steps: More carefully clean the values of the variable
net_migration so that the means computed do not include any possible
illegal values. Find correlations for combinations death rate, infant 
mortality, and net migration. And use proc plot to generate a graph of the 
variable net_migration against death rate.
;

proc corr 
        PEARSON SPEARMAN
        data = COTW_analytic_file 
    ;
    var 
        net_migration 
        deathrate 
    ;
run;
title;
footnote;

*******************************************************************************;

title1 
    'Research Question:  Can "Death Rate" be used to predict "Net Migration"?'
    ; 

title2 
    'Rationale: This would help determine whether death rate has any effect on the countries Net Migration.'
    ;

footnote1 
    "Based on the above output, there is no clear inferential pattern for predicting the net migration rate based on a country's death rate since cell counts don't tend to follow trends for increasing or decreasing consistently."
    ;

*
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Death Rate and Net_Migration based upon their 
spread, and use proc freq to cross-tabulate bins.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.;

proc means 
        min q1 median q3 max 
        data=COTW_analytic_file
    ;
    var 
        deathrate 
        net_migration    
    ;
run;

proc freq 
        data=COTW_analytic_file
    ;
    table 
        deathrate*Net_Migration   
        / missing norow nocol nopercent 
    ;
    format 
        Deathrate deathrate_bins. 
        Net_Migration Net_Migration_bins. 
    ;
run;
title;
footnote;
