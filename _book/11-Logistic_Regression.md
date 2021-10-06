---
output:
  html_document:
    toc: yes
  html_notebook: default
  pdf_document:
    toc: yes
---





## Logistic regression

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/J7T7_ulyQ0I" frameborder="0" allowfullscreen></iframe>
</div>
<br>

### Motivation and intuition

In the last section we saw how to predict continuous outcomes (sales, height, etc.) via linear regression models. Another interesting case is that of binary outcomes, i.e. when the variable we want to model can only take two values (yes or no, group 1 or group 2, dead or alive, etc.). To this end we would like to estimate how our predictor variables change the probability of a value being 0 or 1. In this case we can technically still use a linear model (e.g. OLS). However, its predictions will most likely not be particularly useful. A more useful method is the logistic regression. In particular we are going to have a look at the logit model. In the following dataset we are trying to predict whether a song will be a top-10 hit on a popular music streaming platform. In a first step we are going to use only the danceability index as a predictor. Later we are going to add more independent variables. 


```r
library(ggplot2)
library(gridExtra)

chart_data <- read.delim2("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/chart_data_logistic.dat",header=T, sep = "\t",stringsAsFactors = F, dec = ".")
#Create a new dummy variable "top10", which is 1 if a song made it to the top10 and 0 else:
chart_data$top10 <- ifelse(chart_data$rank<11,1,0)

# Inspect data
head(chart_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["artistName"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trackID"],"name":[2],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[3],"type":["chr"],"align":["left"]},{"label":["rank"],"name":[4],"type":["int"],"align":["right"]},{"label":["streams"],"name":[5],"type":["int"],"align":["right"]},{"label":["frequency"],"name":[6],"type":["int"],"align":["right"]},{"label":["danceability"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["key"],"name":[9],"type":["int"],"align":["right"]},{"label":["loudness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["acousticness"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["duration_ms"],"name":[17],"type":["int"],"align":["right"]},{"label":["time_signature"],"name":[18],"type":["int"],"align":["right"]},{"label":["isrc"],"name":[19],"type":["chr"],"align":["left"]},{"label":["spotifyArtistID"],"name":[20],"type":["chr"],"align":["left"]},{"label":["releaseDate"],"name":[21],"type":["chr"],"align":["left"]},{"label":["daysSinceRelease"],"name":[22],"type":["int"],"align":["right"]},{"label":["spotifyFollowers"],"name":[23],"type":["int"],"align":["right"]},{"label":["mbid"],"name":[24],"type":["chr"],"align":["left"]},{"label":["artistCountry"],"name":[25],"type":["chr"],"align":["left"]},{"label":["indicator"],"name":[26],"type":["int"],"align":["right"]},{"label":["top10"],"name":[27],"type":["dbl"],"align":["right"]}],"data":[{"1":"dj mustard","2":"01gNiOqg8u7vT90uVgOVmz","3":"Whole Lotta Lovin'","4":"120","5":"917710","6":"3","7":"0.438","8":"0.399","9":"4","10":"-8.752","11":"0.0623","12":"0.1540","13":"0.00000845","14":"0.0646","15":"0.382","16":"160.159","17":"299160","18":"5","19":"QMJMT1500808","20":"0YinUQ50QDB7ZxSCLyQ40k","21":"08.01.2016","22":"450","23":"139718","24":"0612bcce-e351-40be-b3d7-2bb5e1c23479","25":"US","26":"1","27":"0"},{"1":"bing crosby","2":"01h424WG38dgY34vkI3Yd0","3":"White Christmas","4":"70","5":"1865526","6":"9","7":"0.225","8":"0.248","9":"9","10":"-15.871","11":"0.0337","12":"0.9120","13":"0.00014300","14":"0.4040","15":"0.185","16":"96.013","17":"183613","18":"4","19":"USMC14750470","20":"6ZjFtWeHP9XN7FeKSUe80S","21":"27.08.2007","22":"1000","23":"123135","24":"2437980f-513a-44fc-80f1-b90d9d7fcf8f","25":"US","26":"1","27":"0"},{"1":"post malone","2":"02opp1cycqiFNDpLd2o1J3","3":"Big Lie","4":"129","5":"1480436","6":"1","7":"0.325","8":"0.689","9":"6","10":"-4.951","11":"0.2430","12":"0.1970","13":"0.00000000","14":"0.0722","15":"0.225","16":"77.917","17":"207680","18":"4","19":"USUM71614468","20":"246dkjvS1zLTtiykXe5h60","21":"09.12.2016","22":"114","23":"629600","24":"b1e26560-60e5-4236-bbdb-9aa5a8d5ee19","25":"0","26":"1","27":"0"},{"1":"chris brown","2":"02yRHV9Cgk8CUS2fx9lKVC","3":"Anyway","4":"130","5":"894216","6":"1","7":"0.469","8":"0.664","9":"7","10":"-7.160","11":"0.1210","12":"0.0566","13":"0.00000158","14":"0.4820","15":"0.267","16":"124.746","17":"211413","18":"4","19":"USRC11502943","20":"7bXgB6jMjp9ATFy66eO08Z","21":"11.12.2015","22":"478","23":"4077185","24":"c234fa42-e6a6-443e-937e-2f4b073538a3","25":"US","26":"1","27":"0"},{"1":"5 seconds of summer","2":"0375PEO6HIwCHx5Y2sowQm","3":"Waste The Night","4":"182","5":"642784","6":"1","7":"0.286","8":"0.907","9":"8","10":"-4.741","11":"0.1130","12":"0.0144","13":"0.00000000","14":"0.2680","15":"0.271","16":"75.640","17":"266640","18":"4","19":"GBUM71505159","20":"5Rl15oVamLq7FbSb0NNBNy","21":"23.10.2015","22":"527","23":"2221348","24":"830e5c4e-6b7d-431d-86ab-00c751281dc5","25":"AU","26":"1","27":"0"},{"1":"rihanna","2":"046irIGshCqu24AjmEWZtr","3":"Same Ol’ Mistakes","4":"163","5":"809256","6":"2","7":"0.447","8":"0.795","9":"8","10":"-5.435","11":"0.0443","12":"0.2110","13":"0.00169000","14":"0.0725","15":"0.504","16":"151.277","17":"397093","18":"4","19":"QM5FT1600108","20":"5pKCCKE2ajJHZ9KAiaK11H","21":"29.01.2016","22":"429","23":"9687258","24":"73e5e69d-3554-40d8-8516-00cb38737a1c","25":"0","26":"1","27":"0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
str(chart_data)
```

