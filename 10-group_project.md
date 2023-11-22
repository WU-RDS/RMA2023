

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
  
1. You are interested to understand what curation decisions drive the success of playlists. TO this end, build and estimate a regression model to explain the success of playlist curators in terms of their followers. This means, the variable "playlist_follower" is your dependent variable. As independent (explanatory) variables, you may choose from the remaining variables. Decide based on appropriate criteria between a linear model specification and a non-linear model specification (i.e., using log-transformation). After you have decided for the model specification, please formally state the regression equation, visualize the relationships between the dependent variable and independent variables using appropriate plots and interpret the model coefficients. Which model variables have a significant influence on the dependent variable? How do you judge the fit of the model? 

2. Build and estimate a classification model (i.e., logistic regression) that helps you to classify different playlist types, particularly, to differentiate between playlists that are managed by Spotify and playlists that are managed by other curators. This means, the variable "spotify_pl" is your dependent variable. As independent (explanatory) variables, you can choose from the remaining variables. Please formally state the regression equation, visualize the relationship between the top10 variable and the independent variables using appropriate plots and interpret the model coefficients. Which of the independent variable help you to differentiate between the playlist types? 

3. You are interested to learn more about whether the independent variables  may be reduced to a smaller set of variables. Conduct a PCA using the 10 variables: artist_fame, avg_song_age, n_artists_playlist, n_songs_playlist, new_songs_30d, new_song_share, n_genres, major_share, n_country_rep, avg_song_similarity. How many components emerge and how can these be interpreted? Please conduct the tests discussed in class to see if PCA is appropriate for this data. 
  
4. You would like to investigate the similarity between playlists and how you could group songs into clusters using the 11 variables: artist_fame, avg_song_age, n_artists_playlist, n_songs_playlist, new_songs_30d, new_song_share, n_genres, major_share, n_country_rep, avg_song_similarity, playlist_follower. Conduct a cluster analysis for the subset of artists provided below. Determine the optimal number of clusters first, then run the cluster analysis using k-means clustering and visualize and interpret the results accordingly. Imagine you would like to recommend a playlist to a user that is most similar to the playlist "80s SMASH HITS" curated by "myplay.com". Which playlist would you recommend?  

When you are done with your analysis, click on "Knit to HTML" button above the code editor. This will create a HTML document of your results in the folder where the "group_project.Rmd" file is stored. Open this file in your Internet browser to see if the output is correct. If the output is correct, submit the HTML file via Canvas. The file name should be "group_assignment_group_id.html".

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
head(playlist_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["playlist_id"],"name":[1],"type":["chr"],"align":["left"]},{"label":["playlist_owner"],"name":[2],"type":["chr"],"align":["left"]},{"label":["playlist_name"],"name":[3],"type":["chr"],"align":["left"]},{"label":["spotify_pl"],"name":[4],"type":["int"],"align":["right"]},{"label":["major_pl"],"name":[5],"type":["int"],"align":["right"]},{"label":["artist_pl"],"name":[6],"type":["int"],"align":["right"]},{"label":["german_pl"],"name":[7],"type":["int"],"align":["right"]},{"label":["context_pl"],"name":[8],"type":["int"],"align":["right"]},{"label":["content_pl"],"name":[9],"type":["int"],"align":["right"]},{"label":["ranking_pl"],"name":[10],"type":["int"],"align":["right"]},{"label":["playlist_follower"],"name":[11],"type":["int"],"align":["right"]},{"label":["artist_fame"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["avg_song_age"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["n_artists_playlist"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["n_songs_playlist"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["new_songs_30d"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["new_song_share"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["n_genres"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["major_share"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["n_country_rep"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["avg_song_similarity"],"name":[21],"type":["dbl"],"align":["right"]}],"data":[{"1":"00BTx3ggFpepiYT4T9sdo5","2":"beengan","3":"Metal Gym Hours","4":"0","5":"0","6":"0","7":"0","8":"0","9":"1","10":"0","11":"168495","12":"131.99405","13":"284.31648","14":"59.745223","15":"66.63057","16":"6.000000","17":"0.096235978","18":"4.203822","19":"0.5836797","20":"12.121019","21":"0.7494937"},{"1":"00e2vXzWaSmxJ1Fga6l2ug","2":"logansandberg","3":"Party - Breathe - Jax Jones - Vigiland Friday Night Axwell /\\\\ Ingrosso More Than You Know","4":"0","5":"0","6":"0","7":"0","8":"1","9":"0","10":"0","11":"221068","12":"301.35776","13":"148.78716","14":"75.617834","15":"108.10828","16":"24.821656","17":"0.212003765","18":"8.152866","19":"0.8629232","20":"21.318471","21":"0.7008787"},{"1":"00sP0XsnG64tXgaBUJ8u2c","2":"darrenorourk","3":"Hipster Morning","4":"0","5":"0","6":"0","7":"0","8":"0","9":"0","10":"0","11":"52154","12":"1549.48528","13":"424.48640","14":"266.675159","15":"413.76433","16":"1.853503","17":"0.004484624","18":"13.821656","19":"0.6208318","20":"23.821656","21":"0.5517421"},{"1":"00t68Ndg5LJHxmKKE8LPXI","2":"theedgenz","3":"The Edge Fat 40","4":"0","5":"0","6":"0","7":"0","8":"0","9":"0","10":"0","11":"22334","12":"781.04395","13":"29.24226","14":"36.191083","15":"39.92357","16":"21.363057","17":"0.535719992","18":"7.936306","19":"0.7993758","20":"9.292994","21":"0.5973310"},{"1":"012Jm4s6ckHWnKqs1d4ZIv","2":"sonymusicaustralia","3":"R N Beats","4":"0","5":"1","6":"0","7":"0","8":"0","9":"1","10":"0","11":"17848","12":"73.17763","13":"28.77840","14":"50.388535","15":"62.08280","16":"74.414013","17":"1.198615937","18":"7.732484","19":"0.6529823","20":"7.885350","21":"0.5524443"},{"1":"01DbkmjFPYPeZyw7MxBal5","2":"logicofficial","3":"OCD","4":"0","5":"0","6":"0","7":"0","8":"0","9":"1","10":"0","11":"119139","12":"1.84098","13":"116.40405","14":"1.146497","15":"44.49682","16":"17.515924","17":"0.358885541","18":"3.458599","19":"0.8407240","20":"2.675159","21":"0.5453239"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

## Question 1

Provide a description of your steps here! 
  

```r
# provide your code here
```

Interpret the results here!
  
## Question 2

Provide a description of your steps here!
  

```r
# provide your code here
```

Interpret the results here!
  
## Question 3
  
Provide a description of your steps here!
  

```r
# provide your code here
```

Interpret the results here!
  
## Question 4
  
Provide a description of your steps here! 
  

```r
# provide your code here
```

Interpret the results here!
  
