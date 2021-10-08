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

In the previous example it was easy to set the number of clusters. However, if we use all artists in our data the best value for "K" is not immediately obvious. Surely some artists should be in the same cluster. We can user the `NbClust` package to determine the best number of clusters according to various indices (see `?NbClust`). First we scale all our variables and then we use the scaled versions to determine "K". To make computations faster we will use songs by 6 famous artists. Then we count how many indices would choose a certain number of clusters. The two best candidates are 3 clusters, chosen by 13 indices and 2 clusters, chosen by 5 indices.


```r
library(NbClust)
famous_artists <- c("Ed Sheeran", "Eminem", "Rihanna", 
    "Taylor Swift", "Queen")
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
## * 5 proposed 2 as the best number of clusters 
## * 13 proposed 3 as the best number of clusters 
## * 1 proposed 4 as the best number of clusters 
## * 1 proposed 8 as the best number of clusters 
## * 4 proposed 10 as the best number of clusters 
## 
##                    ***** Conclusion *****                            
##  
## * According to the majority rule, the best number of clusters is  3 
##  
##  
## *******************************************************************
```

```r
table(opt_K$Best.nc["Number_clusters", ])
```

```
## 
##  0  2  3  4  8 10 
##  2  5 13  1  1  4
```

A great library for visualizing many statistical analysis results in `ggfortify`. We can use it to plot the results of `kmeans`. In order to get the artists as labels we set them to be the `rownames` of our scaled data matrix.




```r
rownames(famous_tracks_scale) <- famous_tracks$artistName
kmeans_tracks <- kmeans(famous_tracks_scale, 3)
kmeans_tracks$centers
```

```
##   danceability     energy   loudness       mode speechiness acousticness
## 1    0.2758301  0.4526214  0.4853302 -0.1461378  -0.2576401   -0.5618965
## 2   -0.5385548 -0.9566495 -0.8742383  0.2632910  -0.4147683    0.9772843
## 3    0.3678342  0.7543900  0.4954862 -0.1492974   1.5546155   -0.5015270
##   instrumentalness   liveness    valence       tempo duration_ms
## 1       0.06266324 -0.2524251  0.4012080  0.03789976 -0.09047459
## 2      -0.06816719 -0.2728148 -0.6158085 -0.17761023  0.09754255
## 3      -0.02849344  1.2469257  0.1885188  0.26482862  0.04295692
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
library(plotly)
ed <- famous_tracks[famous_tracks$artistName == "Ed Sheeran", 
    ]
plot_ly(ed, x = ~acousticness, y = ~energy, z = ~valence, 
    color = ~cluster, marker = list(size = 4)) %>% 
    layout(title = "Ed Sheeran")
```

