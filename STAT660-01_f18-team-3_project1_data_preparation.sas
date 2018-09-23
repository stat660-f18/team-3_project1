
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
/*
This file prepares the dataset described below for analysis.

[Dataset Name] Countries of the world Data

[Experimental Units] World's countries

[Number of Observations] 228                    

[Number of Features] 20

[Data Source] https://www.kaggle.com/fernandol/countries-of-the-world#countries%20of%20the%20world.csv

[Data Dictionary] https://www.kaggle.com/fernandol/countries-of-the-world

[Unique ID] The column "Country" is a primary key.

[Edited File] https://github.com/stat660/team-3_project1/blob/master/COTW-edited.csv

[Process to create the COTW-edited.csv file in GitHub]
Step 1: Downloaded the file from kaggle.com site.
Step 2: Massage data. 
 1) In Excel, we replaced commas with periods for numeric variables. 
 2) Rename columns by replacing the space with underscore, and removing notes
    in parentheses.
Step 3: Drag and drop the files to GitHub.

*******************************************************************************;
*/

*******************************************************************************;
* Environmental setup                                                          ;
*******************************************************************************;

* Create format output;

proc format;
    value deathrate_bins
        low   -05.85 ="Q1 Death Rate"
        05.85<-07.84 ="Q2 Death Rate"
        07.84<-10.62 ="Q3 Death Rate"
        10.62<-high  ="Q4 Death Rate"
    ;
    value Net_Migration_bins
        low   --0.95 ="Q1 Net Migration"
        -0.95<- 0    ="Q2 Net Migration"
         0   <- 1.01 ="Q3 Net Migration"
         1.01<- high ="Q4 Net Migration"
    ;
    value Literacy_bin
        1-<50 = "Under 50% Literacy"
        50-99.9 = "Over 50% Literacy"
        100 = "100% Literacy"
    ;
run;

* setup environmental parameters;

%let inputDatasetURL = 
    https://github.com/stat660/team-3_project1/blob/master/COTW-edited.csv?raw=true;

*load COTW raw file over the wire;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;

%loadDataIfNotAlreadyAvailable(
    cotw_raw,
    &inputDatasetURL.,
    csv
)


*******************************************************************************;
* Check raw dataset for duplicates with respect to primary key (country)       ;
*******************************************************************************;

proc sort
        nodupkey
        data=cotw_raw
        out=_null_
    ;
    by 
        Country
    ;
run;

*******************************************************************************;
* Build analytic dataset from COTW dataset with the least number of columns and
  minimal cleaning/transformation needed to address research questions in
  corresponding data-analysis files ;
*******************************************************************************;

data COTW_analytic_file;
    retain
        Country
        Population
        Net_Migration
        Literacy
        Deathrate 
        GDP
        Infant_mortality
    ;
    keep
        Country
        Population
        Net_Migration
        Literacy
        Deathrate 
        GDP
        Infant_mortality
    ;
    set 
        cotw_raw
    ;
run;

*******************************************************************************;
* 
Use PROC MEANS to compute the mean of net_migration for Country, and output the
results to a temporary dataset, and use PROC SORT to extract and sort just the 
means the temporary dataset, which will be used as part of data analysis by MP.;
*******************************************************************************;

proc means 
        mean 
        noprint 
        data=COTW_analytic_file 
    ;
    class 
        Country
    ;
    var 
        net_migration
    ;
    output 
        out=COTW_analytic_file_temp_mp
    ;
run;

proc sort 
        data=COTW_analytic_file_temp_mp (where=(_STAT_="MEAN"))
    ;
    by 
        descending net_migration
    ;
run;

*******************************************************************************;
* 
Use PROC MEANS to compute the mean of GDP for Country, and output the
results to a temporary dataset, and use PROC SORT to extract and sort just the 
means the temporary dataset, which will be used as part of data analysis by AN.;
*******************************************************************************;
proc means 
        mean 
        noprint 
        data=COTW_analytic_file 
    ;
    class 
        Country
    ; 
    var 
        GDP
    ; 
    output 
        out=COTW_analytic_file_temp
    ; 
run; 

proc sort 
        data=COTW_analytic_file_temp (where=(_STAT_="MEAN"))
    ; 
    by 
        descending GDP
    ; 
run; 
