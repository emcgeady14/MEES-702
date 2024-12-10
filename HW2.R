# Homework 2: Option 1 - 
# speed up the function funtimes::ccf_boot() 
# use smaller objects, parallelizing, find more efficient solution
# submit two files - one file with new version of the function
# second file should have test code that shows my version is faster

# checks:
# new function and original produce same outputs - use set.seed
# run new function on a large data set (heavy) and compare computing speed
# obtain similar gains in the function performance (computing time should
# be similar on Slava's computer)
library(funtimes)
?funtimes::ccf_boot

plot.ts(cbind(BJsales.lead,BJsales))
ccf_boot(diff(BJsales.lead), diff(BJsales),plot="Spearman")  #original result
#black estimates should be same, and blue band should be similar though its bootstrap
#so maybe some variation

#will eventually test ccf_boot2
ccf_boot2(diff(BJsales.lead), diff(BJsales),plot="Spearman")


#option 2-
#write a replication file
#load available data and replicate the results
#test replicability of the study - this matters more than formatting
#see section for math notations - LaTex in Q&A
#paper and data set are shared
#submit a pdf

#page 11 of 16
#and equations beforehand?
#mcusum_test() applied -- use time points and residuals - will get similar p-values from table 2
#CLASSIFICATION REGRESSION TREES M- CART for figure 4, need rpart::rpart package and function
#partition by year then by year , change point is 1988 and 2013
#load rpart.plot package for replicating the aesthetics
#residuals are provided in fig 4 as input?

#bootstrapped p-values

