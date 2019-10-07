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
library(openssl)
url <- "https://raw.githubusercontent.com/IMSMWU/mrda_data_pub/master/secret-music_data.rds"
download.file(url, "./data/secret_music_data.rds", method = "auto", quiet=FALSE)
encrypted_music_data <- readRDS("./data/secret_music_data.rds")
music_data <- unserialize(aes_cbc_decrypt(encrypted_music_data, key = key))

s.genre <- c("pop","hip hop","rock","rap","indie")
music_data <- subset(music_data, top.genre %in% s.genre)

music_data$genre_cat <- as.factor(music_data$top.genre)
music_data$explicit_cat <- factor(music_data$explicit, levels = c(0:1), 
                                  labels = c("not explicit", "explicit"))

head(music_data)

# Calculate relative frequencies and transform into a data frame
## ------------------------------------------------------------------------
table_plot_rel <- as.data.frame(prop.table(table(music_data[,c("genre_cat")]))) #relative frequencies
head(table_plot_rel)

# Rename a variable with the help of the plyr package
## ------------------------------------------------------------------------
library(plyr)
table_plot_rel <- plyr::rename(table_plot_rel, c(Var1="Genre"))
head(table_plot_rel)

# Create an empty plot
## ------------------------------------------------------------------------
library(ggplot2)
bar_chart <- ggplot(table_plot_rel, aes(x = Genre,y = Freq))
bar_chart

# Add a bar chart geom
## ------------------------------------------------------------------------
bar_chart + geom_col() 

# Adjust axis names
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") 

# Add value labels
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) 

# Add theme
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_bw()

# Add theme
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal()

# Add theme from ggthemes package
## ------------------------------------------------------------------------
library(ggthemes)
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  theme_economist()

# Plot conditional relative frequencies
## ------------------------------------------------------------------------
table_plot_cond_rel <- as.data.frame(prop.table(table(music_data[,c("genre_cat", "explicit_cat")]), 2))  #conditional relative frequencies
# Use the face_wrap() function to split plot by gender variable
## ------------------------------------------------------------------------
ggplot(table_plot_cond_rel, aes(x = genre_cat, y = Freq)) + 
  geom_col() + 
  facet_wrap(~explicit_cat) + 
  ylab("Conditional relative frequency") + 
  xlab("Genre") + 
  theme_bw()

# Use "fill = gender" and "position = dodge" arguments to plot bars in different colour by gender next to each other 
## ------------------------------------------------------------------------
ggplot(table_plot_cond_rel, aes(x = genre_cat, y = Freq, fill = explicit_cat)) + #use "fill" argument for different colors
  geom_col(position = "dodge") + #use "dodge" to display bars next to each other (instead of stacked on top)
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)),position=position_dodge(width=0.9), vjust=-0.25) +
  ylab("Conditional relative frequency") + 
  xlab("Genre") + 
  theme_bw() 

# Investigate relation between theoretical and practical knowledge in regression analysis
## ------------------------------------------------------------------------
music_data$genre_cat <- as.factor(music_data$top.genre)

music_data$popularity_factor <- cut(music_data$trackPopularity, 
                                    breaks = c(-Inf, 40, 60, Inf), labels = c("low", 
                                                                              "middle", "high"))

# Plot frequency count of co-occurences
## ------------------------------------------------------------------------
ggplot(data = music_data) + geom_count(aes(x = genre_cat, y = popularity_factor, size = stat(prop), group = genre_cat)) + 
  ylab("Popularity") + 
  xlab("Genre") + 
  labs(size = "Proportion") + 
  theme_bw()

# Contingency table
## ------------------------------------------------------------------------
table_plot_rel <- prop.table(table(music_data[, c("genre_cat", 
                                                  "popularity_factor")]), 1)
table_plot_rel <- as.data.frame(table_plot_rel)


# Tile plot
ggplot(table_plot_rel, aes(x = genre_cat, y = popularity_factor)) + 
  geom_tile(aes(fill = Freq)) + 
  ylab("Popularity") + 
  xlab("Genre") + 
  theme_bw()


#-------------------------------------------------------------------#
#----------------------Continuous variables-------------------------#
#-------------------------------------------------------------------#

# Histogram
## ------------------------------------------------------------------------
ggplot(music_data, aes(mstreams)) + geom_histogram(binwidth = 3000, col = "black", fill = "darkblue") + 
  labs(x = "Number of streams", y = "Frequency") + 
  theme_bw()

# Grouped Boxplot
## ------------------------------------------------------------------------
ggplot(music_data, aes(x = explicit_cat, y = mstreams)) + 
  geom_boxplot(coef = 3) + labs(x = "Explicit", y = "Number of streams") + 
  theme_bw()


# Grouped Boxplot with augmented data points
## ------------------------------------------------------------------------
ggplot(music_data, aes(x = explicit_cat, y = mstreams)) + 
  geom_boxplot(coef = 3) + geom_jitter(colour = "red", alpha = 0.2) + 
  labs(x = "Explicit", y = "Number of streams") + 
  theme_bw()

# Single Boxplot
## ------------------------------------------------------------------------
ggplot(music_data, aes(x = "", y = mstreams)) + 
  geom_boxplot(coef = 3) + 
  labs(x = "Total", y = "Number of streams") + 
  theme_bw()

# Plot of means
## ------------------------------------------------------------------------
ggplot(music_data, aes(explicit_cat, duration_ms)) + 
  geom_bar(stat = "summary", color = "black", fill = "white", width = 0.7, na.rm = T) + 
  geom_pointrange(stat = "summary",fun.ymin = function(x) mean(x) - sd(x), fun.ymax = function(x) mean(x) + 
                  sd(x), fun.y = mean, na.rm = T) + 
  labs(x = "Explicit",y = "Average number of streams") +
  theme_bw()

# Scatter plot
## ------------------------------------------------------------------------
ggplot(music_data, aes(log(adv_spending), mstreams)) + 
  geom_point() +
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) +
  labs(x = "Advertising expenditures (EUR)", y = "Number of streams") + 
  theme_bw() 

# Grouped scatter plot (using the "colour" argument)
## ------------------------------------------------------------------------
ggplot(music_data, aes(log(adv_spending), mstreams, colour = explicit_cat)) +
  geom_point() + 
  geom_smooth(method="lm", alpha = 0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of streams", colour="Explicit") + 
  theme_bw()

# Combination of scatter plot and histogram
## ------------------------------------------------------------------------
library(ggExtra)
p <- ggplot(music_data, aes(log(adv_spending), mstreams)) + 
  geom_point() +
  labs(x = "Advertising expenditures (EUR)", y = "Number of strams", colour = "store") + 
  theme_bw() 
ggExtra::ggMarginal(p, type = "histogram")

# Line plot
## ------------------------------------------------------------------------
library(jsonlite)
library(jsonlite)
#specifies url
url <- "http://api.worldbank.org/countries/AT/indicators/SP.POP.TOTL/?date=1960:2016&format=json&per_page=100" 
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
ggplot(table_plot_rel, aes(x = genre_cat, y = popularity_factor)) + 
  geom_tile(aes(fill = Freq)) + 
  ylab("Popularity") + 
  xlab("Genre") + 
  theme_bw()

ggsave("popularity_genre_regression.jpg", height = 5, width = 7.5)


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

