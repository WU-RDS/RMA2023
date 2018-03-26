## Logistic Regression

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
rm(stream_data)
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

stream_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/stream_data.dat", 
                          sep = "\t", 
                          header = TRUE, fill = T) #read in data
stream_data$spotifyFollowers1000 <- stream_data$spotifyFollowers/1000

stream_data$delete <- ifelse(stream_data$danceability>0.50 & stream_data$top10==0,sample(c(0,1), size=nrow(stream_data), replace=TRUE, prob=c(0.99,0.01)),0)
#stream_data$delete
plot_data <- subset(stream_data, !(danceability>0.50 & top10==0 & delete==0))
#plot_data <- subset(plot_data, !(danceability>0.55 & top10==0)  & delete!=0 )

#head(stream_data)
#unique(stream_data$top10)
stream_data <- stream_data[complete.cases(stream_data),]
#table(stream_data$top10)
```


```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Linear model with binary DV (wrong!)"}
ggplot(plot_data,aes(danceability,top10)) +  
  geom_point(size=2,shape=1) +    # Use hollow circles
  geom_smooth(method="lm") + # Add linear examplereg line (by default includes 95% confidence region);
  scale_x_continuous(name="danceability") +
  scale_y_continuous(name="top10") +
  theme_bw()
```

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Logistic model with binary DV (correct!)"}
ggplot(plot_data, aes(x=danceability, y=top10)) + geom_point() + 
  stat_smooth(method="glm", method.args=list(family="binomial"), se=FALSE) +  theme_bw()
```

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
#Run the logistic regression
stream_data$years_since_release <- stream_data$daysSinceRelease/365
stream_data$potify_followers_mil <- stream_data$spotifyFollowers/1000000

multipleLogitModel <- glm(top10 ~ danceability + potify_followers_mil + years_since_release,family=binomial(link='logit'),data=stream_data)
summary(multipleLogitModel)
exp(coef(multipleLogitModel))
logisticPseudoR2s(multipleLogitModel)
```




```{r message=FALSE, warning=FALSE,eval=FALSE,echo=FALSE}
for (degfred in c(1,10,100,1000)) {
  df <- degfred
  p1 <- 0.025
  p2 <- 0.975
  min <- -5
  max <- 5
  t1 <- round(qt(p1,df=df), digits = 3)
  t2 <- round(qt(p2,df=df), digits = 3)
  print(ggplot(data.frame(x = c(min, max)), aes(x = x)) +
          stat_function(fun = dt, args = list(df = df)) + 
          stat_function(fun = dt, args = list(df = df), xlim = c(min,qt(p1,df=df)), geom = "area") +
          stat_function(fun = dt, args = list(df = df), xlim = c(max,qt(p2,df=df)), geom = "area") +
          scale_x_continuous(breaks = c(t1,t2)) +
          labs(title = paste0("Critical values for t-distribution with ",df," df"),
               subtitle = "Two-tailed test and a=0.05",
               x = "x", y = "Density") +
          theme(axis.title = element_text(size = 14),
                axis.text  = element_text(size=14),
                strip.text.x = element_text(size = 14),
                legend.position="none") + theme_bw())
}
```



To get a better overview, we can also look at the data in a slightly different way. 

```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Observations"), tidy = FALSE}
library(reshape2)
dcast(car_sales_promo, DealerNumber ~ Promotion)
```


```{r message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE}
online_store_promo$Group <- paste(online_store_promo$Promotion,online_store_promo$Newsletter,sep = "_") 
online_store_promo
```


```{r message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE}
rss <- sum( (regression$sales-regression$yhat)^2)
#rss <- sum(resid(lm))
rss
rse <- sqrt(rss/(nrow(regression)-2))
rse
se_beta_1 <- rse*sqrt(1/(sum((regression$adspend - mean(regression$adspend))^2)))
se_beta_1
df <- (nrow(regression) - 2) #degrees of freedom
qt(0.975, df) #critical value
beta_1-qt(0.975, df)*se_beta_1
beta_1+qt(0.975, df)*se_beta_1
confint(lm)

