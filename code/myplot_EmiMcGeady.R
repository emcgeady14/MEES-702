#Emi McGeady

#This function plots...

myplot <- function(data,
                   main = "Time Series Plot",
                   xlab = "Year",
                   ylab = "Response Variable",
                   plotmean = T)
  
  {
  
  #load packages
  library(ggplot2)
  library(dplyr)
  library(reshape2)
  
  #check if input is numeric vector and print warning
  if(is.vector(data)) {
    stop("Error: A numeric vector was provided. Provide
         data frame, matrix, or time series object for quantile calculations.")
  }
  
  #check data structures, convert to dataframes
  if(is.ts(data)){
    if (NCOL(data)<2) 
      stop("Error: single column time series provided. Time Series with at least 2 columns needed.")
    else data <- data.frame(
      Year = as.numeric(time(data)),  # Extract year as numeric
      Value = as.numeric(data)        # Extract time series values
    )}
  
  if(is.matrix(data)){
    if (ncol(data)<2) 
      stop("Error: single column matrix provided. Matrix with at least 2 columns needed.")
    else data <- as.data.frame(data)}
  
  if (is.data.frame(data) && ncol(data) < 2) {
    stop("Error: single column dataframe provided. Dataframe with at least 2 columns needed.")
    
  }

  #Reshape data to long format
  longd <- data %>%
    pivot_longer(cols = -Year, names_to = "Variable", values_to = "Value")
  
  #calculate summary stats
  dsum <- longd %>% 
    group_by(Year) %>% 
    summarize (mean = mean(Value, na.rm=T),
               median = median(Value, na.rm=T), 
               Q1 = quantile(Value,0.25, na.rm = T), 
               Q3 = quantile(Value,0.75, na.rm = T))
  
  #plot the data, edit graph aesthetics
  p <- ggplot(data = dsum, aes(x = Year)) +
    geom_line(aes(y = mean, color = "Average")) +
    geom_point(aes(y = mean), size = 2, shape = 1, stroke = 1) +
    geom_line(aes(y = median, color ='Median')) +
    geom_ribbon(aes(ymin = Q1, ymax = Q3, fill = "Q1 & Q3"), alpha = 0.30) +
    labs(
      x = xlab,
      y = ylab,
      title = main) +
    scale_color_manual(name = "", values = c("Average" = "black", "Median" = "darkgray")) +
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
      plot.title = element_text(hjust = 0.5),
      legend.position = c(0.2, 0.4))

    print(p)
    
  }


myplot(d)
myplot(EuStockMarkets)


dts <- data.frame(
  Year = as.numeric(time(EuStockMarkets)),  # Extract year as numeric
  Value = as.numeric(EuStockMarkets)        # Extract time series values
)
