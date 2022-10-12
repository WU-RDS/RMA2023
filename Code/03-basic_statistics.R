## ----echo=FALSE, eval=TRUE, message=FALSE, warning=FALSE-------------------------
library(knitr)
options(scipen = 999)
#This code automatically tidies code so that it does not reach over the page
opts_chunk$set(tidy.opts=list(width.cutoff=50),tidy=TRUE, rownames.print = FALSE, rows.print = 10)
opts_chunk$set(cache=T)




## ---- message=FALSE, warning=FALSE, eval=TRUE, cache=TRUE------------------------
# read.csv2 is shorthand for read.csv(file, sep = ";")
music_data <- read.csv2("https://short.wu.ac.at/ma22_musicdata")
dim(music_data)
head(music_data)
names(music_data)


## ---- message=FALSE, warning=FALSE, eval=TRUE------------------------------------
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


## ---- message=FALSE, warning=FALSE, eval=TRUE------------------------------------
table(music_data$genre) #absolute frequencies
table(music_data$label) #absolute frequencies
table(music_data$explicit) #absolute frequencies


## ---- message=FALSE, warning=FALSE, eval=TRUE------------------------------------
prop.table(table(music_data$genre)) #relative frequencies
prop.table(table(music_data$label)) #relative frequencies
prop.table(table(music_data$explicit)) #relative frequencies

## ----include=FALSE---------------------------------------------------------------
warner_share <- prop.table(table(music_data$label))
warner_share <- round(100*warner_share[names(warner_share) == "Warner Music"], digits = 1)
rock_share <- prop.table(table(music_data$genre))
rock_share <- round(100*rock_share[names(rock_share) == "Rock"], digits = 1)
explicit_share <- prop.table(table(music_data$explicit))
explicit_share <- round(100*explicit_share[names(explicit_share) == "explicit"], digits = 1)


## ---- message=FALSE, warning=FALSE, eval=TRUE------------------------------------
prop.table(table(select(music_data, genre, explicit)),1) #conditional relative frequencies


## ---- message=FALSE, warning=FALSE, eval=TRUE------------------------------------
median_rating <- quantile(music_data$expert_rating, 0.5, type = 1)
median_rating


## ---- message=FALSE, warning=FALSE, eval=TRUE------------------------------------
quantile(music_data$expert_rating,c(0.25,0.5,0.75), type = 1)


## ----echo=TRUE, message=FALSE, warning=FALSE, eval=TRUE--------------------------
percentiles <- c(0.25, 0.5, 0.75)
rating_percentiles <- music_data |>
  group_by(explicit) |>
  summarize(
    percentile = percentiles,
    value = quantile(expert_rating, percentiles, type = 1)) 
rating_percentiles


## ----message=FALSE, warning=FALSE, paged.print = FALSE---------------------------
library(psych)
psych::describe(select(music_data, streams, danceability, valence))


## ----message=FALSE, warning=FALSE------------------------------------------------
describeBy(select(music_data, streams, danceability, valence), music_data$genre,skew = FALSE, range = FALSE)


## ---- echo=FALSE, message=FALSE, warning=FALSE, results='asis'-------------------
library(summarytools)
st_css()


## ---- message=FALSE, error = FALSE, warning = FALSE, results='asis'--------------
library(summarytools)
print(dfSummary(select(music_data, streams, valence, genre, label, explicit), plain.ascii = FALSE, style = "grid",valid.col = FALSE, tmp.img.dir = "tmp", graph.magnif = .65),  method = 'render',headings = FALSE,footnote= NA)


## ----message=FALSE, warning=FALSE------------------------------------------------
music_data_valence <- filter(music_data, !is.na(valence))


## ----echo=FALSE,out.width = '70%',fig.align='center',fig.cap = "Standard normal table"----
knitr::include_graphics("./images/prob_table.JPG")


## ----echo=FALSE,out.width = '70%',fig.align='center',fig.cap = "Standard normal distribution"----
knitr::include_graphics("./images/normal_distribution.JPG")


## ----message=FALSE, warning=FALSE,fig.align='center',fig.cap = "Histogram of tempo variable"----
hist(music_data$tempo)


## ----message=FALSE, warning=FALSE------------------------------------------------
music_data$tempo_std <- (music_data$tempo - mean(music_data$tempo))/sd(music_data$tempo)


## ----message=FALSE, warning=FALSE,fig.align='center',fig.cap = "Histogram of standardized tempo variable"----
hist(music_data$tempo_std)


## ----message=FALSE, warning=FALSE------------------------------------------------
music_data$tempo_std <- scale(music_data$tempo)


## ----message=FALSE, warning=FALSE------------------------------------------------
pnorm(-1.96)


## ----message=FALSE, warning=FALSE------------------------------------------------
pnorm(-1.96)*2


## ----message=FALSE, warning=FALSE------------------------------------------------
min(music_data$tempo_std)


## ----message=FALSE, warning=FALSE------------------------------------------------
pnorm(min(music_data$tempo_std))*2


## ----echo=FALSE,out.width = '70%',fig.align='center',fig.cap = "The 68, 95, 99.7 rule (source: Wikipedia)"----
knitr::include_graphics("./images/prob_rule.JPG")