```
## 'data.frame':	422 obs. of  27 variables:
##  $ artistName      : chr  "dj mustard" "bing crosby" "post malone" "chris brown" ...
##  $ trackID         : chr  "01gNiOqg8u7vT90uVgOVmz" "01h424WG38dgY34vkI3Yd0" "02opp1cycqiFNDpLd2o1J3" "02yRHV9Cgk8CUS2fx9lKVC" ...
##  $ trackName       : chr  "Whole Lotta Lovin'" "White Christmas" "Big Lie" "Anyway" ...
##  $ rank            : int  120 70 129 130 182 163 12 86 67 77 ...
##  $ streams         : int  917710 1865526 1480436 894216 642784 809256 3490456 1737890 1914768 1056689 ...
##  $ frequency       : int  3 9 1 1 1 2 2 12 17 11 ...
##  $ danceability    : num  0.438 0.225 0.325 0.469 0.286 0.447 0.337 0.595 0.472 0.32 ...
##  $ energy          : num  0.399 0.248 0.689 0.664 0.907 0.795 0.615 0.662 0.746 0.752 ...
##  $ key             : int  4 9 6 7 8 8 9 11 6 6 ...
##  $ loudness        : num  -8.75 -15.87 -4.95 -7.16 -4.74 ...
##  $ speechiness     : num  0.0623 0.0337 0.243 0.121 0.113 0.0443 0.0937 0.0362 0.119 0.056 ...
##  $ acousticness    : num  0.154 0.912 0.197 0.0566 0.0144 0.211 0.0426 0.0178 0.072 0.289 ...
##  $ instrumentalness: num  0.00000845 0.000143 0 0.00000158 0 0.00169 0.0000167 0 0 0.000101 ...
##  $ liveness        : num  0.0646 0.404 0.0722 0.482 0.268 0.0725 0.193 0.0804 0.116 0.102 ...
##  $ valence         : num  0.382 0.185 0.225 0.267 0.271 0.504 0.0729 0.415 0.442 0.398 ...
##  $ tempo           : num  160.2 96 77.9 124.7 75.6 ...
##  $ duration_ms     : int  299160 183613 207680 211413 266640 397093 199973 218447 196040 263893 ...
##  $ time_signature  : int  5 4 4 4 4 4 4 4 4 4 ...
##  $ isrc            : chr  "QMJMT1500808" "USMC14750470" "USUM71614468" "USRC11502943" ...
##  $ spotifyArtistID : chr  "0YinUQ50QDB7ZxSCLyQ40k" "6ZjFtWeHP9XN7FeKSUe80S" "246dkjvS1zLTtiykXe5h60" "7bXgB6jMjp9ATFy66eO08Z" ...
##  $ releaseDate     : chr  "08.01.2016" "27.08.2007" "09.12.2016" "11.12.2015" ...
##  $ daysSinceRelease: int  450 1000 114 478 527 429 506 132 291 556 ...
##  $ spotifyFollowers: int  139718 123135 629600 4077185 2221348 9687258 8713999 39723 4422933 3462797 ...
##  $ mbid            : chr  "0612bcce-e351-40be-b3d7-2bb5e1c23479" "2437980f-513a-44fc-80f1-b90d9d7fcf8f" "b1e26560-60e5-4236-bbdb-9aa5a8d5ee19" "c234fa42-e6a6-443e-937e-2f4b073538a3" ...
##  $ artistCountry   : chr  "US" "US" "0" "US" ...
##  $ indicator       : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ top10           : num  0 0 0 0 0 0 0 0 0 0 ...
```

