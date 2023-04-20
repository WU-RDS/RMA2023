

## Assignment 1

We'll use the music data set from the last session as the basis for the assignment. 

Please use R to solve the tasks. When you finished the assignment, click on the "Knit to HTML" in the RStudio menu. This will create an html document in the folder in which the assignment1.Rmd file is stored. Open this file in your browser to check if everything is correct. If you are happy with the output, pleas submit the .html-file via the assignment on Learn\@WU using the following file name: "assignment1_studendID_lastname.html".

We'll first load the data that is needed for the assignment.

```{r load_data, message = FALSE, warning = FALSE}
library(dplyr)
library(psych)
library(ggplot2)

music_data <- read.csv2("https://raw.githubusercontent.com/WU-RDS/RMA2022/main/data/music_data_fin.csv",
                        sep = ";", header = TRUE, dec = ",")
str(music_data)
head(music_data) 
```

You should then convert the variables to the correct types:  
  
  ```{r convert_variables, message=FALSE, warning=FALSE}
music_data <-  music_data %>% 
  mutate(label = as.factor(label), # convert label and genre variables to factor with values as labels
         genre = as.factor(genre)) %>% as.data.frame()
```

### Q1

Create a new data frame containing the most successful songs of the artist "Billie Eilish" by filtering the original data set by the artist "Billie Eilish" and order the observations in an descending order.  

```{r question_1, message = FALSE, warning = FALSE}
billie_eilish <- music_data %>% 
  select(artistName,trackName,streams) %>% #select relevant variables
  filter(artistName == "Billie Eilish") %>% #filter by artist name
  arrange(desc(streams)) #arrange by number of streams (in descending order)
billie_eilish #print output
```

### Q2

Create a new data frame containing the 100 overall most successful songs in the data frame and order them descending by the number of streams.

Here you could simply arrange the whole data set by streams and then take 100 first rows using the `head()`-function:
  
  ```{r question_2, message = FALSE, warning = FALSE}
top_100 <- music_data %>% 
  select(artistName,trackName,streams) %>% #select relevant variables
  arrange(desc(streams)) %>% #arrange by number of streams (in descending order)
  head(100) #select first 100 observations
top_100
```

### Q3

Which genres are most popular? Group the data by genre and compute the sum of streams by genre. 

Using `dplyr` functions, you could first group the observations by genre, then summarize the streams using `sum()`:
  
  ```{r question_3_1, message = FALSE, warning = FALSE}
genres_popularity <- music_data %>% 
  group_by(genre) %>% #group by genre
  summarize(streams = sum(streams)) #compute sum of streams per genre
genres_popularity
```

### Q4

Which music label is most successful? Group the data by music label and compute the sum of streams by label and the average number of streams for all songs associated with a label. 

Just like in the previous task, it would be enough to group the observations (in this case, by labels), and get the sums and averages of streams:
  
  ```{r question_4_1, message = FALSE, warning = FALSE}
label_success <- music_data %>% 
  group_by(label) %>% #group by label
  summarize(sum_streams = sum(streams),
            avg_streams = mean(streams)) #compute sum of streams and average streams per label
label_success
```

### Q5

How do the songs differ in terms of the song features? Please first select the relevant variables (7 song features) and compute the descriptive statistics for these variables by genre.     

All audio features (danceability, energy, speechiness, instrumentalness, liveness, valence, and tempo) are variables measured on a **ratio scale**, which means that we can evaluate their **average values**. We can use `describeBy()` function, which displays mean by default alongside with range and other values:
  
  ```{r question_5_1, message = FALSE, warning = FALSE}
library(psych)
describeBy(select(music_data, 
                  danceability, energy, speechiness, instrumentalness, liveness, valence, tempo), 
           music_data$genre, skew = FALSE) 
```


### Q6

How many songs in the data set are associated with each label? 
  
  You could use `table()` to get the number of songs by label:
  
  ```{r question_6, message = FALSE, warning = FALSE}
table(music_data$label)
```


### Q7

Which share of streams do the different genres account for?
  
  ```{r question_7, message = FALSE, warning = FALSE}
genre_streams <- music_data %>% 
  group_by(genre) %>%
  summarise(genre_streams=sum(streams)) #first compute sum of streams by genre
genre_streams_share <- genre_streams %>%
  mutate(genre_share = genre_streams/sum(genre_streams)) #then divide the sum by the total streams
genre_streams_share
```

### Q8

Create a histogram for the variable "Valence" 

This is a simple plot of valence distribution across all songs in your data (we can see that it follows normal distribution):
  
  ```{r question_8, message = FALSE, warning = FALSE, fig.cap=c("Distribution of valence"), fig.align="center", echo=TRUE}
ggplot(music_data,aes(x = valence)) + 
  geom_histogram(binwidth = 4, col = "white", fill = "lavenderblush3") + 
  labs(x = "Valence", y = "Frequency") +
  theme_minimal()
```

