TD <- function() {
  x = Sys.Date()
  Year = as.numeric(format(x,"%Y"))
  Month = as.numeric(format(x,"%m"))
  MonthName = format(x,"%B")
  Day = as.numeric(format(x,"%d"))
  print(paste("Today is", MonthName, Day))
  list(Year = Year, Month = Month, Day = Day)
}

TDx <- function(dates=NULL) {
  if(is.null(dates)){
    x=Sys.Date()
  } else {
    x=dates
  }
  Year = as.numeric(format(x,"%Y"))
  Month = as.numeric(format(x,"%m"))
 # MonthName = format(x,"%B")
  Day = as.numeric(format(x,"%d"))
  #print(paste("Today is", MonthName, Day))
  data.frame(Year = Year, Month = Month, Day = Day)
}