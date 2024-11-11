funRatio <- function(x, y){
  x/y
}

funPower2 <- function(x, y){
  x^2
  x < y
}

funPower <- function(x, y){
  funPower2 <- function(x, y){
    z <- x^2
  }
  if (y == 2) {
    print("Square it!")
    return(funPower2(x))
  } else {
    z = x^y
    #browser()
    ra <- funRatio(x, y)
    return(list(z = z, x, y, ratio = ra))
  }
}

funPlot <- function(x, y, ..., ratio){
  plot(x, y, pch = 18, cex = ratio, ...)
}


