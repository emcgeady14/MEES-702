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

