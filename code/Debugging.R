#####################################################################
#####################################################################
library(tidyverse)
message("this prints text")

# Debugging
as.Date(c("2011-04-05", 35))
#this code produces an NA, but doesn't tell us
#you will only find out when you try to use a function on the data
#if you continue, error perculates

#Warning - this will give us a warning if code is bugged
tmp <- log(-pi) #"warning message NaNs produced"
is.na(tmp)  #is it NA? - True

# Error
lm(x~y) #tells us that we do not have x and y in our environment
#lazy evaluation - only tells you first error

#triple dot notation allows you to pass additional arguments
lm(x~y, weights = z, iris, col = "blue" )
tapply(iris$Sepal.Length,
       iris$Species, 
       quantile, 
       probs = c(0.5),  #adding this argument and na.rm
       na.rm = T) #triple dots, we can pass additional arguments

#plot is a high level function - you don't have to specify everything


#functions ----
lm #gives you code for the function

Sys.Date()

#function to report year, month, and day of today
today #already and R function so change name

TD <- function() {
  x = Sys.Date()
  Year = as.numeric(format(x,"%Y"))
  Month = as.numeric(format(x,"%m"))
  MonthName = format(x,"%B")
  Day = as.numeric(format(x,"%d"))
  print(paste("Today is", MonthName, Day))
  list(Year = Year, Month = Month, Day = Day)
}
#or place function in a separate file and source it - this is what we do with the
#DEB code

source("./code/datefunction.R") #sourcing function quickly runs the code, faster
#so now the function will be in the environment
TD() #executes the function
TDx()
TDx(as.Date("2020-12-31"))
TDx(as.Date(c("2020-12-31","2028-10-16")))

dates <- TDx(as.Date(from= as.Date("2020-12-31"),
            to = as.Date("2021-12-31"), by =5))
#example plot
iris
x = iris$Sepal.Length
y = iris$Petal.Length

plot(x,y,
     las=1,
     pch = 15, col="tomato")

#made this code into a function:

source("code/datefunction.R")
myplot(iris$Sepal.Length,iris$Petal.Length) #have to define x and y but can keep defaults
myplot(iris$Sepal.Length,iris$Petal.Length, pch = 5, cex=2) #can respecify arguments


#### TOOLS
traceback()

mean(x)
traceback()

# browser() and debug()
source('MyFunctions.R')


debug()
