#-------------------------------------------------------------------#
#-----------------------Data visualization--------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the fifth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2018/_book/data-visualization.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_pacakges <- c("Hmisc", "knitr", "ggmap", "ggplot2", "plyr", "ggthemes", "jsonlite", "dplyr", "ggExtra")
req_pacakges <- req_pacakges[!req_pacakges %in% installed.packages()]
lapply(req_pacakges, install.packages)

#-------------------------------------------------------------------#
#----------------------Categorical variables------------------------#
#-------------------------------------------------------------------#

# Read in data and transform variables into factors
## ------------------------------------------------------------------------
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/survey2017.dat", 
                        sep = "\t", 
                        header = TRUE)
head(test_data)

test_data$overall_knowledge_cat <- factor(test_data$overall_knowledge, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate","advanced","proficient"))

test_data$gender_cat <- factor(test_data$gender, 
                               levels = c(1:2), 
                               labels = c("male", "female"))

# Calculate relative frequencies and transform into a data frame
## ------------------------------------------------------------------------
table_plot_rel <- as.data.frame(prop.table(table(test_data[,c("overall_knowledge_cat")]))) #relative frequencies
head(table_plot_rel)

# Rename a variable with the help of the plyr package
## ------------------------------------------------------------------------
library(plyr)
table_plot_rel <- plyr::rename(table_plot_rel, c(Var1="overall_knowledge"))
head(table_plot_rel)

# Create an empty plot
## ------------------------------------------------------------------------
library(ggplot2)
bar_chart <- ggplot(table_plot_rel, aes(x = overall_knowledge,y = Freq))
bar_chart

# Add a bar chart geom
## ------------------------------------------------------------------------
bar_chart + geom_col() 

# Adjust axis names
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") 

# Add value labels
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) 

# Add theme
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_bw()

# Add theme
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal()

# Add theme from ggthemes package
## ------------------------------------------------------------------------
library(ggthemes)
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  theme_economist()

# Plot conditional relative frequencies
## ------------------------------------------------------------------------
table_plot_cond_rel <- as.data.frame(prop.table(table(test_data[,c("overall_knowledge_cat","gender_cat")]), 2)) #conditional relative frequencies

# Use the face_wrap() function to split plot by gender variable
## ------------------------------------------------------------------------
ggplot(table_plot_cond_rel, aes(x = overall_knowledge_cat, y = Freq)) + 
  geom_col() + 
  facet_wrap(~ gender_cat) + 
  ylab("Absolute frequency") + 
  xlab("Overall Knowledge") + 
  theme_bw() 

# Use "fill = gender" and "position = dodge" arguments to plot bars in different colour by gender next to each other 
## ------------------------------------------------------------------------
ggplot(table_plot_cond_rel, aes(x = overall_knowledge_cat, y = Freq, fill = gender_cat)) + #use "fill" argument for different colors
  geom_col(position = "dodge") + #use "dodge" to display bars next to each other (instead of stacked on top)
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)),position=position_dodge(width=0.9), vjust=-0.25) +
  ylab("Conditional relative frequency") + 
  xlab("Overall Knowledge") + 
  theme_bw() 

# Investigate relation between theoretical and practical knowledge in regression analysis
## ------------------------------------------------------------------------
test_data$Theory_Regression_cat <- factor(test_data$theory_reg, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate", "advanced", "proficient"))

test_data$Practice_Regression_cat <- factor(test_data$pract_reg, 
                                            levels = c(1:5), 
                                            labels = c("Definitely not", "Probably not", "Might or might not", "Probably yes", "Definitely yes"))

# Plot frequency count of co-occurences
## ------------------------------------------------------------------------
ggplot(data = test_data) + 
  geom_count(aes(x = Theory_Regression_cat, y = Practice_Regression_cat))  + 
  ylab("Practical knowledge") + 
  xlab("Theoretical knowledge") + 
  theme_bw()

# Contingency table
## ------------------------------------------------------------------------
table_plot_abs_reg <- as.data.frame(table(test_data[,c("Theory_Regression_cat", "Practice_Regression_cat")])) #absolute frequencies

# Tile plot
ggplot(table_plot_abs_reg, aes(x = Theory_Regression_cat, y = Practice_Regression_cat)) + 
  geom_tile(aes(fill = Freq)) + 
  ylab("Practical knowledge") + 
  xlab("Theoretical knowledge") + 
  theme_bw()


#-------------------------------------------------------------------#
#----------------------Continuous variables-------------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
adv_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/advertising_sales.dat", 
                       sep = "\t", 
                       header = TRUE)

adv_data$store <- factor(adv_data$store, levels = c(1:2), labels = c("store1", "store2")) #convert to factor

head(adv_data)