### Q9

Create a grouped boxplot for the variable "energy" by genre.

```{r question_9, message = FALSE, warning = FALSE, fig.cap=c("Boxplot of energy by genre"), fig.align="center", echo=TRUE}
ggplot(music_data, aes(x = genre, y = energy, color = genre)) + 
  geom_boxplot(coef = 3) + 
  labs(x = "Genre", y = "Energy") + 
  theme_minimal() + 
  coord_flip()
```

### Q10

Create a scatterplot for the variables "valence" and "energy"

Finally, we can visualize the relationship between valence and energy of songs in our data:
  
  ```{r question_10, message = FALSE, warning = FALSE, fig.cap=c("Scatterplot of energy and valence"), fig.align="center", echo=TRUE}
ggplot(music_data, aes(x = valence, y = energy)) +
  geom_point(shape = 1) + 
  labs(x = "Valence", y = "Energy") +
  theme_minimal()
```



## Assignment 2

As a marketing manager of a consumer electronics company, you are assigned the task to analyze the relative influence of different marketing activities. Specifically, you are supposed to analyze the effects of (1) TV advertising, (2) online advertising, and (3) radio advertising on the sales of fitness trackers (wristbands). Your data set consists of sales of the product in different markets (each line represents one market) from the past year, along with the advertising budgets for the product in each of those markets for three different media: TV, online, and radio. 

The following variables are available to you:
  
  * Sales (in thousands of units)
* TV advertising budget (in thousands of Euros)
* Online advertising budget (in thousands of Euros)
* Radio advertising budget (in thousands of Euros)

Please conduct the following analyses: 
  
  1. Formally state the regression equation, which you will use to determine the relative influence of the marketing activities on sales.
2. Describe the model variables using appropriate statistics and plots
3. Estimate a multiple linear regression model and interpret the model results:
  * Which variables have a significant influence on sales and what is the interpretation of the coefficients?
  * How do you judge the fit of the model? Please also visualize the model fit using an appropriate graph.
4. What sales quantity would you predict based on your model for a product when the marketing activities are planned as follows: TV: EUR 150 thsd., Online: EUR 26 thsd., Radio: EUR 15 thsd.? Please provide the equation you used for your prediction. 

When you are done with your analysis, click on "Knit to HTML" button above the code editor. This will create a HTML document of your results in the folder where the "assignment2.Rmd" file is stored. Open this file in your Internet browser to see if the output is correct. If the output is correct, submit the HTML file via Learn\@WU. The file name should be "assignment2_studendID_name.html".


```{r load_data2, message = FALSE, warning = FALSE}
library(tidyverse)
library(psych)
library(Hmisc)
library(ggstatsplot)
options(scipen = 999)

sales_data <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/assignment4.dat", 
                         sep = "\t", 
                         header = TRUE) #read in data
sales_data$market_id <- 1:nrow(sales_data)
head(sales_data)
str(sales_data)
```

### Q1

In a first step, we specify the regression equation. In this case, sales is the **dependent variable** which is regressed on the different types of advertising expenditures that represent the **independent variables** for product *i*. Thus, the regression equation is:
  
  $$sales_{i}=\beta_0 + \beta_1 * tv\_adspend_{i} + \beta_2 * online\_adspend_{i} + \beta_3 * radio\_adspend_{i} + \epsilon$$
  
  This equation will be used later to turn the output of the regression analysis (namely the coefficients: $\beta_0$ - intersect coefficient, and $\beta_1$, $\beta_2$, and $\beta_3$ that represent the unknown relationship between sales and advertising expenditures on TV, online channels and radio, respectively) to the "managerial" form and draw marketing conclusions.  

### Q2

The descriptive statistics for the variables can be checked using the ```describe()``` function:
  
  ```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, paged.print = FALSE}
psych::describe(sales_data)
```

Inspecting the correlation matrix reveals that the sales variable is positively correlated with TV advertising and online advertising expenditures. The correlations among the independent variables appear to be low to moderate. 

```{r, eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE}
rcorr(as.matrix(sales_data[,c("sales","tv_adspend","online_adspend","radio_adspend")]))
```

Since we have continuous variables, we use scatterplots to investigate the relationship between sales and each of the predictor variables.

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.show="hold", out.width="50%"}
ggplot(sales_data, aes(x = tv_adspend, y = sales)) + geom_point(shape = 1) + geom_smooth(method = "lm", 
                                                                                         fill = "gray", color = "lavenderblush3", alpha = 0.1) + theme_minimal()
ggplot(sales_data, aes(x = online_adspend, y = sales)) + geom_point(shape = 1) + geom_smooth(method = "lm", 
                                                                                             fill = "gray", color = "lavenderblush3", alpha = 0.1) + theme_minimal()
