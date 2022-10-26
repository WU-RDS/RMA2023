




# Group project

Die Informationen zum Gruppenprojekt entnehmen Sie bitte der .Rmd-Datei in dem entsprechenden Assignment auf Learn. Verwenden Sie R, um die Aufgaben zu loesen. Wenn Sie mit der Bearbeitung fertig sind, klicken Sie auf den "Knit to HTML" Button oben in der Menueleiste in R. Dadurch wird ein HTML-Dokument in dem Ordner erstellt, in dem die group_project.Rmd Datei gespeichert ist. Oeffnen Sie diese Datei im Browser um zu testen, ob der Inhalt korrekt dargestellt wird. Wenn der Output korrekt ist, reichen Sie die .html Datei ueber Learn ein. Den Dateinamen sollten sie wie folgt waehlen: "group_project_groupID.html".


As a marketing manager of a music streaming service, you are set the task to derive insights from data using different quantitative analyses.   

The following variables are available to you:

The data set contains the following variables:

* isrc = unique song id
* artist_id = unique artist ID
* streams = the number of streams of the song received globally between 2017-2021
* weeks_in_charts = the number of weeks the song was in the top200 charts in this period
* n_regions = the number of markets where the song appeared in the top200 charts
* danceability
* energy
* speechiness
* instrumentalness
* liveness
* valence
* tempo
* song_length = the duration of the song (in minutes)
* song_age = the age of the song (in weeks since release)
* explicit = indicator for explicit lyrics
* n_playlists = number of playlists a song is featured on
* sp_popularity = the Spotify popularity index of an artist
* youtube_views = the number of views the song received on YouTube
* tiktok_counts = the number of Tiktok views the song received on TikTok
* ins_followers_artist = the number of Instagram followers of the artist
* monthly_listeners_artist = the number of monthly listeners of an artist
* playlist_total_reach_artist = the number of playlist followers of the playlists the song is on
* sp_fans_artist = the number of fans of the artist on Spotify
* shazam_counts = the number of times a song is shazamed
* artistName = name of the artist
* trackName = name of the song
* release_date = release date of song
* genre = genre associated with the song
* label = music label associated with the song
* top10 = indicator variable, indicating if a song made it to the top10

Please conduct the following analyses: 

1. Build and estimate a linear regression model to explain the success of songs in terms of their streams. This means, the variable "streams"" is your dependent variable. As independent (explanatory) variables, you should include the variables "weeks_in_charts", "song_age" and "label". In addition to these 3 variables you should identify 5 more variables that have a significant effect on the number of streams. Please visualize the relationship between streams and the independent variables using appropriate plots and interpret the model coefficients.   

2. Build and estimate a classification model (i.e., logistic regression) to explain the success of songs in terms of the chart position (i.e., if a song made it to the top 10 or not). This means, the variable "top10"" is your dependent variable. As independent (explanatory) variables, you should include the variables "weeks_in_charts", "song_age" and "label". In addition to these 3 variables you should identify 5 more variables that have a significant effect on the chart performance. Please visualize the relationship between the top10 variable and the independent variables using appropriate plots and interpret the model coefficients.

3. You are interested to learn more about the interdependencies between the social media variables that you and if the variables may be reduced to a smaller set of variables. Conduct a PCA using the 9 social media variables in the data set: n_playlists, sp_popularity, youtube_views, tiktok_counts, ins_followers_artist, monthly_listeners_artist, playlist_total_reach_artist, sp_fans_artist, shazam_counts. How many components emerge and how can these be interpreted? 

4. You would like to investigate the similarity between songs of the top artists and how you could group songs into clusters by their musical features. Conduct a cluster analysis for the subset of artists provided below. Determine the optimal number of clusters first, then run the cluster analysis using k-means clustering and visualize and interpret the results accordingly. 

When you are done with your analysis, click on "Knit to HTML" button above the code editor. This will create a HTML document of your results in the folder where the "group_project.Rmd" file is stored. Open this file in your Internet browser to see if the output is correct. If the output is correct, submit the HTML file via Learn\@WU. The file name should be "group_assignment_group_id.html".

## Data analysis

## Load data


```r
library(ggplot2)
library(psych)
library(dplyr)
library(ggiraph)
library(ggiraphExtra)
library(NbClust)
library(factoextra)
library(GPArotation)
options(scipen = 999)
set.seed(123)
music_data <- read.csv2("https://raw.githubusercontent.com/WU-RDS/RMA2022/main/data/music_data_group.csv",
    sep = ";", header = TRUE, dec = ",")
music_data$genre <- as.factor(music_data$genre)
music_data$label <- as.factor(music_data$label)
str(music_data)
```

