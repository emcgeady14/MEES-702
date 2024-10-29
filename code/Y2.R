# Sorting, printing, and summarizing data ####

#Subsetting Data ----

set.seed(123)
rnorm(10)
set.seed(123)

#1. simulation from distribution
rnorm(10)
rpois(10,2)

library(gamlss)
?gamlss.dist  #options for distributions
rSI(10) #generate 10 obs from rSI distribution
rSI(10, mu=5) #can change mu

#all observations are independent when we simulate

#when there is a relationship in the data, simulating from a model
names(iris)
m0 = lm(Sepal.Length ~ Sepal.Width, data=iris)
n = nrow(iris)
e = rnorm(n, sd=sd(m0$residuals))
y = 6.5262-0.2234  * iris$Sepal.Width + e  #simulated variable
a = coef(m0)[1]
b = coef(m0)[2]
#not hard coded:
y = a + b  * iris$Sepal.Width + e

par(mfrow = c(1,2))
hist(iris$Sepal.Length) 
hist(y)


#repeating steps many times: for loops
rm(list = ls())
N = 1000 #repeating 1000 times
pv = rep(NA,N)  #specify empty vector for output
#pv = rep(NA,N) #helps with bugs

#curly braces denote code that will be repeated 
for (i in 1:N) {
  x <- rnorm(n) #independent variable
  y <- 2*x +rnorm(n) #dependent variable
  out <- lm(y~x)
  s <- summary(out)
  pv[i] = s$coefficients[2,"Pr(>|t|)"]
}

mean(pv < 0.05)
#mean of all p-values

# Arima time series
n = 100
phi <- 0.5
tmp <- arima.sim(n, model = list(order=c(1,0,0), ar=phi))
ts.plot(tmp)
acf(tmp)


#sample function
sample(c(1:5)) #permutation, reordering
sample(c(1:5), 3) #subsampling, selecting 3 random obs
sample(c(1:5), 3, replace = T)


#Looping Functions----
B<- 1000
Bmeans <- rep(NA,B)
for(b in 1:B){
  Bmeans[b] <- mean(sample(X,replace = T))
}

hist(Bmeans, col=2)
quantile(Bmeans, probs = c(0.025,0.975)) #95% confidence interval

#or use sapply function
l1 <- list(a = c(1,2,3), b = 1:10, c = rnorm(10))
lapply(l1,mean)
sapply(l1, mean)
l1
#use lapply to output values from each element of l1 that are > mean
?lapply
lapply(l1, function(x) x[x > mean(x)] )

#do the same in a for loop

for(x in l1) {
  print(x[x > mean(x)])
}  #highlight and run all at once

#can we use sapply
sapply(l1, function(x) x[x > mean(x)] )
#does work but it behaves like lapply, doesn't simplify be default.

lapply(l1, quantile, probs = c(0.025,0.975))  #now quantile is the function

#apply functions over array margins
#matrix = 2dimensional array
#all elements of a matrix are all of the same type
library(dplyr)

M2 <- iris %>% 
  select(-Species)
apply(M2,1,sum)  #margin is kept in tact, in this instance we are keeping rows (1) in tact
#column sums:
apply(M2, 2, sum)
apply(M2, 2, mean)
#proportion of obs greater than mean
apply(M2, 2, function(x) mean(x>mean(x)))

M <- array(rnorm(10^3), dim= c(10,10,10))

F1 <- factor(c(rep("smoke", 10), rep("NoSmoke",10)))
BP<- rnorm(20,80)
tapply(BP, F1, mean)
#or
tapply(iris$Sepal.Length,iris$Species, mean)
