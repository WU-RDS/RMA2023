#-------------------------------------------------------------------#
#-----------------------Data visualization--------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the fifth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/summarizing-data.html#data-visualization

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("Hmisc", "knitr", "ggplot2", "plyr", "ggthemes", "gtools", "Rmisc", "tidyr", "jsonlite", "dplyr", "ggExtra", "scales", "devtools", "tidyr", "gridExtra", "ggstatsplot")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 2)

#-------------------------------------------------------------------#
#----------------------Categorical variables------------------------#
#-------------------------------------------------------------------#

# Read in data and transform variables into factors
## ------------------------------------------------------------------------
music_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_data_at.csv", 
                         sep = ",", 
                         header = TRUE)

music_data$release_date <- as.Date(music_data$release_date) #convert to date
music_data$explicit <- factor(music_data$explicit, levels = 0:1, labels = c("not explicit", "explicit")) #convert to factor
music_data$label <- as.factor(music_data$label) #convert to factor
music_data$rep_ctry <- as.factor(music_data$rep_ctry) #convert to factor
music_data$genre <- as.factor(music_data$genre) #convert to factor
prop.table(table(music_data[,c("genre")])) #relative frequencies
music_data <- music_data[!is.na(music_data$valence) & !is.na(music_data$duration_ms),] # exclude cases with missing values


# Calculate relative frequencies and transform into a data frame
## ------------------------------------------------------------------------
table_plot_rel <- as.data.frame(prop.table(table(music_data[,c("genre")]))) #relative frequencies #relative frequencies
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
  #theme_bw() 
  theme_minimal()

# Rotate axis labels on x-axis
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=0.75)) 

# Add title
## ------------------------------------------------------------------------
bar_chart + geom_col() +
  labs(x = "Genre", y = "Relative frequency", title = "Chart songs by genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=0.75),
        plot.title = element_text(hjust = 0.5,color = "#666666")
  ) 

# Adjust color
## ------------------------------------------------------------------------
# see color palattes here: http://rstudio-pubs-static.s3.amazonaws.com/5312_98fc1aba2d5740dd849a5ab797cc2c8d.html
bar_chart + geom_col(aes(fill = Genre)) +
  labs(x = "Genre", y = "Relative frequency", title = "Chart share by genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  ylim(0,0.5) +
  scale_fill_brewer(palette = "Blues") +
  theme(axis.text.x = element_text(angle=45,vjust=0.75),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
  ) 

# Change theme
## ------------------------------------------------------------------------
library(ggthemes)
bar_chart + geom_col() +
  labs(x = "Genre", y = "Relative frequency", title = "Chart songs by genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_economist() +
  ylim(0,0.5) +
  theme(axis.text.x = element_text(angle=45,vjust=0.55),
        plot.title = element_text(hjust = 0.5,color = "#666666")
  ) 


# Plot conditional relative frequencies
## ------------------------------------------------------------------------
table_plot_cond_rel <- as.data.frame(prop.table(table(music_data[,c("genre", "explicit")]),2)) #conditional relative frequencies
table_plot_cond_rel

# Use the face_wrap() function to split plot by gender variable
## ------------------------------------------------------------------------
ggplot(table_plot_cond_rel, aes(x = genre, y = Freq)) + 
  geom_col(aes(fill = genre)) +
  facet_wrap(~explicit) +
  labs(x = "", y = "Relative frequency", title = "Distribution of genres for explicit and non-explicit songs") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq * 100)), vjust=-0.2) +
  theme_minimal() +
  ylim(0,1) +
  scale_fill_brewer(palette = "Blues") +
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
  ) 

# Grouped bar chart
## ------------------------------------------------------------------------
table_plot_cond_rel_1 <- as.data.frame(prop.table(table(music_data[,c("genre", "explicit")]),1)) #conditional relative frequencies
ggplot(table_plot_cond_rel_1, aes(x = genre, y = Freq, fill = explicit)) + #use "fill" argument for different colors
  geom_col(position = "dodge") + #use "dodge" to display bars next to each other (instead of stacked on top)
  geom_text(aes(label = sprintf("%.0f%%", Freq * 100)),position=position_dodge(width=0.9), vjust=-0.25) +
  scale_fill_brewer(palette = "Blues") +
  labs(x = "Genre", y = "Relative frequency", title = "Explicit lyrics share by genre") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.title = element_blank()
  ) 

# Pie chart
## ------------------------------------------------------------------------
ggplot(subset(table_plot_rel,Freq > 0), aes(x="", y=Freq, fill=Genre)) + # Create a basic bar
  geom_bar(stat="identity", width=1) + 
  coord_polar("y", start=0) + #Convert to pie (polar coordinates) 
  geom_text(aes(label = paste0(round(Freq*100), "%")), position = position_stack(vjust = 0.5)) + #add labels
  scale_fill_brewer(palette = "Blues") +
  labs(x = NULL, y = NULL, fill = NULL, title = "Spotify tracks by Genre") +  #remove labels and add title
  theme_minimal() + 
  theme(axis.line = element_blank(),  # Tidy up the theme
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5, color = "#666666")) 


