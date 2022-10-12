## ----message=FALSE, warning=FALSE---------------------------------------------------------------------------------
library(tidyverse)
music_data <- read.csv2("https://short.wu.ac.at/ma22_musicdata") |> # pipe music data into mutate
  mutate(release_date = as.Date(release_date), # convert to date
         explicit = factor(explicit, levels = 0:1, labels = c("not explicit", "explicit")), # convert to factor w. new labels
         label = as.factor(label), # convert to factor with values as labels
         genre = as.factor(genre),
         top10 = as.logical(top10),
         # Create an ordered factor for the ratings (e.g., for arranging the data)
         expert_rating = factor(expert_rating, 
                                levels = c("poor", "fair", "good", "excellent", "masterpiece"), 
                                ordered = TRUE)
         ) |>
  filter(!is.na(valence))
head(music_data)


## ----message=FALSE, warning=FALSE---------------------------------------------------------------------------------
table_plot_rel <- as.data.frame(prop.table(table(music_data$genre))) #relative frequencies
head(table_plot_rel)


## ----message=FALSE, warning=FALSE---------------------------------------------------------------------------------
table_plot_rel <- rename(table_plot_rel, Genre = Var1)
head(table_plot_rel)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (step 1)"-------
bar_chart <- ggplot(table_plot_rel, aes(x = Genre,y = Freq))
bar_chart


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (step 2)"-------
bar_chart + geom_col() 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (step 3)"-------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (step 4)"-------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq * 100)), vjust=-0.2) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (step 5)"-------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (options 1)"----
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (options 1)"----
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=0.75)) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (options 1)"----
bar_chart + geom_col() +
  labs(x = "Genre", y = "Relative frequency", title = "Chart songs by genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=0.75),
        plot.title = element_text(hjust = 0.5, color = "#666666")
        ) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (options 1)"----
library(colorspace)
bar_chart + geom_col(aes(fill = Freq)) +
  labs(x = "Genre", y = "Relative frequency", title = "Chart share by genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  ylim(0,0.5) +
  scale_fill_continuous_sequential(palette = "Blues") +
  theme(axis.text.x = element_text(angle=45,vjust=0.75),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.title = element_blank()
        ) 


## -----------------------------------------------------------------------------------------------------------------
bar_chart + geom_col(aes(x=fct_reorder(Genre, Freq), fill = Freq)) +
  labs(x = "Genre", y = "Relative frequency", title = "Chart share by genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  ylim(0,0.5) +
  scale_fill_continuous_sequential(palette = "Blues") +
  theme(axis.text.x = element_text(angle=45,vjust=0.75),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.title = element_blank()
        )


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Bar chart (options 2)"----
library(ggthemes)
bar_chart + geom_col(aes(x=fct_reorder(Genre, Freq))) +
  labs(x = "Genre", y = "Relative frequency", title = "Chart songs by genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_economist() +
  ylim(0,0.5) +
  theme(axis.text.x = element_text(angle=45,vjust=0.55),
        plot.title = element_text(hjust = 0.5,color = "#666666")
        ) 


## -----------------------------------------------------------------------------------------------------------------
table_plot_cond_rel <- as.data.frame(prop.table(table(select(music_data, genre, explicit)),2)) #conditional relative frequencies
table_plot_cond_rel


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Grouped bar chart (facet_wrap)"----
ggplot(table_plot_cond_rel, aes(x = fct_reorder(genre, Freq), y = Freq)) + 
  geom_col(aes(fill = Freq)) +
      facet_wrap(~explicit) +
  labs(x = "", y = "Relative frequency", title = "Distribution of genres for explicit and non-explicit songs") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq * 100)), vjust=-0.2) +
  theme_minimal() +
  ylim(0,1) +
  scale_fill_continuous_sequential(palette = "Blues") +
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
        ) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Grouped bar chart (fill)"----
table_plot_cond_rel_1 <- as.data.frame(prop.table(table(select(music_data, genre, explicit)),1)) #conditional relative frequencies
ggplot(table_plot_cond_rel_1, aes(x = genre, y = Freq, fill = explicit)) + #use "fill" argument for different colors
  geom_col(position = "dodge") + #use "dodge" to display bars next to each other (instead of stacked on top)
  geom_text(aes(label = sprintf("%.0f%%", Freq * 100)),position=position_dodge(width=0.9), vjust=-0.25) +
    scale_fill_discrete_qualitative(palette = "Dynamic") +
  labs(x = "Genre", y = "Relative frequency", title = "Explicit lyrics share by genre") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
        ) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Histogram"----------------
head(music_data)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Histogram"----------------
music_data |>
  filter(genre=="R&B") |>
  ggplot(aes(streams)) + 
    geom_histogram(binwidth = 20000000, col = "black", fill = "darkblue") + 
    labs(x = "Number of streams", y = "Frequency", title = "Distribution of streams") + 
    theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Histogram 2"--------------
