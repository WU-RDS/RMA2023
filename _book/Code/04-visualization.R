## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#load and transform data
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


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#table of relative frequencies
table_plot_rel <- as.data.frame(prop.table(table(music_data$genre))) 
head(table_plot_rel)
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
library(plyr)
table_plot_rel <- dplyr::rename(table_plot_rel, "Genre" = "Var1")
head(table_plot_rel)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#create a bar chart - step by step
bar_chart <- ggplot(table_plot_rel, aes(x = Genre,y = Freq))
bar_chart
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.0f%%", Freq * 100)), vjust=-0.2) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_bw()
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() +
  ylab("Relative frequency") + 
  xlab("Genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=0.75)) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
bar_chart + geom_col() +
  labs(x = "Genre", y = "Relative frequency", title = "Chart songs by genre") + 
  geom_text(aes(label = sprintf("%.1f%%", Freq/sum(Freq) * 100)), vjust=-0.2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle=45,vjust=0.75),
        plot.title = element_text(hjust = 0.5, color = "#666666")
        ) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
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
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
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
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#save a plot
ggsave("test_plot.jpg", height = 5, width = 8.5)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#use pre defined themes
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
#visualize conditional relative frequencies
table_plot_cond_rel <- as.data.frame(prop.table(table(select(music_data, genre, explicit)),2)) #conditional relative frequencies
table_plot_cond_rel
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
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

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
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

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#create a histogram
music_data |>
  filter(genre=="R&B") |>
  ggplot(aes(streams)) + 
    geom_histogram(binwidth = 20000000, col = "black", fill = "darkblue") + 
    labs(x = "Number of streams", y = "Frequency", title = "Distribution of streams") + 
    theme_bw()
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#add vertical reference lines
music_data |>
  filter(genre=="R&B") |>
ggplot(aes(streams)) + 
  geom_histogram(binwidth = 20000000, col = "black", fill = "darkblue") + 
  labs(x = "Number of streams", y = "Frequency", title = "Distribution of streams", subtitle = "Red vertical line = mean, green vertical line = median") + 
  geom_vline(aes(xintercept = mean(streams)), color = "red", size = 1) +
  geom_vline(aes(xintercept = median(streams)), color = "green", size = 1) +
  theme_bw()

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#boxplot
#transform streams variable
music_data$log_streams <- log(music_data$streams)
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(music_data,aes(x = fct_reorder(genre, log_streams), y = log_streams)) +
  geom_boxplot(coef = 3) + 
  labs(x = "Genre", y = "Number of streams (log-scale)") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle=45,vjust=1.1,hjust=1),
        plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
        ) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
# flix axes
ggplot(music_data,aes(x = log_streams, y = fct_reorder(genre, log_streams))) +
  geom_boxplot(coef = 3) + 
  labs(x = "Number of streams (log-scale)", y = "Genre") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5,color = "#666666"),
        legend.position = "none"
        ) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#add individual data points
ggplot(music_data,aes(x = log_streams , y = fct_reorder(genre, log_streams))) +
  geom_jitter(colour="red", alpha = 0.1) +
  geom_boxplot(coef = 3, alpha =0.1) + 
  labs(x = "Number of streams (log-scale)", y = "Genre") + 
  theme_minimal() 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#single boxplot
ggplot(music_data,aes(x = log_streams, y = "")) +
  geom_boxplot(coef = 3,width=0.3) + 
  labs(x = "Number of streams (log-scale)", y = "") 

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#bar charts with error bars
music_data$genre_dummy <- as.factor(ifelse(music_data$genre=="HipHop/Rap","HipHop & Rap","other"))
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
library(Rmisc)
mean_data <- summarySE(music_data, measurevar="streams", groupvars=c("genre_dummy"))
mean_data
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(mean_data,aes(x = genre_dummy, y = streams)) + 
  geom_bar(position=position_dodge(.9), colour="black", fill = "#CCCCCC", stat="identity", width = 0.65) +
  geom_errorbar(position=position_dodge(.9), width=.15, aes(ymin=streams-ci, ymax=streams+ci)) +
  theme_bw() +
  labs(x = "Genre", y = "Average number of streams", title = "Average number of streams by genre")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#grouped bar chart
mean_data2 <- summarySE(music_data, measurevar="streams", groupvars=c("genre_dummy","explicit"))
mean_data2
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(mean_data2,aes(x = genre_dummy, y = streams, fill = explicit)) + 
  geom_bar(position=position_dodge(.9), colour="black", stat="identity") +
  geom_errorbar(position=position_dodge(.9), width=.2, aes(ymin=streams-ci, ymax=streams+ci)) +
  scale_fill_manual(values=c("#CCCCCC","#FFFFFF")) +
  theme_bw() +
  labs(x = "Genre", y = "Average number of streams", title = "Average number of streams by genre and lyric type")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#scatter plot
ggplot(music_data, aes(speechiness, log_streams)) + 
  geom_point(shape =1) +
  labs(x = "Genre", y = "Relative frequency") + 
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) +
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot of streams and speechiness") + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#grouped scatter plot
ggplot(music_data, aes(speechiness, log_streams, colour = explicit)) +
  geom_point(shape =1) + 
  geom_smooth(method="lm", alpha = 0.1) + 
  labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot of streams and speechiness by lyric type", colour="Explicit") + 
  scale_color_manual(values=c("lightblue","darkblue")) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------------------------------------------

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#line plot
music_data_ctry <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/streaming_charts_ctry.csv", 
                              sep = ",", 
                              header = TRUE) |>
  mutate(week = as.Date(week),
         region = as.factor(region))
head(music_data_ctry)

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data_at <- filter(music_data_ctry, region == 'at')
ggplot(music_data_at, aes(x = week, y = streams)) + 
  geom_line() + 
  labs(x = "", y = "Total streams in Austria", title = "Weekly number of streams in Austria") +
  theme_bw() +
  scale_y_continuous(labels = scales::label_comma()) +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#line plot by group
music_data_at_compare <- filter(music_data_ctry, region %in% c('at','de','ch','se','dk','nl'))
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(music_data_at_compare, aes(x = week, y = streams, color = region)) + 
  geom_line() + 
  labs(x = "Week", y = "Total streams", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) +
  scale_y_continuous(labels = scales::label_comma())
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000)) + 
  geom_line() + 
  facet_wrap(~region, scales = "free_y") +
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#area plot
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000)) + 
  geom_area(fill = "steelblue", color = "steelblue", alpha = 0.5) + 
  facet_wrap(~region, scales = "free_y") +
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#stacked area plot
ggplot(music_data_at_compare, aes(x = week, y = streams/1000000,group=region,fill=region,color=region)) + 
  geom_area(position="stack",alpha = 0.65) + 
  labs(x = "Week", y = "Total streams (in million)", title = "Weekly number of streams by country") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#add second y-axis
music_data_at_se_compare <- filter(music_data_ctry, region %in% c('at','se'))
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
library(tidyr)
data_wide <- pivot_wider(music_data_at_se_compare, names_from = region, values_from = streams)
data_wide
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ratio <- mean(data_wide$at/1000000)/mean(data_wide$se/1000000)
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
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

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#ggstatsplot package for statistical outputs
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

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#combine different plot types
library(ggExtra)
p <- ggplot(music_data, aes(x = speechiness, y = log_streams)) + 
  geom_point() +
    labs(x = "Speechiness", y = "Number of streams (log-scale)", title = "Scatterplot & histograms of streams and speechiness") + 
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
ggExtra::ggMarginal(p, type = "histogram")