<!--html_preserve--><div id="htmlwidget-b5ed4906484ed42468d8" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-b5ed4906484ed42468d8">{"x":{"visdat":{"c6c614737e":["function () ","plotlyVisDat"]},"cur_data":"c6c614737e","attrs":{"c6c614737e":{"x":{},"y":{},"z":{},"marker":{"size":4},"color":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20]}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Ed Sheeran","scene":{"xaxis":{"title":"acousticness"},"yaxis":{"title":"energy"},"zaxis":{"title":"valence"}},"hovermode":"closest","showlegend":true},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[0.607,0.669,0.559,0.694,0.697,0.64,0.536,0.719,0.914,0.85,0.556,0.877,0.529,0.689,0.565,0.518,0.732,0.638,0.559,0.459,0.886,0.811,0.783,0.453,0.902,0.772,0.791,0.581,0.698,0.77],"y":[0.379,0.289,0.0549,0.328,0.346,0.227,0.385,0.366,0.242,0.29,0.377,0.321,0.316,0.436,0.425,0.26,0.449,0.176,0.0549,0.377,0.31,0.344,0.158,0.529,0.209,0.286,0.349,0.355,0.324,0.396],"z":[0.201,0.407,0.234,0.11,0.359,0.182,0.236,0.181,0.257,0.481,0.336,0.306,0.543,0.446,0.284,0.616,0.506,0.297,0.234,0.394,0.36,0.377,0.455,0.403,0.336,0.379,0.624,0.644,0.273,0.263],"marker":{"color":"rgba(102,194,165,1)","size":4,"line":{"color":"rgba(102,194,165,1)"}},"type":"scatter3d","mode":"markers","name":"1","textfont":{"color":"rgba(102,194,165,1)"},"error_y":{"color":"rgba(102,194,165,1)"},"error_x":{"color":"rgba(102,194,165,1)"},"line":{"color":"rgba(102,194,165,1)"},"frame":null},{"x":[0.474,0.0113,0.0735,0.355,0.0559,0.448,0.52,0.117,0.419,0.162,0.645,0.281],"y":[0.445,0.608,0.876,0.386,0.745,0.76,0.677,0.852,0.652,0.837,0.603,0.859],"z":[0.591,0.849,0.781,0.526,0.862,0.682,0.882,0.858,0.459,0.927,0.619,0.822],"marker":{"color":"rgba(141,160,203,1)","size":4,"line":{"color":"rgba(141,160,203,1)"}},"type":"scatter3d","mode":"markers","name":"3","textfont":{"color":"rgba(141,160,203,1)"},"error_y":{"color":"rgba(141,160,203,1)"},"error_x":{"color":"rgba(141,160,203,1)"},"line":{"color":"rgba(141,160,203,1)"},"frame":null},{"x":[0.0232,0.424,0.163,0.562,0.0089,0.0977,0.464,0.0425],"y":[0.834,0.439,0.448,0.637,0.557,0.649,0.637,0.4],"z":[0.471,0.242,0.168,0.565,0.287,0.184,0.333,0.15],"marker":{"color":"rgba(166,216,84,1)","size":4,"line":{"color":"rgba(166,216,84,1)"}},"type":"scatter3d","mode":"markers","name":"5","textfont":{"color":"rgba(166,216,84,1)"},"error_y":{"color":"rgba(166,216,84,1)"},"error_x":{"color":"rgba(166,216,84,1)"},"line":{"color":"rgba(166,216,84,1)"},"frame":null},{"x":[0.581,0.086,0.251,0.49,0.189,0.304,0.168,0.294,0.0469],"y":[0.652,0.812,0.492,0.4,0.307,0.67,0.872,0.542,0.897],"z":[0.931,0.914,0.895,0.927,0.631,0.939,0.46,0.733,0.591],"marker":{"color":"rgba(229,196,148,1)","size":4,"line":{"color":"rgba(229,196,148,1)"}},"type":"scatter3d","mode":"markers","name":"7","textfont":{"color":"rgba(229,196,148,1)"},"error_y":{"color":"rgba(229,196,148,1)"},"error_x":{"color":"rgba(229,196,148,1)"},"line":{"color":"rgba(229,196,148,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


```r
ed[ed$cluster == 1, ]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["isrc"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[2],"type":["chr"],"align":["left"]},{"label":["artistName"],"name":[3],"type":["chr"],"align":["left"]},{"label":["danceability"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["loudness"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["mode"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["acousticness"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["duration_ms"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["cluster"],"name":[15],"type":["fct"],"align":["left"]}],"data":[{"1":"GBAHS1400094","2":"Photograph","3":"Ed Sheeran","4":"0.614","5":"0.3790","6":"-10.480","7":"1","8":"0.0476","9":"0.607","10":"0.00050000","11":"0.0986","12":"0.201","13":"107.989","14":"258987","15":"1"},{"1":"GBAHS1100095","2":"The A Team","3":"Ed Sheeran","4":"0.642","5":"0.2890","6":"-9.918","7":"1","8":"0.0367","9":"0.669","10":"0.00000000","11":"0.1800","12":"0.407","13":"84.996","14":"258373","15":"1"},{"1":"USNLR1300728","2":"I See Fire - From \"The Hobbit - The Desolation Of Smaug\"","3":"Ed Sheeran","4":"0.581","5":"0.0549","6":"-20.514","7":"0","8":"0.0397","9":"0.559","10":"0.00000000","11":"0.0718","12":"0.234","13":"152.037","14":"300840","15":"1"},{"1":"GBAHS1100209","2":"Give Me Love","3":"Ed Sheeran","4":"0.526","5":"0.3280","6":"-9.864","7":"1","8":"0.0461","9":"0.694","10":"0.00000000","11":"0.1120","12":"0.110","13":"116.068","14":"526387","15":"1"},{"1":"GBAHS1400096","2":"Tenerife Sea","3":"Ed Sheeran","4":"0.530","5":"0.3460","6":"-10.497","7":"1","8":"0.0376","9":"0.697","10":"0.00000000","11":"0.1050","12":"0.359","13":"121.876","14":"241347","15":"1"},{"1":"GBAHS1100208","2":"Kiss Me","3":"Ed Sheeran","4":"0.589","5":"0.2270","6":"-16.670","7":"1","8":"0.0498","9":"0.640","10":"0.00470000","11":"0.0248","12":"0.182","13":"74.993","14":"280853","15":"1"},{"1":"GBAHS1700028","2":"Happier","3":"Ed Sheeran","4":"0.522","5":"0.3850","6":"-7.355","7":"1","8":"0.0288","9":"0.536","10":"0.00000000","11":"0.1350","12":"0.236","13":"89.792","14":"207520","15":"1"},{"1":"GBAHS1700032","2":"Hearts Don't Break Around Here","3":"Ed Sheeran","4":"0.604","5":"0.3660","6":"-7.881","7":"1","8":"0.0267","9":"0.719","10":"0.00000000","11":"0.1620","12":"0.181","13":"105.177","14":"248413","15":"1"},{"1":"GBAHS1700040","2":"Supermarket Flowers","3":"Ed Sheeran","4":"0.589","5":"0.2420","6":"-10.517","7":"1","8":"0.0442","9":"0.914","10":"0.00000000","11":"0.0887","12":"0.257","13":"89.749","14":"221107","15":"1"},{"1":"GBAHS1700048","2":"Save Myself","3":"Ed Sheeran","4":"0.552","5":"0.2900","6":"-5.617","7":"1","8":"0.0448","9":"0.850","10":"0.00000000","11":"0.2270","12":"0.481","13":"78.842","14":"247107","15":"1"},{"1":"GBAHS1400091","2":"I'm a Mess","3":"Ed Sheeran","4":"0.697","5":"0.3770","6":"-7.755","7":"1","8":"0.0397","9":"0.556","10":"0.00000000","11":"0.0999","12":"0.336","13":"138.754","14":"244573","15":"1"},{"1":"GBAHS1400092","2":"One","3":"Ed Sheeran","4":"0.464","5":"0.3210","6":"-11.120","7":"1","8":"0.0418","9":"0.877","10":"0.00000000","11":"0.0789","12":"0.306","13":"93.528","14":"252760","15":"1"},{"1":"GBAHS1400095","2":"Bloodstream","3":"Ed Sheeran","4":"0.660","5":"0.3160","6":"-11.567","7":"0","8":"0.0364","9":"0.529","10":"0.00030000","11":"0.1040","12":"0.543","13":"91.207","14":"300253","15":"1"},{"1":"GBAHS1100203","2":"Small Bump","3":"Ed Sheeran","4":"0.810","5":"0.4360","6":"-12.683","7":"1","8":"0.0717","9":"0.689","10":"0.00020000","11":"0.1100","12":"0.446","13":"119.973","14":"259413","15":"1"},{"1":"GBAHS1100211","2":"Little Bird - Deluxe Edition","3":"Ed Sheeran","4":"0.843","5":"0.4250","6":"-8.676","7":"1","8":"0.0352","9":"0.565","10":"0.00000000","11":"0.1020","12":"0.284","13":"104.020","14":"224529","15":"1"},{"1":"GBAHS1700198","2":"Castle on the Hill - Acoustic","3":"Ed Sheeran","4":"0.563","5":"0.2600","6":"-5.856","7":"1","8":"0.0391","9":"0.518","10":"0.00000000","11":"0.1460","12":"0.616","13":"145.561","14":"226227","15":"1"},{"1":"GBUM71800115","2":"Candle In The Wind - 2018 Version","3":"Ed Sheeran","4":"0.549","5":"0.4490","6":"-10.479","7":"1","8":"0.0455","9":"0.732","10":"0.00000000","11":"0.1170","12":"0.506","13":"76.028","14":"198777","15":"1"},{"1":"GBAHS1400104","2":"I See Fire","3":"Ed Sheeran","4":"0.641","5":"0.1760","6":"-11.692","7":"1","8":"0.0349","9":"0.638","10":"0.00000514","11":"0.2520","12":"0.297","13":"76.031","14":"299147","15":"1"},{"1":"USNLR1300700","2":"I See Fire","3":"Ed Sheeran","4":"0.581","5":"0.0549","6":"-20.514","7":"0","8":"0.0397","9":"0.559","10":"0.00000000","11":"0.0718","12":"0.234","13":"152.037","14":"300840","15":"1"},{"1":"GBAHS1701083","2":"Perfect - Acoustic","3":"Ed Sheeran","4":"0.432","5":"0.3770","6":"-5.790","7":"1","8":"0.0304","9":"0.459","10":"0.00000000","11":"0.1140","12":"0.394","13":"94.973","14":"260867","15":"1"},{"1":"GB6S41000006","2":"Firefly","3":"Ed Sheeran","4":"0.602","5":"0.3100","6":"-11.469","7":"1","8":"0.0373","9":"0.886","10":"0.00010000","11":"0.1050","12":"0.360","13":"159.917","14":"255000","15":"1"},{"1":"GB6S41000012","2":"She","3":"Ed Sheeran","4":"0.573","5":"0.3440","6":"-10.910","7":"1","8":"0.0361","9":"0.811","10":"0.00000000","11":"0.1300","12":"0.377","13":"157.783","14":"244653","15":"1"},{"1":"GBAHS1400157","2":"Friends","3":"Ed Sheeran","4":"0.516","5":"0.1580","6":"-14.433","7":"1","8":"0.0672","9":"0.783","10":"0.00000132","11":"0.2220","12":"0.455","13":"93.255","14":"190539","15":"1"},{"1":"GB6S41000009","2":"Cold Coffee","3":"Ed Sheeran","4":"0.544","5":"0.5290","6":"-6.753","7":"1","8":"0.0256","9":"0.453","10":"0.00000000","11":"0.1310","12":"0.403","13":"92.936","14":"254227","15":"1"},{"1":"GBAHS1100202","2":"Wake Me Up","3":"Ed Sheeran","4":"0.616","5":"0.2090","6":"-13.430","7":"1","8":"0.4060","9":"0.902","10":"0.00000000","11":"0.1390","12":"0.336","13":"86.891","14":"229613","15":"1"},{"1":"GB6S41000011","2":"Fire Alarms","3":"Ed Sheeran","4":"0.602","5":"0.2860","6":"-9.886","7":"1","8":"0.0296","9":"0.772","10":"0.00000000","11":"0.1620","12":"0.379","13":"102.009","14":"144013","15":"1"},{"1":"GBAHS1900797","2":"I Don't Care - Acoustic","3":"Ed Sheeran","4":"0.706","5":"0.3490","6":"-8.125","7":"1","8":"0.0302","9":"0.791","10":"0.00000000","11":"0.1080","12":"0.624","13":"94.058","14":"238220","15":"1"},{"1":"GBAHS1700525","2":"Castle on the Hill - Recorded at Spotify Studios New York City","3":"Ed Sheeran","4":"0.556","5":"0.3550","6":"-6.416","7":"1","8":"0.0398","9":"0.581","10":"0.00000000","11":"0.1180","12":"0.644","13":"147.580","14":"225791","15":"1"},{"1":"GBAHS2001193","2":"Afterglow","3":"Ed Sheeran","4":"0.641","5":"0.3240","6":"-5.851","7":"1","8":"0.0299","9":"0.698","10":"0.00000000","11":"0.3280","12":"0.273","13":"110.184","14":"185487","15":"1"},{"1":"GBAHS2100680","2":"Visiting Hours","3":"Ed Sheeran","4":"0.471","5":"0.3960","6":"-6.654","7":"1","8":"0.0336","9":"0.770","10":"0.00000000","11":"0.0729","12":"0.263","13":"149.609","14":"215507","15":"1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
ed[which.min(ed$danceability), ]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["isrc"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[2],"type":["chr"],"align":["left"]},{"label":["artistName"],"name":[3],"type":["chr"],"align":["left"]},{"label":["danceability"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["loudness"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["mode"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["acousticness"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["duration_ms"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["cluster"],"name":[15],"type":["fct"],"align":["left"]}],"data":[{"1":"GBAHS1701083","2":"Perfect - Acoustic","3":"Ed Sheeran","4":"0.432","5":"0.377","6":"-5.79","7":"1","8":"0.0304","9":"0.459","10":"0","11":"0.114","12":"0.394","13":"94.973","14":"260867","15":"1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
ed[order(ed$danceability, decreasing = T), ]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["isrc"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[2],"type":["chr"],"align":["left"]},{"label":["artistName"],"name":[3],"type":["chr"],"align":["left"]},{"label":["danceability"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["loudness"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["mode"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["acousticness"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["duration_ms"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["cluster"],"name":[15],"type":["fct"],"align":["left"]}],"data":[{"1":"GBAHS1700200","2":"Shape of You - Acoustic","3":"Ed Sheeran","4":"0.843","5":"0.4000","6":"-5.576","7":"0","8":"0.1030","9":"0.4900","10":"0.00000000","11":"0.1250","12":"0.927","13":"100.728","14":"223573","15":"7"},{"1":"GBAHS1100211","2":"Little Bird - Deluxe Edition","3":"Ed Sheeran","4":"0.843","5":"0.4250","6":"-8.676","7":"1","8":"0.0352","9":"0.5650","10":"0.00000000","11":"0.1020","12":"0.284","13":"104.020","14":"224529","15":"1"},{"1":"GBAHS1700036","2":"What Do I Know?","3":"Ed Sheeran","4":"0.838","5":"0.4920","6":"-5.690","7":"0","8":"0.0380","9":"0.2510","10":"0.00000000","11":"0.2620","12":"0.895","13":"115.092","14":"237333","15":"7"},{"1":"GBAHS1600463","2":"Shape of You","3":"Ed Sheeran","4":"0.825","5":"0.6520","6":"-3.183","7":"0","8":"0.0802","9":"0.5810","10":"0.00000000","11":"0.0931","12":"0.931","13":"95.977","14":"233713","15":"7"},{"1":"GBAHS1400082","2":"Sing","3":"Ed Sheeran","4":"0.818","5":"0.6700","6":"-4.451","7":"0","8":"0.0472","9":"0.3040","10":"0.00000122","11":"0.0601","12":"0.939","13":"119.988","14":"235382","15":"7"},{"1":"GBAHS1500471","2":"Touch and Go","3":"Ed Sheeran","4":"0.812","5":"0.5420","6":"-5.403","7":"0","8":"0.0444","9":"0.2940","10":"0.00010000","11":"0.1410","12":"0.733","13":"110.268","14":"240987","15":"7"},{"1":"GBAHS1100203","2":"Small Bump","3":"Ed Sheeran","4":"0.810","5":"0.4360","6":"-12.683","7":"1","8":"0.0717","9":"0.6890","10":"0.00020000","11":"0.1100","12":"0.446","13":"119.973","14":"259413","15":"1"},{"1":"GBAHS2100318","2":"Bad Habits","3":"Ed Sheeran","4":"0.808","5":"0.8970","6":"-3.712","7":"0","8":"0.0348","9":"0.0469","10":"0.00000000","11":"0.3640","12":"0.591","13":"126.026","14":"231041","15":"7"},{"1":"GBAHS1400090","2":"Don't","3":"Ed Sheeran","4":"0.806","5":"0.6080","6":"-7.008","7":"1","8":"0.0659","9":"0.0113","10":"0.00000000","11":"0.6350","12":"0.849","13":"95.049","14":"219840","15":"3"},{"1":"GBAHS1700526","2":"Baby One More Time - Recorded at Spotify Studios New York City","3":"Ed Sheeran","4":"0.792","5":"0.3070","6":"-6.224","7":"0","8":"0.0522","9":"0.1890","10":"0.00000000","11":"0.0834","12":"0.631","13":"104.511","14":"177215","15":"7"},{"1":"GBAHS2100671","2":"Shivers","3":"Ed Sheeran","4":"0.788","5":"0.8590","6":"-2.724","7":"1","8":"0.0856","9":"0.2810","10":"0.00000000","11":"0.0424","12":"0.822","13":"141.020","14":"207853","15":"3"},{"1":"GBAHS1700245","2":"Shape of You (feat. Zion & Lennox) - Latin Remix","3":"Ed Sheeran","4":"0.787","5":"0.8720","6":"-1.397","7":"0","8":"0.0871","9":"0.1680","10":"0.00000151","11":"0.0408","12":"0.460","13":"95.995","14":"237664","15":"7"},{"1":"GBAHS1400099","2":"Thinking out Loud","3":"Ed Sheeran","4":"0.781","5":"0.4450","6":"-6.061","7":"1","8":"0.0295","9":"0.4740","10":"0.00000000","11":"0.1840","12":"0.591","13":"78.998","14":"281560","15":"3"},{"1":"GBAHS1700030","2":"New Man","3":"Ed Sheeran","4":"0.780","5":"0.7450","6":"-3.970","7":"1","8":"0.1450","9":"0.0559","10":"0.00000000","11":"0.0595","12":"0.862","13":"94.026","14":"189280","15":"3"},{"1":"GBAHS1700022","2":"Dive","3":"Ed Sheeran","4":"0.761","5":"0.3860","6":"-6.158","7":"1","8":"0.0399","9":"0.3550","10":"0.00000000","11":"0.0953","12":"0.526","13":"134.943","14":"238440","15":"3"},{"1":"GBAHS1100207","2":"You Need Me, I Don't Need You","3":"Ed Sheeran","4":"0.749","5":"0.8370","6":"-8.837","7":"1","8":"0.0512","9":"0.1620","10":"0.00000000","11":"0.5250","12":"0.927","13":"103.483","14":"220413","15":"3"},{"1":"GBAHS1700042","2":"Barcelona","3":"Ed Sheeran","4":"0.747","5":"0.7600","6":"-4.294","7":"1","8":"0.1870","9":"0.4480","10":"0.00000000","11":"0.1530","12":"0.682","13":"99.975","14":"191147","15":"3"},{"1":"GBAHS1700044","2":"Bibia Be Ye Ye","3":"Ed Sheeran","4":"0.738","5":"0.6770","6":"-5.121","7":"1","8":"0.0824","9":"0.5200","10":"0.00000000","11":"0.1330","12":"0.882","13":"127.067","14":"176747","15":"3"},{"1":"GBAHS1100199","2":"Drunk","3":"Ed Sheeran","4":"0.733","5":"0.6520","6":"-9.101","7":"1","8":"0.0696","9":"0.4190","10":"0.00000237","11":"0.5210","12":"0.459","13":"99.998","14":"200093","15":"3"},{"1":"GB6S41000020","2":"Let It Out","3":"Ed Sheeran","4":"0.731","5":"0.6030","6":"-7.656","7":"1","8":"0.0378","9":"0.6450","10":"0.01100000","11":"0.1470","12":"0.619","13":"96.973","14":"231547","15":"3"},{"1":"GBAHS1900797","2":"I Don't Care - Acoustic","3":"Ed Sheeran","4":"0.706","5":"0.3490","6":"-8.125","7":"1","8":"0.0302","9":"0.7910","10":"0.00000000","11":"0.1080","12":"0.624","13":"94.058","14":"238220","15":"1"},{"1":"GBAHS1400091","2":"I'm a Mess","3":"Ed Sheeran","4":"0.697","5":"0.3770","6":"-7.755","7":"1","8":"0.0397","9":"0.5560","10":"0.00000000","11":"0.0999","12":"0.336","13":"138.754","14":"244573","15":"1"},{"1":"GBAHS1700046","2":"Nancy Mulligan","3":"Ed Sheeran","4":"0.680","5":"0.8520","6":"-4.350","7":"1","8":"0.0349","9":"0.1170","10":"0.00000000","11":"0.0866","12":"0.858","13":"101.993","14":"179787","15":"3"},{"1":"GBAHS1400095","2":"Bloodstream","3":"Ed Sheeran","4":"0.660","5":"0.3160","6":"-11.567","7":"0","8":"0.0364","9":"0.5290","10":"0.00030000","11":"0.1040","12":"0.543","13":"91.207","14":"300253","15":"1"},{"1":"GBAHS1100095","2":"The A Team","3":"Ed Sheeran","4":"0.642","5":"0.2890","6":"-9.918","7":"1","8":"0.0367","9":"0.6690","10":"0.00000000","11":"0.1800","12":"0.407","13":"84.996","14":"258373","15":"1"},{"1":"GBAHS1400104","2":"I See Fire","3":"Ed Sheeran","4":"0.641","5":"0.1760","6":"-11.692","7":"1","8":"0.0349","9":"0.6380","10":"0.00000514","11":"0.2520","12":"0.297","13":"76.031","14":"299147","15":"1"},{"1":"GBAHS2001193","2":"Afterglow","3":"Ed Sheeran","4":"0.641","5":"0.3240","6":"-5.851","7":"1","8":"0.0299","9":"0.6980","10":"0.00000000","11":"0.3280","12":"0.273","13":"110.184","14":"185487","15":"1"},{"1":"GBAHS1700020","2":"Eraser","3":"Ed Sheeran","4":"0.640","5":"0.8120","6":"-5.647","7":"0","8":"0.0834","9":"0.0860","10":"0.00000000","11":"0.0509","12":"0.914","13":"86.013","14":"227427","15":"7"},{"1":"GBAHS1700026","2":"Galway Girl","3":"Ed Sheeran","4":"0.624","5":"0.8760","6":"-3.374","7":"1","8":"0.1000","9":"0.0735","10":"0.00000000","11":"0.3270","12":"0.781","13":"99.943","14":"170827","15":"3"},{"1":"GBAHS1700038","2":"How Would You Feel (Paean)","3":"Ed Sheeran","4":"0.617","5":"0.4390","6":"-5.630","7":"1","8":"0.0269","9":"0.4240","10":"0.00000000","11":"0.1270","12":"0.242","13":"139.979","14":"280533","15":"5"},{"1":"GBAHS1100202","2":"Wake Me Up","3":"Ed Sheeran","4":"0.616","5":"0.2090","6":"-13.430","7":"1","8":"0.4060","9":"0.9020","10":"0.00000000","11":"0.1390","12":"0.336","13":"86.891","14":"229613","15":"1"},{"1":"GBAHS1400094","2":"Photograph","3":"Ed Sheeran","4":"0.614","5":"0.3790","6":"-10.480","7":"1","8":"0.0476","9":"0.6070","10":"0.00050000","11":"0.0986","12":"0.201","13":"107.989","14":"258987","15":"1"},{"1":"GBAHS1700032","2":"Hearts Don't Break Around Here","3":"Ed Sheeran","4":"0.604","5":"0.3660","6":"-7.881","7":"1","8":"0.0267","9":"0.7190","10":"0.00000000","11":"0.1620","12":"0.181","13":"105.177","14":"248413","15":"1"},{"1":"GB6S41000006","2":"Firefly","3":"Ed Sheeran","4":"0.602","5":"0.3100","6":"-11.469","7":"1","8":"0.0373","9":"0.8860","10":"0.00010000","11":"0.1050","12":"0.360","13":"159.917","14":"255000","15":"1"},{"1":"GB6S41000011","2":"Fire Alarms","3":"Ed Sheeran","4":"0.602","5":"0.2860","6":"-9.886","7":"1","8":"0.0296","9":"0.7720","10":"0.00000000","11":"0.1620","12":"0.379","13":"102.009","14":"144013","15":"1"},{"1":"GBAHS1700024","2":"Perfect","3":"Ed Sheeran","4":"0.599","5":"0.4480","6":"-6.312","7":"1","8":"0.0232","9":"0.1630","10":"0.00000000","11":"0.1060","12":"0.168","13":"95.050","14":"263400","15":"5"},{"1":"GBAHS1100206","2":"Lego House","3":"Ed Sheeran","4":"0.592","5":"0.6370","6":"-8.480","7":"1","8":"0.0992","9":"0.5620","10":"0.00000000","11":"0.1300","12":"0.565","13":"159.701","14":"185093","15":"5"},{"1":"GBAHS1100208","2":"Kiss Me","3":"Ed Sheeran","4":"0.589","5":"0.2270","6":"-16.670","7":"1","8":"0.0498","9":"0.6400","10":"0.00470000","11":"0.0248","12":"0.182","13":"74.993","14":"280853","15":"1"},{"1":"GBAHS1700040","2":"Supermarket Flowers","3":"Ed Sheeran","4":"0.589","5":"0.2420","6":"-10.517","7":"1","8":"0.0442","9":"0.9140","10":"0.00000000","11":"0.0887","12":"0.257","13":"89.749","14":"221107","15":"1"},{"1":"USNLR1300728","2":"I See Fire - From \"The Hobbit - The Desolation Of Smaug\"","3":"Ed Sheeran","4":"0.581","5":"0.0549","6":"-20.514","7":"0","8":"0.0397","9":"0.5590","10":"0.00000000","11":"0.0718","12":"0.234","13":"152.037","14":"300840","15":"1"},{"1":"USNLR1300700","2":"I See Fire","3":"Ed Sheeran","4":"0.581","5":"0.0549","6":"-20.514","7":"0","8":"0.0397","9":"0.5590","10":"0.00000000","11":"0.0718","12":"0.234","13":"152.037","14":"300840","15":"1"},{"1":"GBAHS1500470","2":"English Rose","3":"Ed Sheeran","4":"0.579","5":"0.6490","6":"-6.522","7":"1","8":"0.0352","9":"0.0977","10":"0.00000000","11":"0.1250","12":"0.184","13":"114.593","14":"184173","15":"5"},{"1":"GB6S41000012","2":"She","3":"Ed Sheeran","4":"0.573","5":"0.3440","6":"-10.910","7":"1","8":"0.0361","9":"0.8110","10":"0.00000000","11":"0.1300","12":"0.377","13":"157.783","14":"244653","15":"1"},{"1":"GBAHS1700198","2":"Castle on the Hill - Acoustic","3":"Ed Sheeran","4":"0.563","5":"0.2600","6":"-5.856","7":"1","8":"0.0391","9":"0.5180","10":"0.00000000","11":"0.1460","12":"0.616","13":"145.561","14":"226227","15":"1"},{"1":"GBAHS1700525","2":"Castle on the Hill - Recorded at Spotify Studios New York City","3":"Ed Sheeran","4":"0.556","5":"0.3550","6":"-6.416","7":"1","8":"0.0398","9":"0.5810","10":"0.00000000","11":"0.1180","12":"0.644","13":"147.580","14":"225791","15":"1"},{"1":"GBAHS1700048","2":"Save Myself","3":"Ed Sheeran","4":"0.552","5":"0.2900","6":"-5.617","7":"1","8":"0.0448","9":"0.8500","10":"0.00000000","11":"0.2270","12":"0.481","13":"78.842","14":"247107","15":"1"},{"1":"GBAHS1400100","2":"Afire Love","3":"Ed Sheeran","4":"0.552","5":"0.6370","6":"-6.568","7":"1","8":"0.0445","9":"0.4640","10":"0.00000000","11":"0.1360","12":"0.333","13":"97.970","14":"314280","15":"5"},{"1":"GBUM71800115","2":"Candle In The Wind - 2018 Version","3":"Ed Sheeran","4":"0.549","5":"0.4490","6":"-10.479","7":"1","8":"0.0455","9":"0.7320","10":"0.00000000","11":"0.1170","12":"0.506","13":"76.028","14":"198777","15":"1"},{"1":"GB6S41000009","2":"Cold Coffee","3":"Ed Sheeran","4":"0.544","5":"0.5290","6":"-6.753","7":"1","8":"0.0256","9":"0.4530","10":"0.00000000","11":"0.1310","12":"0.403","13":"92.936","14":"254227","15":"1"},{"1":"USAT21503687","2":"All of the Stars","3":"Ed Sheeran","4":"0.540","5":"0.5570","6":"-6.097","7":"1","8":"0.0259","9":"0.0089","10":"0.00020000","11":"0.3070","12":"0.287","13":"75.035","14":"237147","15":"5"},{"1":"GBAHS1400096","2":"Tenerife Sea","3":"Ed Sheeran","4":"0.530","5":"0.3460","6":"-10.497","7":"1","8":"0.0376","9":"0.6970","10":"0.00000000","11":"0.1050","12":"0.359","13":"121.876","14":"241347","15":"1"},{"1":"GBAHS1100209","2":"Give Me Love","3":"Ed Sheeran","4":"0.526","5":"0.3280","6":"-9.864","7":"1","8":"0.0461","9":"0.6940","10":"0.00000000","11":"0.1120","12":"0.110","13":"116.068","14":"526387","15":"1"},{"1":"GBAHS1700028","2":"Happier","3":"Ed Sheeran","4":"0.522","5":"0.3850","6":"-7.355","7":"1","8":"0.0288","9":"0.5360","10":"0.00000000","11":"0.1350","12":"0.236","13":"89.792","14":"207520","15":"1"},{"1":"GBAHS1400157","2":"Friends","3":"Ed Sheeran","4":"0.516","5":"0.1580","6":"-14.433","7":"1","8":"0.0672","9":"0.7830","10":"0.00000132","11":"0.2220","12":"0.455","13":"93.255","14":"190539","15":"1"},{"1":"GBAHS1800361","2":"Happier - Acoustic","3":"Ed Sheeran","4":"0.493","5":"0.4000","6":"-8.117","7":"1","8":"0.0261","9":"0.0425","10":"0.00000147","11":"0.1330","12":"0.150","13":"91.004","14":"206209","15":"5"},{"1":"GBAHS2100680","2":"Visiting Hours","3":"Ed Sheeran","4":"0.471","5":"0.3960","6":"-6.654","7":"1","8":"0.0336","9":"0.7700","10":"0.00000000","11":"0.0729","12":"0.263","13":"149.609","14":"215507","15":"1"},{"1":"GBAHS1400092","2":"One","3":"Ed Sheeran","4":"0.464","5":"0.3210","6":"-11.120","7":"1","8":"0.0418","9":"0.8770","10":"0.00000000","11":"0.0789","12":"0.306","13":"93.528","14":"252760","15":"1"},{"1":"GBAHS1600462","2":"Castle on the Hill","3":"Ed Sheeran","4":"0.461","5":"0.8340","6":"-4.868","7":"1","8":"0.0989","9":"0.0232","10":"0.00000000","11":"0.1400","12":"0.471","13":"135.007","14":"261154","15":"5"},{"1":"GBAHS1701083","2":"Perfect - Acoustic","3":"Ed Sheeran","4":"0.432","5":"0.3770","6":"-5.790","7":"1","8":"0.0304","9":"0.4590","10":"0.00000000","11":"0.1140","12":"0.394","13":"94.973","14":"260867","15":"1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
