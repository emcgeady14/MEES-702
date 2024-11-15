#Emi McGeady

#This function plots average, median, and Q1-Q3 range per year of a 
#response variable, given a data frame, time series, or matrix of 2 or more 
#columns. The arguments for main, xlab, and ylab should be specified by
#the user based on the input data. The function automatically plots average in black,
#but this can be changed by setting plotmean = F or by changing the color argument.

myplot <- function(data,
                   main = NULL,
                   xlab = "Year",
                   ylab = "Response Variable",
                   plotmean = T,
                   color = "black")
  
  {
  
  #load packages
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  
  #check if input is numeric vector and print warning
  if(is.vector(data)) {
    stop("Error: A numeric vector was provided. Provide
         data frame, matrix, or time series object.")
  }
  
  #check data structures, convert to dataframes
  #if time series with more columns than 2, convert to data frame 
  #with time data in a new year column
  if(is.ts(data)){
    if (NCOL(data)<2) 
      stop("Error: single column time series provided. Time series with at least 2 columns needed.")
    else data <- data.frame(Year = as.numeric(floor(time(data))),  # Extract only integer year - still need to figure this out
                            Value = as.numeric(data))       
    }
  
  if(is.matrix(data)){
    if (ncol(data)<2) 
      stop("Error: single column matrix provided. Matrix with at least 2 columns needed.")
    else data <- as.data.frame(data)}
  
  if (is.data.frame(data) && ncol(data) < 2) {
    stop("Error: single column data frame provided. Data frame with at least 2 columns needed.")
    
  }

  #Add in year column if there isn't one present
  if (!"Year" %in% colnames(data)) {
    if ("year" %in% colnames(data)) {
      data$Year <- data$year  #taking care of potential issues with capitalization
    } else if ("date" %in% colnames(data)) {
      # Use the date column to create year column
      data$Year <- format(as.Date(data$date), "%Y")
    } else if ("Date" %in% colnames(data)) {
      data$Year <- format(as.Date(data$Date), "%Y")  #same thing but if its capitalized
    } else {
      data$Year <- as.numeric(row.names(data))  #if none of those, use row names
    }
  }
  
  #Reshape data to long format
  longd <- data %>%
    pivot_longer(cols = -Year, names_to = "Variable", values_to = "Value")
  
  #calculate summary stats
  dsum <- longd %>% 
    group_by(Year) %>% 
    summarize (mean = mean(Value, na.rm=T),  #remove NA values 
               median = median(Value, na.rm=T), 
               Q1 = quantile(Value,0.25, na.rm = T), 
               Q3 = quantile(Value,0.75, na.rm = T))
  
  #plot the data, edit graph aesthetics
  p <- ggplot(data = dsum, aes(x = Year)) +
    geom_line(aes(y = median, color ='Median')) +
    geom_ribbon(aes(ymin = Q1, ymax = Q3, fill = "Q1 & Q3"), alpha = 0.30) +
    labs(
      x = xlab,
      y = ylab,
      title = main) +
    scale_color_manual(name = "", values = c("Median" = "darkgray",
                                             "Average" = color)) +
    scale_fill_manual(name = "", values = c("Q1 & Q3" = "skyblue")) +
    guides(color = guide_legend(override.aes = list(fill = NA)),
           fill = guide_legend(override.aes = list(color = NA))) +
    scale_x_continuous(breaks = seq(min(dsum$Year), max(dsum$Year), by = 5)) +
    theme_minimal() +
    theme(
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      axis.line.x = element_line(color = "black"),  
      axis.line.y = element_line(color = "black"),  
      plot.title = element_text(hjust = 0.5))
    
  if (plotmean == TRUE) {
    print( 
      p + 
      geom_line(aes(y = mean, color = "Average")) + 
      geom_point(aes(y = mean), size = 2, shape = 1, stroke = 1) +  
        scale_color_manual(name = "", values = c("Median" = "darkgray", 
                                                 "Average" = color)))
    } else {
      print(p)
  }
    
  }
  


