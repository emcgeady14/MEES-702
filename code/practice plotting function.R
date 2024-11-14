d <- read.csv("./data/AD_cluster_3.csv")

library(dplyr)

# Reshape data to long format
longd <- d %>%
  pivot_longer(cols = -Year, names_to = "Variable", values_to = "Value")

#calculate summary stats
dsum <- longd %>% 
  group_by(Year) %>% 
  summarize (mean = mean(Value, na.rm = T),
             median = median(Value, na.rm=T), 
             Q1 = quantile(Value,0.25, na.rm=T), 
             Q3 = quantile(Value,0.75, na.rm = T))

#plot
p <- ggplot(data = dsum, aes(x = Year)) +
  geom_line(aes(y = mean, color = "Average")) +
  geom_point(aes(y = mean), size = 2, shape = 1, stroke = 1) +
  geom_line(aes(y = median, color ='Median')) +
  geom_ribbon(aes(ymin = Q1, ymax = Q3, fill = "Q1 & Q3"), alpha = 0.30) +
  labs(
    x = "Year",
    y = "Attainment Deficit (%)",
    title = "Cluster 3") +
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
  
p