Below are two attempts to model the data. The left assumes a linear probability model (calculated with the same methods that we used in the last chapter), while the right model is a __logistic regression model__. As you can see, the linear probability model produces probabilities that are above 1 and below 0, which are not valid probabilities, while the logistic model stays between 0 and 1. Notice that songs with a higher danceability index (on the right of the x-axis) seem to cluster more at $1$ and those with a lower more at $0$ so we expect a positive influence of danceability on the probability of a song to become a top-10 hit. 

<div class="figure" style="text-align: center">
<img src="11-Logistic_Regression_files/figure-html/unnamed-chunk-4-1.png" alt="The same binary data explained by two models; A linear probability model (on the left) and a logistic regression model (on the right)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-4)The same binary data explained by two models; A linear probability model (on the left) and a logistic regression model (on the right)</p>
</div>

A key insight at this point is that the connection between $\mathbf{X}$ and $Y$ is __non-linear__ in the logistic regression model. As we can see in the plot, the probability of success is most strongly affected by danceability around values of $0.5$, while higher and lower values have a smaller marginal effect. This obviously also has consequences for the interpretation of the coefficients later on.  

### Technical details of the model

As the name suggests, the logistic function is an important component of the logistic regression model. It has the following form:

$$
f(\mathbf{X}) = \frac{1}{1 + e^{-\mathbf{X}}}
$$
This function transforms all real numbers into the range between 0 and 1. We need this to model probabilities, as probabilities can only be between 0 and 1. 