# Histogram
## ------------------------------------------------------------------------
ggplot(adv_data) + 
  geom_histogram(aes(sales), binwidth = 3000, col = "black", fill = "darkblue") + 
  labs(x = "Number of sales", y = "Frequency") + 
  theme_bw()

# Grouped Boxplot
## ------------------------------------------------------------------------
ggplot(adv_data,aes(x = store, y = sales)) +
  geom_boxplot() + 
  labs(x = "Store ID", y = "Number of sales") + 
  theme_bw()

# Grouped Boxplot with augmented data points
## ------------------------------------------------------------------------
ggplot(adv_data,aes(x = store, y = sales)) +
  geom_boxplot() + 
  geom_jitter(colour="red", alpha = 0.2) +
  labs(x = "Store ID", y = "Number of sales") + 
  theme_bw()

# Single Boxplot
## ------------------------------------------------------------------------
ggplot(adv_data,aes(x = "", y = sales)) +
  geom_boxplot() + 
  labs(x = "Total", y = "Number of sales") + 
  theme_bw()

# Plot of means
## ------------------------------------------------------------------------
ggplot(adv_data, aes(store, sales)) + 
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Store ID", y = "Average number of sales") +
  coord_cartesian(ylim = c(100000, 130000)) +
  theme_bw()

# Scatter plot
## ------------------------------------------------------------------------
ggplot(adv_data, aes(advertising, sales)) + 
  geom_point() +
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) +
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour = "store") + 
  theme_bw()

# Grouped scatter plot (using the "colour" argument)
## ------------------------------------------------------------------------
ggplot(adv_data, aes(advertising, sales, colour = store)) +
  geom_point() + 
  geom_smooth(method="lm", alpha = 0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour="store") + 
  theme_bw()

# Combination of scatter plot and histogram
## ------------------------------------------------------------------------
library(ggExtra)
p <- ggplot(adv_data, aes(advertising, sales)) + 
  geom_point() +
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour = "store") + 
  theme_bw() 
ggExtra::ggMarginal(p, type = "histogram")

# Line plot
## ------------------------------------------------------------------------
library(jsonlite)
#specifies url
url <- "http://api.worldbank.org/countries/AT/indicators/SP.POP.TOTL/?date=1960:2017&format=json&per_page=100" 
ctrydata_at <- fromJSON(url) #parses the data 
head(ctrydata_at[[2]][, c("value", "date")]) #checks if we scraped the desired data
ctrydata_at <- ctrydata_at[[2]][, c("date","value")]
ctrydata_at$value <- as.numeric(ctrydata_at$value)
ctrydata_at$date <- as.integer(ctrydata_at$date)
str(ctrydata_at)

## ------------------------------------------------------------------------
ggplot(ctrydata_at, aes(x = date, y = value)) + 
  geom_line() + 
  labs(x = "Year", y = "Population of Austria") +
  theme_bw()

# Save plots using ggsave()
## ------------------------------------------------------------------------
ggplot(table_plot_abs_reg, aes(x = Theory_Regression_cat, y = Practice_Regression_cat)) +
   geom_tile(aes(fill = Freq)) +
   ylab("Practical knowledge") +
   xlab("Theoretical knowledge") +
   theme_bw()
 
 ggsave("theory_practice_regression.jpg", height = 5, width = 7.5)


#-------------------------------------------------------------------#
#------------------------Additional options-------------------------#
#-------------------------------------------------------------------#

# Geo-location data
## ------------------------------------------------------------------------
library(ggmap)
library(dplyr)
geo_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/geo_data.dat", 
                       sep = "\t", 
                       header = TRUE)
head(geo_data)

register_google(key = "your_api_key")

# Download the base map
de_map_g_str <- get_map(location=c(10.018343,51.133481), zoom=6, scale=2) # results in below map (wohoo!)

# Draw the heat map
ggmap(de_map_g_str, extent = "device") + 
  geom_density2d(data = geo_data, aes(x = lon, y = lat), size = 0.3) + 
  stat_density2d(data = geo_data, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), 
                 size = 0.01, bins = 16, geom = "polygon") + 
  scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)

# Transform data
geo_data <- geo_data %>% 
  group_by(latlon) %>% 
  dplyr::summarise(sumCount = n(), lat = first(lat), lon = first(lon)) %>% 
  filter(!is.na(latlon)) %>% 
  as.data.frame()

# Circle plot

circle_scale_amt = 0.15 # make the circles 25% of the size!
ggmap(get_googlemap(center = c(10.018343,51.133481), scale = 2, zoom = 6), extent = "normal") + 
  geom_point(aes(x = lon, y = lat), data = geo_data, col = "orange", alpha = 0.3, 
             size = geo_data$sumCount*circle_scale_amt) + 
  scale_size_continuous(range = range(geo_data$sumCount)) + 
  ylim(min(geo_data$lat), max(geo_data$lat)) + 
  xlim(min(geo_data$lon), max(geo_data$lon)) 

