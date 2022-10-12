---
output:
  html_document:
    toc: yes
  html_notebook: default
  pdf_document:
    toc: yes

---

# Summarizing data

## Summary statistics

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/03-basic_statistics.R)
:::

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/wGBbLyjUquY" frameborder="0" allowfullscreen></iframe>
</div>
<br>



This section discusses how to produce and analyze basic summary statistics. Summary statistics are often used to describe variables in terms of 1) the central tendency of the frequency distribution, and 2) the dispersion of values.  

<br>

A **measure of central tendency** is a single value that attempts to describe the data by identifying the central position within the data. There are various measures of central tendency as the following table shows. 

Statistic    | Description   | Definition 
---- | ------------------------------  | -----
Mean | The average value when you sum up all elements and divide by the number of elements  | $\bar{X}=\frac{\sum_{i=1}^{n}{X_i}}{n}$  
Mode  | The value that occurs most frequently (i.e., the highest peak of the frequency distribution)  |   
Median | The middle value when the data are arranged in ascending or descending order (i.e., the 50th percentile) |   

<br>

The **dispersion** refers to the degree to which the data is distributed around the central tendency and can be described in terms of the range, interquartile range, variance, and standard deviation. 

Statistic    | Description   | Definition 
---- | ------------------------------  | -----
Range | The difference between the largest and smallest values in the sample | $Range=X_{largest}-X_{smallest}$  
Interquartile range  | The range of the middle 50% of scores | $IQR=Q_3-Q_1$   
Variance | The mean squared deviation of all the values of the mean | $s^2=\frac{1}{n-1}*\sum_{i=1}^{n}{(X_i-\bar{X})^2}$
Standard deviation | The square root of the variance | $s_x=\sqrt{s^2}$

<br>

The answer to the question which measures to use depends on the level of measurement. Based on the discussion in chapter 1, we make a distinction between categorical and continuous variables, for which different statistics are permissible as summarized in the following table.

OK to compute...    | Nominal   | Ordinal   | Interval    | Ratio
------------- | ------------- | ------------- | --- | ---
frequency distribution  | Yes  | Yes  | Yes  | Yes
median and percentiles  | No  | Yes  | Yes  | Yes
mean, standard deviation, standard error of the mean | No  | No  | Yes  | Yes
ratio, or coefficient of variation  | No  | No  | No  | Yes

<br>

As an example data set, we will be using a data set containing music streaming data from a popular streaming service. Let's load and inspect the data first.





```r
# read.csv2 is shorthand for read.csv(file, sep = ";")
music_data <- read.csv2("https://short.wu.ac.at/ma22_musicdata")
dim(music_data)
```

```
## [1] 66796    31
```

```r
head(music_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["isrc"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_id"],"name":[2],"type":["int"],"align":["right"]},{"label":["streams"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["weeks_in_charts"],"name":[4],"type":["int"],"align":["right"]},{"label":["n_regions"],"name":[5],"type":["int"],"align":["right"]},{"label":["danceability"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["song_length"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["song_age"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["explicit"],"name":[15],"type":["int"],"align":["right"]},{"label":["n_playlists"],"name":[16],"type":["int"],"align":["right"]},{"label":["sp_popularity"],"name":[17],"type":["int"],"align":["right"]},{"label":["youtube_views"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tiktok_counts"],"name":[19],"type":["int"],"align":["right"]},{"label":["ins_followers_artist"],"name":[20],"type":["int"],"align":["right"]},{"label":["monthly_listeners_artist"],"name":[21],"type":["int"],"align":["right"]},{"label":["playlist_total_reach_artist"],"name":[22],"type":["int"],"align":["right"]},{"label":["sp_fans_artist"],"name":[23],"type":["int"],"align":["right"]},{"label":["shazam_counts"],"name":[24],"type":["int"],"align":["right"]},{"label":["artistName"],"name":[25],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[26],"type":["chr"],"align":["left"]},{"label":["release_date"],"name":[27],"type":["chr"],"align":["left"]},{"label":["genre"],"name":[28],"type":["chr"],"align":["left"]},{"label":["label"],"name":[29],"type":["chr"],"align":["left"]},{"label":["top10"],"name":[30],"type":["int"],"align":["right"]},{"label":["expert_rating"],"name":[31],"type":["chr"],"align":["left"]}],"data":[{"1":"BRRGE1603547","2":"3679","3":"11944813","4":"141","5":"1","6":"50.9","7":"80.3","8":"4.00","9":"0.050000","10":"46.30","11":"65.1","12":"166.018","13":"3.118650","14":"228.28571","15":"0","16":"450","17":"51","18":"145030723","19":"9740","20":"29613108","21":"4133393","22":"24286416","23":"3308630","24":"73100","25":"Luan Santana","26":"Eu, VocÃª, O Mar e Ela","27":"2016-06-20","28":"other","29":"Independent","30":"1","31":"excellent"},{"1":"USUM71808193","2":"5239","3":"8934097","4":"51","5":"21","6":"35.3","7":"75.5","8":"73.30","9":"0.000000","10":"39.00","11":"43.7","12":"191.153","13":"3.228000","14":"144.28571","15":"0","16":"768","17":"54","18":"13188411","19":"358700","20":"3693566","21":"18367363","22":"143384531","23":"465412","24":"588550","25":"Alessia Cara","26":"Growing Pains","27":"2018-06-14","28":"Pop","29":"Universal Music","30":"0","31":"good"},{"1":"ES5701800181","2":"776407","3":"38835","4":"1","5":"1","6":"68.3","7":"67.6","8":"14.70","9":"0.000000","10":"7.26","11":"43.4","12":"98.992","13":"3.015550","14":"112.28571","15":"0","16":"48","17":"32","18":"6116639","19":"0","20":"623778","21":"888273","22":"4846378","23":"23846","24":"0","25":"Ana Guerra","26":"El Remedio","27":"2018-04-26","28":"Pop","29":"Universal Music","30":"0","31":"good"},{"1":"ITRSE2000050","2":"433730","3":"46766","4":"1","5":"1","6":"70.4","7":"56.8","8":"26.80","9":"0.000253","10":"8.91","11":"49.5","12":"91.007","13":"3.453417","14":"50.71429","15":"0","16":"6","17":"44","18":"0","19":"13","20":"81601","21":"143761","22":"156521","23":"1294","24":"0","25":"Claver Gold feat. Murubutu","26":"Ulisse","27":"2020-03-31","28":"HipHop/Rap","29":"Independent","30":"0","31":"poor"},{"1":"QZJ842000061","2":"526471","3":"2930573","4":"7","5":"4","6":"84.2","7":"57.8","8":"13.80","9":"0.000000","10":"22.80","11":"19.0","12":"74.496","13":"3.946317","14":"58.28571","15":"0","16":"475","17":"52","18":"0","19":"515","20":"11962358","21":"15551876","22":"90841884","23":"380204","24":"55482","25":"Trippie Redd feat. Young Thug","26":"YELL OH","27":"2020-02-07","28":"HipHop/Rap","29":"Universal Music","30":"0","31":"excellent"},{"1":"USIR20400274","2":"1939","3":"72199738","4":"226","5":"8","6":"35.2","7":"91.1","8":"7.47","9":"0.000000","10":"9.95","11":"23.6","12":"148.033","13":"3.716217","14":"876.71429","15":"0","16":"20591","17":"81","18":"20216069","19":"67300","20":"1169284","21":"16224250","22":"80408253","23":"1651866","24":"5281161","25":"The Killers","26":"Mr. Brightside","27":"2004-06-07","28":"Rock","29":"Universal Music","30":"1","31":"fair"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
names(music_data)
```