# Investigate association between song popularity & speechiness 
## ------------------------------------------------------------------------
library(gtools)
# Convert to categorical variables
music_data$streams_cat <- as.numeric(quantcut(music_data$streams, 5, na.rm=TRUE))
music_data$speech_cat <- as.numeric(quantcut(music_data$speechiness, 3, na.rm=TRUE))
# Convert to factor
music_data$streams_cat <- factor(music_data$streams_cat, levels = 1:5, labels = c("low", "low-med", "medium", "med-high", "high")) #convert to factor
music_data$speech_cat <- factor(music_data$speech_cat, levels = 1:3, labels = c("low", "medium", "high")) #convert to factor

# Plot frequency count of co-occurrences
## ------------------------------------------------------------------------
ggplot(data = music_data) + 
  geom_count(aes(x = speech_cat, y = streams_cat, size = stat(prop), group = speech_cat))  + 
  ylab("Popularity") + 
  xlab("Speechiness") + 
  labs(size = "Proportion") +
  theme_bw()

# Tile plot
## ------------------------------------------------------------------------
# Contingency table
table_plot_rel <- prop.table(table(music_data[,c("speech_cat", "streams_cat")]),1)
table_plot_rel <- as.data.frame(table_plot_rel)
# Create plot
ggplot(table_plot_rel, aes(x = speech_cat, y = streams_cat)) + 
  geom_tile(aes(fill = Freq)) + 
  ylab("Populartiy") + 
  xlab("Speechiness") + 
  theme_bw()


#-------------------------------------------------------------------#
#----------------------Continuous variables-------------------------#
#-------------------------------------------------------------------#

# Histogram
## ------------------------------------------------------------------------
ggplot(music_data,aes(streams)) + 
  geom_histogram(binwidth = 4000, col = "black", fill = "darkblue") + 
  labs(x = "Number of streams", y = "Frequency", title = "Distribution of streams") + 
  theme_bw()

# Add vertical lines
ggplot(music_data,aes(streams)) + 
  geom_histogram(binwidth = 4000, col = "black", fill = "darkblue") + 
  labs(x = "Number of streams", y = "Frequency", title = "Distribution of streams", subtitle = "Red vertical line = mean, green vertical line = median") + 
  geom_vline(xintercept = mean(music_data$streams), color = "red", size = 1) +
  geom_vline(xintercept = median(music_data$streams), color = "green", size = 1) +
  theme_bw()

# Grouped Boxplot
## ------------------------------------------------------------------------
# Convert data to log-scale
music_data$log_streams <- log(music_data$streams)
# Create plot
ggplot(music_data,aes(x = genre, y = log_streams, fill = genre)) +
  geom_boxplot(coef = 3) + 
  labs(x = "Genre", y = "Number of streams (log-scale)") + 
  theme_minimal() + 
  scale_fill_brewer(palette = "Blues") +
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
  ) 
# Flip plot
ggplot(music_data,aes(x = log_streams, y = genre, fill = genre)) +
  geom_boxplot(coef = 3) + 
  labs(x = "Number of streams (log-scale)", y = "Genre") + 
  theme_minimal() + 
  scale_fill_brewer(palette = "Blues") +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
  ) 
# Augment data
ggplot(music_data,aes(x = log_streams , y = genre)) +
  geom_boxplot(coef = 3) + 
  labs(x = "Number of streams (log-scale)", y = "Genre") + 
  theme_minimal() +
  geom_jitter(colour="red", alpha = 0.1) 
# Single Boxplot
## ------------------------------------------------------------------------
ggplot(music_data,aes(x = log_streams, y = "")) +
  geom_boxplot(coef = 3,width=0.3) + 
  labs(x = "Number of streams (log-scale)", y = "") 

# Plot of means
## ------------------------------------------------------------------------
# Specify genre dummy variable
music_data$genre_dummy <- as.factor(ifelse(music_data$genre=="HipHop & Rap","HipHop & Rap","other"))
# Compute required statistics
library(Rmisc)
mean_data <- summarySE(music_data, measurevar="streams", groupvars=c("genre_dummy"))
mean_data
# Create plot of means
ggplot(mean_data,aes(x = genre_dummy, y = streams)) + 
  geom_bar(position=position_dodge(.9), colour="black", fill = "#CCCCCC", stat="identity", width = 0.65) +
  geom_errorbar(position=position_dodge(.9), width=.15, aes(ymin=streams-ci, ymax=streams+ci)) +
  theme_bw() +
  labs(x = "Genre", y = "Average number of streams", title = "Average number of streams by genre")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