<img src="11-Logistic_Regression_files/figure-html/unnamed-chunk-5-1.png" width="672" />



The logistic function on its own is not very useful yet, as we want to be able to determine how predictors influence the probability of a value to be equal to 1. To this end we replace the $\mathbf{X}$ in the function above with our familiar linear specification, i.e.

$$
\mathbf{X} = \beta_0 + \beta_1 * x_{1,i} + \beta_2 * x_{2,i} + ... +\beta_m * x_{m,i}\\
f(\mathbf{X}) = P(y_i = 1) = \frac{1}{1 + e^{-(\beta_0 + \beta_1 * x_{1,i} + \beta_2 * x_{2,i} + ... +\beta_m * x_{m,i})}}
$$

In our case we only have $\beta_0$ and $\beta_1$, the coefficient associated with danceability. 

In general we now have a mathematical relationship between our predictor variables $(x_1, ..., x_m)$ and the probability of $y_i$ being equal to one. The last step is to estimate the parameters of this model $(\beta_0, \beta_1, ..., \beta_m)$ to determine the magnitude of the effects.  

### Estimation in R

We are now going to show how to perform logistic regression in R. Instead of ```lm()``` we now use ```glm(Y~X, family=binomial(link = 'logit'))``` to use the logit model. We can still use the ```summary()``` command to inspect the output of the model. 


```r
#Run the glm
logit_model <- glm(top10 ~ danceability,family=binomial(link='logit'),data=chart_data)
#Inspect model summary
summary(logit_model )
```

```
## 
## Call:
## glm(formula = top10 ~ danceability, family = binomial(link = "logit"), 
##     data = chart_data)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.8852  -0.5011  -0.2385   0.2932   2.8196  
## 
## Coefficients:
##              Estimate Std. Error z value            Pr(>|z|)    
## (Intercept)  -10.0414     0.8963  -11.20 <0.0000000000000002 ***
## danceability  17.0939     1.6016   10.67 <0.0000000000000002 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 539.05  on 421  degrees of freedom
## Residual deviance: 258.49  on 420  degrees of freedom
## AIC: 262.49
## 
## Number of Fisher Scoring iterations: 6
```

Noticeably this output does not include an $R^2$ value to asses model fit. Multiple "Pseudo $R^2$s", similar to the one used in OLS, have been developed. There are packages that return the $R^2$ given a logit model (see ```rcompanion``` or ```pscl```). The calculation by hand is also fairly simple. We define the function ```logisticPseudoR2s()``` that takes a logit model as an input and returns three popular pseudo $R^2$ values.


```r
logisticPseudoR2s <- function(LogModel) {
  dev <- LogModel$deviance 
  nullDev <- LogModel$null.deviance 
  modelN <- length(LogModel$fitted.values)
  R.l <-  1 -  dev / nullDev
  R.cs <- 1- exp ( -(nullDev - dev) / modelN)
  R.n <- R.cs / ( 1 - ( exp (-(nullDev / modelN))))
  cat("Pseudo R^2 for logistic regression\n")
  cat("Hosmer and Lemeshow R^2  ", round(R.l, 3), "\n")
  cat("Cox and Snell R^2        ", round(R.cs, 3), "\n")
  cat("Nagelkerke R^2           ", round(R.n, 3),    "\n")
}
#Inspect Pseudo R2s
logisticPseudoR2s(logit_model )
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.52 
## Cox and Snell R^2         0.486 
## Nagelkerke R^2            0.673
```