```
##  [1] "isrc"                        "artist_id"                  
##  [3] "streams"                     "weeks_in_charts"            
##  [5] "n_regions"                   "danceability"               
##  [7] "energy"                      "speechiness"                
##  [9] "instrumentalness"            "liveness"                   
## [11] "valence"                     "tempo"                      
## [13] "song_length"                 "song_age"                   
## [15] "explicit"                    "n_playlists"                
## [17] "sp_popularity"               "youtube_views"              
## [19] "tiktok_counts"               "ins_followers_artist"       
## [21] "monthly_listeners_artist"    "playlist_total_reach_artist"
## [23] "sp_fans_artist"              "shazam_counts"              
## [25] "artistName"                  "trackName"                  
## [27] "release_date"                "genre"                      
## [29] "label"                       "top10"                      
## [31] "expert_rating"
```

The data set contains information about all songs that appeared in the Top200 charts of a popular streaming service between 2017 and 2020. The `dim()`-function returns the dimensions of the data frame (i.e., the number of rows and columns). As can be seen, the data set comprises information for 66,796 songs and 31 variables. The variables in the data set are:

* isrc: unique song id
* artist_id: unique artist ID
* streams: the number of streams of the song received globally between 2017-2021
* weeks_in_charts: the number of weeks the song was in the top200 charts in this period
* n_regions: the number of markets where the song appeared in the top200 charts
* audio features, see: (see: https://developer.spotify.com/documentation/web-api/reference/*category-tracks) 
    * danceability
    * energy
    * speechiness
    * instrumentalness
    * liveness
    * valence
    * tempo
* song_length: the duration of the song (in minutes)
* song_age: the age of the song (in weeks since release)
* explicit: indicator for explicit lyrics
* n_playlists: number of playlists a song is featured on
* sp_popularity: the Spotify popularity index of an artist
* youtube_views: the number of views the song received on YouTube
* tiktok_counts: the number of Tiktok views the song received on TikTok
* ins_followers_artist: the number of Instagram followers of the artist
* monthly_listeners_artist: the number of monthly listeners of an artist
* playlist_total_reach_artist: the number of playlist followers of the playlists the song is on
* sp_fans_artist: the number of fans of the artist on Spotify
* shazam_counts: the number of times a song is shazamed
* artistName: name of the artist
* trackName: name of the song
* release_date: release date of song
* genre: genre associated with the song
* label: music label associated with the song
* top10: indicator whether the song was in the top 10
* expert_rating: 5-scale rating by a music expert (poor, fair, good, excellent, masterpiece)

In a first step, we need to make sure all variables are in the correct format, according to these variable definitions: 


```r
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
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["isrc"],"name":[1],"type":["chr"],"align":["left"]},{"label":["artist_id"],"name":[2],"type":["int"],"align":["right"]},{"label":["streams"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["weeks_in_charts"],"name":[4],"type":["int"],"align":["right"]},{"label":["n_regions"],"name":[5],"type":["int"],"align":["right"]},{"label":["danceability"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["song_length"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["song_age"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["explicit"],"name":[15],"type":["fct"],"align":["left"]},{"label":["n_playlists"],"name":[16],"type":["int"],"align":["right"]},{"label":["sp_popularity"],"name":[17],"type":["int"],"align":["right"]},{"label":["youtube_views"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tiktok_counts"],"name":[19],"type":["int"],"align":["right"]},{"label":["ins_followers_artist"],"name":[20],"type":["int"],"align":["right"]},{"label":["monthly_listeners_artist"],"name":[21],"type":["int"],"align":["right"]},{"label":["playlist_total_reach_artist"],"name":[22],"type":["int"],"align":["right"]},{"label":["sp_fans_artist"],"name":[23],"type":["int"],"align":["right"]},{"label":["shazam_counts"],"name":[24],"type":["int"],"align":["right"]},{"label":["artistName"],"name":[25],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[26],"type":["chr"],"align":["left"]},{"label":["release_date"],"name":[27],"type":["date"],"align":["right"]},{"label":["genre"],"name":[28],"type":["fct"],"align":["left"]},{"label":["label"],"name":[29],"type":["fct"],"align":["left"]},{"label":["top10"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["expert_rating"],"name":[31],"type":["ord"],"align":["right"]}],"data":[{"1":"BRRGE1603547","2":"3679","3":"11944813","4":"141","5":"1","6":"50.9","7":"80.3","8":"4.00","9":"0.050000","10":"46.30","11":"65.1","12":"166.018","13":"3.118650","14":"228.28571","15":"not explicit","16":"450","17":"51","18":"145030723","19":"9740","20":"29613108","21":"4133393","22":"24286416","23":"3308630","24":"73100","25":"Luan Santana","26":"Eu, VocÃª, O Mar e Ela","27":"2016-06-20","28":"other","29":"Independent","30":"TRUE","31":"excellent"},{"1":"USUM71808193","2":"5239","3":"8934097","4":"51","5":"21","6":"35.3","7":"75.5","8":"73.30","9":"0.000000","10":"39.00","11":"43.7","12":"191.153","13":"3.228000","14":"144.28571","15":"not explicit","16":"768","17":"54","18":"13188411","19":"358700","20":"3693566","21":"18367363","22":"143384531","23":"465412","24":"588550","25":"Alessia Cara","26":"Growing Pains","27":"2018-06-14","28":"Pop","29":"Universal Music","30":"FALSE","31":"good"},{"1":"ES5701800181","2":"776407","3":"38835","4":"1","5":"1","6":"68.3","7":"67.6","8":"14.70","9":"0.000000","10":"7.26","11":"43.4","12":"98.992","13":"3.015550","14":"112.28571","15":"not explicit","16":"48","17":"32","18":"6116639","19":"0","20":"623778","21":"888273","22":"4846378","23":"23846","24":"0","25":"Ana Guerra","26":"El Remedio","27":"2018-04-26","28":"Pop","29":"Universal Music","30":"FALSE","31":"good"},{"1":"ITRSE2000050","2":"433730","3":"46766","4":"1","5":"1","6":"70.4","7":"56.8","8":"26.80","9":"0.000253","10":"8.91","11":"49.5","12":"91.007","13":"3.453417","14":"50.71429","15":"not explicit","16":"6","17":"44","18":"0","19":"13","20":"81601","21":"143761","22":"156521","23":"1294","24":"0","25":"Claver Gold feat. Murubutu","26":"Ulisse","27":"2020-03-31","28":"HipHop/Rap","29":"Independent","30":"FALSE","31":"poor"},{"1":"QZJ842000061","2":"526471","3":"2930573","4":"7","5":"4","6":"84.2","7":"57.8","8":"13.80","9":"0.000000","10":"22.80","11":"19.0","12":"74.496","13":"3.946317","14":"58.28571","15":"not explicit","16":"475","17":"52","18":"0","19":"515","20":"11962358","21":"15551876","22":"90841884","23":"380204","24":"55482","25":"Trippie Redd feat. Young Thug","26":"YELL OH","27":"2020-02-07","28":"HipHop/Rap","29":"Universal Music","30":"FALSE","31":"excellent"},{"1":"USIR20400274","2":"1939","3":"72199738","4":"226","5":"8","6":"35.2","7":"91.1","8":"7.47","9":"0.000000","10":"9.95","11":"23.6","12":"148.033","13":"3.716217","14":"876.71429","15":"not explicit","16":"20591","17":"81","18":"20216069","19":"67300","20":"1169284","21":"16224250","22":"80408253","23":"1651866","24":"5281161","25":"The Killers","26":"Mr. Brightside","27":"2004-06-07","28":"Rock","29":"Universal Music","30":"TRUE","31":"fair"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

In the following sections, we will inspect the data in more detail.

### Categorical variables

Categorical variables contain a finite number of categories or distinct groups and are also known as qualitative or non-metric variables. There are different types of categorical variables:

* **Nominal variables**: variables that have two or more categories but no logical order (e.g., music genres). A dichotomous variable (also referred to as dummy variable or binary variable) is simply a nominal variable that only has two categories (e.g., indicator for explicit lyrics).
* **Ordinal variables**: variables that have two or more categories that can also be ordered or ranked (e.g., expert ratings).

Let's now start to investigate the **nominal variables** in our data set (i.e., explicit, genre, label).

As the table above shows, the only permissible operation with nominal variables is counting. That is, we can inspect the frequency distribution, which tells us how many observations we have per category. The ```table()``` function creates a frequency table that counts how many observations we have in each category. 


```r
table(music_data$genre) #absolute frequencies
```

```
## 
## Classics/Jazz       Country Electro/Dance   German Folk    HipHop/Rap 
##            80           504          2703           539         21131 
##         other           Pop           R&B        Reggae          Rock 
##          5228         30069          1881           121          4214 
##    Soundtrack 
##           326
```

```r
table(music_data$label) #absolute frequencies
```

```
## 
##     Independent      Sony Music Universal Music    Warner Music 
##           22570           12390           21632           10204
```

```r
table(music_data$explicit) #absolute frequencies
```

```
## 
## not explicit     explicit 
##        58603         8193
```

The numbers associated with the factor level in the output tell you, how many observations there are per category. For example, there are 21131 songs from the HipHop & Rap genre. 

Often, we are interested in the relative frequencies, which can be obtained by using the ```prop.table()``` function.


```r
prop.table(table(music_data$genre)) #relative frequencies
```

```
## 
## Classics/Jazz       Country Electro/Dance   German Folk    HipHop/Rap 
##   0.001197677   0.007545362   0.040466495   0.008069345   0.316351279 
##         other           Pop           R&B        Reggae          Rock 
##   0.078268160   0.450161686   0.028160369   0.001811486   0.063087610 
##    Soundtrack 
##   0.004880532
```

```r
prop.table(table(music_data$label)) #relative frequencies
```

```
## 
##     Independent      Sony Music Universal Music    Warner Music 
##       0.3378945       0.1854901       0.3238517       0.1527636
```

```r
prop.table(table(music_data$explicit)) #relative frequencies
```

```
## 
## not explicit     explicit 
##     0.877343     0.122657
```



Now the output gives you the relative frequencies. For example, the market share of Warner Music in the Top200 charts is ~15.3%, ~6.3% of songs are from the Rock genre, and ~12.3% of the songs have explicit lyrics. 

Note that the above output shows the overall relative frequencies. In many cases, it is meaningful to consider conditional relative frequencies. This can be achieved by adding a ```,1``` to the ```prop.table()``` command, which tells R to compute the relative frequencies by row (which is in our case the genre variable). The following code can be used to show the relative frequency of songs with explicit lyrics by genre.  


```r
prop.table(table(select(music_data, genre, explicit)),1) #conditional relative frequencies
```

```
##                explicit
## genre           not explicit   explicit
##   Classics/Jazz   0.82500000 0.17500000
##   Country         0.98015873 0.01984127
##   Electro/Dance   0.66000740 0.33999260
##   German Folk     0.70129870 0.29870130
##   HipHop/Rap      0.94846434 0.05153566
##   other           0.92214996 0.07785004
##   Pop             0.84472380 0.15527620
##   R&B             0.92238171 0.07761829
##   Reggae          0.90909091 0.09090909
##   Rock            0.82819174 0.17180826
##   Soundtrack      0.86809816 0.13190184
```
As can be seen, the presence of explicit lyrics greatly varies across genres. While in the Electro/Dance genre ~34% of songs have explicit lyrics, in the Country genre, this share is only ~2%.

The 'expert_rating' variable is an example of an **ordinal variable**. Although we can now rank order the songs with respect to their rating, this variable doesn't contain information about the distance between two songs. To get a measure of central tendency, we could, for example, compute the median of this variable using the `quantile()`-function (recall that the 50th percentile is the median). For ordinal factors we also have to set the algorithm that calculates the percentiles to `type=1` (see `?quantile` for more details).


```r
median_rating <- quantile(music_data$expert_rating, 0.5, type = 1)
median_rating
```

```
##  50% 
## good 
## Levels: poor < fair < good < excellent < masterpiece
```
This means that the "middle" value when the data are arranged is expert rating "good" (median = 50th percentile). Note that you could also compute other percentiles using the `quanile()`-function. For example, to get the median and the interquartile range, we could compute the 25th, 50th, and 75th percentile.  


```r
quantile(music_data$expert_rating,c(0.25,0.5,0.75), type = 1)
```

```
##       25%       50%       75% 
##      fair      good excellent 
## Levels: poor < fair < good < excellent < masterpiece
```
This means that the interquartile range is between "fair" and "excellent". If you wanted to compare different genres according to these statistics, you could do this using the `group_by()`-function as follows:


```r
percentiles <- c(0.25, 0.5, 0.75)
rating_percentiles <- music_data |>
  group_by(explicit) |>
  summarize(
    percentile = percentiles,
    value = quantile(expert_rating, percentiles, type = 1)) 
rating_percentiles
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["explicit"],"name":[1],"type":["fct"],"align":["left"]},{"label":["percentile"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["value"],"name":[3],"type":["ord"],"align":["right"]}],"data":[{"1":"not explicit","2":"0.25","3":"fair"},{"1":"not explicit","2":"0.50","3":"good"},{"1":"not explicit","2":"0.75","3":"excellent"},{"1":"explicit","2":"0.25","3":"fair"},{"1":"explicit","2":"0.50","3":"good"},{"1":"explicit","2":"0.75","3":"excellent"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
In this case, we don't observe any differences in the first, second, or third quantile of expert ratings between explicit and non-explicit songs.


### Continuous variables

#### Descriptive statistics

Continuous variables (also know as metric variables) are numeric variables that can take on any value on a measurement scale (i.e., there is an infinite number of values between any two values). There are different types of continuous variables as we have seen in chapter 1:

* **Interval variables**: while the zero point is arbitrary, equal intervals on the scale represent equal differences in the property being measured. E.g., on a temperature scale measured in Celsius the difference between a temperature of 15 degrees and 25 degrees is the same difference as between 25 degrees and 35 degrees but the zero point is arbitrary (there are different scales to measure temperature, such as Fahrenheit or Celsius, and zero in this case doesn't indicate the absence of temperature). 
* **Ratio variables**: has all the properties of an interval variable, but also has an absolute zero point. When the variable equals 0.0, it means that there is none of that variable (e.g., the number of streams or duration variables in our example). 

For interval and ratio variables we can also compute the mean as a measure of central tendency, as well as the variance and the standard deviation as measures of dispersion. Computing descriptive statistics for continuous variables is easy and there are many functions from different packages that let you calculate summary statistics (including the ```summary()``` function from the ```base``` package). In this tutorial, we will use the ```describe()``` function from the ```psych``` package. Note that you could just as well use other packages to compute the descriptive statistics (e.g., the ```stat.desc()``` function from the ```pastecs``` package). Which one you choose depends on what type of information you seek (the results provide slightly different information) and on personal preferences. 

We could, for example, compute the summary statistics for the variables "streams", "danceability", and "valence" in our data set as follows:


```r
library(psych)
psych::describe(select(music_data, streams, danceability, valence))
```

```
##              vars     n       mean          sd   median    trimmed       mad
## streams         1 66796 7314673.94 39956263.68 333335.5 1309559.27 471342.26
## danceability    2 66796      66.32       14.71     68.0      67.15     14.83
## valence         3 66796      50.42       22.26     50.0      50.16     25.35
##               min          max        range  skew kurtosis        se
## streams      1003 2165692479.0 2165691476.0 16.74   452.05 154600.05
## danceability    0         98.3         98.3 -0.53     0.03      0.06
## valence         0         99.0         99.0  0.08    -0.84      0.09
```
You can see that the output contains measures of central tendency (e.g., the mean) and dispersion (e.g., sd) for the selected variables. It can be seen, for example, that the mean of the streams variable is 7,314,674 while the median is 333,336. This already tells us something about the distribution of the data. Because the mean is substantially higher than the median, we can conclude that there are a few songs with many streams, resulting in a right skew of the distribution. The median as a measure of central tendency is generally less susceptible to outliers.   

In the above command, we used the ```psych::``` prefix to avoid confusion and to make sure that R uses the ```describe()``` function from the ```psych``` package since there are many other packages that also contain a ```desribe()``` function. Note that you could also compute these statistics separately by using the respective functions (e.g., ```mean()```, ```sd()```, ```median()```, ```min()```, ```max()```, etc.). There are many options for additional statistics for this function. For example, you could add the argument `IQR = TRUE` to add the interquartile range to the output.   

The ```psych``` package also contains the ```describeBy()``` function, which lets you compute the summary statistics by sub-groups separately. For example, we could compute the summary statistics by genre as follows: 


```r
describeBy(select(music_data, streams, danceability, valence), music_data$genre,skew = FALSE, range = FALSE)
```

```
## 
##  Descriptive statistics by group 
## group: Classics/Jazz
##              vars  n      mean         sd        se
## streams         1 80 735685.05 2590987.28 289681.18
## danceability    2 80     46.00      18.34      2.05
## valence         3 80     38.24      24.30      2.72
## ------------------------------------------------------------ 
## group: Country
##              vars   n        mean          sd         se
## streams         1 504 15029908.45 43603853.23 1942269.99
## danceability    2 504       59.67       11.98       0.53
## valence         3 504       58.90       21.08       0.94
## ------------------------------------------------------------ 
## group: Electro/Dance
##              vars    n        mean          sd         se
## streams         1 2703 12510460.33 56027266.04 1077646.71
## danceability    2 2703       66.55       11.87       0.23
## valence         3 2703       47.50       21.49       0.41
## ------------------------------------------------------------ 
## group: German Folk
##              vars   n       mean          sd        se
## streams         1 539 2823274.57 10037803.62 432358.81
## danceability    2 539      63.03       15.36      0.66
## valence         3 539      56.07       24.07      1.04
## ------------------------------------------------------------ 
## group: HipHop/Rap
##              vars     n       mean          sd        se
## streams         1 21131 6772815.16 37100200.64 255220.90
## danceability    2 21131      73.05       12.30      0.08
## valence         3 21131      49.04       20.73      0.14
## ------------------------------------------------------------ 
## group: other
##              vars    n        mean          sd        se
## streams         1 5228 12615232.06 38126472.04 527301.29
## danceability    2 5228       64.53       15.39      0.21
## valence         3 5228       60.16       22.73      0.31
## ------------------------------------------------------------ 
## group: Pop
##              vars     n       mean          sd        se
## streams         1 30069 5777165.76 36618010.00 211171.47
## danceability    2 30069      63.74       14.46      0.08
## valence         3 30069      50.33       22.57      0.13
## ------------------------------------------------------------ 
## group: R&B
##              vars    n        mean          sd         se
## streams         1 1881 15334008.40 54013527.81 1245397.95
## danceability    2 1881       67.97       13.43       0.31
## valence         3 1881       52.83       23.01       0.53
## ------------------------------------------------------------ 
## group: Reggae
##              vars   n       mean          sd         se
## streams         1 121 6413030.64 20384605.84 1853145.99
## danceability    2 121      75.06        9.33       0.85
## valence         3 121      69.73       18.38       1.67
## ------------------------------------------------------------ 
## group: Rock
##              vars    n       mean          sd        se
## streams         1 4214 6902054.06 54383538.37 837761.11
## danceability    2 4214      54.75       13.98      0.22
## valence         3 4214      45.65       22.53      0.35
## ------------------------------------------------------------ 
## group: Soundtrack
##              vars   n        mean          sd         se
## streams         1 326 12676756.22 71865892.69 3980283.67
## danceability    2 326       52.82       16.25       0.90
## valence         3 326       37.99       22.44       1.24
```

In this example, we used the arguments `skew = FALSE` and `range = FALSE` to exclude some statistics from the output. 

R is open to user contributions and various users have contributed packages that aim at making it easier for researchers to summarize statistics. For example, the <a href="https://cran.r-project.org/web/packages/summarytools/vignettes/Recommendations-rmarkdown.html" target="_blank">summarytools</a> package can be used to summarize the variables. If you would like to use this package and you are a Mac user, you may need to also install XQuartz (X11) too. To do this, go to <a href="https://www.xquartz.org/" target="_blank">this page</a> and download the XQuartz-2.7.7.dmg, then open the downloaded folder and click XQuartz.pkg and follow the instruction on screen and install XQuartz. If you still encouter an error after installing XQuartz, you may find a solution <a href="href="https://www.xquartz.org/" target="_blank">here</a>.

<style type="text/css">
 img {   background-color: transparent;   border: 0; }  .st-table td, .st-table th {   padding: 8px; }  .st-table > thead > tr {    background-color: #eeeeee; }  .st-cross-table td {   text-align: center; }  .st-descr-table td {   text-align: right; }  table.st-table th {   text-align: center; }  table.st-table > thead > tr {    background-color: #eeeeee; }  table.st-table td span {   display: block; }  table.st-table > tfoot > tr > td {   border:none; }  .st-container {   width: 100%;   padding-right: 15px;   padding-left: 15px;   margin-right: auto;   margin-left: auto;   margin-top: 15px; }  .st-multiline {   white-space: pre; }  .st-table {     width: auto;     table-layout: auto;     margin-top: 20px;     margin-bottom: 20px;     max-width: 100%;     background-color: transparent;     border-collapse: collapse; }  .st-table > thead > tr > th, .st-table > tbody > tr > th, .st-table > tfoot > tr > th, .st-table > thead > tr > td, .st-table > tbody > tr > td, .st-table > tfoot > tr > td {   vertical-align: middle; }  .st-table-bordered {   border: 1px solid #bbbbbb; }  .st-table-bordered > thead > tr > th, .st-table-bordered > tbody > tr > th, .st-table-bordered > thead > tr > td, .st-table-bordered > tbody > tr > td {   border: 1px solid #cccccc; }  .st-table-bordered > thead > tr > th, .st-table-bordered > thead > tr > td, .st-table thead > tr > th {   border-bottom: none; }  .st-freq-table > thead > tr > th, .st-freq-table > tbody > tr > th, .st-freq-table > tfoot > tr > th, .st-freq-table > thead > tr > td, .st-freq-table > tbody > tr > td, .st-freq-table > tfoot > tr > td, .st-freq-table-nomiss > thead > tr > th, .st-freq-table-nomiss > tbody > tr > th, .st-freq-table-nomiss > tfoot > tr > th, .st-freq-table-nomiss > thead > tr > td, .st-freq-table-nomiss > tbody > tr > td, .st-freq-table-nomiss > tfoot > tr > td, .st-cross-table > thead > tr > th, .st-cross-table > tbody > tr > th, .st-cross-table > tfoot > tr > th, .st-cross-table > thead > tr > td, .st-cross-table > tbody > tr > td, .st-cross-table > tfoot > tr > td {   padding-left: 20px;   padding-right: 20px; }  .st-table-bordered > thead > tr > th, .st-table-bordered > tbody > tr > th, .st-table-bordered > thead > tr > td, .st-table-bordered > tbody > tr > td {   border: 1px solid #cccccc; }  .st-table-striped > tbody > tr:nth-of-type(odd) {   background-color: #ffffff; }  .st-table-striped > tbody > tr:nth-of-type(even) {   background-color: #f9f9f9; }  .st-descr-table > thead > tr > th, .st-descr-table > tbody > tr > th, .st-descr-table > thead > tr > td, .st-descr-table > tbody > tr > td {   padding-left: 24px;   padding-right: 24px;   word-wrap: break-word; }  .st-freq-table, .st-freq-table-nomiss, .st-cross-table {   border: medium none; }  .st-freq-table > thead > tr:nth-child(1) > th:nth-child(1), .st-cross-table > thead > tr:nth-child(1) > th:nth-child(1), .st-cross-table > thead > tr:nth-child(1) > th:nth-child(3) {   border: none;   background-color: #ffffff;   text-align: center; }  .st-protect-top-border {   border-top: 1px solid #cccccc !important; }  .st-ws-char {   display: inline;   color: #999999;   letter-spacing: 0.2em; }  /* Optional classes */ .st-small {   font-size: 13px; }  .st-small td, .st-small th {   padding: 8px; }  .st-small > thead > tr > th, .st-small > tbody > tr > th, .st-small > thead > tr > td, .st-small > tbody > tr > td {   padding-left: 12px;   padding-right: 12px; } </style>


```r
library(summarytools)
print(dfSummary(select(music_data, streams, valence, genre, label, explicit), plain.ascii = FALSE, style = "grid",valid.col = FALSE, tmp.img.dir = "tmp", graph.magnif = .65),  method = 'render',headings = FALSE,footnote= NA)
```

```{=html}
<div class="container st-container"><table class="table table-striped table-bordered st-table st-table-striped st-table-bordered st-multiline ">
  <thead>
    <tr>
      <th align="center" class="st-protect-top-border"><strong>No</strong></th>
      <th align="center" class="st-protect-top-border"><strong>Variable</strong></th>
      <th align="center" class="st-protect-top-border"><strong>Stats / Values</strong></th>
      <th align="center" class="st-protect-top-border"><strong>Freqs (% of Valid)</strong></th>
      <th align="center" class="st-protect-top-border"><strong>Graph</strong></th>
      <th align="center" class="st-protect-top-border"><strong>Missing</strong></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">1</td>
      <td align="left">streams
[numeric]</td>
      <td align="left" style="padding:8;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">Mean (sd) : 7314674 (39956264)</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">min &le; med &le; max:</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">1003 &le; 333335.5 &le; 2165692479</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">IQR (CV) : 2125326 (5.5)</td></tr></table></td>
      <td align="left" style="vertical-align:middle">63462 distinct values</td>
      <td align="left" style="vertical-align:middle;padding:0;background-color:transparent;"><img style="border:none;background-color:transparent;padding:0;max-width:max-content;" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAGcAAABJBAMAAADSySWMAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAD1BMVEX////9/v2mpqbw8PD///+xh0SBAAAAAnRSTlMAAHaTzTgAAAABYktHRACIBR1IAAAAB3RJTUUH5goMFSwsHauT8AAAADVJREFUSMftyzEBABAQAMCPQANeBP27WQRg5W6/iDdl9nqs7DSmJEmSJEmSJEnSdylvtHjTAm862kkOB9vNAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIyLTEwLTEyVDIxOjQ0OjQ0KzAwOjAwsmKeLQAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMi0xMC0xMlQyMTo0NDo0NCswMDowMMM/JpEAAAAASUVORK5CYII="></td>
      <td align="center">0
(0.0%)</td>
    </tr>
    <tr>
      <td align="center">2</td>
      <td align="left">valence
[numeric]</td>
      <td align="left" style="padding:8;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">Mean (sd) : 50.4 (22.3)</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">min &le; med &le; max:</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">0 &le; 50 &le; 99</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">IQR (CV) : 34.2 (0.4)</td></tr></table></td>
      <td align="left" style="vertical-align:middle">1420 distinct values</td>
      <td align="left" style="vertical-align:middle;padding:0;background-color:transparent;"><img style="border:none;background-color:transparent;padding:0;max-width:max-content;" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAGcAAABJBAMAAADSySWMAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAD1BMVEX////9/v2mpqbw8PD///+xh0SBAAAAAnRSTlMAAHaTzTgAAAABYktHRACIBR1IAAAAB3RJTUUH5goMFSwtaqyjZgAAAMpJREFUSMft1lEOgyAMBmCPMHeCrb0B//3vNkBHADFpWePU0AcfTL8gTSlO0z1jroLo7Z9PorkRjx3EiAjuEOQ/rgPBwS2bEyC/REKAFAGdiMKOtIgj6UXbUggQ4zhEVQuKEFeNYYVCy+lRyvwVFaWQomItG7T0qRJxkXkdlJ0QOcpOowUKY0iNUsJ/UaqfBqVhMdDJ0TqfdWgdgDmKV60a1QkXRKF+ahTWGmiDivtZjFoJrXdELz0CBrJA1T+HDPFOgj0iTXzR3eIDdhKhqxe0o5cAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjItMTAtMTJUMjE6NDQ6NDUrMDA6MDAUFZWZAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIyLTEwLTEyVDIxOjQ0OjQ1KzAwOjAwZUgtJQAAAABJRU5ErkJggg=="></td>
      <td align="center">0
(0.0%)</td>
    </tr>
    <tr>
      <td align="center">3</td>
      <td align="left">genre
[factor]</td>
      <td align="left" style="padding:8;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">1. Classics/Jazz</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">2. Country</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">3. Electro/Dance</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">4. German Folk</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">5. HipHop/Rap</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">6. other</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">7. Pop</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">8. R&B</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">9. Reggae</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">10. Rock</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">11. Soundtrack</td></tr></table></td>
      <td align="left" style="padding:0;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">80</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">0.1%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">504</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">0.8%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">2703</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">4.0%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">539</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">0.8%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">21131</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">31.6%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">5228</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">7.8%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">30069</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">45.0%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">1881</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">2.8%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">121</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">0.2%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">4214</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">6.3%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">326</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">0.5%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr></table></td>
      <td align="left" style="vertical-align:middle;padding:0;background-color:transparent;"><img style="border:none;background-color:transparent;padding:0;max-width:max-content;" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADgAAACwBAMAAACoS7CYAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAD1BMVEX////9/v2mpqbw8PD///+xh0SBAAAAAnRSTlMAAHaTzTgAAAABYktHRACIBR1IAAAAB3RJTUUH5goMFSwtaqyjZgAAAIpJREFUWMPt1rENwCAMBEBW8Ag2G8D+uyVSigjJvIgRgeK/vQa9DSKlPVHxQtyLEkYj7kEJo5n2MVfiKoTFi5tTt484eQWbaIO5NiF+Q9jt3Mi6eB+oENcgLB6ODKK58RfsSSEOIux2ZmQAcyGuQli8CEAlHogSRnP/sO+bQIwj7BZOBaISD8S/cwEoD0WI9I+a0gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMi0xMC0xMlQyMTo0NDo0NSswMDowMBQVlZkAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjItMTAtMTJUMjE6NDQ6NDUrMDA6MDBlSC0lAAAAAElFTkSuQmCC"></td>
      <td align="center">0
(0.0%)</td>
    </tr>
    <tr>
      <td align="center">4</td>
      <td align="left">label
[factor]</td>
      <td align="left" style="padding:8;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">1. Independent</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">2. Sony Music</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">3. Universal Music</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">4. Warner Music</td></tr></table></td>
      <td align="left" style="padding:0;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">22570</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">33.8%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">12390</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">18.5%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">21632</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">32.4%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">10204</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">15.3%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr></table></td>
      <td align="left" style="vertical-align:middle;padding:0;background-color:transparent;"><img style="border:none;background-color:transparent;padding:0;max-width:max-content;" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAC0AAABEBAMAAADnz6E7AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAD1BMVEX////9/v2mpqbw8PD///+xh0SBAAAAAnRSTlMAAHaTzTgAAAABYktHRACIBR1IAAAAB3RJTUUH5goMFSwtaqyjZgAAAFBJREFUOMtjYKA9UEIDClBxZWNUMCqOKo4r3ATRgAC6ekVUcbj5o+JYxXGFG65wJhj+UIBhLwQYjYqjiuMKN0LhjC4ONd9oVBy7OK5woyUAAI5glsNJfR49AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIyLTEwLTEyVDIxOjQ0OjQ1KzAwOjAwFBWVmQAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMi0xMC0xMlQyMTo0NDo0NSswMDowMGVILSUAAAAASUVORK5CYII="></td>
      <td align="center">0
(0.0%)</td>
    </tr>
    <tr>
      <td align="center">5</td>
      <td align="left">explicit
[factor]</td>
      <td align="left" style="padding:8;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">1. not explicit</td></tr><tr style="background-color:transparent"><td style="padding:0;margin:0;border:0" align="left">2. explicit</td></tr></table></td>
      <td align="left" style="padding:0;vertical-align:middle"><table style="border-collapse:collapse;border:none;margin:0"><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">58603</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">87.7%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr><tr style="background-color:transparent"><td style="padding:0 5px 0 7px;margin:0;border:0" align="right">8193</td><td style="padding:0 2px 0 0;border:0;" align="left">(</td><td style="padding:0;border:0" align="right">12.3%</td><td style="padding:0 4px 0 2px;border:0" align="left">)</td></tr></table></td>
      <td align="left" style="vertical-align:middle;padding:0;background-color:transparent;"><img style="border:none;background-color:transparent;padding:0;max-width:max-content;" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAGEAAAAlBAMAAACg4ZrqAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAD1BMVEX////9/v2mpqbw8PD///+xh0SBAAAAAnRSTlMAAHaTzTgAAAABYktHRACIBR1IAAAAB3RJTUUH5goMFSwtaqyjZgAAADdJREFUOMtjYBg+QIlooADVoWxMLBjVMaqDeB2kp0RBooEAih2KJOiA+GNUx6gO6uogPSUOBwAAJaKl00rgu8kAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjItMTAtMTJUMjE6NDQ6NDUrMDA6MDAUFZWZAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIyLTEwLTEyVDIxOjQ0OjQ1KzAwOjAwZUgtJQAAAABJRU5ErkJggg=="></td>
      <td align="center">0
(0.0%)</td>
    </tr>
  </tbody>
</table></div>
```

The 'Missing' column in the output above gives us information about missing values. It this case, there are no missing values; however, in reality there are usually at least a couple of lost or not recorded values. To get more precise analysis results, we might want to exclude these observations by creating a "complete" subset of our data. Imagine that we have a missing value in the variable "valence"; we would create a subset by filtering that hypothetical observation out:


```r
music_data_valence <- filter(music_data, !is.na(valence))
```

In the command above, `!is.na()` is used to filter the rows for observations where the respective variable does not have missing values. The "!" in this case translates to "is not" and the function `is.na()` checks for missing values. Hence, the entire statement can be read as "select the rows from the 'music_data' data set where the values of the 'valence' and 'duration_ms' variables are not missing".

As you can see, the output also includes a visualization of the frequency distribution using a histogram for the continuous variables and a bar chart for the categorical variables. The frequency distribution is an important element that allows us to assign probabilities to observed values if the observations come from a known probability distribution. How to derive these probability statements will be discussed next.   

#### Using frequency distributions to go beyond the data

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/O6zyyV1ycgA" frameborder="0" allowfullscreen></iframe>
</div>
<br>

The frequency distribution can be used to make statements about the probability that a certain observed value will occur if the observations come from a known probability distribution. For normally distributed data, the following table can be used to look up the probability that a certain value will occur. For example, the value of -1.96 has a probability of 2.5% (i.e., .0250).  

<div class="figure" style="text-align: center">
<img src="./images/prob_table.JPG" alt="Standard normal table" width="70%" />
<p class="caption">(\#fig:unnamed-chunk-17)Standard normal table</p>
</div>
There are two things worth noting. First, the normal distribution has two tails as the following figure shows and we need to take the probability mass at each side of the distribution into account. Hence, there is a 2.5% probability of observing a value of -1.96 or smaller and a 2.5% of observing a value of 1.96 or larger. Hence, the probability mass within this interval is 0.95.  

<div class="figure" style="text-align: center">
<img src="./images/normal_distribution.JPG" alt="Standard normal distribution" width="70%" />
<p class="caption">(\#fig:unnamed-chunk-18)Standard normal distribution</p>
</div>
The second point is related to the scale of the distribution. Since the variables that we will collect can be measured at many different scales (e.g., number of streams, duration in milliseconds), we need a way to convert the scale into a standardized measure that would allow us to compare the observations against the values from the probability table. The **standardized variate**, or z-score, allows us to do exactly that. It is computed as follows: 

$$\begin{align}
Z=\frac{X_i-\bar{X}}{s}
\end{align}
$$

By subtracting the mean of the variable from each observation and dividing by the standard deviation, the data is converted to a scale with mean = 0 and SD = 1, so we can use the tables of probabilities for the normal distribution to see how likely it is that a particular score will occur in the data. In other words, **the z-score tells us how many standard deviations above or below the mean a particular x-value is**. 


To see how this works in practice, let's inspect the distribution of the 'tempo' variable from the music data set, which is defined as the overall estimated tempo of a track in beats per minute (BPM). The `hist()`-function can be used to draw the corresponding histogram.


```r
hist(music_data$tempo)
```

<div class="figure" style="text-align: center">
<img src="04-basic_statistics_files/figure-html/unnamed-chunk-19-1.png" alt="Histogram of tempo variable" width="672" />
<p class="caption">(\#fig:unnamed-chunk-19)Histogram of tempo variable</p>
</div>
In this case, the variable is measured on the scale "beats per minute". To standardize this variable, we will subtract the mean of this variable from each observation and then divide by the standard deviation. We can compute the standardized variable by hand as follows:


```r
music_data$tempo_std <- (music_data$tempo - mean(music_data$tempo))/sd(music_data$tempo)
```

If we create the histogram again, we can see that the scale has changed and now we can compare the standardized values to the values we find in the probability table.  


```r
hist(music_data$tempo_std)
```

<div class="figure" style="text-align: center">
<img src="04-basic_statistics_files/figure-html/unnamed-chunk-21-1.png" alt="Histogram of standardized tempo variable" width="672" />
<p class="caption">(\#fig:unnamed-chunk-21)Histogram of standardized tempo variable</p>
</div>
Note that you could have also used the `scale()`-function instead of computing the z-scores manually, which leads to the same result: 


```r
music_data$tempo_std <- scale(music_data$tempo)
```

Instead of manually comparing the observed values to the values in the table, it is much easier to use the in-built functions to obtain the probabilities. The `pnorm()`-function gives the probability of obtaining values lower than the indicated values (i.e., the probability mass left of that value). For the value of 1.96, this probability mass is ~0.025, in line with the table above. 


```r
pnorm(-1.96)
```

```
## [1] 0.0249979
```
To also take the other end of the distribution into consideration, we would need to multiply this value by to. This way, we arrive at a value of 5%.


```r
pnorm(-1.96)*2
```

```
## [1] 0.04999579
```
Regarding the standard normal distribution, it is helpful to remember the following numbers, indicating the points on the standard normal distribution, where the sum of the probability mass to the left at the lower end and to the right of the upper end exceed a certain threshold:  

* +/-**1.645** - 10% of probability mass outside this region
* +/-**1.960** - 5% of probability mass outside this region
* +/-**2.580** - 1% of probability mass outside this region

Going back to our example, we could also ask: what is the probability of obtaining the minimum (or maximum) observed value in our data? The minimum value on the standardized scale is:


```r
min(music_data$tempo_std)
```

```
## [1] -4.253899
```
And the associated probability is:  


```r
pnorm(min(music_data$tempo_std))*2
```

```
## [1] 0.00002100803
```
Although the probability of observing this minimum value is very low, there are very few observations in the extreme regions at each end of the histogram, so this doesn't seem too unusual. As a rule of thumb, you can remember that 68% of the observations of a normally distributed variable should be within 1 standard deviation of the mean, 95% within 2 standard deviations, and 99.7% within 3 standard deviations. This is also shown in the following plot: 

<div class="figure" style="text-align: center">
<img src="./images/prob_rule.JPG" alt="The 68, 95, 99.7 rule (source: Wikipedia)" width="70%" />
<p class="caption">(\#fig:unnamed-chunk-27)The 68, 95, 99.7 rule (source: Wikipedia)</p>
</div>

In case of our 'tempo' variable, we do not observe values that are more than 3 standard deviations away from the mean. In other instances, checking the standardized values of a variable may help you to identify outliers. For example, if you conducted a survey and you would like to exclude respondents who answered the survey too fast, you may exclude cases with a low probability based on the distribution of the duration variable.   

