




# Group project

Die Informationen zum Gruppenprojekt entnehmen Sie bitte der .Rmd-Datei in dem entsprechenden Assignment auf Canvas. Verwenden Sie R, um die Aufgaben zu loesen. Wenn Sie mit der Bearbeitung fertig sind, klicken Sie auf den "Knit to HTML" Button oben in der Menueleiste in R. Dadurch wird ein HTML-Dokument in dem Ordner erstellt, in dem die group_project.Rmd Datei gespeichert ist. Oeffnen Sie diese Datei im Browser um zu testen, ob der Inhalt korrekt dargestellt wird. Wenn der Output korrekt ist, reichen Sie die .html Datei ueber Learn ein. Den Dateinamen sollten sie wie folgt waehlen: "group_project_groupID.html".

As a marketing manager of a music streaming service, you are set the task to derive insights from data using different quantitative analyses.   

The following variables are available to you:

- playlist_id: unique ID per playlist
- playlist_owner: curator of playlist
- playlist_name: name of playlist
- playlist_follower: number of playlist follower
- spotify_pl: 1 if playlist is curated by Spotify, 0 else
- major_pl: 1 if playlist is curated by major label, 0 else
- artist_pl: 1 if playlist is artist specific (e.g., "this is..." playlists), 0 else
- german_pl: 1 if playlist contains high share of german content, 0 else
- context_pl: 1 if playlist is curated according to a context (e.g., running, cooking, commuting, etc.), 0 else
- content_pl: 1 if playlist is curated accoridng to content (e.g., genre), 0 else
- ranking_pl: 1 if playlist is ranking-based (e.g., top 100 DE charts), 0 else
- artist_fame: avg. artist popularity of artists on playlist
- avg_song_age: avg. week since release of songs on playlist
- n_artists_playlist: avg. number of unique artists on playlist
- n_songs_playlist: avg. number of unique songs on playlist
- new_songs_30d: avg. number of new song listings per playlist over the past 30days
- new_song_share: avg. share of new song listings per playlist over the past 30days
- n_genres: avg. number of genres that songs on a playlist are associated with 
- major_share: avg. share of major label content
- n_country_rep: avg. number of countries where the songs on a given playlist come from  
- avg_song_similariy: measure of how similar the songs on a playlist are (higher values = more similar)

Please conduct the following analyses: 

1. Build and estimate a regression model to explain the success of playlist curators in terms of their followers. This means, the variable "playlist_follower" is your dependent variable. As independent (explanatory) variables, you may choose from the remaining variables. Please formally state the regression equation, visualize the relationships between the dependent variable and independent variables using appropriate plots and interpret the model coefficients.   

2. Build and estimate a classification model (i.e., logistic regression) that helps you to classify different playlist types, particularly, to differentiate between playlists that are managed by Spotify and playlists that are managed by other curators. This means, the variable "spotify_pl" is your dependent variable. As independent (explanatory) variables, you can choose from the remainig variables. Please formally state the regression equation, visualize the relationship between the top10 variable and the independent variables using appropriate plots and interpret the model coefficients.

3. You are interested to learn more about whether the independent variables  may be reduced to a smaller set of variables. Conduct a PCA using the 10 variables: artist_fame, avg_song_age, n_artists_playlist, n_songs_playlist, new_songs_30d, new_song_share, n_genres, major_share, n_country_rep, avg_song_similarity. How many components emerge and how can these be interpreted? 

4. You would like to investigate the similarity between playlists and how you could group songs into clusters using the 11 variables: artist_fame, avg_song_age, n_artists_playlist, n_songs_playlist, new_songs_30d, new_song_share, n_genres, major_share, n_country_rep, avg_song_similarity, playlist_follower. Conduct a cluster analysis for the subset of artists provided below. Determine the optimal number of clusters first, then run the cluster analysis using k-means clustering and visualize and interpret the results accordingly. 

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
playlist_data <- read.csv2("https://raw.githubusercontent.com/WU-RDS/RMA2023/main/data/rma_playlist_data.csv",
    sep = ",", header = TRUE, dec = ".")
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
# provide your code here (you can use multiple
# code chunks per question if you like)
```

Interpret the results here!