The coefficients of the model give the change in the [log odds](https://en.wikipedia.org/wiki/Odds#Statistical_usage) of the dependent variable due to a unit change in the regressor. This makes the exact interpretation of the coefficients difficult, but we can still interpret the signs and the p-values which will tell us if a variable has a significant positive or negative impact on the probability of the dependent variable being $1$. In order to get the odds ratios we can simply take the exponent of the coefficients. 


```r
exp(coef(logit_model ))
```

```
##          (Intercept)         danceability 
##        0.00004355897 26532731.71142345294
```

Notice that the coefficient is extremely large. That is (partly) due to the fact that the danceability variable is constrained to values between $0$ and $1$ and the coefficients are for a unit change. We can make the "unit-change" interpretation more meaningful by multiplying the danceability index by $100$. This linear transformation does not affect the model fit or the p-values.


```r
#Re-scale independet variable
chart_data$danceability_100 <- chart_data$danceability*100 
#Run the regression model
logit_model <- glm(top10 ~ danceability_100,family=binomial(link='logit'),data=chart_data)
#Inspect model summary
summary(logit_model )
```

```
## 
## Call:
## glm(formula = top10 ~ danceability_100, family = binomial(link = "logit"), 
##     data = chart_data)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.8852  -0.5011  -0.2385   0.2932   2.8196  
## 
## Coefficients:
##                   Estimate Std. Error z value            Pr(>|z|)    
## (Intercept)      -10.04139    0.89629  -11.20 <0.0000000000000002 ***
## danceability_100   0.17094    0.01602   10.67 <0.0000000000000002 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 539.05  on 421  degrees of freedom
## Residual deviance: 258.49  on 420  degrees of freedom
## AIC: 262.49
## 
## Number of Fisher Scoring iterations: 6
```

```r
#Inspect Pseudo R2s
logisticPseudoR2s(logit_model )
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.52 
## Cox and Snell R^2         0.486 
## Nagelkerke R^2            0.673
```

```r
#Convert coefficients to odds ratios
exp(coef(logit_model ))
```

```
##      (Intercept) danceability_100 
##    0.00004355897    1.18641825295
```

We observe that danceability positively affects the likelihood of becoming at top-10 hit. To get the confidence intervals for the coefficients we can use the same function as with OLS


```r
confint(logit_model)
```

```
##                        2.5 %     97.5 %
## (Intercept)      -11.9208213 -8.3954496
## danceability_100   0.1415602  0.2045529
```

In order to get a rough idea about the magnitude of the effects we can calculate the partial effects at the mean of the data (that is the effect for the average observation). Alternatively, we can calculate the mean of the effects (that is the average of the individual effects). Both can be done with the ```logitmfx(...)``` function from the ```mfx``` package. If we set ```logitmfx(logit_model, data = my_data, atmean = FALSE)``` we calculate the latter. Setting ```atmean = TRUE``` will calculate the former. However, in general we are most interested in the sign and significance of the coefficient.


```r
library(mfx)
# Average partial effect
logitmfx(logit_model, data = chart_data, atmean = FALSE)
```

```
## Call:
## logitmfx(formula = logit_model, data = chart_data, atmean = FALSE)
## 
## Marginal Effects:
##                      dF/dx Std. Err.      z        P>|z|    
## danceability_100 0.0157310 0.0029761 5.2857 0.0000001252 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This now gives the average partial effects in percentage points. An additional point on the danceability scale (from $1$ to $100$), on average, makes it $1.57%$ more likely for a song to become at top-10 hit.

To get the effect of an additional point at a specific value, we can calculate the odds ratio by predicting the probability at a value and at the value $+1$. For example if we are interested in how much more likely a song with 51 compared to 50 danceability is to become a hit we can simply calculate the following


```r
#Probability of a top 10 hit with a danceability of 50
prob_50 <- exp(-(-summary(logit_model)$coefficients[1,1]-summary(logit_model)$coefficients[2,1]*50 ))
prob_50
```

```
## [1] 0.224372
```

```r
#Probability of a top 10 hit with a danceability of 51
prob_51 <- exp(-(-summary(logit_model)$coefficients[1,1]-summary(logit_model)$coefficients[2,1]*51 ))
prob_51
```

```
## [1] 0.266199
```

```r
#Odds ratio
prob_51/prob_50
```

```
## [1] 1.186418
```

So the odds are 20% higher at 51 than at 50. 

#### Logistic model with multiple predictors

Of course we can also use multiple predictors in logistic regression as shown in the formula above. We might want to add spotify followers (in million) and weeks since the release of the song.

```r
chart_data$spotify_followers_m <- chart_data$spotifyFollowers/1000000
chart_data$weeks_since_release <- chart_data$daysSinceRelease/7
```

Again, the familiar formula interface can be used with the ```glm()``` function. All the model summaries shown above still work with multiple predictors.


```r
multiple_logit_model <- glm(top10 ~ danceability_100 + spotify_followers_m + weeks_since_release,family=binomial(link='logit'),data=chart_data)
summary(multiple_logit_model)
```

```
## 
## Call:
## glm(formula = top10 ~ danceability_100 + spotify_followers_m + 
##     weeks_since_release, family = binomial(link = "logit"), data = chart_data)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.8861  -0.4390  -0.2083   0.2311   2.8015  
## 
## Coefficients:
##                      Estimate Std. Error z value             Pr(>|z|)    
## (Intercept)         -9.603762   0.990481  -9.696 < 0.0000000000000002 ***
## danceability_100     0.166236   0.016358  10.162 < 0.0000000000000002 ***
## spotify_followers_m  0.197717   0.060030   3.294             0.000989 ***
## weeks_since_release -0.012976   0.004956  -2.619             0.008832 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 534.91  on 416  degrees of freedom
## Residual deviance: 239.15  on 413  degrees of freedom
##   (5 observations deleted due to missingness)
## AIC: 247.15
## 
## Number of Fisher Scoring iterations: 6
```

```r
logisticPseudoR2s(multiple_logit_model)
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.553 
## Cox and Snell R^2         0.508 
## Nagelkerke R^2            0.703
```

```r
exp(coef(multiple_logit_model))
```

```
##         (Intercept)    danceability_100 spotify_followers_m weeks_since_release 
##        0.0000674744        1.1808513243        1.2186174345        0.9871076460
```

```r
confint(multiple_logit_model)
```

```
##                            2.5 %       97.5 %
## (Intercept)         -11.67983072 -7.782122558
## danceability_100      0.13625795  0.200625438
## spotify_followers_m   0.08079476  0.317115293
## weeks_since_release  -0.02307859 -0.003566462
```


#### Model selection

The question remains, whether a variable *should* be added to the model. We will present two methods for model selection for logistic regression. The first is based on the _Akaike Information Criterium_ (AIC). It is reported with the summary output for logit models. The value of the AIC is __relative__, meaning that it has no interpretation by itself. However, it can be used to compare and select models. The model with the lowest AIC value is the one that should be chosen. Note that the AIC does not indicate how well the model fits the data, but is merely used to compare models. 

For example, consider the following model, where we exclude the ```followers``` covariate. Seeing as it was able to contribute significantly to the explanatory power of the model, the AIC increases, indicating that the model including ```followers``` is better suited to explain the data. We always want the lowest possible AIC. 


```r
multiple_logit_model2 <- glm(top10 ~ danceability_100 + weeks_since_release,family=binomial(link='logit'),data=chart_data)

summary(multiple_logit_model2)
```

```
## 
## Call:
## glm(formula = top10 ~ danceability_100 + weeks_since_release, 
##     family = binomial(link = "logit"), data = chart_data)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.9578  -0.4721  -0.2189   0.2562   2.8759  
## 
## Coefficients:
##                      Estimate Std. Error z value            Pr(>|z|)    
## (Intercept)         -8.980225   0.930654  -9.649 <0.0000000000000002 ***
## danceability_100     0.166498   0.016107  10.337 <0.0000000000000002 ***
## weeks_since_release -0.012805   0.004836  -2.648              0.0081 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 534.91  on 416  degrees of freedom
## Residual deviance: 250.12  on 414  degrees of freedom
##   (5 observations deleted due to missingness)
## AIC: 256.12
## 
## Number of Fisher Scoring iterations: 6
```

As a second measure for variable selection, you can use the pseudo $R^2$s as shown above. The fit is distinctly worse according to all three values presented here, when excluding the Spotify followers. 


```r
logisticPseudoR2s(multiple_logit_model2)
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.532 
## Cox and Snell R^2         0.495 
## Nagelkerke R^2            0.685
```


#### Predictions

We can predict the probability given an observation using the ```predict(my_logit, newdata = ..., type = "response")``` function. Replace ```...``` with the observed values for which you would like to predict the outcome variable.



```r
# Prediction for one observation
predict(multiple_logit_model, newdata = data.frame(danceability_100=50, spotify_followers_m=10, weeks_since_release=1), type = "response")
```

```
##         1 
## 0.6619986
```

The prediction indicates that a song with danceability of $50$ from an artist with $10M$ Spotify followers has a $66%$ chance of being in the top-10, 1 week after its release. 

#### Perfect Prediction Logit

Perfect prediction occurs whenever a linear function of $X$ can perfectly separate the $1$s from the $0$s in the dependent variable. This is problematic when estimating a logit model as it will result in biased estimators (also check to p-values in the example!). R will return the following message if this occurs:

```glm.fit: fitted probabilities numerically 0 or 1 occurred```

Given this error, one should not use the output of the ```glm(...)``` function for the analysis. There are [various ways](https://stats.stackexchange.com/a/68917) to deal with this problem, one of which is to use Firth's bias-reduced penalized-likelihood logistic regression with the ```logistf(Y~X)``` function in the ```logistf``` package.  

##### Example

In this example data $Y = 0$ if $x_1 <0$ and $Y=1$ if $x_1>0$ and we thus have perfect prediction. As we can see the output of the regular logit model is not interpretable. The standard errors are huge compared to the coefficients and thus the p-values are $1$ despite $x_1$ being a predictor of $Y$. Thus, we turn to the penalized-likelihood version. This model correctly indicates that $x_1$ is in fact a predictor for $Y$ as the coefficient is significant.  


```r
Y <- c(0,0,0,0,1,1,1,1)
X <- cbind(c(-1,-2,-3,-3,5,6,10,11),c(3,2,-1,-1,2,4,1,0))

# Perfect prediction with regular logit
summary(glm(Y~X, family=binomial(link="logit")))
```

```
## 
## Call:
## glm(formula = Y ~ X, family = binomial(link = "logit"))
## 
## Deviance Residuals: 
##             1              2              3              4              5  
## -0.0000102197  -0.0000012300  -0.0000033675  -0.0000033675   0.0000105893  
##             6              7              8  
##  0.0000060786   0.0000000211   0.0000000211  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)
## (Intercept)     -6.943 113859.814       0        1
## X1               7.359  15925.251       0        1
## X2              -3.125  43853.489       0        1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 11.09035488895912  on 7  degrees of freedom
## Residual deviance:  0.00000000027772  on 5  degrees of freedom
## AIC: 6
## 
## Number of Fisher Scoring iterations: 24
```

```r
library(logistf)
# Perfect prediction with penalized-likelihood logit
summary(logistf(Y~X))
```

```
## logistf(formula = Y ~ X)
## 
## Model fitted by Penalized ML
## Coefficients:
##                    coef  se(coef)  lower 0.95 upper 0.95      Chisq          p
## (Intercept) -0.98871431 1.4283595 -10.2169313   1.884501 0.59231445 0.44152553
## X1           0.33195157 0.2142516   0.0417035   1.463409 5.31583569 0.02113246
## X2           0.08250307 0.6085055  -2.1788866   3.379327 0.01980379 0.88808646
##             method
## (Intercept)      2
## X1               2
## X2               2
## 
## Method: 1-Wald, 2-Profile penalized log-likelihood, 3-None
## 
## Likelihood ratio test=5.800986 on 2 df, p=0.05499609, n=8
## Wald test = 2.706445 on 2 df, p = 0.2584062
```


## Learning check {-}

**(LC7.1) What is a correlation coefficient?**

- [ ] It describes the difference in means of two variables
- [ ] It describes the causal relation between two variables
- [ ] It is the standardized covariance
- [ ] It describes the degree to which the variation in one variable is related to the variation in another variable
- [ ] None of the above 

**(LC7.2) Which line through a scatterplot produces the best fit in a linear regression model?**

- [ ] The line associated with the steepest slope parameter
- [ ] The line that minimizes the sum of the squared deviations of the predicted values (regression line) from the observed values
- [ ] The line that minimizes the sum of the squared residuals
- [ ] The line that maximizes the sum of the squared residuals
- [ ] None of the above 

**(LC7.3) What is the interpretation of the regression coefficient ($\beta_1$=0.05) in a regression model where log(sales) (i.e., log-transformed units) is the dependent variable and log(advertising) (i.e., the log-transformed advertising expenditures in Euro) is the independent variable (i.e., $log(sales)=13.4+0.05∗log(advertising)$)?**

- [ ] An increase in advertising by 1€ leads to an increase in sales by 0.5 units
- [ ] A 1% increase in advertising leads to a 0.05% increase in sales
- [ ] A 1% increase in advertising leads to a 5% decrease in sales
- [ ] An increase in advertising by 1€ leads to an increase in sales by 0.005 units
- [ ] None of the above

**(LC7.4) Which of the following statements about the adjusted R-squared is TRUE?**

- [ ] It is always larger than the regular $R^{2}$
- [ ] It increases with every additional variable
- [ ] It increases only with additional variables that add more explanatory power than pure chance
- [ ] It contains a “penalty” for including unnecessary variables
- [ ] None of the above 

**(LC7.5) What does the term overfitting refer to?**

- [ ] A regression model that has too many predictor variables
- [ ] A regression model that fits to a specific data set so poorly, that it will not generalize to other samples
- [ ] A regression model that fits to a specific data set so well, that it will only predict well within the sample but not generalize to other samples
- [ ] A regression model that fits to a specific data set so well, that it will generalize to other samples particularly well
- [ ] None of the above 

**(LC7.6) What are assumptions of the linear regression model?**

- [ ] Endogeneity
- [ ] Independent errors
- [ ] Heteroscedasticity
- [ ] Linear dependence of regressors
- [ ] None of the above 

**(LC7.7) What does the problem of heteroscedasticity in a regression model refer to?**

- [ ] The variance of the error term is not constant
- [ ] A strong linear relationship between the independent variables
- [ ] The variance of the error term is constant
- [ ] A correlation between the error term and the independent variables
- [ ] None of the above 

**(LC7.8) What are properties of the multiplicative regression model (i.e., log-log specification)?**

- [ ] Constant marginal returns
- [ ] Decreasing marginal returns
- [ ] Constant elasticity
- [ ] Increasing marginal returns
- [ ] None of the above 

**(LC7.9) When do you use a logistic regression model?**

- [ ] When the dependent variable is continuous
- [ ] When the independent and dependent variables are binary
- [ ] When the dependent variable is binary
- [ ] None of the above 

**(LC7.10) What is the correct way to implement a linear regression model in R? (x = independent variable, y = dependent variable)?**

- [ ] `lm(y~x, data=data)`
- [ ] `lm(x~y + error, data=data)`
- [ ] `lm(x~y, data=data)`
- [ ] `lm(y~x + error, data=data)`
- [ ] None of the above 

## References {-}

* Field, A., Miles J., & Field, Z. (2012): Discovering Statistics Using R. Sage Publications (**chapters 6, 7, 8**).
* James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013): An Introduction to Statistical Learning with Applications in R, Springer (**chapter 3**)
