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

Please see included file for dataset properties ;

filename _inbox "%sysfunc(getoption(work))/STAT660-01_f18-team-3_project1_data_preparation.sas";
proc http method="get" url="https://raw.githubusercontent.com/stat660/team-3_project1/v0.1/STAT660-01_f18-team-3_project1_data_preparation.sas" 
out=_inbox;
run;

%Include _inbox;
filename _inbox clear;

*******************************************************************************;
*
Research Question: What are the top 20 countries with the highest values of 
"Net Migration"? 

Rationale: This should help identify least attractive countries.

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

proc means mean noprint data=COTW_analytic_file;
  class Country;
  var net_migration;
  output out=COTW_analytic_file_temp;
run;

proc sort data=COTW_analytic_file_temp (where=(_STAT_="MEAN"));
  by descending net_migration;
run;

  title1 "STAT 660: Team 3 Project 1 MP";
  title2 "Top 20 Countries with Highest Net Migration Rate";
  footnote2 "Based on the above output, Afghanistan has the highest net 
    migration.  8 other countries have at least 10% net migration rate. Both
    war torn countries and countries with well established economy exhibited
    high net migration rate of above 10%.";
    
proc print data=COTW_analytic_file_temp (obs=20) ;
  id Country;
  var net_migration;
run;
  title2;
  footnote2;
  
*******************************************************************************;
*
Research Question: Is there a correlation between net migration and death rate? 

Rationale: Identify correlations between net migration and death rate.

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

 title2 "Correlation Between Net Migration Rate and Death Rate";
 footnote2 "Pearson Chi-Sq Test shows p-value > 0.05, therefore failed to 
		reject Ho s.t. there is not enough evidence to show significant
		correlation between net migration and death rate.";
proc corr data = COTW_analytic_file PEARSON SPEARMAN;
 var net_migration deathrate ;
run;
  title2;
  footnote2;

*******************************************************************************;
*
Research Question:  Can "Death Rate" be used to predict "Net Migration"? 

Rationale: This would help determine whether literacy has any effect on the 
countries's Net Migration.

Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Literacy and Net_Migration based upon their 
spread, and use proc freq to cross-tabulate bins.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.;

data _temp_COTW_analytic_file;
	set COTW_analytic_file;
	deathrate = deathrate/100;
	net_migration = net_migration/100;
	format deathrate net_migration percent15.2;
run;

  title2 "Death Rate effect on Net Migration";
  footnote2 "Quartile Values";
proc means min q1 median q3 max data=_temp_COTW_analytic_file;
  var deathrate net_migration    ;
run;
  title2;
  footnote2;

proc format;
    value deathrate_bins
        low    -0.0585 ="Q1 Death Rate"
        0.0585<-0.0784 ="Q2 Death Rate"
        0.0784<-0.1062 ="Q3 Death Rate"
        0.1062<-high   ="Q4 Death Rate"
    ;
    value Net_Migration_bins
         low    - -0.0095="Q1 Net Migration"
        -0.0095<-  0     ="Q2 Net Migration"
         0     <-  0.0100="Q3 Net Migration"
         0.0100<-  high  ="Q4 Net Migration"
    ;
run;

  title2 "Death Rate effect on Net Migration";
  footnote2 "Based on the above output, there's no clear inferential pattern 
    for predicting the net migration rate based on a country's death rate 
    since cell counts don't tend to follow trends for increasing or decreasing 
    consistently.";
proc freq data=_temp_COTW_analytic_file;
  table deathrate*Net_Migration   / missing norow nocol nopercent    ;
  format
    Deathrate      deathrate_bins.
    Net_Migration  Net_Migration_bins.    ;
run;
  title2;
  footnote2;

*******************************************************************************;
