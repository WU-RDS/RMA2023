---
output:
  html_document:
    toc: yes
  pdf_document:
    toc: yes
  html_notebook: default
---





# Cluster analysis

**In progress**

<img src="./images/cluster.PNG" width="25%" style="display: block; margin: auto;" />

In the previous chapter on factor analysis we tried to reduce the number of variables or columns by identifying underlying dimensions. In order to do so we exploited the fact that some items are highly correlated and therefore might represent the same underlying concept (e.g., health benefits or social benefits). Similarly, in cluster analysis we again do not distinguish between dependent and independent variables. However, in the case of cluster analysis we do not try to reduce the number of variables but the number of observations by grouping similar ones into "clusters". What exactly defines "similarity" depends on the use case. In the case of music audio features of songs might be used to identify clusters of similar songs (similar to the genre classification) which can be used for recommendation systems. Other use cases are customer segmentation and anomaly (e.g., fraud) detection.

Let's try to create a recommendation system using track features. In our data we have the ISRC, name of the track, name of the artist and audio features of the track. We are going to use the audio features to cluster tracks together such that given one track we can easily identify similar tracks by looking at which cluster it belongs to.


```r
load(url("https://github.com/WU-RDS/MRDA2021/raw/main/trackfeatures.RData"))
# remove duplicates
tracks <- na.omit(tracks[!duplicated(tracks$isrc), 
    ])
```

To get an idea of how clustering might work let's first take a look at just  with two variables, energy and acousticness, and two artists, Robin Schulz and Adele. We immediately see that Adele's songs are more to the top left (high acousticness, low energy) whereas Robin Schulz's songs are mostly on the bottom right (low acousticness, high energy).


```r
library(ggplot2)
library(stringr)
robin_schulz <- tracks[str_detect(tracks$artistName, 
    "Robin Schulz"), ]
robin_schulz$artist <- "Robin Schulz"
adele <- tracks[str_detect(tracks$artistName, "Adele"), 
    ]
adele$artist <- "Adele"

example_tracks <- rbind(robin_schulz, adele)
ggplot(example_tracks, aes(x = energy, y = acousticness, 
    color = artist)) + geom_point()
```

<img src="13-cluster_analysis_files/figure-html/unnamed-chunk-5-1.png" width="672" />

## K-Means

One of the most popular algorithms for clustering is the **K-means** algorithm. The "K" stands for the number of clusters that are specified as a hyperparameter (more on how to set that parameter later). The algorithm then tries to separate the observations into K clusters such that the variance of the features (e.g., our audio features) is minimized. Therefore, it is important to `scale` all variables before performing clustering such that they all contribute equally to the  distance between the observations. Intuitively the algorithm groups observations by iteratively calculating the mean or center of each cluster, assigning each observation to the cluster with the closest mean and re-calculating the mean... The algorithm has "converged" (i.e., is done) when the assignments no longer change. 
Let's try it out with our two artists. In order to perform clustering we first have to remove all missing values from the used variables as for those we cannot calculate distances. Because we know that there are two artists in the sample we will start with two clusters.


```r
library(cluster)

tracks_scale <- data.frame(artist = example_tracks$artist, 
    energy = scale(example_tracks$energy), acousticness = scale(example_tracks$acousticness))
tracks_scale <- na.omit(tracks_scale)
kmeans_clusters <- kmeans(tracks_scale[-1], 2)
kmeans_clusters$centers
```

```
##      energy acousticness
## 1 -1.439466    1.3234653
## 2  0.500684   -0.4603358
```

The `kmeans` function returns, among other statistics, the centers of each cluster and a cluster identifier for each observation which we can add to our original data. In our case one cluster's center is rather low in energy and high acousticness and the second one has higher energy and lower acousticness. 

In our plot we can add a color for each cluster and a different marker shape for each artist. We observe that cluster 1 corresponds mostly to Robin Schulz songs and cluster 2 mostly to Adele. Alternatively we can also look at the counts in each cluster per artist using the `table` function.


```r
tracks_scale$cluster <- as.factor(kmeans_clusters$cluster)
ggplot(tracks_scale, aes(x = energy, y = acousticness, 
    color = cluster, shape = artist)) + geom_point(size = 3)
```