ggplot(sales_data, aes(x = radio_adspend, y = sales)) + geom_point(shape = 1) + geom_smooth(method = "lm", 
                                                                                            fill = "gray", color = "lavenderblush3", alpha = 0.1) + theme_minimal()
```

The plots including the fitted lines from a simple linear model already suggest that there might be a positive linear relationship between sales and TV- and online-advertising. However, there does not appear to be a strong relationship between sales and radio advertising. 

Further steps include estimate of a multiple linear regression model in order to determine the relative influence of each type of advertising on sales.

### Q3

The estimate the model, we will use the ```lm()``` function:
  
  ```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
linear_model <- lm(sales ~ tv_adspend + online_adspend + radio_adspend, data = sales_data) 
```

In a next step, we will investigate the results from the model using the ```summary()``` function. 

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
summary(linear_model)
```


For each of the individual predictors, we test the following hypothesis: 
  
  $$H_0: \beta_k=0$$
  $$H_1: \beta_k\ne0$$
  
  where k denotes the number of the regression coefficient. In the present example, we reject the null hypothesis for tv_adspend and online_adspend, where we observe a significant effect (i.e., p-value < 0.05). However, we fail to reject the null for the "radio_adspend" variable (i.e., the effect is insignificant). 

The interpretation of the coefficients is as follows: 
  
  * tv_adspend (&beta;<sub>1</sub>): when TV advertising expenditures increase by 1000 Euro, sales will increase by `r round(summary(linear_model)$coefficients[2],3)*1000` units;
* online_adspend (&beta;<sub>2</sub>): when online advertising expenditures increase by 1000 Euro, sales will increase by `r round(summary(linear_model)$coefficients[3],3)*1000` units;
* radio_adspend (&beta;<sub>3</sub>): when radio advertising expenditures increase by 1000 Euro, sales will increase by `r round(summary(linear_model)$coefficients[4],3)*1000` units (i.e., decrease by `r round(summary(linear_model)$coefficients[4],3)*1000*(-1)` units).

You should always provide a measure of uncertainty that is associated with the estimates. You could compute the confidence intervals around the coefficients using the ```confint()``` function.

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
confint(linear_model)
```

The results show that, for example, the 95% confidence interval associated with coefficient capturing the effect of online advertising on sales is between 0.168 and 0.205. 

Regarding the model fit, the R<sup>2</sup> statistic tells us that **approximately 86% of the variance can be explained by the model**. This can be visualized as follows: 
  
  ```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.width=7, fig.height=5}
sales_data$yhat <- predict(linear_model)
ggplot(sales_data,aes(yhat,sales)) +  
  geom_point(size=2,shape=1) +
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_minimal()
```

In addition, the output tells us that our predictions on average deviate from the observed values by 2048 units (see residual standard error, remember that the sales variable is measures in thousand units).

Of course, you could have also used the functions included in the ggstatsplot package to report the results from your regression model. 

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.width=7, fig.height=5}
ggcoefstats(x = linear_model, k = 3, title = "Sales predicted by TV-, online-, & radio advertising")
```

### Q4

Finally, we can predict the outcome for the given marketing mix using the following equation: 
  
  $$\hat{Sales} = \beta_0 + \beta_1*150 + \beta_2*26 + \beta_3*15 $$
  
  The coefficients can be extracted from the summary of the linear model and used for quick sales value prediction as follows:
  ```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
summary(linear_model)$coefficients[1,1] + 
  summary(linear_model)$coefficients[2,1]*150 + 
  summary(linear_model)$coefficients[3,1]*26 +
  summary(linear_model)$coefficients[4,1]*15
```

$$\hat{sales}= 3.6 + 0.045*150 + 0.187*26 + 0.011*15 = 15.11$$
  
  This means that given the planned marketing mix, we would expect to sell around 15,112 units. 


## Assignment 3

As a marketing manager of a music streaming service, you are interested to categorise the inventory according to musical features of songs. Hence, you are assigned the task of conducting a cluster analysis in order to assign each song to a distinct segment.   

The following variables are available to you:
  
  * isrc (unique song id)
* trackName (name of song)
* artistName (name of artist)
* danceability
* energy
* loudness
* mode
* speechiness
* acousticness
* instrumentalness
* liveness
* valence
* tempo
* duration_ms

Please conduct the following analyses: 
  
  1. Standardize the song feature variables as a preparation for the cluster analysis.
2. Provide a histogram for all 11 song features to describe the distribution of the variables
3. Determinde the optimal number of clusters
4. Run the K-Means Cluster analysis using the optimal number of clusters
5. Describe the clusters visually: 
  * radar plot by song feature