music_data |>
  filter(genre=="R&B") |>
ggplot(aes(streams)) + 
  geom_histogram(binwidth = 20000000, col = "black", fill = "darkblue") + 
  labs(x = "Number of streams", y = "Frequency", title = "Distribution of streams", subtitle = "Red vertical line = mean, green vertical line = median") + 
  geom_vline(aes(xintercept = mean(streams)), color = "red", size = 1) +
  geom_vline(aes(xintercept = median(streams)), color = "green", size = 1) +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Boxplot by group"---------
music_data$log_streams <- log(music_data$streams)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Boxplot by group", cache=FALSE----
ggplot(music_data,aes(x = fct_reorder(genre, log_streams), y = log_streams)) +
  geom_boxplot(coef = 3) + 
  labs(x = "Genre", y = "Number of streams (log-scale)") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
        ) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Boxplot by group", cache=FALSE----
ggplot(music_data,aes(x = log_streams, y = fct_reorder(genre, log_streams))) +
  geom_boxplot(coef = 3) + 
  labs(x = "Number of streams (log-scale)", y = "Genre") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
        ) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Boxplot by group",cache =FALSE----
ggplot(music_data,aes(x = log_streams , y = fct_reorder(genre, log_streams))) +
  geom_jitter(colour="red", alpha = 0.1) +
  geom_boxplot(coef = 3, alpha =0.1) + 
  labs(x = "Number of streams (log-scale)", y = "Genre") + 
  theme_minimal() 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Single Boxplot"-----------
ggplot(music_data,aes(x = log_streams, y = "")) +
  geom_boxplot(coef = 3,width=0.3) + 
  labs(x = "Number of streams (log-scale)", y = "") 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------
music_data$genre_dummy <- as.factor(ifelse(music_data$genre=="HipHop/Rap","HipHop & Rap","other"))


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------
library(Rmisc)
mean_data <- summarySE(music_data, measurevar="streams", groupvars=c("genre_dummy"))
mean_data


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Plot of means"------------
ggplot(mean_data,aes(x = genre_dummy, y = streams)) + 
  geom_bar(position=position_dodge(.9), colour="black", fill = "#CCCCCC", stat="identity", width = 0.65) +
  geom_errorbar(position=position_dodge(.9), width=.15, aes(ymin=streams-ci, ymax=streams+ci)) +
  theme_bw() +
  labs(x = "Genre", y = "Average number of streams", title = "Average number of streams by genre")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------
mean_data2 <- summarySE(music_data, measurevar="streams", groupvars=c("genre_dummy","explicit"))
mean_data2


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Grouped plot of means"----
ggplot(mean_data2,aes(x = genre_dummy, y = streams, fill = explicit)) + 
  geom_bar(position=position_dodge(.9), colour="black", stat="identity") +
  geom_errorbar(position=position_dodge(.9), width=.2, aes(ymin=streams-ci, ymax=streams+ci)) +
  scale_fill_manual(values=c("#CCCCCC","#FFFFFF")) +
  theme_bw() +
  labs(x = "Genre", y = "Average number of streams", title = "Average number of streams by genre and lyric type")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Scatter plot"-------------
ggplot(music_data, aes(speechiness, log_streams)) + 
  geom_point(shape =1) +
  labs(x = "Genre", y = "Relative frequency") + 
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) +
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot of streams and speechiness") + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Grouped scatter plot"------
ggplot(music_data, aes(speechiness, log_streams, colour = explicit)) +
  geom_point(shape =1) + 
  geom_smooth(method="lm", alpha = 0.1) + 
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot of streams and speechiness by lyric type", colour="Explicit") + 
  scale_color_manual(values=c("lightblue","darkblue")) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE---------------------------------------------------------------------------------
music_data_ctry <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/streaming_charts_ctry.csv", 
                        sep = ",", 
                        header = TRUE) |>
  mutate(week = as.Date(week),
         region = as.factor(region))
head(music_data_ctry)


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE------------------------------------------------------------
music_data_at <- filter(music_data_ctry, region == 'at')


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Line plot"-----------------
ggplot(music_data_at, aes(x = week, y = streams)) + 
  geom_line() + 
  labs(x = "", y = "Total streams in Austria", title = "Weekly number of streams in Austria") +
  theme_bw() +
  scale_y_continuous(labels = scales::label_comma()) +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE------------------------------------------------------------
