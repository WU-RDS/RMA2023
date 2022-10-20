## --------------------------------------------------------------------------------------------------------------------------------------------------------------
# read.csv2 is shorthand for read.csv(file, sep = ";")
music_data <- read.csv2("https://short.wu.ac.at/ma22_musicdata")
dim(music_data)
head(music_data)
names(music_data)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#read and transform data
library(tidyverse)
music_data <- music_data |> # pipe music data into mutate
  mutate(release_date = as.Date(release_date), # convert to date
         explicit = factor(explicit, levels = 0:1, labels = c("not explicit", "explicit")), # convert to factor w. new labels
         label = as.factor(label), # convert to factor with values as labels
         genre = as.factor(genre),
         top10 = as.logical(top10),
         # Create an ordered factor for the ratings (e.g., for arranging the data)
         expert_rating = factor(expert_rating, 
                                levels = c("poor", "fair", "good", "excellent", "masterpiece"), 
                                ordered = TRUE)
         )
head(music_data)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
table(music_data$genre) #absolute frequencies
table(music_data$label) #absolute frequencies
table(music_data$explicit) #absolute frequencies


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
prop.table(table(music_data$genre)) #relative frequencies
prop.table(table(music_data$label)) #relative frequencies
prop.table(table(music_data$explicit)) #relative frequencies


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#some examples
warner_share <- prop.table(table(music_data$label))
warner_share <- round(100*warner_share[names(warner_share) == "Warner Music"], digits = 1)
rock_share <- prop.table(table(music_data$genre))
rock_share <- round(100*rock_share[names(rock_share) == "Rock"], digits = 1)
explicit_share <- prop.table(table(music_data$explicit))
explicit_share <- round(100*explicit_share[names(explicit_share) == "explicit"], digits = 1)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
prop.table(table(select(music_data, genre, explicit)),1) #conditional relative frequencies


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#median rating
median_rating <- quantile(music_data$expert_rating, 0.5, type = 1)
median_rating


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#percentiles
quantile(music_data$expert_rating,c(0.25,0.5,0.75), type = 1)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
percentiles <- c(0.25, 0.5, 0.75)
rating_percentiles <- music_data |>
  group_by(explicit) |>
  summarize(
    percentile = percentiles,
    value = quantile(expert_rating, percentiles, type = 1)) 
rating_percentiles


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#descriptive statistics
library(psych)
psych::describe(select(music_data, streams, danceability, valence))


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#descriptive statistics by group
describeBy(select(music_data, streams, danceability, valence), music_data$genre,skew = FALSE, range = FALSE)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data_valence <- filter(music_data, !is.na(valence))


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
hist(music_data$tempo)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data$tempo_std <- (music_data$tempo - mean(music_data$tempo))/sd(music_data$tempo)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
hist(music_data$tempo_std)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data$tempo_std <- scale(music_data$tempo)

