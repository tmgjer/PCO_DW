* Encoding: UTF-8.

*set working dir and clean the environment. 
cd 'C:\Users\u399171\surfdrive\Education\2122\pco\DW\WVS_files'.

*I always include this line to clean my global environment when I work. This makes it possible to do a “ctrl-a, ctrl-r” procedure. 
*This means rerunning the script to make sure you use clean data. A lot of problems in data manipulation occur by reusing ‘saved’ data. 
*This is bad practice. If you make tidy and clean code, you normally do not need to save data ever. Also, it also contributes to reproducibility. Unless your data is huge and computations take up a lot of time. 

dataset close all.

*import the WVS longitudinal file.
get file = 'WVS_TimeSeries_spss_v1_6.sav'. 
dataset name wvs_long.

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

*compare the table in appendix X with the previous crosstab.Focus on the Dutch case. What are your conclusions. 
*Answer: weirdly enough these are not the same data. For instance, according to the appendix the Netherlands should be in there in 1981 and 1991. 
*However, they are not in the timeseries data. 

*------------------------------------------------------ four item -----------------------------------------------------*.
*create the four item index. 
*Which of the twelve items do we need for this?
*Check the appendix of the book. 
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

*it works, not perfect as we do not have a distinction in the missings, for now it is okay. 
aggregate outfile * mode addvariables
/break S025
/mean_pm4_cy = mean(V1000).


fre mean_pm4_cy.

aggregate 
/outfile = "grouped_data.sav" 
/break S025
/mean_pm4_cy = mean(V1000).

*import the data. 
get file =  'grouped_data.sav'.
dataset name grouped_data.

*activate the dataset.
dataset activate grouped_data.

*activate the grouped data. 
list  S025 mean_pm4_cy.
crosstabs S025 by mean_pm4_cy.

sort cases by mean_pm4_cy.

*simple way to solve the problem. Just only do this for country year combination: 5282012 *Netherlands (2012).
*first create a filter variable. 
compute filter_dutch = 0.
if (S025 = 5282012) filter_dutch = 1.
execute. 

filter by filter_dutch.
frequencies V1000 Y002. 
filter off. 

* PGT(varlist,value) Percentage of cases greater than the specified value.
* PLT(varlist,value) Percentage of cases less than the specified value.
aggregate outfile * mode addvariables
/break S025
/p_postmat_fouritem_cy = PGT(V1000, 2)
/p_mat_fouritem_cy =  PLT(V1000, 2).

*now we can actually create the postmate variable for every country year combination. 
compute postmat_cy = p_postmat_fouritem_cy - p_mat_fouritem_cy.
exe. 

*check the new variable.
frequencies postmat_cy.

*think of all the time you have just saved?

fre X002.

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

*for split file you need to sort cases.
sort cases by S002 S030.

*use split file. 
split file by S002 S030. 

*frequency command. Split file will now perform this on all subsets. 
frequencies V1000.


