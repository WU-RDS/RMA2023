#-------------------------------------------------------------------#
#-----------------------Data visualization--------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the fifth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2019/_book/summarizing-data.html#data-visualization
# Also see further resources:
# https://github.com/IndrajeetPatil/ggstatsplot
# https://rstudio-pubs-static.s3.amazonaws.com/228019_f0c39e05758a4a51b435b19dbd321c23.html
# https://indrajeetpatil.github.io/ggstatsplot_slides

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("Hmisc", "knitr", "ggmap", "ggplot2", "plyr", "ggthemes", "jsonlite", "dplyr", "ggExtra", "scales", "devtools", "tidyr", "gridExtra")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
if(!"ggstatsplot" %in% installed.packages()) {
library(devtools)
devtools::install_github('IndrajeetPatil/ggstatsplot', force = TRUE)
}
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 2)

#-------------------------------------------------------------------#
#----------------------Categorical variables------------------------#
#-------------------------------------------------------------------#

# Read in data and transform variables into factors
## ------------------------------------------------------------------------
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/survey2017.dat", 
                        sep = "\t", 
                        header = TRUE)
head(test_data)

# Convert factor variables
test_data$overall_knowledge_cat <- factor(test_data$overall_knowledge, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate","advanced","proficient"))

test_data$theory_ht_cat <- factor(test_data$theory_ht, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate","advanced","proficient"))

test_data$theory_anova_cat <- factor(test_data$theory_anova, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate","advanced","proficient"))

test_data$theory_reg_cat <- factor(test_data$theory_reg, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate","advanced","proficient"))

test_data$theory_fa_cat <- factor(test_data$theory_fa, 
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

# Adjust color
## ------------------------------------------------------------------------
bar_chart + geom_col(fill="blue") +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_bw()
## ------------------------------------------------------------------------
# see color palattes here: http://rstudio-pubs-static.s3.amazonaws.com/5312_98fc1aba2d5740dd849a5ab797cc2c8d.html
ggplot(table_plot_rel, aes(x = overall_knowledge,y = Freq, fill=overall_knowledge)) + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  scale_fill_brewer(palette="Blues") +
  #scale_fill_manual(values=c("#55DDE0", "#33658A", "#2F4858", "#F6AE2D", "#666666")) # Add color scale (hex colors)
  theme_bw()

# Add theme
## ------------------------------------------------------------------------
ggplot(table_plot_rel, aes(x = overall_knowledge,y = Freq, fill=overall_knowledge)) + geom_col() +
  ylab("Relative frequency") + 
  xlab("Overall Knowledge") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  scale_fill_brewer(palette="Blues") +
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
  scale_fill_brewer(palette="Blues") +
  theme_bw() 

# Pie chart
## ------------------------------------------------------------------------
ggplot(subset(table_plot_rel,Freq > 0), aes(x="", y=Freq, fill=overall_knowledge)) + # Create a basic bar
  geom_bar(stat="identity", width=1) + 
  coord_polar("y", start=0) + #Convert to pie (polar coordinates) 
  geom_text(aes(label = paste0(round(Freq*100), "%")), position = position_stack(vjust = 0.5)) + #add labels
  #scale_fill_manual(values=c("#55DDE0", "#33658A", "#2F4858", "#F6AE2D")) # Add color scale (hex colors)
  scale_fill_brewer(palette = "Blues") +
  labs(x = NULL, y = NULL, fill = NULL, title = "Overall knowledge") +  #remove labels and add title
  theme_classic() + 
  theme(axis.line = element_blank(),  # Tidy up the theme
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5, color = "#666666"))   
# alternative approach
library(ggstatsplot)
ggstatsplot::ggpiestats(
  data = test_data,
  x = overall_knowledge_cat,
  title = "Overall knowledge",
  messages = FALSE,
  bf.message = FALSE,
  legend.title = element_blank(),
  #palette = "Blues",
  results.subtitle = FALSE
)

#Alternatively use ggbarstats function which has a similar syntax
library(tidyr)
test_data$Theory_Regression_cat <- factor(test_data$theory_reg, 
                                          levels = c(1:5), 
                                          labels = c("none", "basic", "intermediate", "advanced", "proficient"))
plot_vars <- gather(test_data[,c("overall_knowledge_cat", "theory_ht_cat", "theory_anova_cat", "theory_reg_cat", "theory_fa_cat")], variable, category, overall_knowledge_cat:theory_fa_cat, factor_key=TRUE)
ggbarstats(
  data = plot_vars,
  x = category,
  y = variable,
  sampling.plan = "jointMulti",
  title = "Prior knowledge by method",
  xlab = "Variable",
  ggplot.component = ggplot2::theme(axis.text.x = ggplot2::element_text(face = "italic")),
  palette = "Blues",
  messages = FALSE,
  results.subtitle = FALSE,
  bar.proptest = FALSE
)

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

# Histogram
## ------------------------------------------------------------------------
ggplot(adv_data) + 
  geom_histogram(aes(sales), binwidth = 3000, col = "black", fill = "darkblue") + 
  labs(x = "Number of sales", y = "Frequency") + 
  theme_bw()
# alternative
gghistostats(
  data = adv_data, # dataframe from which variable is to be taken
  x = sales, # numeric variable whose distribution is of interest
  title = "Distribution of sales", # title for the plot
  caption = substitute(paste(italic("Source:"), "Advertising data set from source X")),
  #test.value.line = TRUE, # display a vertical line at test value
  #test.value.color = "#0072B2", # color for the line for test value
  centrality.para = "mean", # which measure of central tendency is to be plotted
  centrality.color = "darkred", # decides color for central tendency line
  binwidth = 3000, # binwidth value 
  messages = FALSE, # turn off the messages
  ggtheme = theme_bw(), # choosing a different theme
  ggstatsplot.layer = FALSE, # turn off ggstatsplot theme layer
  bf.message = FALSE,
  results.subtitle = FALSE,
  #normal.curve = TRUE
)

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
#alternative
  ggbetweenstats(
    data = adv_data,
    title = "Sales by store", # title for the plot
    plot.type = "box",
    x = store, # 2 groups
    y = sales ,
    type = "p", # default
    messages = FALSE,
    bf.message = FALSE
  )

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
url <- "http://api.worldbank.org/countries/AT/indicators/SP.POP.TOTL/?date=1960:2018&format=json&per_page=100" 
ctrydata_at <- fromJSON(url) #parses the data 
head(ctrydata_at[[2]][, c("value", "date")]) #checks if we scraped the desired data
ctrydata_at <- ctrydata_at[[2]][, c("date","value")]
ctrydata_at$value <- as.numeric(ctrydata_at$value)
ctrydata_at$date <- as.integer(ctrydata_at$date)
## ------------------------------------------------------------------------
ggplot(ctrydata_at, aes(x = date, y = value)) + 
  geom_line() + 
  labs(x = "Year", y = "Population of Austria") +
  theme_bw()
## ------------------------------------------------------------------------
# Secondary y-axis
# see: https://rpubs.com/MarkusLoew/226759
url <- "http://api.worldbank.org/countries/AT/indicators/NY.GDP.MKTP.CD/?date=1960:2018&format=json&per_page=100" 
ctrydata_at_gdp <- fromJSON(url) #parses the data 
head(ctrydata_at_gdp[[2]][, c("value", "date")]) #checks if we scraped the desired data
ctrydata_at_gdp <- ctrydata_at_gdp[[2]][, c("date","value")]
ctrydata_at_gdp$value <- as.numeric(ctrydata_at_gdp$value)
ctrydata_at_gdp$date <- as.integer(ctrydata_at_gdp$date)
# ratio to scale y-axis
ratio <- mean(ctrydata_at$value/1000000)/mean(ctrydata_at_gdp$value/1000000)
ggplot(ctrydata_at) + 
  geom_line(aes(x = date, y = value/1000000, colour = "Population"), size = 1) + 
  geom_line(data = ctrydata_at_gdp, aes(x = date, y = (value/1000000)*ratio, colour = "GDP"), size = 1) + 
  scale_y_continuous(sec.axis = sec_axis(~./ratio, name = "GDP of Austria (million)")) +
  scale_colour_manual(values = c("steelblue", "darkgrey")) + 
  theme_bw() +
  labs(y = "Population of Austria (million)",
       x = "Year",
       colour = "") +
  theme(legend.position = "bottom") 

# Area plot
## ------------------------------------------------------------------------
ggplot(ctrydata_at) + 
  geom_area(aes(x = date, y = value/1000000, colour = "Population", fill = "Population"), alpha = 0.5) + 
  geom_area(data = ctrydata_at_gdp, aes(x = date, y = (value/1000000)*ratio, colour = "GDP", fill = "GDP"), alpha = 0.5) + 
  scale_y_continuous(sec.axis = sec_axis(~./ratio, name = "GDP of Austria (million)")) +
  scale_fill_manual(values = c("steelblue", "darkgrey")) + 
  scale_colour_manual(values = c("steelblue", "darkgrey"),guide=FALSE) + 
  theme_bw() +
  labs(y = "Population of Austria (million)",
       x = "Year",
       fill = "",
       title = "GDP and Population of Austria",
       caption = "Source: Worldbank") +
  theme(legend.position = "bottom") 

# Stacked area plot
## ------------------------------------------------------------------------
# scrape data for another country
url <- "http://api.worldbank.org/countries/DE/indicators/NY.GDP.MKTP.CD/?date=1960:2018&format=json&per_page=100" 
ctrydata_de_gdp <- fromJSON(url) #parses the data 
head(ctrydata_de_gdp[[2]][, c("value", "date")]) #checks if we scraped the desired data
ctrydata_de_gdp <- ctrydata_de_gdp[[2]][, c("date","value")]
ctrydata_de_gdp$value <- as.numeric(ctrydata_de_gdp$value)
ctrydata_de_gdp$date <- as.integer(ctrydata_de_gdp$date)
ctrydata_de_gdp$country <- "DE"
ctrydata_at_gdp$country <- "AT"
# combine data from both countries
gdp_de_at <- rbind(ctrydata_de_gdp,ctrydata_at_gdp)
gdp_de_at <- subset(gdp_de_at,date > 1969)

ggplot(gdp_de_at) +   
  geom_area(position="stack",aes(x=date,y=value/1000000,group=country,fill=country)) + 
  labs(title = "GDP by country (in million US$)",
       y = "GDP (million)", x = "Year",
       caption = "Source: Worldbank") +
  theme_bw() +
  scale_fill_manual(values = c("steelblue", "darkgrey")) 

#-------------------------------------------------------------------#
#--------------------------Saving plots-----------------------------#
#-------------------------------------------------------------------#

# Make sure your working directory is set correctly
getwd()
# If necessary, set the working directory in which you would like to save the graphics
#setwd("path/to/folder")

# Save plots using ggsave()
## ------------------------------------------------------------------------
# Example 1
plot_example_1 <- ggbarstats(
                      data = plot_vars,
                      x = category,
                      y = variable,
                      sampling.plan = "jointMulti",
                      title = "Prior knowledge by method",
                      xlab = "Variable",
                      ggplot.component = ggplot2::theme(axis.text.x = ggplot2::element_text(face = "italic")),
                      palette = "Blues",
                      messages = FALSE,
                      results.subtitle = FALSE,
                      bar.proptest = FALSE
                    )
ggsave("plot_example_1.jpg", height = 5, width = 9, plot_example_1)

# Example 2
plot_example_2 <- ggbetweenstats(
                      data = test_data,
                      plot.type = "box",
                      x = gender_cat, # 2 groups
                      y = overall_100 ,
                      type = "p", # default
                      messages = FALSE,
                      bf.message = FALSE,
                      title = "Knowledge by gender",
                      ylab = "overall knowledge",
                      xlab = "gender"
                    )
ggsave("plot_example_2.jpg", height = 5, width = 7, plot_example_2)

# Example 3
# You can customize the font size of the text elements in the graphic
# set the font size here
title_size = 16
font_size = 12
line_size = 0.5
# create plot 
plot_example_3 <- ggplot(ctrydata_at) + 
                    geom_area(aes(x = date, y = value/1000000, colour = "Population", fill = "Population"), alpha = 0.5) + 
                    geom_area(data = ctrydata_at_gdp, aes(x = date, y = (value/1000000)*ratio, colour = "GDP", fill = "GDP"), alpha = 0.5) + 
                    scale_y_continuous(sec.axis = sec_axis(~./ratio, name = "GDP of Austria (million)")) +
                    scale_fill_manual(values = c("steelblue", "darkgrey")) + 
                    scale_colour_manual(values = c("steelblue", "darkgrey"),guide=FALSE) + 
                    theme_bw() +
                    labs(y = "Population of Austria (million)",
                         x = "Year",
                         fill = "",
                         title = "GDP and Population of Austria",
                         subtitle = "Development from 1960 to 2018",
                         caption = "Source: Worldbank") +
                    theme(axis.text=element_text(size=font_size),
                          panel.border = element_blank(), 
                          panel.grid.major.x = element_blank(),
                          axis.title=element_text(size=font_size),
                          panel.grid.minor.x = element_blank(), 
                          panel.grid.major.y = element_line(size = 0.5), 
                          axis.line = element_line(colour = "black"),
                          plot.title = element_text(size=title_size,hjust = 0.5),
                          plot.subtitle=element_text(size=font_size,hjust = 0.5),
                          legend.position="bottom",
                          legend.title = element_text(size=font_size),
                          legend.text=element_text(size=font_size))

ggsave("plot_example_3.jpg", height = 5, width = 7.5, plot_example_3)


#-------------------------------------------------------------------#
#-------------------------Combining plots---------------------------#
#-------------------------------------------------------------------#

# You can also combine multiple plots in one graphic
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html

library(gridExtra)
combined_plot <- grid.arrange(plot_example_1, plot_example_2, nrow = 1)
ggsave("combined_plot.jpg", height = 5, width = 15, combined_plot)

 
#-------------------------------------------------------------------#
#-------------------------Further options---------------------------#
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