music_data_at_compare <- filter(music_data_ctry, region %in% c('at','de','ch','se','dk','nl'))


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Line plot (by region)"-----
ggplot(music_data_at_compare, aes(x = week, y = streams, color = region)) + 
  geom_line() + 
  labs(x = "Week", y = "Total streams", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) +
  scale_y_continuous(labels = scales::label_comma())


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Line plot (facet wrap)"----
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000)) + 
  geom_line() + 
  facet_wrap(~region, scales = "free_y") +
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Line plot (facet wrap)"----
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000)) + 
  geom_area(fill = "steelblue", color = "steelblue", alpha = 0.5) + 
  facet_wrap(~region, scales = "free_y") +
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Line plot (facet wrap)"----
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000,group=region,fill=region,color=region)) + 
  geom_area(position="stack",alpha = 0.65) + 
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE------------------------------------------------------------
music_data_at_se_compare <- filter(music_data_ctry, region %in% c('at','se'))


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE------------------------------------------------------------
library(tidyr)
data_wide <- pivot_wider(music_data_at_se_compare, names_from = region, values_from = streams)
data_wide


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE------------------------------------------------------------
ratio <- mean(data_wide$at/1000000)/mean(data_wide$se/1000000)


## ----message=FALSE, warning=FALSE,eval=TRUE,fig.align="center", fig.cap = "Secondary y-axis"----------------------
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


## ----eval=FALSE---------------------------------------------------------------------------------------------------
## ggsave("test_plot.jpg", height = 5, width = 8.5)


## ----message=FALSE, warning=FALSE, echo=TRUE, fig.height=6, eval=TRUE, fig.align="center", fig.cap = "Boxplot using ggstatsplot package"----
library(ggstatsplot)
music_data_subs <- filter(music_data, genre %in% c("HipHop/Rap", "Soundtrack","Pop","Rock"))
ggbetweenstats(
   data = music_data_subs,
   title = "Number of streams by genre", # title for the plot
   plot.type = "box",
   x = genre, # 4 groups
   y = log_streams,
   type = "p", # default
   messages = FALSE,
   bf.message = FALSE,
   pairwise.comparisons = TRUE # display results from pairwise comparisons
 )


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Scatter plot with histogram"----
library(ggExtra)
p <- ggplot(music_data, aes(x = speechiness, y = log_streams)) + 
  geom_point() +
    labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot & histograms of streams and speechiness") + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
ggExtra::ggMarginal(p, type = "histogram")



## -----------------------------------------------------------------------------------------------------------------
library(gtools)
music_data$streams_cat <- as.numeric(quantcut(music_data$streams, 5, na.rm=TRUE))
music_data$speech_cat <- as.numeric(quantcut(music_data$speechiness, 3, na.rm=TRUE))

music_data$streams_cat <- factor(music_data$streams_cat, levels = 1:5, labels = c("low", "low-med", "medium", "med-high", "high")) #convert to factor
music_data$speech_cat <- factor(music_data$speech_cat, levels = 1:3, labels = c("low", "medium", "high")) #convert to factor


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Covariation between categorical data (1)"----
ggplot(data = music_data) + 
  geom_count(aes(x = speech_cat, y = streams_cat, size = stat(prop), group = speech_cat))  + 
  ylab("Popularity") + 
  xlab("Speechiness") + 
  labs(size = "Proportion") +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Covariation between categorical data (2)"----
table_plot_rel <- prop.table(table(music_data[,c("speech_cat", "streams_cat")]),1)
table_plot_rel <- as.data.frame(table_plot_rel)

ggplot(table_plot_rel, aes(x = speech_cat, y = streams_cat)) + 
  geom_tile(aes(fill = Freq)) + 
  ylab("Populartiy") + 
  xlab("Speechiness") + 
  theme_bw()


## ----message=FALSE, warning=FALSE,echo=TRUE, eval=TRUE------------------------------------------------------------
library(ggmap)
library(dplyr)
geo_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/geo_data.dat", 
                       sep = "\t", 
                       header = TRUE)
head(geo_data)


## ----ggmaps, echo=TRUE, eval=TRUE,message=FALSE, warning=FALSE----------------------------------------------------
#register_google(key = "your_api_key")

# Download the base map
de_map_g_str <- get_map(location=c(10.018343,51.133481), zoom=6, scale=2) # results in below map (wohoo!)

# Draw the heat map
ggmap(de_map_g_str, extent = "device") + 
  geom_density2d(data = geo_data, aes(x = lon, y = lat), size = 0.3) + 
  stat_density2d(data = geo_data, aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), 
                 size = 0.01, bins = 16, geom = "polygon") + 
  scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)



## ----echo=FALSE---------------------------------------------------------------------------------------------------
head(mtcars,6)


## ----echo=FALSE,message=FALSE, warning=FALSE, error=FALSE---------------------------------------------------------
library(psych)
as.data.frame(psych::describe(select(mtcars, hp, mpg, qsec)))


## ----echo=FALSE---------------------------------------------------------------------------------------------------
table(mtcars$carb)


## ----echo=FALSE---------------------------------------------------------------------------------------------------
hist(mtcars$mpg,xlab="miles per gallon", main="miles per gallon")


## ---- echo=FALSE,strip.white=TRUE, out.width="50%"----------------------------------------------------------------
boxplot(mtcars$mpg, outline = T, notch = F)