# Grouped plot of means
# Compute required statistics
mean_data2 <- summarySE(music_data, measurevar="streams", groupvars=c("genre_dummy","explicit"))
mean_data2
# Create plot
ggplot(mean_data2,aes(x = genre_dummy, y = streams, fill = explicit)) + 
  geom_bar(position=position_dodge(.9), colour="black", stat="identity") +
  geom_errorbar(position=position_dodge(.9), width=.2, aes(ymin=streams-ci, ymax=streams+ci)) +
  scale_fill_manual(values=c("#CCCCCC","#FFFFFF")) +
  theme_bw() +
  labs(x = "Genre", y = "Average number of streams", title = "Average number of streams by genre and lyric type")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

# Scatter plot
## ------------------------------------------------------------------------
ggplot(music_data, aes(speechiness, log_streams)) + 
  geom_point(shape =1) +
  labs(x = "Genre", y = "Relative frequency") + 
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) +
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot of streams and speechiness") + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

# Grouped scatter plot (using the "color" argument)
## ------------------------------------------------------------------------
ggplot(music_data, aes(speechiness, log_streams, colour = explicit)) +
  geom_point(shape =1) + 
  geom_smooth(method="lm", alpha = 0.1) + 
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot of streams and speechiness by lyric type", colour="Explicit") + 
  scale_color_manual(values=c("lightblue","darkblue")) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

# Line plot
## ------------------------------------------------------------------------
music_data_ctry <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/streaming_charts_ctry.csv", 
                              sep = ",", 
                              header = TRUE)
music_data_ctry$week <- as.Date(music_data_ctry$week)
music_data_ctry$region <- as.factor(music_data_ctry$region)
head(music_data_ctry)
music_data_at <- subset(music_data_ctry, region == 'at')
## ------------------------------------------------------------------------
ggplot(music_data_at, aes(x = week, y = streams)) + 
  geom_line() + 
  labs(x = "Week", y = "Total streams in Austria", title = "Weekly number of streams in Austria") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
# Multiple line plot
music_data_at_compare <- subset(music_data_ctry, region %in% c('at','de','ch','se','dk','nl'))
ggplot(music_data_at_compare, aes(x = week, y = streams, color = region)) + 
  geom_line() + 
  labs(x = "Week", y = "Total streams", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
# Using facet wrap to create one plot by region
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000)) + 
  geom_line() + 
  facet_wrap(~region, scales = "free_y") +
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
# Area plot
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000)) + 
  geom_area(fill = "steelblue", color = "steelblue", alpha = 0.5) + 
  facet_wrap(~region, scales = "free_y") +
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
# Stacked area plot
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000,group=region,fill=region,color=region)) + 
  geom_area(position="stack",alpha = 0.65) + 
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

# Secondary y-axis
## ------------------------------------------------------------------------
music_data_at_se_compare <- subset(music_data_ctry, region %in% c('at','se'))
library(tidyr)
data_wide <- spread(music_data_at_se_compare, region, streams)
head(data_wide)
# ratio to scale y-axis
ratio <- mean(data_wide$at/1000000)/mean(data_wide$se/1000000)
# create plot
ggplot(data_wide) + 
  geom_area(aes(x = week, y = at/1000000, colour = "Austria", fill = "Austria"), alpha = 0.5) + 
  geom_area(aes(x = week, y = (se/1000000)*ratio, colour = "Sweden", fill = "Sweden"), alpha = 0.5) + 
  scale_y_continuous(sec.axis = sec_axis(~./ratio, name = "Total streams SE (in million)")) +
  scale_fill_manual(values = c("#999999", "#E69F00")) + 
  scale_colour_manual(values = c("#999999", "#E69F00"),guide=FALSE) + 
  theme_minimal() +
  labs(x = "Week", y = "Total streams AT (in million)", title = "Weekly number of streams by country") +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.title = element_blank(),
        legend.position = "bottom"
  ) 

#-------------------------------------------------------------------#
#--------------------------Saving plots-----------------------------#
#-------------------------------------------------------------------#

# Make sure your working directory is set correctly
getwd()
# If necessary, set the working directory in which you would like to save the graphics
#setwd("path/to/folder")
ggsave("test_plot.jpg", height = 5, width = 8.5)


#-------------------------------------------------------------------#
#-------------------------Further options---------------------------#
#-------------------------------------------------------------------#

# Include results of statistical tests
## ------------------------------------------------------------------------
library(ggstatsplot)
music_data_subs <- subset(music_data, genre %in% c("HipHop & Rap", "Soundtrack","Pop","Rock"))
ggbetweenstats(
  data = music_data_subs,
  title = "Number of streams by genre", # title for the plot
  plot.type = "box",
  x = genre, # 2 groups
  y = log_streams,
  type = "p", # default
  messages = FALSE,
  bf.message = FALSE,
  pairwise.comparisons = TRUE # display results from pairwise comparisons
)
ggsave("test_plot_1.jpg", height = 5.5, width = 7.5)

# Combination of scatter plot and histogram
## ------------------------------------------------------------------------
library(ggExtra)
p <- ggplot(music_data, aes(x = speechiness, y = log_streams)) + 
  geom_point() +
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot & histograms of streams and speechiness") + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
ggExtra::ggMarginal(p, type = "histogram")
