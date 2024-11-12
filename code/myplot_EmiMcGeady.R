#Emi McGeady

#This function plots...

myplot <- function(data,
                   main = "Time Series Plot",
                   xlab = "Year",
                   ylab = "Response Variable",
                   colors = NULL,
                   plotmean = T,
                   ... )
  
  {
  #check if input is numeric vector and print warning
  if(is.vector(data) && is.numeric(data)) {
    stop("Error: A numeric vector was supplied. Provide
         data frame, matrix, or time series object for quantile calculations.")
  }
  #check if data structure
  if(inherits(data,"ts")){
    time_points <- time(data)
    data <- as.matrix(data)
  } else if (is.data.frame(data)|| is.matrix(data)) {
    time_points <- 1:nrow(data)
    data <- as.matrix(data)
  } else {
    stop("Input must me data frame, matrix, or time series object")
  }
  #remove NA values in data if provided
  if(any(is.na(data))) {
    data <- na.omit(data)
    time_points <- time_points[1:nrow(data)]  # Adjust time points after NAs omitted
    message("Warning: Missing data rows were removed with na.omit.")
  }
  plot(data, 
       main = main,  #soft code so that user can change these if they want.
       xlab = xlab,
       ylab = ylab,
       colors = colors,
       plotmean = plotmean,
       ...)
}
