* Encoding: UTF-8.
****PCO DW1****.

*------------------------------ SECTION 1 ------------------------------.
*set working directory.
cd 'C:\Users\u399171\surfdrive\Education\2122\pco\DW\data\data-raw\WVS_files'.
*I always include this line to clean my global environment when I work. 
*This makes it possible to do a “ctrl-a, ctrl-r” procedure. 
*This means rerunning the script to make sure you use clean data.
*A lot of problems in data manipulation occur by reusing ‘saved’ data. 
*This is bad practice. If you make tidy and clean code, you normally do not need to save data ever.
*It also makes your work reproducible. Unless your data is huge and computations take up a lot of time. 
dataset close all.

*import the WVS longitudinal file and rename it to wvs_long. 
get file 'WVS_TimeSeries_spss_v1_6.sav'. 
dataset name wvs_long.
dataset activate wvs_long.

*------------------------------ SECTION 2 ------------------------------.
*frequency of waves.
*the frequency table shows that we have 7 different waves, so we have 6 periods . 
frequencies S002 S020.

*how many respondents do we have?.
descriptives variables S007.
*answer: 426435.

*Look at the different countries. Do you see something unusual?.  
frequencies S003.

*answer: yes, uneven representation of countries. Not all countries participate in every wave. 

*check what countries participate in which wave. Just to get a feel for the data. 
crosstabs S003 by S002.

*------------------------------ SECTION 3 ------------------------------.
*use the syntax in the appendix to create the four item index.
* Use Y002 to check your coding. (preprogrammed postmat variable (four item)).
frequencies
E001
E002
E003
E004
E005
E006.

*answer is  E003 and E004.
*use the syntax in the back of the book to create the four item index.
* Use Y002 to check your coding. (preprogrammed postmat var (four item).
compute V1000 = 2.
if ((E003 = 1 AND E004 = 3) or (E003 = 3 AND E004 = 1)) V1000 = 1.
if ((E003 = 2 AND E004 = 4) or (E003 = 4 AND E004 = 2)) V1000 = 3.
execute. 

value labels V1000
1 'Materialist'
2 'Mixed'
3 'Postmaterialist'.

*check coding. 
fre V1000.
fre Y002.

*Uh, something weird occurred. The frequencies do not add up. How come?
*Any idea how to solve this?.

*answer: well, the missings are not accounted for in the way the appendix codes the answers.
*my coding would be:.
if (missing(E003) or missing(E004)) V1000 = -99. 
missing values V1000 (-99).
execute.

*check the coding. 
fre V1000 Y002.

*------------------------------ SECTION 4 ------------------------------.
*use aggregate to calculate mean scores for each country-year combo. save it as a variable. 
aggregate outfile * mode addvariables
/break S025
/mean_pm4_cy = mean(V1000).

* frequency table.
frequencies mean_pm4_cy.

*crosstable.
crosstabs mean_pm4_cy by S020.

*germany 2018 has the highest mean.
crosstabs mean_pm4_cy by S025.

*simple way to create postmataterlist score for a countryear combination. Just only do this for country year combination: 5282012 *Netherlands (2012).
*first create a filter variable. 
compute filter_dutch = 0.
if (S025 = 5282012) filter_dutch = 1.
execute. 

*use filter. 
filter by filter_dutch.
frequencies V1000. 
filter off. 


*you can scale this method by using split file. 
*for split file you need to sort cases.
sort cases by S025.

*use split file. 
split file by S025. 

*frequency command. Split file will now perform this on all subsets. 
frequencies V1000.

*turn off split file.
split file off.

*use aggregate to create new aggregated data. 
aggregate outfile * mode addvariables
/break S025
/p_postmat_fouritem_cy = PGT(V1000, 2)
/p_mat_fouritem_cy =  PLT(V1000, 2).

*now we can actually create the postmat variable for every country year combination. 
compute postmat_cy = p_postmat_fouritem_cy - p_mat_fouritem_cy.
exe.  

*frequency table of postmat_cy.
frequencies postmat_cy.

*compute cohort variable. 
compute cohort = -99.
if (X002 >= 1886 and X002 <= 1905) cohort = 1.
if (X002 >= 1906 and X002 <= 1915) cohort = 2.
if (X002 >= 1916 and X002 <= 1925) cohort = 3.
if (X002 >= 1926 and X002 <= 1935) cohort = 4.
if (X002 >= 1936 and X002 <= 1945) cohort = 5.
if (X002 >= 1946 and X002 <= 1955) cohort = 6.
if (X002 >= 1956 and X002 <= 1965) cohort = 7.
if (X002 >= 1966 and X002 <= 1975) cohort = 8.
if (X002 >= 1976 and X002 <= 1985) cohort = 9.
if (X002 >= 1986 and X002 <= 1995) cohort = 10.
if (X002 >= 1996 and X002 <= 2005) cohort = 11.
execute. 

*set labels. 
value labels cohort
1 '1886 - 1905'
2 '1906 - 1915'
3 '1916 - 1925'
4 '1926 - 1935'
5 '1936 - 1945'
6 '1946 - 1955'
7 '1956 - 1965'
8 '1966 - 1975'
9 '1976 - 1985'
10 '1986 - 1995'
11 '1996 - 2005'.

*set missing variables 
missing values cohort (-99).

*check the new variable. 
frequencies cohort.

*crosstab check.
crosstabs cohort by X002.

*list check. Another nice way to check the compute command. 
list 
/variables = cohort X002 
/cases = from 1 to 100.

*use aggregate to create new aggregated data for cohort year.
aggregate outfile * mode addvariables
/break S020 cohort
/p_postmat_fouritem_cohort_y  = PGT(V1000, 2)
/p_mat_fouritem_cohort_y =  PLT(V1000, 2).

*now we can actually create the postmat variable for every country year combination. 
compute postmat_cohort_y = p_postmat_fouritem_cohort_y - p_mat_fouritem_cohort_y.
exe.  

*frequency table of postmat_cy.
frequencies postmat_cohort_y.

*use aggregate to create new aggregated data for cohort year.
aggregate outfile * mode addvariables
/break S025 cohort
/p_postmat_fouritem_cohort_cy  = PGT(V1000, 2)
/p_mat_fouritem_cohort_cy =  PLT(V1000, 2).

*now we can actually create the postmat variable for every country year combination. 
compute postmat_cohort_cy = p_postmat_fouritem_cohort_cy - p_mat_fouritem_cohort_cy.
exe.  

*frequency table of postmat_cy.
frequencies postmat_cohort_cy.

save outfile = 'wvs_aggregated_postmat.sav'
/keep S020 S002 S003 S025 postmat_cy postmat_cohort_cy postmat_cohort_y cohort.

get file =  'wvs_aggregated_postmat.sav'.