<img src="13-cluster_analysis_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```r
table(tracks_scale$artist, tracks_scale$cluster)
```

```
##               
##                 1  2
##   Adele        14  9
##   Robin Schulz  2 37
```

In the previous example it was easy to set the number of clusters. However, if we use all artists in our data the best value for "K" is not immediately obvious. Surely some artists should be in the same cluster. We can user the `NbClust` package to determine the best number of clusters according to various indices (see `?NbClust`). First we scale all our variables and then we use the scaled versions to determine "K". To make computations faster we will use songs by 6 famous artists. Then we count how many indices would choose a certain number of clusters. The two best candidates are 2 clusters, chosen by 8 indices and 8 clusters, chosen by 5 indices.


```r
library(NbClust)
```

```
## Warning: Paket 'NbClust' wurde unter R Version 4.0.3 erstellt
```

```r
famous_artists <- c("Ed Sheeran", "Eminem", "Rihanna", 
    "Taylor Swift", "BTS", "Queen")
famous_tracks <- tracks[tracks$artistName %in% famous_artists, 
    ]
famous_tracks_scale <- scale(famous_tracks[4:ncol(famous_tracks)])
set.seed(123)
opt_K <- NbClust(famous_tracks_scale, method = "kmeans", 
    max.nc = 10)
```

<img src="13-cluster_analysis_files/figure-html/unnamed-chunk-8-1.png" width="672" />

```
## *** : The Hubert index is a graphical method of determining the number of clusters.
##                 In the plot of Hubert index, we seek a significant knee that corresponds to a 
##                 significant increase of the value of the measure i.e the significant peak in Hubert
##                 index second differences plot. 
## 
```

<img src="13-cluster_analysis_files/figure-html/unnamed-chunk-8-2.png" width="672" />

```
## *** : The D index is a graphical method of determining the number of clusters. 
##                 In the plot of D index, we seek a significant knee (the significant peak in Dindex
##                 second differences plot) that corresponds to a significant increase of the value of
##                 the measure. 
##  
## ******************************************************************* 
## * Among all indices:                                                
## * 8 proposed 2 as the best number of clusters 
## * 3 proposed 3 as the best number of clusters 
## * 1 proposed 4 as the best number of clusters 
## * 1 proposed 6 as the best number of clusters 
## * 4 proposed 7 as the best number of clusters 
## * 5 proposed 8 as the best number of clusters 
## * 2 proposed 10 as the best number of clusters 
## 
##                    ***** Conclusion *****                            
##  
## * According to the majority rule, the best number of clusters is  2 
##  
##  
## *******************************************************************
```

```r
table(opt_K$Best.nc["Number_clusters", ])
```

```
## 
##  0  2  3  4  6  7  8 10 
##  2  8  3  1  1  4  5  2
```

A great library for visualizing many statistical analysis results in `ggfortify`. We can use it to plot the results of `kmeans`. In order to get the artists as labels we set them to be the `rownames` of our scaled data matrix.




```r
rownames(famous_tracks_scale) <- famous_tracks$artistName
kmeans_tracks <- kmeans(famous_tracks_scale, 8)
```



```r
famous_tracks$cluster <- as.factor(kmeans_tracks$cluster)
ggplot(famous_tracks, aes(y = cluster, fill = artistName)) + 
    geom_bar()
```

<img src="13-cluster_analysis_files/figure-html/unnamed-chunk-10-1.png" width="672" />

```r
table(famous_tracks$artistName, famous_tracks$cluster)
```

```
##               
##                 1  2  3  4  5  6  7  8
##   BTS           3 45 26  7 17  7 17  2
##   Ed Sheeran   30  0 12  0  8  0  9  0
##   Eminem        2  2 17 10  1  0 10  3
##   Queen         6  4  6  4  2  0  1  1
##   Rihanna       1  4  4  1  0  0  5  0
##   Taylor Swift 35  7 22  1 42  0  3  1
```


```r
ed <- famous_tracks[famous_tracks$cluster %in% c(1, 
    4) & famous_tracks$artistName == "Ed Sheeran", 
    ]
ggplot(ed, aes(x = valence, y = loudness, color = cluster)) + 
    geom_point()
```

<img src="13-cluster_analysis_files/figure-html/unnamed-chunk-11-1.png" width="672" />