* bar chart for artists per cluster
* 2D visualization using of clusters (using PCA)
6. Imagine you create a playlist and you would like to find a song that is similar to the song "Monkey Wrench" by the Foo Fighters. Name one example song that would fit on the same playlist according to the cluster analysis (i.e., a song from the same cluster)? 
  
  When you are done with your analysis, click on "Knit to HTML" button above the code editor. This will create a HTML document of your results in the folder where the "assignment3.Rmd" file is stored. Open this file in your Internet browser to see if the output is correct. If the output is correct, submit the HTML file via Learn\@WU. The file name should be "assignment3_studendID_name.html".

We first load the data:
  
  ```{r load_data3, warning=FALSE, message=FALSE}
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
track_data <- read.table("https://raw.githubusercontent.com/WU-RDS/RMA2022/main/data/tracks_cluster.csv", 
                         sep = ";", header = TRUE, dec = ",") #read data
str(track_data)
```

### Q1

We can standardize the relevant variables as follows:
  
  ```{r question_1_13, warning=F, message=F}
# standardize variables
track_data_scale <- track_data %>% mutate_at(vars(danceability:duration_ms), scale)
track_data_scale <- track_data_scale %>% mutate_at(vars(danceability:duration_ms),as.vector)
```

### Q2

Now we can create histograms of the respective variables to inspect their distributions:
  
  ```{r question_2_13, warning=F, message=F}
ggplot(track_data_scale,aes(x=danceability)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=energy)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=loudness)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=mode)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=speechiness)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=acousticness)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=instrumentalness)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=liveness)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=valence)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=tempo)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
ggplot(track_data_scale,aes(x=duration_ms)) + geom_histogram(color="black",fill="steelblue") + theme_bw()
```

The distributions of the variables reveal nothing that would disqualify them from being included in the cluster analysis (e.g., severe outliers, etc.).

### Q3

The optimal number of clusters may be derived as follows (recall that you might get different results due to different starting values for the algorithm):
  
  ```{r question_3_13, warning=F, message=F}
# optimal number of clusters
set.seed(123)
opt_K <- NbClust(track_data_scale %>% select(danceability:duration_ms), method = "kmeans", max.nc = 10)
table(opt_K$Best.nc["Number_clusters",])
```

According to the output, the optimal number of clusters is 3.

### Q4

Now we can run the analysis using 3 clusters:
  
  ```{r question_4_13, warning=F, message=F}
kmeans_tracks <- kmeans(track_data_scale %>% select(danceability:duration_ms), 3)
```

### Q5

We can describe and characterize the clusters as follows. In a first step, we can inspect the mean values of the cluster variables by cluster. 

```{r question_5_13, warning=F, message=F}
kmeans_tracks$centers
centers <- data.frame(kmeans_tracks$centers)
centers$cluster <- 1:3
ggRadar(centers, aes(color = cluster), rescale = FALSE) + 
  ggtitle("Centers") +
  theme_bw()
```
This analysis reveals that there is one cluster (cluster 1) that exhibits comparatively high levels of liveness and speechiness and another cluster (cluster 3) that is characterized by high levels of acousticness and instrumentalness. Cluster 2 appears to have moderate values on all dimensions. 

We can further characterize the clusters by inspecting the artists in each cluster:
  
  ```{r question_5_23, warning=F, message=F}
track_data$cluster <- as.factor(kmeans_tracks$cluster)
ggplot(track_data, aes(y = cluster, fill = artistName)) +
  geom_bar() +
  theme_bw()
```
We can also count how many songs each artist has in each cluster:
  
  ```{r question_5_33, warning=F, message=F}
table(track_data$artistName, track_data$cluster)
```

It appears that cluster 1 consists of songs by rap artists such as Kontra K, Cpaital Bra, and Drake, while cluster 3 consists of songs by artists such as Coldplay and Taylor Swift. Cluster 2 is a mix of songs by different artists. This appears consistent with the analysis of the song features from the previous plot. 

Finally, we can group the songs by cluster and visualize their association with the first two principal components from a pca-analysis. Although this reduces the information compared to the original 11 variables, we cannot meaningfully display the 11 dimensions in detail.

```{r question_5_43, warning=F, message=F}
fviz_cluster(kmeans_tracks, data = track_data_scale %>% select(danceability:duration_ms),
             palette = hcl.colors(3, palette = "Dynamic"), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw())
```

Although the two dimensions only represent a fraction (approx. 41%) of the variation across the 11 dimensions, the plot shows that the cluster separates the songs rather well, since each cluster has a sizable area that is not overlapping with any of the other clusters. 

### Q6

For our playlist, let's first see in which cluster the song is:
 
```{r question_6_13, warning=F, message=F}
track_data %>% filter(trackName == "Monkey Wrench")
```

The song is in cluster number 2, so we can select any song from this cluster for our playlist:

```{r question_6_23, warning=F, message=F}
recommendations <- track_data %>% filter(cluster==2)
head(recommendations)
```