rse/sqrt((sum((regression$adspend - mean(regression$adspend))^2)))
pt(9.98, df)
```

To compute percentiles, you can use the ```quantile()``` function. The n<sup>th</sup> percentile of an observation variable is the value that cuts off the first n percent of the data values when it is sorted in ascending order.

```{r}
quantile(test_data$Duration_in_seconds, probs = 0.75) #the 75th percentile
quantile(test_data$Duration_in_seconds, probs = 0.25) #the 25th percentile
quantile(test_data$Duration_in_seconds, probs = 0.75) - quantile(test_data$Duration_in_seconds, probs = 0.25) #the interquartile range
IQR(test_data$Duration_in_seconds) #also produces the interquartile range (equivalent to the previous line)
```
The frequency distribution can also be used to make statements about the probability that a certain value would occur. Remember that for the normal distribution, the values less than one standard deviation away from the mean account for 68.27% of the observations, while two standard deviations from the mean account for 95.45%; and three standard deviations account for 99.73%.

<p style="text-align:center;">
  <img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/Graphics/normalprops.JPG" alt="normalprobs" height="300"  />&nbsp;
</p>
  
  Let's put this to the test. It is easy to compute the z-scores for a variable from the data using the ```scale()``` function. Remember that this converts the variable to a scale with mean = 0 and SD = 1, so we can use the tables of probabilities for the normal distribution to see how likely it is that a particular score will occur in the data. Remember the formula for the z-score is:

\begin{equation} 
\begin{split}
z = \frac{x_i - \overline{x}}s
\end{split}
(\#eq:z)
\end{equation} 

```{r message=FALSE, warning=FALSE}
hist(test_data_clean$overall_knowledge)
shapiro.test(test_data_clean$overall_knowledge)
test_data_clean <- subset(test_data, duration < 600)
test_data_clean$duration_std <- scale(test_data_clean$duration) #computes z-scores and stores them in new variable
#this is equivalent to the following manual computation of z-scores
test_data_clean$duration_std_test <- (test_data_clean$duration-mean(test_data_clean$duration))/sd(test_data_clean$duration) #also computes z-scores
head(test_data_clean[,c("duration","duration_std","duration_std_test")]) #test if both are the same
mean(test_data_clean$duration_std) #tests if mean equals 0
sd(test_data_clean$duration_std) #tests if sd equals 1

test_data_clean[,c("duration","duration_std","duration_std_test")]
```

Now you can easily compute the percentage of observations within a specific range from the mean:

```{r message=FALSE, warning=FALSE}
nrow(subset(test_data_clean,duration_std<=1 & duration_std>=-1))/nrow(test_data_clean) #share of observations within 1SD
nrow(subset(test_data_clean,duration_std<=2 & duration_std>=-2))/nrow(test_data_clean) #share of observations within 2SD
nrow(subset(test_data_clean,duration_std<=3 & duration_std>=-3))/nrow(test_data_clean) #share of observations within 3 SD
```

Next, we can find the probability associated with each observation in our dataset using the ```pnorm()``` function, which returns the probability for a given standardized score according to the normal distribution. For a two sided test we need to multiply the result by two. Also, if the Z-score that is found is positive then we need to take one minus the associated probability. Here we take care of these issues and insure that the Z-score is negative by taking the negative of the absolute value.

```{r message=FALSE, warning=FALSE}
test_data$probability <- 2*pnorm(-(abs(test_data$duration_std)))
head(test_data[order(test_data$probability),])
```

Finally, let's compute a confidence intervall around the mean. Remember the formula for the confidence interval:

\begin{equation} 
\begin{split}
CI = \overline{X}\pm(z*\frac{s}{\sqrt{n}})
\end{split}
(\#eq:confidence)
\end{equation} 

We can obtain the critical z-score for the 95% CI using the ```qnorm()```-function. Using ```nrow(data_set)```, we can obtain the number ob rows (i.e., observations) in a dataset. 

```{r message=FALSE, warning=FALSE}
error <- qnorm(0.975)*sd(test_data$duration)/sqrt(nrow(test_data))
ci_lower <- mean(test_data$Duration_in_seconds)-error
ci_upper <- mean(test_data$Duration_in_seconds)+error
print(ci_lower)
print(ci_upper)
```

We are 95% confident that the true average response time of our survey is between 217.73 and 275.29!

  
  
  
  
  
  
  
#Cook's distance can easily be calculated for all observations in R with the function ```cooks.distance()```.
#There are various rules to determine whether an observation should be classified as influential or not, with the two most well known being any observation with a Cook's distance > 1 or any observation with a Cook's distance > 4/n, with n being the number of observations in a regression. While these are good starting points it is best to look at the values on a case-by-case basis and see if anything seems out of the ordinary.

```{r, eval = TRUE, echo = FALSE, message = FALSE, warning = FALSE}
b_0 <- 10
b_1 <- 0.3