```
## 'data.frame':	66796 obs. of  30 variables:
##  $ isrc                       : chr  "BRRGE1603547" "USUM71808193" "ES5701800181" "ITRSE2000050" ...
##  $ artist_id                  : int  3679 5239 776407 433730 526471 1939 210184 212546 4938 119985 ...
##  $ streams                    : num  11944813 8934097 38835 46766 2930573 ...
##  $ weeks_in_charts            : int  141 51 1 1 7 226 13 1 64 7 ...
##  $ n_regions                  : int  1 21 1 1 4 8 1 1 5 1 ...
##  $ danceability               : num  50.9 35.3 68.3 70.4 84.2 35.2 73 55.6 71.9 34.6 ...
##  $ energy                     : num  80.3 75.5 67.6 56.8 57.8 91.1 69.6 24.5 85 43.3 ...
##  $ speechiness                : num  4 73.3 14.7 26.8 13.8 7.47 35.5 3.05 3.17 6.5 ...
##  $ instrumentalness           : num  0.05 0 0 0.000253 0 0 0 0 0.02 0 ...
##  $ liveness                   : num  46.3 39 7.26 8.91 22.8 9.95 32.1 9.21 11.4 10.1 ...
##  $ valence                    : num  65.1 43.7 43.4 49.5 19 23.6 58.4 27.6 36.7 76.8 ...
##  $ tempo                      : num  166 191.2 99 91 74.5 ...
##  $ song_length                : num  3.12 3.23 3.02 3.45 3.95 ...
##  $ song_age                   : num  228.3 144.3 112.3 50.7 58.3 ...
##  $ explicit                   : int  0 0 0 0 0 0 0 0 1 0 ...
##  $ n_playlists                : int  450 768 48 6 475 20591 6 105 547 688 ...
##  $ sp_popularity              : int  51 54 32 44 52 81 44 8 59 68 ...
##  $ youtube_views              : num  145030723 13188411 6116639 0 0 ...
##  $ tiktok_counts              : int  9740 358700 0 13 515 67300 0 0 653 3807 ...
##  $ ins_followers_artist       : int  29613108 3693566 623778 81601 11962358 1169284 1948850 39381 9751080 343 ...
##  $ monthly_listeners_artist   : int  4133393 18367363 888273 143761 15551876 16224250 2683086 1318874 4828847 3088232 ...
##  $ playlist_total_reach_artist: int  24286416 143384531 4846378 156521 90841884 80408253 7332603 24302331 8914977 8885252 ...
##  $ sp_fans_artist             : int  3308630 465412 23846 1294 380204 1651866 214001 10742 435457 1897685 ...
##  $ shazam_counts              : int  73100 588550 0 0 55482 5281161 0 0 39055 0 ...
##  $ artistName                 : chr  "Luan Santana" "Alessia Cara" "Ana Guerra" "Claver Gold feat. Murubutu" ...
##  $ trackName                  : chr  "Eu, VocÃª, O Mar e Ela" "Growing Pains" "El Remedio" "Ulisse" ...
##  $ release_date               : chr  "2016-06-20" "2018-06-14" "2018-04-26" "2020-03-31" ...
##  $ genre                      : Factor w/ 11 levels "Classics/Jazz",..: 6 7 7 5 5 10 5 7 7 7 ...
##  $ label                      : Factor w/ 4 levels "Independent",..: 1 3 3 1 3 3 3 1 1 3 ...
##  $ top10                      : int  1 0 0 0 0 1 0 0 0 0 ...
```

## Question 1

Provide a description of your steps here! 


```r
# provide your code here (you can use multiple
# code chunks per question if you like)
```

Interpret the results here!

## Question 2

Provide a description of your steps here!


```r
# provide your code here (you can use multiple
# code chunks per question if you like)
```

Interpret the results here!

## Question 3

Provide a description of your steps here!


```r
# provide your code here (you can use multiple
# code chunks per question if you like)
```

Interpret the results here!

## Question 4

Provide a description of your steps here! 
 

```r
famous_artists <- c("Ed Sheeran", "Drake", "Post Malone",
    "Ariana Grande", "Billie Eilish", "Dua Lipa", "Travis Scott",
    "Taylor Swift", "Imagine Dragons", "Selena Gomez",
    "Ozuna", "Justin Bieber", "Coldplay", "Eminem")
famous_tracks <- music_data %>%
    filter(artistName %in% famous_artists)
famous_tracks_scale <- famous_tracks %>%
    mutate_at(vars(danceability:song_age), scale)
famous_tracks_scale <- famous_tracks_scale %>%
    mutate_at(vars(danceability:song_age), as.vector)
set.seed(123)
```

Interpret the results here!
