* Encoding: UTF-8.

*set working dir and clean the environment. 
cd 'path to your directory'.

*I always include this line to clean my global environment when I work. This makes it possible to do a “ctrl-a, ctrl-r” procedure. 
*This means rerunning the script to make sure you use clean data. A lot of problems in data manipulation occur by reusing ‘saved’ data. 
*This is bad practice. If you make tidy and clean code, you normally do not need to save data ever. Also, it also contributes to reproducibility. Unless your data is huge and computations take up a lot of time. 

dataset close all.

*import the WVS longitudinal file.
get file = 'WVS_TimeSeries_spss_v1_6.sav'. 
dataset name wvs_long.