x <- c(1:100)

y_norm <- b_0 + b_1 * x + rnorm(100, sd = 5)
y_unif <- b_0 + b_1 * x + runif(100, -10, 10)

reg_norm <- lm(y_norm ~ x)
reg_unif <- lm(y_unif ~ x)

data_normal_dist <- data.frame(Y = c(y_norm, y_unif), X = rep(x, 2), 
                               group = rep(c("Normally distributed", "Non-normally distributed"), each = 100))
data_normal_dist$fitted <- b_0 + b_1 * data_normal_dist$X


#This is code to produce q-q plots in ggplot, but the qqline is a bit of a headache, so I switched to the base qqnorm function
#data_residuals <- data.frame(residuals = c(reg_norm$residuals, reg_unif$residuals), 
#                             group = rep(c("Normally distributed", "Non-normally distributed"), each = 100))

#ggplot(data = data_residuals) + 
#  geom_qq(mapping = aes(sample = residuals)) + 
#  theme_bw() +
#  facet_grid(. ~ group)
```

```{r, eval = TRUE, message = FALSE, warning = FALSE}
#Manual calculatuion of the residuals
#Subtract the fitted values (calculated with the coefficients from the regression) 
#from the actual values (stored in the data_normal_dist dataframe)
manual_residuals <- data_normal_dist$Y[1:100] - (reg_norm$coefficients[1] + reg_norm$coefficients[2] * data_normal_dist$X[1:100])


#Extract residuals from the lm() object
reg_norm <- lm(y_norm ~ x)
automatic_residuals <- reg_norm$residuals


#Check to see if they're actually the same
head(data.frame(manual = manual_residuals, automatic = automatic_residuals))
```


```{r, echo = FALSE, eval = TRUE, fig.align = "center", fig.cap = "Non-constant error variance"}
b_0 <- 9
b_1 <- 0.4

x <- c(1:100)
y_1 <- b_0 + b_1 * x + rnorm(100, sd = seq(1, 20, length.out = 100))
upper_y1 <- b_0 + b_1 * x + qnorm(0.975, sd = seq(1, 20, length.out = 100))
lower_y1 <- b_0 + b_1 * x + qnorm(0.025, sd = seq(1, 20, length.out = 100))

y_2 <- b_0 + b_1 * x + rnorm(100, sd = 5)
upper_y2 <- b_0 + b_1 * x + qnorm(0.975, sd = 5)
lower_y2 <- b_0 + b_1 * x + qnorm(0.025, sd = 5)

y_3 <- b_0 + b_1 * x + rnorm(100, sd = seq(20, 1, length.out = 100))
upper_y3 <- b_0 + b_1 * x + qnorm(0.975, sd = seq(20, 1, length.out = 100))
lower_y3 <- b_0 + b_1 * x + qnorm(0.025, sd = seq(20, 1, length.out = 100))

data_heterosked <-data.frame(Y = c(y_1, y_2, y_3), X = rep(x, 3), group = rep(c(1,2,3), each = 100),
                             upper = c(upper_y1, upper_y2, upper_y3),
                             lower = c(lower_y1, lower_y2, lower_y3))

ggplot(data = data_heterosked, mapping = aes(y = Y, x = X)) +
  geom_point() + 
  geom_line(mapping = aes(x = X, y = upper), lty = 2) +
  geom_line(mapping = aes(x = X, y = lower), lty = 2) +
  stat_function(fun = function(x) (b_0 + b_1 * x), col = "firebrick") +
  theme_bw() +
  theme(strip.background = element_blank(),
        strip.text.x = element_blank()) +
  facet_grid(. ~ group)

```

  