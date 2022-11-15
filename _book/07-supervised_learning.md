---
output:
  html_document:
    toc: yes
  pdf_document:
    toc: yes
  html_notebook: default
---




# Supervised learning



## Linear regression

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/10-regression.R)
:::

### Correlation

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/HeIW9_ijHF4" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Before we start with regression analysis, we will review the basic concept of correlation first. Correlation helps us to determine the degree to which the variation in one variable, X, is related to the variation in another variable, Y. 

#### Correlation coefficient

The correlation coefficient summarizes the strength of the linear relationship between two metric (interval or ratio scaled) variables. Let's consider a simple example. Say you conduct a survey to investigate the relationship between the attitude towards a city and the duration of residency. The "Attitude" variable can take values between 1 (very unfavorable) and 12 (very favorable), and the "duration of residency" is measured in years. Let's further assume for this example that the attitude measurement represents an interval scale (although it is usually not realistic to assume that the scale points on an itemized rating scale have the same distance). To keep it simple, let's further assume that you only asked 12 people. We can create a short data set like this:    


```r
library(psych)
attitude <- c(6, 9, 8, 3, 10, 4, 5, 2, 11, 9, 10, 2)
duration <- c(10, 12, 12, 4, 12, 6, 8, 2, 18, 9, 17,
    2)
att_data <- data.frame(attitude, duration)
att_data <- att_data[order(-attitude), ]
att_data$respodentID <- c(1:12)
str(att_data)
```

```
## 'data.frame':	12 obs. of  3 variables:
##  $ attitude   : num  11 10 10 9 9 8 6 5 4 3 ...
##  $ duration   : num  18 12 17 12 9 12 10 8 6 4 ...
##  $ respodentID: int  1 2 3 4 5 6 7 8 9 10 ...
```

```r
psych::describe(att_data[, c("attitude", "duration")])
```

```
##          vars  n mean   sd median trimmed  mad min max range  skew kurtosis
## attitude    1 12 6.58 3.32    7.0     6.6 4.45   2  11     9 -0.14    -1.74
## duration    2 12 9.33 5.26    9.5     9.2 4.45   2  18    16  0.10    -1.27
##            se
## attitude 0.96
## duration 1.52
```

```r
att_data
```

```
##    attitude duration respodentID
## 9        11       18           1
## 5        10       12           2
## 11       10       17           3
## 2         9       12           4
## 10        9        9           5
## 3         8       12           6
## 1         6       10           7
## 7         5        8           8
## 6         4        6           9
## 4         3        4          10
## 8         2        2          11
## 12        2        2          12
```

Let's look at the data first. The following graph shows the individual data points for the "duration of residency"" variable, where the y-axis shows the duration of residency in years and the x-axis shows the respondent ID. The blue horizontal line represents the mean of the variable (9.33) and the vertical lines show the distance of the individual data points from the mean.

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-4-1.png" alt="Scores for duration of residency variable" width="672" />
<p class="caption">(\#fig:unnamed-chunk-4)Scores for duration of residency variable</p>
</div>

You can see that there are some respondents that have been living in the city longer than average and some respondents that have been living in the city shorter than average. Let's do the same for the second variable ("Attitude"). Again, the y-axis shows the observed scores for this variable and the x-axis shows the respondent ID.  

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-5-1.png" alt="Scores for attitude variable" width="672" />
<p class="caption">(\#fig:unnamed-chunk-5)Scores for attitude variable</p>
</div>

Again, we can see that some respondents have an above average attitude towards the city (more favorable) and some respondents have a below average attitude towards the city. Let's combine both variables in one graph now to see if there is some co-movement: 

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-6-1.png" alt="Scores for attitude and duration of residency variables" width="672" />
<p class="caption">(\#fig:unnamed-chunk-6)Scores for attitude and duration of residency variables</p>
</div>

We can see that there is indeed some co-movement here. The variables <b>covary</b> because respondents who have an above (below) average attitude towards the city also appear to have been living in the city for an above (below) average amount of time and vice versa. Correlation helps us to quantify this relationship. Before you proceed to compute the correlation coefficient, you should first look at the data. We usually use a scatterplot to visualize the relationship between two metric variables:

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-7-1.png" alt="Scatterplot for durationand attitute variables" width="672" />
<p class="caption">(\#fig:unnamed-chunk-7)Scatterplot for durationand attitute variables</p>
</div>

How can we compute the correlation coefficient? Remember that the variance measures the average deviation from the mean of a variable:

\begin{equation} 
\begin{split}
s_x^2&=\frac{\sum_{i=1}^{N} (X_i-\overline{X})^2}{N-1} \\
     &= \frac{\sum_{i=1}^{N} (X_i-\overline{X})*(X_i-\overline{X})}{N-1}
\end{split}
(\#eq:variance)
\end{equation} 

When we consider two variables, we multiply the deviation for one variable by the respective deviation for the second variable: 

<p style="text-align:center;">
$(X_i-\overline{X})*(Y_i-\overline{Y})$
</p>

This is called the cross-product deviation. Then we sum the cross-product deviations:

<p style="text-align:center;">
$\sum_{i=1}^{N}(X_i-\overline{X})*(Y_i-\overline{Y})$
</p>

... and compute the average of the sum of all cross-product deviations to get the <b>covariance</b>:

\begin{equation} 
Cov(x, y) =\frac{\sum_{i=1}^{N}(X_i-\overline{X})*(Y_i-\overline{Y})}{N-1}
(\#eq:covariance)
\end{equation} 

You can easily compute the covariance manually as follows


```r
x <- att_data$duration
x_bar <- mean(att_data$duration)
y <- att_data$attitude
y_bar <- mean(att_data$attitude)
N <- nrow(att_data)
cov <- (sum((x - x_bar) * (y - y_bar)))/(N - 1)
cov
```

```
## [1] 16.333333
```

Or you simply use the built-in ```cov()``` function:


```r
cov(att_data$duration, att_data$attitude)  # apply the cov function 
```

```
## [1] 16.333333
```

A positive covariance indicates that as one variable deviates from the mean, the other variable deviates in the same direction. A negative covariance indicates that as one variable deviates from the mean (e.g., increases), the other variable deviates in the opposite direction (e.g., decreases).

However, the size of the covariance depends on the scale of measurement. Larger scale units will lead to larger covariance. To overcome the problem of dependence on measurement scale, we need to convert the covariance to a standard set of units through standardization by dividing the covariance by the standard deviation (similar to how we compute z-scores).

With two variables, there are two standard deviations. We simply multiply the two standard deviations. We then divide the covariance by the product of the two standard deviations to get the standardized covariance, which is known as a correlation coefficient r:

\begin{equation} 
r=\frac{Cov_{xy}}{s_x*s_y}
(\#eq:corcoeff)
\end{equation} 

This is known as the product moment correlation (r) and it is straight-forward to compute:


```r
x_sd <- sd(att_data$duration)
y_sd <- sd(att_data$attitude)
r <- cov/(x_sd * y_sd)
r
```

```
## [1] 0.93607782
```

Or you could just use the ```cor()``` function:


```r
cor(att_data[, c("attitude", "duration")], method = "pearson",
    use = "complete")
```

```
##            attitude   duration
## attitude 1.00000000 0.93607782
## duration 0.93607782 1.00000000
```

The properties of the correlation coefficient ('r') are:

* ranges from -1 to + 1
* +1 indicates perfect linear relationship
* -1 indicates perfect negative relationship
* 0 indicates no linear relationship
* ± .1 represents small effect
* ± .3 represents medium effect
* ± .5 represents large effect

#### Significance testing

How can we determine if our two variables are significantly related? To test this, we denote the population moment correlation *&rho;*. Then we test the null of no relationship between variables:

$$H_0:\rho=0$$
$$H_1:\rho\ne0$$

The test statistic is: 

\begin{equation} 
t=\frac{r*\sqrt{N-2}}{\sqrt{1-r^2}}
(\#eq:cortest)
\end{equation} 

It has a t distribution with n - 2 degrees of freedom. Then, we follow the usual procedure of calculating the test statistic and comparing the test statistic to the critical value of the underlying probability distribution. If the calculated test statistic is larger than the critical value, the null hypothesis of no relationship between X and Y is rejected. 


```r
t_calc <- r * sqrt(N - 2)/sqrt(1 - r^2)  #calculated test statistic
t_calc
```

```
## [1] 8.4144314
```

```r
df <- (N - 2)  #degrees of freedom
t_crit <- qt(0.975, df)  #critical value
t_crit
```

```
## [1] 2.2281389
```

```r
pt(q = t_calc, df = df, lower.tail = F) * 2  #p-value 
```

```
## [1] 0.0000075451612
```

Or you can simply use the ```cor.test()``` function, which also produces the 95% confidence interval:


```r
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided",
    method = "pearson", conf.level = 0.95)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  att_data$attitude and att_data$duration
## t = 8.41443, df = 10, p-value = 0.0000075452
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.78260411 0.98228152
## sample estimates:
##        cor 
## 0.93607782
```

To determine the linear relationship between variables, the data only needs to be measured using interval scales. If you want to test the significance of the association, the sampling distribution needs to be normally distributed (we usually assume this when our data are normally distributed or when N is large). If parametric assumptions are violated, you should use non-parametric tests:

* Spearman's correlation coefficient: requires ordinal data and ranks the data before applying Pearson's equation.
* Kendall's tau: use when N is small or the number of tied ranks is large.


```r
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided",
    method = "spearman", conf.level = 0.95)
```

```
## 
## 	Spearman's rank correlation rho
## 
## data:  att_data$attitude and att_data$duration
## S = 14.1969, p-value = 0.0000021833
## alternative hypothesis: true rho is not equal to 0
## sample estimates:
##        rho 
## 0.95036059
```

```r
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided",
    method = "kendall", conf.level = 0.95)
```

```
## 
## 	Kendall's rank correlation tau
## 
## data:  att_data$attitude and att_data$duration
## z = 3.90948, p-value = 0.000092496
## alternative hypothesis: true tau is not equal to 0
## sample estimates:
##        tau 
## 0.89602867
```

Report the results:

A Pearson product-moment correlation coefficient was computed to assess the relationship between the duration of residence in a city and the attitude toward the city. There was a positive correlation between the two variables, r = 0.936, n = 12, p < 0.05. A scatterplot summarizes the results (Figure XY).

**A note on the interpretation of correlation coefficients:**

As we have already seen in chapter 1, correlation coefficients give no indication of the direction of causality. In our example, we can conclude that the attitude toward the city is more positive as the years of residence increases. However, we cannot say that the years of residence cause the attitudes to be more positive. There are two main reasons for caution when interpreting correlations:

* Third-variable problem: there may be other unobserved factors that affect both the 'attitude towards a city' and the 'duration of residency' variables
* Direction of causality: Correlations say nothing about which variable causes the other to change (reverse causality: attitudes may just as well cause the years of residence variable).


### Regression analysis

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/rtvDHLuXUEI" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Correlations measure relationships between variables (i.e., how much two variables covary). Using regression analysis we can predict the outcome of a dependent variable (Y) from one or more independent variables (X). For example, we could be interested in how many products will we will sell if we increase the advertising expenditures by 1000 Euros? In regression analysis, we fit a model to our data and use it to predict the values of the dependent variable from one predictor variable (bivariate regression) or several predictor variables (multiple regression). The following table shows a comparison of correlation and regression analysis:

<br>

&nbsp; | Correlation	 | Regression	
-------------|--------------------------  | -------------------------- 
Estimated coefficient  | Coefficient of correlation (bounded between -1 and +1) | Regression coefficient (not bounded a priori)
Interpretation  | Linear association between two variables; Association is bidirectional | (Linear) relation between one or more independent variables and dependent variable; Relation is directional
Role of theory | Theory neither required nor testable  | Theory required and testable

<br>

#### Simple linear regression

In simple linear regression, we assess the relationship between one dependent (regressand) and one independent (regressor) variable. The goal is to fit a line through a scatterplot of observations in order to find the line that best describes the data (scatterplot).

Suppose you are a marketing research analyst at a music label and your task is to suggest, on the basis of historical data, a marketing plan for the next year that will maximize product sales. The data set that is available to you includes information on the sales of music downloads (thousands of units), advertising expenditures (in Euros), the number of radio plays an artist received per week (airplay), the number of previous releases of an artist (starpower), repertoire origin (country; 0 = local, 1 = international), and genre (1 = rock, 2 = pop, 3 = electronic). Let's load and inspect the data first: 


```r
regression <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_sales_regression.dat",
    sep = "\t", header = TRUE)  #read in data
regression$country <- factor(regression$country, levels = c(0:1),
    labels = c("local", "international"))  #convert grouping variable to factor
regression$genre <- factor(regression$genre, levels = c(1:3),
    labels = c("rock", "pop", "electronic"))  #convert grouping variable to factor
head(regression)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["sales"],"name":[1],"type":["int"],"align":["right"]},{"label":["adspend"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["airplay"],"name":[3],"type":["int"],"align":["right"]},{"label":["starpower"],"name":[4],"type":["int"],"align":["right"]},{"label":["genre"],"name":[5],"type":["fct"],"align":["left"]},{"label":["country"],"name":[6],"type":["fct"],"align":["left"]}],"data":[{"1":"330","2":"10.256","3":"43","4":"10","5":"electronic","6":"international"},{"1":"300","2":"174.093","3":"40","4":"7","5":"electronic","6":"international"},{"1":"250","2":"1000.000","3":"5","4":"7","5":"pop","6":"international"},{"1":"120","2":"75.896","3":"34","4":"6","5":"rock","6":"local"},{"1":"290","2":"1351.254","3":"37","4":"9","5":"electronic","6":"local"},{"1":"60","2":"202.705","3":"13","4":"8","5":"rock","6":"local"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


```r
psych::describe(regression)  #descriptive statistics using psych
```

```
##           vars   n   mean     sd median trimmed    mad  min     max   range
## sales        1 200 193.20  80.70 200.00  192.69  88.96 10.0  360.00  350.00
## adspend      2 200 614.41 485.66 531.92  560.81 489.09  9.1 2271.86 2262.76
## airplay      3 200  27.50  12.27  28.00   27.46  11.86  0.0   63.00   63.00
## starpower    4 200   6.77   1.40   7.00    6.88   1.48  1.0   10.00    9.00
## genre*       5 200   2.40   0.79   3.00    2.50   0.00  1.0    3.00    2.00
## country*     6 200   1.17   0.38   1.00    1.09   0.00  1.0    2.00    1.00
##            skew kurtosis    se
## sales      0.04    -0.72  5.71
## adspend    0.84     0.17 34.34
## airplay    0.06    -0.09  0.87
## starpower -1.27     3.56  0.10
## genre*    -0.83    -0.91  0.06
## country*   1.74     1.05  0.03
```

As stated above, regression analysis may be used to relate a quantitative response ("dependent variable") to one or more predictor variables ("independent variables"). In a simple linear regression, we have one dependent and one independent variable and we regress the dependent variable on the independent variable.  

Here are a few important questions that we might seek to address based on the data:

* Is there a relationship between advertising budget and sales? 
* How strong is the relationship between advertising budget and sales?
* Which other variables contribute to sales?
* How accurately can we estimate the effect of each variable on sales?
* How accurately can we predict future sales?
* Is the relationship linear?
* Is there synergy among the advertising activities?

We may use linear regression to answer these questions. We will see later that the interpretation of the results strongly depends on the goal of the analysis - whether you would like to simply predict an outcome variable or you would like to explain the causal effect of the independent variable on the dependent variable (see chapter 1). Let's start with the first question and investigate the relationship between advertising and sales. 

##### Estimating the coefficients

A simple linear regression model only has one predictor and can be written as:

\begin{equation} 
Y=\beta_0+\beta_1X+\epsilon
(\#eq:regequ)
\end{equation} 

In our specific context, let's consider only the influence of advertising on sales for now:

\begin{equation} 
Sales=\beta_0+\beta_1*adspend+\epsilon
(\#eq:regequadv)
\end{equation} 

The word "adspend" represents data on advertising expenditures that we have observed and &beta;<sub>1</sub> (the "slope"") represents the unknown relationship between advertising expenditures and sales. It tells you by how much sales will increase for an additional Euro spent on advertising. &beta;<sub>0</sub> (the "intercept") is the number of sales we would expect if no money is spent on advertising. Together, &beta;<sub>0</sub> and &beta;<sub>1</sub> represent the model coefficients or *parameters*. The error term (&epsilon;) captures everything that we miss by using our model, including, (1) misspecifications (the true relationship might not be linear), (2) omitted variables (other variables might drive sales), and (3) measurement error (our measurement of the variables might be imperfect).

Once we have used our training data to produce estimates for the model coefficients, we can predict future sales on the basis of a particular value of advertising expenditures by computing:

\begin{equation} 
\hat{Sales}=\hat{\beta_0}+\hat{\beta_1}*adspend
(\#eq:predreg)
\end{equation} 

We use the hat symbol, <sup>^</sup>, to denote the estimated value for an unknown parameter or coefficient, or to denote the predicted value of the response (sales). In practice, &beta;<sub>0</sub> and &beta;<sub>1</sub> are unknown and must be estimated from the data to make predictions. In the case of our advertising example, the data set consists of the advertising budget and product sales of 200 music songs (n = 200). Our goal is to obtain coefficient estimates such that the linear model fits the available data well. In other words, we fit a line through the scatterplot of observations and try to find the line that best describes the data. The following graph shows the scatterplot for our data, where the black line shows the regression line. The grey vertical lines shows the difference between the predicted values (the regression line) and the observed values. This difference is referred to as the residuals ("e").

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-17-1.png" alt="Ordinary least squares (OLS)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-17)Ordinary least squares (OLS)</p>
</div>

The estimation of the regression function is based on the idea of the method of least squares (OLS = ordinary least squares). The first step is to calculate the residuals by subtracting the observed values from the predicted values.

<p style="text-align:center;">
$e_i = Y_i-(\beta_0+\beta_1X_i)$
</p>

This difference is then minimized by minimizing the sum of the squared residuals:

\begin{equation} 
\sum_{i=1}^{N} e_i^2= \sum_{i=1}^{N} [Y_i-(\beta_0+\beta_1X_i)]^2\rightarrow min!
(\#eq:rss)
\end{equation} 

e<sub>i</sub>: Residuals (i = 1,2,...,N)<br>
Y<sub>i</sub>: Values of the dependent variable (i = 1,2,...,N) <br>
&beta;<sub>0</sub>: Intercept<br>
&beta;<sub>1</sub>: Regression coefficient / slope parameters<br>
X<sub>ni</sub>: Values of the nth independent variables and the i*th* observation<br>
N: Number of observations<br>

This is also referred to as the <b>residual sum of squares (RSS)</b>, which you may still remember from the previous chapter on ANOVA. Now we need to choose the values for &beta;<sub>0</sub> and &beta;<sub>1</sub> that minimize RSS. So how can we derive these values for the regression coefficient? The equation for &beta;<sub>1</sub> is given by:

\begin{equation} 
\hat{\beta_1}=\frac{COV_{XY}}{s_x^2}
(\#eq:slope)
\end{equation} 

The exact mathematical derivation of this formula is beyond the scope of this script, but the intuition is to calculate the first derivative of the squared residuals with respect to &beta;<sub>1</sub> and set it to zero, thereby finding the &beta;<sub>1</sub> that minimizes the term. Using the above formula, you can easily compute &beta;<sub>1</sub> using the following code:


```r
cov_y_x <- cov(regression$adspend, regression$sales)
cov_y_x
```

```
## [1] 22672.016
```

```r
var_x <- var(regression$adspend)
var_x
```

```
## [1] 235860.98
```

```r
beta_1 <- cov_y_x/var_x
beta_1
```

```
## [1] 0.096124486
```

The interpretation of &beta;<sub>1</sub> is as follows: 

For every extra Euro spent on advertising, sales can be expected to increase by 0.096 units. Or, in other words, if we increase our marketing budget by 1,000 Euros, sales can be expected to increase by 96 units.

Using the estimated coefficient for &beta;<sub>1</sub>, it is easy to compute &beta;<sub>0</sub> (the intercept) as follows:

\begin{equation} 
\hat{\beta_0}=\overline{Y}-\hat{\beta_1}\overline{X}
(\#eq:intercept)
\end{equation} 

The R code for this is:


```r
beta_0 <- mean(regression$sales) - beta_1 * mean(regression$adspend)
beta_0
```

```
## [1] 134.13994
```

The interpretation of &beta;<sub>0</sub> is as follows: 

If we spend no money on advertising, we would expect to sell 134.14 units.

You may also verify this based on a scatterplot of the data. The following plot shows the scatterplot including the regression line, which is estimated using OLS.  


```r
ggplot(regression, mapping = aes(adspend, sales)) +
    geom_point(shape = 1) + geom_smooth(method = "lm",
    fill = "blue", alpha = 0.1) + labs(x = "Advertising expenditures (EUR)",
    y = "Number of sales") + theme_bw()
```

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-20-1.png" alt="Scatterplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-20)Scatterplot</p>
</div>

You can see that the regression line intersects with the y-axis at 134.14, which corresponds to the expected sales level when advertising expenditure (on the x-axis) is zero (i.e., the intercept &beta;<sub>0</sub>). The slope coefficient (&beta;<sub>1</sub>) tells you by how much sales (on the y-axis) would increase if advertising expenditures (on the x-axis) are increased by one unit.   

##### Significance testing

In a next step, we assess if the effect of advertising on sales is statistically significant. This means that we test the null hypothesis H<sub>0</sub>: "There is no relationship between advertising and sales" versus the alternative hypothesis H<sub>1</sub>: "The is some relationship between advertising and sales". Or, to state this formally:

$$H_0:\beta_1=0$$
$$H_1:\beta_1\ne0$$

How can we test if the effect is statistically significant? Recall the generalized equation to derive a test statistic:

\begin{equation} 
test\ statistic = \frac{effect}{error}
(\#eq:teststatgeneral)
\end{equation} 

The effect is given by the &beta;<sub>1</sub> coefficient in this case. To compute the test statistic, we need to come up with a measure of uncertainty around this estimate (the error). This is because we use information from a sample to estimate the least squares line to make inferences regarding the regression line in the entire population. Since we only have access to one sample, the regression line will be slightly different every time we take a different sample from the population. This is sampling variation and it is perfectly normal! It just means that we need to take into account the uncertainty around the estimate, which is achieved by the standard error. Thus, the test statistic for our hypothesis is given by:

\begin{equation} 
t = \frac{\hat{\beta_1}}{SE(\hat{\beta_1})}
(\#eq:teststatreg)
\end{equation} 

After calculating the test statistic, we compare its value to the values that we would expect to find if there was no effect based on the t-distribution. In a regression context, the degrees of freedom are given by ```N - p - 1``` where N is the sample size and p is the number of predictors. In our case, we have 200 observations and one predictor. Thus, the degrees of freedom is 200 - 1 - 1 = 198. In the regression output below, R provides the exact probability of observing a t value of this magnitude (or larger) if the null hypothesis was true. This probability - as we already saw in chapter 6 - is the p-value. A small p-value indicates that it is unlikely to observe such a substantial association between the predictor and the outcome variable due to chance in the absence of any real association between the predictor and the outcome.

To estimate the regression model in R, you can use the ```lm()``` function. Within the function, you first specify the dependent variable ("sales") and independent variable ("adspend") separated by a ```~``` (tilde). As mentioned previously, this is known as _formula notation_ in R. The ```data = regression``` argument specifies that the variables come from the data frame named "regression". Strictly speaking, you use the ```lm()``` function to create an object called "simple_regression," which holds the regression output. You can then view the results using the ```summary()``` function: 


```r
simple_regression <- lm(sales ~ adspend, data = regression)  #estimate linear model
summary(simple_regression)  #summary of results
```

```
## 
## Call:
## lm(formula = sales ~ adspend, data = regression)
## 
## Residuals:
##       Min        1Q    Median        3Q       Max 
## -152.9493  -43.7961   -0.3933   37.0404  211.8658 
## 
## Coefficients:
##                Estimate  Std. Error t value              Pr(>|t|)    
## (Intercept) 134.1399378   7.5365747 17.7985 < 0.00000000000000022 ***
## adspend       0.0961245   0.0096324  9.9793 < 0.00000000000000022 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 65.991 on 198 degrees of freedom
## Multiple R-squared:  0.33465,	Adjusted R-squared:  0.33129 
## F-statistic: 99.587 on 1 and 198 DF,  p-value: < 0.000000000000000222
```

Note that the estimated coefficients for &beta;<sub>0</sub> (134.14) and &beta;<sub>1</sub> (0.096) correspond to the results of our manual computation above. The associated t-values and p-values are given in the output. The t-values are larger than the critical t-values for the 95% confidence level, since the associated p-values are smaller than 0.05. In case of the coefficient for &beta;<sub>1</sub>, this means that the probability of an association between the advertising and sales of the observed magnitude (or larger) is smaller than 0.05, if the value of &beta;<sub>1</sub> was, in fact, 0. This finding leads us to reject the null hypothesis of no association between advertising and sales. 

The coefficients associated with the respective variables represent <b>point estimates</b>. To obtain a better understanding of the range of values that the coefficients could take, it is helpful to compute <b>confidence intervals</b>. A 95% confidence interval is defined as a range of values such that with a 95% probability, the range will contain the true unknown value of the parameter. For example, for &beta;<sub>1</sub>, the confidence interval can be computed as.

\begin{equation} 
CI = \hat{\beta_1}\pm(t_{1-\frac{\alpha}{2}}*SE(\beta_1))
(\#eq:regCI)
\end{equation} 

It is easy to compute confidence intervals in R using the ```confint()``` function. You just have to provide the name of you estimated model as an argument:


```r
confint(simple_regression)
```

```
##                     2.5 %       97.5 %
## (Intercept) 119.277680821 149.00219480
## adspend       0.077129291   0.11511968
```

For our model, the 95% confidence interval for &beta;<sub>0</sub> is [119.28,149], and the 95% confidence interval for &beta;<sub>1</sub> is [0.08,0.12]. Thus, we can conclude that when we do not spend any money on advertising, sales will be somewhere between 119 and 149 units on average. In addition, for each increase in advertising expenditures by one Euro, there will be an average increase in sales of between 0.08 and 0.12. If you revisit the graphic depiction of the regression model above, the uncertainty regarding the intercept and slope parameters can be seen in the confidence bounds (blue area) around the regression line. 

##### Assessing model fit

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/nG4_st29Qe8" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Once we have rejected the null hypothesis in favor of the alternative hypothesis, the next step is to investigate how well the model represents ("fits") the data. How can we assess the model fit?

* First, we calculate the fit of the most basic model (i.e., the mean)
* Then, we calculate the fit of the best model (i.e., the regression model)
* A good model should fit the data significantly better than the basic model
* R<sup>2</sup>: Represents the percentage of the variation in the outcome that can be explained by the model
* The F-ratio measures how much the model has improved the prediction of the outcome compared to the level of inaccuracy in the model

Similar to ANOVA, the calculation of model fit statistics relies on estimating the different sum of squares values. SS<sub>T</sub> is the difference between the observed data and the mean value of Y (aka. total variation). In the absence of any other information, the mean value of Y ($\overline{Y}$) represents the best guess on where a particular observation $Y_{i}$ at a given level of advertising will fall:

\begin{equation} 
SS_T= \sum_{i=1}^{N} (Y_i-\overline{Y})^2
(\#eq:regSST)
\end{equation} 

The following graph shows the total sum of squares:

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-23-1.png" alt="Total sum of squares" width="672" />
<p class="caption">(\#fig:unnamed-chunk-23)Total sum of squares</p>
</div>

Based on our linear model, the best guess about the sales level at a given level of advertising is the predicted value $\hat{Y}_i$. The model sum of squares (SS<sub>M</sub>) therefore has the mathematical representation:

\begin{equation} 
SS_M= \sum_{i=1}^{N}  (\hat{Y}_i-\overline{Y})^2
(\#eq:regSSM)
\end{equation} 

The model sum of squares represents the improvement in prediction resulting from using the regression model rather than the mean of the data. The following graph shows the model sum of squares for our example:

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-24-1.png" alt="Ordinary least squares (OLS)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-24)Ordinary least squares (OLS)</p>
</div>

The residual sum of squares (SS<sub>R</sub>) is the difference between the observed data points ($Y_{i}$) and the predicted values along the regression line ($\hat{Y}_{i}$), i.e., the variation *not* explained by the model.

\begin{equation} 
SS_R= \sum_{i=1}^{N} ({Y}_{i}-\hat{Y}_{i})^2
(\#eq:regSSR)
\end{equation} 

The following graph shows the residual sum of squares for our example:

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-25-1.png" alt="Ordinary least squares (OLS)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-25)Ordinary least squares (OLS)</p>
</div>

Based on these statistics, we can determine have well the model fits the data as we will see next. 

###### R-squared {-}

The R<sup>2</sup> statistic represents the proportion of variance that is explained by the model and is computed as:

\begin{equation} 
R^2= \frac{SS_M}{SS_T}
(\#eq:regSSR)
\end{equation} 

It takes values between 0 (very bad fit) and 1 (very good fit). Note that when the goal of your model is to *predict* future outcomes, a "too good" model fit can pose severe challenges. The reason is that the model might fit your specific sample so well, that it will only predict well within the sample but not generalize to other samples. This is called **overfitting** and it shows that there is a trade-off between model fit and out-of-sample predictive ability of the model, if the goal is to predict beyond the sample. We will come back to this point later in this chapter. 

You can get a first impression of the fit of the model by inspecting the scatter plot as can be seen in the plot below. If the observations are highly dispersed around the regression line (left plot), the fit will be lower compared to a data set where the values are less dispersed (right plot).

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-26-1.png" alt="Good vs. bad model fit" width="960" />
<p class="caption">(\#fig:unnamed-chunk-26)Good vs. bad model fit</p>
</div>

The R<sup>2</sup> statistic is reported in the regression output (see above). However, you could also extract the relevant sum of squares statistics from the regression object using the ```anova()``` function to compute it manually: 


```r
anova(simple_regression)  #anova results
```

```
## Analysis of Variance Table
## 
## Response: sales
##            Df Sum Sq Mean Sq F value              Pr(>F)    
## adspend     1 433688  433688    99.6 <0.0000000000000002 ***
## Residuals 198 862264    4355                                
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Now we can compute R<sup>2</sup> in the same way that we have computed Eta<sup>2</sup> in the last section:


```r
r2 <- anova(simple_regression)$"Sum Sq"[1]/(anova(simple_regression)$"Sum Sq"[1] +
    anova(simple_regression)$"Sum Sq"[2])  #compute R2
r2
```

```
## [1] 0.33
```

###### Adjusted R-squared {-}

Due to the way the R<sup>2</sup> statistic is calculated, it will never decrease if a new explanatory variable is introduced into the model. This means that every new independent variable either doesn't change the R<sup>2</sup> or increases it, even if there is no real relationship between the new variable and the dependent variable. Hence, one could be tempted to just add as many variables as possible to increase the R<sup>2</sup> and thus obtain a "better" model. However, this actually only leads to more noise and therefore a worse model. 

To account for this, there exists a test statistic closely related to the R<sup>2</sup>, the **adjusted R<sup>2</sup>**. It can be calculated as follows:

\begin{equation} 
\overline{R^2} = 1 - (1 - R^2)\frac{n-1}{n - k - 1}
(\#eq:adjustedR2)
\end{equation} 

where ```n``` is the total number of observations and ```k``` is the total number of explanatory variables. The adjusted R<sup>2</sup> is equal to or less than the regular R<sup>2</sup> and can be negative. It will only increase if the added variable adds more explanatory power than one would expect by pure chance. Essentially, it contains a "penalty" for including unnecessary variables and therefore favors more parsimonious models. As such, it is a measure of suitability, good for comparing different models and is very useful in the model selection stage of a project. In R, the standard ```lm()``` function automatically also reports the adjusted R<sup>2</sup> as you can see above.

###### F-test {-}

Similar to the ANOVA in chapter 6, another significance test is the F-test, which tests the null hypothesis:

$$H_0:R^2=0$$

<br>

Or, to state it slightly differently: 

$$H_0:\beta_1=\beta_2=\beta_3=\beta_k=0$$
<br>
This means that, similar to the ANOVA, we test whether any of the included independent variables has a significant effect on the dependent variable. So far, we have only included one independent variable, but we will extend the set of predictor variables below.   

The F-test statistic is calculated as follows:

\begin{equation} 
F=\frac{\frac{SS_M}{k}}{\frac{SS_R}{(n-k-1)}}=\frac{MS_M}{MS_R}
(\#eq:regSSR)
\end{equation} 

which has a F distribution with k number of predictors and n degrees of freedom. In other words, you divide the systematic ("explained") variation due to the predictor variables by the unsystematic ("unexplained") variation. 

The result of the F-test is provided in the regression output. However, you might manually compute the F-test using the ANOVA results from the model:  


```r
anova(simple_regression)  #anova results
```

```
## Analysis of Variance Table
## 
## Response: sales
##            Df Sum Sq Mean Sq F value              Pr(>F)    
## adspend     1 433688  433688    99.6 <0.0000000000000002 ***
## Residuals 198 862264    4355                                
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
f_calc <- anova(simple_regression)$"Mean Sq"[1]/anova(simple_regression)$"Mean Sq"[2]  #compute F
f_calc
```

```
## [1] 100
```

```r
f_crit <- qf(0.95, df1 = 1, df2 = 100)  #critical value
f_crit
```

```
## [1] 3.9
```

```r
f_calc > f_crit  #test if calculated test statistic is larger than critical value
```

```
## [1] TRUE
```

##### Using the model

After fitting the model, we can use the estimated coefficients to predict sales for different values of advertising. Suppose you want to predict sales for a new product, and the company plans to spend 800 Euros on advertising. How much will it sell? You can easily compute this either by hand:

$$\hat{sales}=134.134 + 0.09612*800=211$$

<br>

... or by extracting the estimated coefficients from the model summary:


```r
summary(simple_regression)$coefficients[1,1] + # the intercept
summary(simple_regression)$coefficients[2,1]*800 # the slope * 800
```

```
## [1] 211
```

The predicted value of the dependent variable is 211 units, i.e., the product will (on average) sell 211 units.

#### Multiple linear regression

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/SDB2PhHMgxg" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Multiple linear regression is a statistical technique that simultaneously tests the relationships between two or more independent variables and an interval-scaled dependent variable. The general form of the equation is given by:

\begin{equation} 
Y=(\beta_0+\beta_1*X_1+\beta_2*X_2+\beta_n*X_n)+\epsilon
(\#eq:regequ)
\end{equation} 

Again, we aim to find the linear combination of predictors that correlate maximally with the outcome variable. Note that if you change the composition of predictors, the partial regression coefficient of an independent variable will be different from that of the bivariate regression coefficient. This is because the regressors are usually correlated, and any variation in Y that was shared by X1 and X2 was attributed to X1. The interpretation of the partial regression coefficients is the expected change in Y when X is changed by one unit and all other predictors are held constant. 

Let's extend the previous example. Say, in addition to the influence of advertising, you are interested in estimating the influence of radio airplay on the number of album downloads. The corresponding equation would then be given by:

\begin{equation} 
Sales=\beta_0+\beta_1*adspend+\beta_2*airplay+\epsilon
(\#eq:regequadv)
\end{equation} 

The words "adspend" and "airplay" represent data that we have observed on advertising expenditures and number of radio plays, and &beta;<sub>1</sub> and &beta;<sub>2</sub> represent the unknown relationship between sales and advertising expenditures and radio airplay, respectively. The corresponding coefficients tell you by how much sales will increase for an additional Euro spent on advertising (when radio airplay is held constant) and by how much sales will increase for an additional radio play (when advertising expenditures are held constant). Thus, we can make predictions about album sales based not only on advertising spending, but also on radio airplay.

With several predictors, the partitioning of sum of squares is the same as in the bivariate model, except that the model is no longer a 2-D straight line. With two predictors, the regression line becomes a 3-D regression plane. In our example:

<div class="figure" style="text-align: center">

```{=html}
<div id="htmlwidget-d5079acbc85567375398" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-d5079acbc85567375398">{"x":{"visdat":{"175c727c3f44":["function () ","plotlyVisDat"],"175c45b5590a":["function () ","data"]},"cur_data":"175c45b5590a","attrs":{"175c727c3f44":{"x":{},"y":{},"z":{},"colors":["#A9D0F5","#08088A"],"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"surface"},"175c45b5590a":{"x":[10.256,174.093,1000,75.896,1351.254,202.705,365.985,305.268,263.268,513.694,152.609,35.987,1720.806,102.568,215.368,426.784,507.772,233.291,1035.433,102.642,526.142,624.538,912.349,611.479,215.994,561.963,474.76,231.523,678.596,70.922,1567.548,263.598,1423.568,715.678,251.192,777.237,509.43,964.11,583.627,923.373,344.392,1095.578,100.025,30.425,1080.342,97.972,799.899,1071.752,893.355,283.161,917.017,234.568,456.897,206.973,1294.099,826.859,406.814,564.158,192.607,10.652,45.689,42.568,20.456,635.192,1002.273,1177.047,507.638,265.398,215.689,526.48,26.895,883.877,9.104,103.568,169.583,429.504,223.639,145.585,1323.287,985.968,500.922,226.652,1051.168,68.093,1547.159,393.774,804.282,801.577,450.562,196.65,26.598,179.061,345.687,295.84,2271.86,1134.575,601.434,45.298,759.518,832.869,1326.598,56.894,709.399,56.895,767.134,503.172,700.929,910.851,888.569,800.615,1500,985.685,1380.689,785.694,792.345,957.167,1789.659,656.137,613.697,313.362,336.51,1544.899,68.954,1445.563,785.692,125.628,377.925,217.994,759.862,1163.444,842.957,125.179,236.598,669.811,1188.193,612.234,922.019,50,2000,1054.027,385.045,1507.972,102.568,204.568,1170.918,574.513,689.547,784.22,405.913,179.778,607.258,1542.329,1112.47,856.985,836.331,236.908,568.954,1077.855,579.321,1500,731.364,25.689,391.749,233.999,275.7,56.895,255.117,471.814,566.501,102.568,250.568,68.594,642.786,1500,102.563,756.984,51.229,644.151,537.352,15.313,243.237,256.894,22.464,45.689,724.938,1126.461,1985.119,1837.516,135.986,514.068,237.703,976.641,1452.689,1600,268.598,900.889,982.063,201.356,746.024,1132.877],"y":[43,40,5,34,37,13,23,54,18,2,11,30,32,22,36,37,9,2,12,5,14,20,57,20,19,35,22,16,53,4,29,43,26,28,24,37,32,34,30,15,23,31,21,28,18,38,28,37,26,30,10,21,18,14,38,36,24,32,9,39,24,45,13,17,32,23,0,25,35,26,19,26,53,29,28,17,26,42,35,17,36,45,20,15,28,27,17,32,46,36,47,19,22,55,31,39,21,36,21,44,27,27,16,33,33,21,35,26,14,34,11,28,33,20,33,28,30,34,49,40,20,42,35,35,8,49,19,42,6,36,32,28,25,34,33,21,34,63,31,25,42,37,25,26,39,44,46,36,12,2,29,33,28,10,38,19,19,13,30,38,22,23,22,20,18,37,16,20,32,26,53,28,32,24,37,30,19,47,22,22,10,1,1,39,8,38,35,40,22,21,27,31,19,24,1,38,26,11,34,55],"z":[330,300,250,120,290,60,140,290,160,100,160,150,290,140,230,230,30,80,190,90,120,150,230,70,150,210,180,140,360,10,240,270,290,220,150,230,220,240,260,170,130,270,140,60,210,190,210,240,210,200,140,90,120,100,360,180,240,150,110,90,160,230,40,60,230,230,120,100,150,120,60,280,120,230,230,40,140,360,250,210,260,250,200,150,250,100,260,210,290,210,220,70,110,250,320,300,180,180,200,320,280,140,100,120,230,150,250,190,240,250,230,120,230,110,210,230,320,210,230,250,60,330,150,360,150,180,80,180,130,320,280,200,130,190,270,150,230,310,340,240,180,220,40,190,290,220,340,250,190,120,230,190,210,170,310,90,170,140,300,340,170,100,200,80,100,70,50,70,240,160,290,140,210,300,230,280,160,200,210,110,110,70,100,190,70,360,360,300,120,200,150,220,280,300,140,290,180,140,210,250],"colors":["#A9D0F5","#08088A"],"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d","mode":"markers","marker":{"color":["darkgray","steelblue","steelblue","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","steelblue","steelblue","steelblue","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","steelblue","darkgray","steelblue","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","steelblue","steelblue","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray"],"size":3,"opacity":0.8,"symbol":75},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"adspend"},"yaxis":{"title":"airplay"},"zaxis":{"title":"sales"}},"hovermode":"closest","showlegend":false,"legend":{"yanchor":"top","y":0.5}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"colorbar":{"title":"z","ticklen":2,"len":0.5,"lenmode":"fraction","y":1,"yanchor":"top"},"colorscale":[["0","rgba(169,208,245,1)"],["0.0416666666666667","rgba(164,199,241,1)"],["0.0833333333333333","rgba(159,191,236,1)"],["0.125","rgba(154,182,232,1)"],["0.166666666666667","rgba(149,174,227,1)"],["0.208333333333333","rgba(144,165,223,1)"],["0.25","rgba(139,157,218,1)"],["0.291666666666667","rgba(134,148,214,1)"],["0.333333333333333","rgba(128,140,209,1)"],["0.375","rgba(123,132,205,1)"],["0.416666666666667","rgba(118,124,200,1)"],["0.458333333333333","rgba(112,115,196,1)"],["0.5","rgba(106,107,191,1)"],["0.541666666666667","rgba(101,99,187,1)"],["0.583333333333333","rgba(95,91,183,1)"],["0.625","rgba(89,84,178,1)"],["0.666666666666667","rgba(83,76,174,1)"],["0.708333333333333","rgba(76,68,169,1)"],["0.75","rgba(70,60,165,1)"],["0.791666666666667","rgba(63,52,160,1)"],["0.833333333333333","rgba(55,44,156,1)"],["0.875","rgba(47,36,151,1)"],["0.916666666666667","rgba(37,28,147,1)"],["0.958333333333333","rgba(26,19,142,1)"],["1","rgba(8,8,138,1)"]],"showscale":true,"x":[9.104,103.3855,197.667,291.9485,386.23,480.5115,574.793,669.0745,763.356,857.6375,951.919,1046.2005,1140.482,1234.7635,1329.045,1423.3265,1517.608,1611.8895,1706.171,1800.4525,1894.734,1989.0155,2083.297,2177.5785,2271.86],"y":[0,2.625,5.25,7.875,10.5,13.125,15.75,18.375,21,23.625,26.25,28.875,31.5,34.125,36.75,39.375,42,44.625,47.25,49.875,52.5,55.125,57.75,60.375,63],"z":[[41.9148312294276,50.1066740811476,58.2985169328676,66.4903597845876,74.6822026363075,82.8740454880275,91.0658883397475,99.2577311914675,107.449574043187,115.641416894907,123.833259746627,132.025102598347,140.216945450067,148.408788301787,156.600631153507,164.792474005227,172.984316856947,181.176159708667,189.368002560387,197.559845412107,205.751688263827,213.943531115547,222.135373967267,230.327216818987,238.519059670707],[51.3354036298894,59.5272464816094,67.7190893333294,75.9109321850494,84.1027750367694,92.2946178884894,100.486460740209,108.678303591929,116.870146443649,125.061989295369,133.253832147089,141.445674998809,149.637517850529,157.829360702249,166.021203553969,174.213046405689,182.404889257409,190.596732109129,198.788574960849,206.980417812569,215.172260664289,223.364103516009,231.555946367729,239.747789219449,247.939632071169],[60.7559760303513,68.9478188820713,77.1396617337913,85.3315045855112,93.5233474372312,101.715190288951,109.907033140671,118.098875992391,126.290718844111,134.482561695831,142.674404547551,150.866247399271,159.058090250991,167.249933102711,175.441775954431,183.633618806151,191.825461657871,200.017304509591,208.209147361311,216.400990213031,224.592833064751,232.784675916471,240.976518768191,249.168361619911,257.360204471631],[70.1765484308131,78.3683912825331,86.5602341342531,94.7520769859731,102.943919837693,111.135762689413,119.327605541133,127.519448392853,135.711291244573,143.903134096293,152.094976948013,160.286819799733,168.478662651453,176.670505503173,184.862348354893,193.054191206613,201.246034058333,209.437876910053,217.629719761773,225.821562613493,234.013405465213,242.205248316933,250.397091168653,258.588934020373,266.780776872093],[79.597120831275,87.788963682995,95.9808065347149,104.172649386435,112.364492238155,120.556335089875,128.748177941595,136.940020793315,145.131863645035,153.323706496755,161.515549348475,169.707392200195,177.899235051915,186.091077903635,194.282920755355,202.474763607075,210.666606458795,218.858449310515,227.050292162235,235.242135013955,243.433977865675,251.625820717395,259.817663569115,268.009506420835,276.201349272555],[89.0176932317368,97.2095360834568,105.401378935177,113.593221786897,121.785064638617,129.976907490337,138.168750342057,146.360593193777,154.552436045497,162.744278897217,170.936121748937,179.127964600657,187.319807452377,195.511650304097,203.703493155817,211.895336007537,220.087178859257,228.279021710977,236.470864562696,244.662707414416,252.854550266136,261.046393117856,269.238235969576,277.430078821296,285.621921673016],[98.4382656321987,106.630108483919,114.821951335639,123.013794187359,131.205637039079,139.397479890799,147.589322742519,155.781165594239,163.973008445958,172.164851297678,180.356694149398,188.548537001118,196.740379852838,204.932222704558,213.124065556278,221.315908407998,229.507751259718,237.699594111438,245.891436963158,254.083279814878,262.275122666598,270.466965518318,278.658808370038,286.850651221758,295.042494073478],[107.85883803266,116.05068088438,124.2425237361,132.43436658782,140.62620943954,148.81805229126,157.00989514298,165.2017379947,173.39358084642,181.58542369814,189.77726654986,197.96910940158,206.1609522533,214.35279510502,222.54463795674,230.73648080846,238.92832366018,247.1201665119,255.31200936362,263.50385221534,271.69569506706,279.88753791878,288.0793807705,296.27122362222,304.46306647394],[117.279410433122,125.471253284842,133.663096136562,141.854938988282,150.046781840002,158.238624691722,166.430467543442,174.622310395162,182.814153246882,191.005996098602,199.197838950322,207.389681802042,215.581524653762,223.773367505482,231.965210357202,240.157053208922,248.348896060642,256.540738912362,264.732581764082,272.924424615802,281.116267467522,289.308110319242,297.499953170962,305.691796022682,313.883638874402],[126.699982833584,134.891825685304,143.083668537024,151.275511388744,159.467354240464,167.659197092184,175.851039943904,184.042882795624,192.234725647344,200.426568499064,208.618411350784,216.810254202504,225.002097054224,233.193939905944,241.385782757664,249.577625609384,257.769468461104,265.961311312824,274.153154164544,282.344997016264,290.536839867984,298.728682719704,306.920525571424,315.112368423144,323.304211274864],[136.120555234046,144.312398085766,152.504240937486,160.696083789206,168.887926640926,177.079769492646,185.271612344366,193.463455196086,201.655298047806,209.847140899526,218.038983751246,226.230826602966,234.422669454686,242.614512306406,250.806355158126,258.998198009846,267.190040861566,275.381883713286,283.573726565006,291.765569416726,299.957412268446,308.149255120166,316.341097971886,324.532940823606,332.724783675326],[145.541127634508,153.732970486228,161.924813337948,170.116656189668,178.308499041388,186.500341893108,194.692184744828,202.884027596548,211.075870448268,219.267713299988,227.459556151708,235.651399003428,243.843241855148,252.035084706868,260.226927558588,268.418770410308,276.610613262028,284.802456113748,292.994298965468,301.186141817187,309.377984668907,317.569827520627,325.761670372347,333.953513224067,342.145356075787],[154.96170003497,163.15354288669,171.34538573841,179.53722859013,187.72907144185,195.92091429357,204.11275714529,212.30459999701,220.49644284873,228.68828570045,236.88012855217,245.07197140389,253.263814255609,261.455657107329,269.647499959049,277.839342810769,286.031185662489,294.223028514209,302.414871365929,310.606714217649,318.798557069369,326.990399921089,335.182242772809,343.374085624529,351.565928476249],[164.382272435432,172.574115287152,180.765958138871,188.957800990591,197.149643842311,205.341486694031,213.533329545751,221.725172397471,229.917015249191,238.108858100911,246.300700952631,254.492543804351,262.684386656071,270.876229507791,279.068072359511,287.259915211231,295.451758062951,303.643600914671,311.835443766391,320.027286618111,328.219129469831,336.410972321551,344.602815173271,352.794658024991,360.986500876711],[173.802844835893,181.994687687613,190.186530539333,198.378373391053,206.570216242773,214.762059094493,222.953901946213,231.145744797933,239.337587649653,247.529430501373,255.721273353093,263.913116204813,272.104959056533,280.296801908253,288.488644759973,296.680487611693,304.872330463413,313.064173315133,321.256016166853,329.447859018573,337.639701870293,345.831544722013,354.023387573733,362.215230425453,370.407073277173],[183.223417236355,191.415260088075,199.607102939795,207.798945791515,215.990788643235,224.182631494955,232.374474346675,240.566317198395,248.758160050115,256.950002901835,265.141845753555,273.333688605275,281.525531456995,289.717374308715,297.909217160435,306.101060012155,314.292902863875,322.484745715595,330.676588567315,338.868431419035,347.060274270755,355.252117122475,363.443959974195,371.635802825915,379.827645677635],[192.643989636817,200.835832488537,209.027675340257,217.219518191977,225.411361043697,233.603203895417,241.795046747137,249.986889598857,258.178732450577,266.370575302297,274.562418154017,282.754261005737,290.946103857457,299.137946709177,307.329789560897,315.521632412617,323.713475264337,331.905318116057,340.097160967777,348.289003819497,356.480846671217,364.672689522937,372.864532374657,381.056375226377,389.248218078097],[202.064562037279,210.256404888999,218.448247740719,226.640090592439,234.831933444159,243.023776295879,251.215619147599,259.407461999319,267.599304851039,275.791147702759,283.982990554479,292.174833406199,300.366676257919,308.558519109639,316.750361961359,324.942204813079,333.134047664799,341.325890516519,349.517733368239,357.709576219959,365.901419071679,374.093261923398,382.285104775118,390.476947626838,398.668790478558],[211.485134437741,219.676977289461,227.868820141181,236.060662992901,244.252505844621,252.444348696341,260.636191548061,268.828034399781,277.019877251501,285.211720103221,293.403562954941,301.595405806661,309.787248658381,317.9790915101,326.170934361821,334.36277721354,342.55462006526,350.74646291698,358.9383057687,367.13014862042,375.32199147214,383.51383432386,391.70567717558,399.8975200273,408.08936287902],[220.905706838203,229.097549689923,237.289392541643,245.481235393363,253.673078245083,261.864921096803,270.056763948522,278.248606800242,286.440449651962,294.632292503682,302.824135355402,311.015978207122,319.207821058842,327.399663910562,335.591506762282,343.783349614002,351.975192465722,360.167035317442,368.358878169162,376.550721020882,384.742563872602,392.934406724322,401.126249576042,409.318092427762,417.509935279482],[230.326279238664,238.518122090384,246.709964942104,254.901807793824,263.093650645544,271.285493497264,279.477336348984,287.669179200704,295.861022052424,304.052864904144,312.244707755864,320.436550607584,328.628393459304,336.820236311024,345.012079162744,353.203922014464,361.395764866184,369.587607717904,377.779450569624,385.971293421344,394.163136273064,402.354979124784,410.546821976504,418.738664828224,426.930507679944],[239.746851639126,247.938694490846,256.130537342566,264.322380194286,272.514223046006,280.706065897726,288.897908749446,297.089751601166,305.281594452886,313.473437304606,321.665280156326,329.857123008046,338.048965859766,346.240808711486,354.432651563206,362.624494414926,370.816337266646,379.008180118366,387.200022970086,395.391865821806,403.583708673526,411.775551525246,419.967394376966,428.159237228686,436.351080080406],[249.167424039588,257.359266891308,265.551109743028,273.742952594748,281.934795446468,290.126638298188,298.318481149908,306.510324001628,314.702166853348,322.894009705068,331.085852556788,339.277695408508,347.469538260228,355.661381111948,363.853223963668,372.045066815388,380.236909667108,388.428752518828,396.620595370548,404.812438222268,413.004281073988,421.196123925708,429.387966777428,437.579809629148,445.771652480868],[258.58799644005,266.77983929177,274.97168214349,283.16352499521,291.35536784693,299.54721069865,307.73905355037,315.93089640209,324.12273925381,332.31458210553,340.50642495725,348.69826780897,356.89011066069,365.08195351241,373.27379636413,381.46563921585,389.65748206757,397.84932491929,406.04116777101,414.23301062273,422.42485347445,430.61669632617,438.80853917789,447.00038202961,455.192224881329],[268.008568840512,276.200411692232,284.392254543952,292.584097395672,300.775940247392,308.967783099112,317.159625950832,325.351468802552,333.543311654272,341.735154505992,349.926997357712,358.118840209432,366.310683061152,374.502525912872,382.694368764592,390.886211616311,399.078054468031,407.269897319751,415.461740171471,423.653583023191,431.845425874911,440.037268726631,448.229111578351,456.420954430071,464.612797281791]],"type":"surface","frame":null},{"x":[10.256,174.093,1000,75.896,1351.254,202.705,365.985,305.268,263.268,513.694,152.609,35.987,1720.806,102.568,215.368,426.784,507.772,233.291,1035.433,102.642,526.142,624.538,912.349,611.479,215.994,561.963,474.76,231.523,678.596,70.922,1567.548,263.598,1423.568,715.678,251.192,777.237,509.43,964.11,583.627,923.373,344.392,1095.578,100.025,30.425,1080.342,97.972,799.899,1071.752,893.355,283.161,917.017,234.568,456.897,206.973,1294.099,826.859,406.814,564.158,192.607,10.652,45.689,42.568,20.456,635.192,1002.273,1177.047,507.638,265.398,215.689,526.48,26.895,883.877,9.104,103.568,169.583,429.504,223.639,145.585,1323.287,985.968,500.922,226.652,1051.168,68.093,1547.159,393.774,804.282,801.577,450.562,196.65,26.598,179.061,345.687,295.84,2271.86,1134.575,601.434,45.298,759.518,832.869,1326.598,56.894,709.399,56.895,767.134,503.172,700.929,910.851,888.569,800.615,1500,985.685,1380.689,785.694,792.345,957.167,1789.659,656.137,613.697,313.362,336.51,1544.899,68.954,1445.563,785.692,125.628,377.925,217.994,759.862,1163.444,842.957,125.179,236.598,669.811,1188.193,612.234,922.019,50,2000,1054.027,385.045,1507.972,102.568,204.568,1170.918,574.513,689.547,784.22,405.913,179.778,607.258,1542.329,1112.47,856.985,836.331,236.908,568.954,1077.855,579.321,1500,731.364,25.689,391.749,233.999,275.7,56.895,255.117,471.814,566.501,102.568,250.568,68.594,642.786,1500,102.563,756.984,51.229,644.151,537.352,15.313,243.237,256.894,22.464,45.689,724.938,1126.461,1985.119,1837.516,135.986,514.068,237.703,976.641,1452.689,1600,268.598,900.889,982.063,201.356,746.024,1132.877],"y":[43,40,5,34,37,13,23,54,18,2,11,30,32,22,36,37,9,2,12,5,14,20,57,20,19,35,22,16,53,4,29,43,26,28,24,37,32,34,30,15,23,31,21,28,18,38,28,37,26,30,10,21,18,14,38,36,24,32,9,39,24,45,13,17,32,23,0,25,35,26,19,26,53,29,28,17,26,42,35,17,36,45,20,15,28,27,17,32,46,36,47,19,22,55,31,39,21,36,21,44,27,27,16,33,33,21,35,26,14,34,11,28,33,20,33,28,30,34,49,40,20,42,35,35,8,49,19,42,6,36,32,28,25,34,33,21,34,63,31,25,42,37,25,26,39,44,46,36,12,2,29,33,28,10,38,19,19,13,30,38,22,23,22,20,18,37,16,20,32,26,53,28,32,24,37,30,19,47,22,22,10,1,1,39,8,38,35,40,22,21,27,31,19,24,1,38,26,11,34,55],"z":[330,300,250,120,290,60,140,290,160,100,160,150,290,140,230,230,30,80,190,90,120,150,230,70,150,210,180,140,360,10,240,270,290,220,150,230,220,240,260,170,130,270,140,60,210,190,210,240,210,200,140,90,120,100,360,180,240,150,110,90,160,230,40,60,230,230,120,100,150,120,60,280,120,230,230,40,140,360,250,210,260,250,200,150,250,100,260,210,290,210,220,70,110,250,320,300,180,180,200,320,280,140,100,120,230,150,250,190,240,250,230,120,230,110,210,230,320,210,230,250,60,330,150,360,150,180,80,180,130,320,280,200,130,190,270,150,230,310,340,240,180,220,40,190,290,220,340,250,190,120,230,190,210,170,310,90,170,140,300,340,170,100,200,80,100,70,50,70,240,160,290,140,210,300,230,280,160,200,210,110,110,70,100,190,70,360,360,300,120,200,150,220,280,300,140,290,180,140,210,250],"type":"scatter3d","mode":"markers","marker":{"color":["darkgray","steelblue","steelblue","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","steelblue","steelblue","steelblue","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","steelblue","darkgray","steelblue","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","steelblue","steelblue","steelblue","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","darkgray","darkgray","darkgray","steelblue","steelblue","darkgray","darkgray","darkgray","steelblue","darkgray","darkgray","darkgray","darkgray","steelblue","darkgray"],"size":3,"opacity":0.8,"symbol":75,"line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"line":{"color":"rgba(255,127,14,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:unnamed-chunk-31)Regression plane</p>
</div>

Like in the bivariate case, the plane is fitted to the data with the aim to predict the observed data as good as possible. The deviation of the observations from the plane represent the residuals (the error we make in predicting the observed data from the model). Note that this is conceptually the same as in the bivariate case, except that the computation is more complex (we won't go into details here). The model is fairly easy to plot using a 3-D scatterplot, because we only have two predictors. While multiple regression models that have more than two predictors are not as easy to visualize, you may apply the same principles when interpreting the model outcome:

* Total sum of squares (SS<sub>T</sub>) is still the difference between the observed data and the mean value of Y (total variation)
* Residual sum of squares (SS<sub>R</sub>) is still the difference between the observed data and the values predicted by the model (unexplained variation)
* Model sum of squares (SS<sub>M</sub>) is still the difference between the values predicted by the model and the mean value of Y (explained variation)
* R measures the multiple correlation between the predictors and the outcome
* R<sup>2</sup> is the amount of variation in the outcome variable explained by the model

Estimating multiple regression models is straightforward using the ```lm()``` function. You just need to separate the individual predictors on the right hand side of the equation using the ```+``` symbol. For example, the model:

\begin{equation} 
Sales=\beta_0+\beta_1*adspend+\beta_2*airplay+\beta_3*starpower+\epsilon
(\#eq:regequadv)
\end{equation} 

could be estimated as follows: 


```r
multiple_regression <- lm(sales ~ adspend + airplay +
    starpower, data = regression)  #estimate linear model
summary(multiple_regression)  #summary of results
```

```
## 
## Call:
## lm(formula = sales ~ adspend + airplay + starpower, data = regression)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -121.32  -28.34   -0.45   28.97  144.13 
## 
## Coefficients:
##              Estimate Std. Error t value             Pr(>|t|)    
## (Intercept) -26.61296   17.35000   -1.53                 0.13    
## adspend       0.08488    0.00692   12.26 < 0.0000000000000002 ***
## airplay       3.36743    0.27777   12.12 < 0.0000000000000002 ***
## starpower    11.08634    2.43785    4.55            0.0000095 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 47 on 196 degrees of freedom
## Multiple R-squared:  0.665,	Adjusted R-squared:  0.66 
## F-statistic:  129 on 3 and 196 DF,  p-value: <0.0000000000000002
```

The interpretation of the coefficients is as follows: 

* adspend (&beta;<sub>1</sub>): when advertising expenditures increase by 1 Euro, sales will increase by 0.085 units
* airplay (&beta;<sub>2</sub>): when radio airplay increases by 1 play per week, sales will increase by 3.367 units
* starpower (&beta;<sub>3</sub>): when the number of previous albums increases by 1, sales will increase by 11.086 units

The associated t-values and p-values are also given in the output. You can see that the p-values are smaller than 0.05 for all three coefficients. Hence, all effects are "significant". This means that if the null hypothesis was true (i.e., there was no effect between the variables and sales), the probability of observing associations of the estimated magnitudes (or larger) is very small (e.g., smaller than 0.05).     

Again, to get a better feeling for the range of values that the coefficients could take, it is helpful to compute <b>confidence intervals</b>. 


```r
confint(multiple_regression)
```

```
##               2.5 % 97.5 %
## (Intercept) -60.830  7.604
## adspend       0.071  0.099
## airplay       2.820  3.915
## starpower     6.279 15.894
```

What does this tell you? Recall that a 95% confidence interval is defined as a range of values such that with a 95% probability, the range will contain the true unknown value of the parameter. For example, for &beta;<sub>3</sub>, the confidence interval is [6.2785522,15.8941182]. Thus, although we have computed a point estimate of 11.086 for the effect of starpower on sales based on our sample, the effect might actually just as well take any other value within this range, considering the sample size and the variability in our data. You could also visualize the output from your regression model including the confidence intervals using the `ggstatsplot` package as follows: 


```r
library(ggstatsplot)
ggcoefstats(x = multiple_regression, title = "Sales predicted by adspend, airplay, & starpower")
```

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-34-1.png" alt="Confidence intervals for regression model" width="672" />
<p class="caption">(\#fig:unnamed-chunk-34)Confidence intervals for regression model</p>
</div>

The output also tells us that 66.4667687% of the variation can be explained by our model. You may also visually inspect the fit of the model by plotting the predicted values against the observed values. We can extract the predicted values using the ```predict()``` function. So let's create a new variable ```yhat```, which contains those predicted values.  


```r
regression$yhat <- predict(simple_regression)
```

We can now use this variable to plot the predicted values against the observed values. In the following plot, the model fit would be perfect if all points would fall on the diagonal line. The larger the distance between the points and the line, the worse the model fit. In other words, if all points would fall exactly on the diagonal line, the model would perfectly predict the observed values. 


```r
ggplot(regression,aes(yhat,sales)) +  
  geom_point(size=2,shape=1) +  #Use hollow circles
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()
```

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-36-1.png" alt="Model fit" width="672" />
<p class="caption">(\#fig:unnamed-chunk-36)Model fit</p>
</div>

**Partial plots**

In the context of a simple linear regression (i.e., with a single independent variable), a scatter plot of the dependent variable against the independent variable provides a good indication of the nature of the relationship. If there is more than one independent variable, however, things become more complicated. The reason is that although the scatter plot still show the relationship between the two variables, it does not take into account the effect of the other independent variables in the model. Partial regression plot show the effect of adding another variable to a model that already controls for the remaining variables in the model. In other words, it is a scatterplot of the residuals of the outcome variable and each predictor when both variables are regressed separately on the remaining predictors. As an example, consider the effect of advertising expenditures on sales. In this case, the partial plot would show the effect of adding advertising expenditures as an explanatory variable while controlling for the variation that is explained by airplay and starpower in both variables (sales and advertising). Think of it as the purified relationship between advertising and sales that remains after controlling for other factors. The partial plots can easily be created using the ```avPlots()``` function from the ```car``` package:


```r
library(car)
avPlots(multiple_regression)
```

<div class="figure" style="text-align: center">
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-37-1.png" alt="Partial plots" width="672" />
<p class="caption">(\#fig:unnamed-chunk-37)Partial plots</p>
</div>

**Using the model**

After fitting the model, we can use the estimated coefficients to predict sales for different values of advertising, airplay, and starpower. Suppose you would like to predict sales for a new music album with advertising expenditures of 800, airplay of 30 and starpower of 5. How much will it sell?

$$\hat{sales}=−26.61 + 0.084 * 800 + 3.367*30 + 11.08 ∗ 5= 197.74$$

<br>

... or by extracting the estimated coefficients:


```r
summary(multiple_regression)$coefficients[1, 1] + summary(multiple_regression)$coefficients[2,
    1] * 800 + summary(multiple_regression)$coefficients[3,
    1] * 30 + summary(multiple_regression)$coefficients[4,
    1] * 5
```

```
## [1] 198
```

The predicted value of the dependent variable is 198 units, i.e., the product will sell 198 units.

**Comparing effects**

Using the output from the regression model above, it is difficult to compare the effects of the independent variables because they are all measured on different scales (Euros, radio plays, releases). Standardized regression coefficients can be used to judge the relative importance of the predictor variables. Standardization is achieved by multiplying the unstandardized coefficient by the ratio of the standard deviations of the independent and dependent variables:

\begin{equation} 
B_{k}=\beta_{k} * \frac{s_{x_k}}{s_y}
(\#eq:stdcoeff)
\end{equation}

Hence, the standardized coefficient will tell you by how many standard deviations the outcome will change as a result of a one standard deviation change in the predictor variable. Standardized coefficients can be easily computed using the ```lm.beta()``` function from the ```lm.beta``` package.


```r
library(lm.beta)
lm.beta(multiple_regression)
```

```
## 
## Call:
## lm(formula = sales ~ adspend + airplay + starpower, data = regression)
## 
## Standardized Coefficients::
## (Intercept)     adspend     airplay   starpower 
##          NA        0.51        0.51        0.19
```

The results show that for ```adspend``` and ```airplay```, a change by one standard deviation will result in a 0.51 standard deviation change in sales, whereas for ```starpower```, a one standard deviation change will only lead to a 0.19 standard deviation change in sales. Hence, while the effects of ```adspend``` and ```airplay``` are comparable in magnitude, the effect of ```starpower``` is less strong. 

<br>

### Categorical predictors

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/Zttj2HWFL2M" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>



#### Two categories

Suppose, you wish to investigate the effect of the variable "country" on sales, which is a categorical variable that can only take two levels (i.e., 0 = local artist, 1 = international artist). Categorical variables with two levels are also called binary predictors. It is straightforward to include these variables in your model as "dummy" variables. Dummy variables are factor variables that can only take two values. For our "country" variable, we can create a new predictor variable that takes the form:

\begin{equation} 
x_4 =
  \begin{cases}
    1       & \quad \text{if } i \text{th artist is international}\\
    0  & \quad \text{if } i \text{th artist is local}
  \end{cases}
(\#eq:dummycoding)
\end{equation} 

This new variable is then added to our regression equation from before, so that the equation becomes 

\begin{align}
Sales =\beta_0 &+\beta_1*adspend\\
      &+\beta_2*airplay\\
      &+\beta_3*starpower\\ 
      &+\beta_4*international+\epsilon
\end{align}

where "international" represents the new dummy variable and $\beta_4$ is the coefficient associated with this variable. Estimating the model is straightforward - you just need to include the variable as an additional predictor variable. Note that the variable needs to be specified as a factor variable before including it in your model. If you haven't converted it to a factor variable before, you could also use the wrapper function ```as.factor()``` within the equation. 


```r
multiple_regression_bin <- lm(sales ~ adspend + airplay +
    starpower + country, data = regression)  #estimate linear model
summary(multiple_regression_bin)  #summary of results
```

```
## 
## Call:
## lm(formula = sales ~ adspend + airplay + starpower + country, 
##     data = regression)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -109.20  -24.30   -1.82   29.19  156.31 
## 
## Coefficients:
##                       Estimate Std. Error t value             Pr(>|t|)    
## (Intercept)          -16.40060   16.39540   -1.00                 0.32    
## adspend                0.08146    0.00653   12.48 < 0.0000000000000002 ***
## airplay                3.03766    0.26809   11.33 < 0.0000000000000002 ***
## starpower             10.08100    2.29546    4.39           0.00001843 ***
## countryinternational  45.67274    8.69117    5.26           0.00000039 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 44 on 195 degrees of freedom
## Multiple R-squared:  0.706,	Adjusted R-squared:   0.7 
## F-statistic:  117 on 4 and 195 DF,  p-value: <0.0000000000000002
```

You can see that we now have an additional coefficient in the regression output, which tells us the effect of the binary predictor. The dummy variable can generally be interpreted as the average difference in the dependent variable between the two groups (similar to a t-test), conditional on the other variables you have included in your model. In this case, the coefficient tells you the difference in sales between international and local artists, and whether this difference is significant. Specifically, it means that international artists on average sell 45.67 units more than local artists, and this difference is significant (i.e., p < 0.05).  

#### More than two categories

Predictors with more than two categories, like our "genre"" variable, can also be included in your model. However, in this case one dummy variable cannot represent all possible values, since there are three genres (i.e., 1 = Rock, 2 = Pop, 3 = Electronic). Thus, we need to create additional dummy variables. For example, for our "genre" variable, we create two dummy variables as follows:

\begin{equation} 
x_5 =
  \begin{cases}
    1       & \quad \text{if } i \text{th  product is from Pop genre}\\
    0  & \quad \text{if } i \text{th product is from Rock genre}
  \end{cases}
(\#eq:dummycoding1)
\end{equation} 

\begin{equation} 
x_6 =
  \begin{cases}
    1       & \quad \text{if } i \text{th  product is from Electronic genre}\\
    0  & \quad \text{if } i \text{th product is from Rock genre}
  \end{cases}
(\#eq:dummycoding2)
\end{equation} 

We would then add these variables as additional predictors in the regression equation and obtain the following model

\begin{align}
Sales =\beta_0 &+\beta_1*adspend\\
      &+\beta_2*airplay\\
      &+\beta_3*starpower\\ 
      &+\beta_4*international\\
      &+\beta_5*Pop\\
      &+\beta_6*Electronic+\epsilon
\end{align}

where "Pop" and "Rock" represent our new dummy variables, and $\beta_5$ and $\beta_6$ represent the associated regression coefficients. 

The interpretation of the coefficients is as follows: $\beta_5$ is the difference in average sales between the genres "Rock" and "Pop", while $\beta_6$ is the difference in average sales between the genres "Rock" and "Electro". Note that the level for which no dummy variable is created is also referred to as the *baseline*. In our case, "Rock" would be the baseline genre. This means that there will always be one fewer dummy variable than the number of levels.

You don't have to create the dummy variables manually as R will do this automatically when you add the variable to your equation: 


```r
multiple_regression <- lm(sales ~ adspend + airplay +
    starpower + country + genre, data = regression)  #estimate linear model
summary(multiple_regression)  #summary of results
```

```
## 
## Call:
## lm(formula = sales ~ adspend + airplay + starpower + country + 
##     genre, data = regression)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -116.18  -26.54    0.05   27.98  154.56 
## 
## Coefficients:
##                       Estimate Std. Error t value             Pr(>|t|)    
## (Intercept)          -30.67901   16.59989   -1.85              0.06611 .  
## adspend                0.07233    0.00657   11.00 < 0.0000000000000002 ***
## airplay                2.71418    0.26824   10.12 < 0.0000000000000002 ***
## starpower             10.49628    2.19380    4.78            0.0000034 ***
## countryinternational  40.87988    8.40868    4.86            0.0000024 ***
## genrepop              47.69640   10.48717    4.55            0.0000095 ***
## genreelectronic       27.62034    8.17223    3.38              0.00088 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 42 on 193 degrees of freedom
## Multiple R-squared:  0.735,	Adjusted R-squared:  0.727 
## F-statistic: 89.2 on 6 and 193 DF,  p-value: <0.0000000000000002
```

How can we interpret the coefficients? It is estimated based on our model that products from the "Pop" genre will on average sell 47.69 units more than products from the "Rock" genre, and that products from the "Electronic" genre will sell on average 27.62 units more than the products from the "Rock" genre. The p-value of both variables is smaller than 0.05, suggesting that there is statistical evidence for a real difference in sales between the genres.

The level of the baseline category is arbitrary. As you have seen, R simply selects the first level as the baseline. If you would like to use a different baseline category, you can use the ```relevel()``` function and set the reference category using the ```ref``` argument. The following would estimate the same model using the second category as the baseline:


```r
multiple_regression <- lm(sales ~ adspend + airplay +
    starpower + country + relevel(genre, ref = 2),
    data = regression)  #estimate linear model
summary(multiple_regression)  #summary of results
```

```
## 
## Call:
## lm(formula = sales ~ adspend + airplay + starpower + country + 
##     relevel(genre, ref = 2), data = regression)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -116.18  -26.54    0.05   27.98  154.56 
## 
## Coefficients:
##                                    Estimate Std. Error t value
## (Intercept)                        17.01739   18.19704    0.94
## adspend                             0.07233    0.00657   11.00
## airplay                             2.71418    0.26824   10.12
## starpower                          10.49628    2.19380    4.78
## countryinternational               40.87988    8.40868    4.86
## relevel(genre, ref = 2)rock       -47.69640   10.48717   -4.55
## relevel(genre, ref = 2)electronic -20.07606    7.98747   -2.51
##                                               Pr(>|t|)    
## (Intercept)                                      0.351    
## adspend                           < 0.0000000000000002 ***
## airplay                           < 0.0000000000000002 ***
## starpower                                    0.0000034 ***
## countryinternational                         0.0000024 ***
## relevel(genre, ref = 2)rock                  0.0000095 ***
## relevel(genre, ref = 2)electronic                0.013 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 42 on 193 degrees of freedom
## Multiple R-squared:  0.735,	Adjusted R-squared:  0.727 
## F-statistic: 89.2 on 6 and 193 DF,  p-value: <0.0000000000000002
```

Note that while your choice of the baseline category impacts the coefficients and the significance level, the prediction for each group will be the same regardless of this choice.

## Logistic regression

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/10-regression.R)
:::

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

chart_data <- read.delim2("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/chart_data_logistic.dat",
    header = T, sep = "\t", stringsAsFactors = F, dec = ".")
# Create a new dummy variable 'top10', which is 1
# if a song made it to the top10 and 0 else:
chart_data$top10 <- ifelse(chart_data$rank < 11, 1,
    0)

# Inspect data
head(chart_data)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["artistName"],"name":[1],"type":["chr"],"align":["left"]},{"label":["trackID"],"name":[2],"type":["chr"],"align":["left"]},{"label":["trackName"],"name":[3],"type":["chr"],"align":["left"]},{"label":["rank"],"name":[4],"type":["int"],"align":["right"]},{"label":["streams"],"name":[5],"type":["int"],"align":["right"]},{"label":["frequency"],"name":[6],"type":["int"],"align":["right"]},{"label":["danceability"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["energy"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["key"],"name":[9],"type":["int"],"align":["right"]},{"label":["loudness"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["speechiness"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["acousticness"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["instrumentalness"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["liveness"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["valence"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tempo"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["duration_ms"],"name":[17],"type":["int"],"align":["right"]},{"label":["time_signature"],"name":[18],"type":["int"],"align":["right"]},{"label":["isrc"],"name":[19],"type":["chr"],"align":["left"]},{"label":["spotifyArtistID"],"name":[20],"type":["chr"],"align":["left"]},{"label":["releaseDate"],"name":[21],"type":["chr"],"align":["left"]},{"label":["daysSinceRelease"],"name":[22],"type":["int"],"align":["right"]},{"label":["spotifyFollowers"],"name":[23],"type":["int"],"align":["right"]},{"label":["mbid"],"name":[24],"type":["chr"],"align":["left"]},{"label":["artistCountry"],"name":[25],"type":["chr"],"align":["left"]},{"label":["indicator"],"name":[26],"type":["int"],"align":["right"]},{"label":["top10"],"name":[27],"type":["dbl"],"align":["right"]}],"data":[{"1":"dj mustard","2":"01gNiOqg8u7vT90uVgOVmz","3":"Whole Lotta Lovin'","4":"120","5":"917710","6":"3","7":"0.44","8":"0.40","9":"4","10":"-8.8","11":"0.062","12":"0.154","13":"0.0000084","14":"0.065","15":"0.38","16":"160","17":"299160","18":"5","19":"QMJMT1500808","20":"0YinUQ50QDB7ZxSCLyQ40k","21":"08.01.2016","22":"450","23":"139718","24":"0612bcce-e351-40be-b3d7-2bb5e1c23479","25":"US","26":"1","27":"0"},{"1":"bing crosby","2":"01h424WG38dgY34vkI3Yd0","3":"White Christmas","4":"70","5":"1865526","6":"9","7":"0.22","8":"0.25","9":"9","10":"-15.9","11":"0.034","12":"0.912","13":"0.0001430","14":"0.404","15":"0.18","16":"96","17":"183613","18":"4","19":"USMC14750470","20":"6ZjFtWeHP9XN7FeKSUe80S","21":"27.08.2007","22":"1000","23":"123135","24":"2437980f-513a-44fc-80f1-b90d9d7fcf8f","25":"US","26":"1","27":"0"},{"1":"post malone","2":"02opp1cycqiFNDpLd2o1J3","3":"Big Lie","4":"129","5":"1480436","6":"1","7":"0.32","8":"0.69","9":"6","10":"-5.0","11":"0.243","12":"0.197","13":"0.0000000","14":"0.072","15":"0.22","16":"78","17":"207680","18":"4","19":"USUM71614468","20":"246dkjvS1zLTtiykXe5h60","21":"09.12.2016","22":"114","23":"629600","24":"b1e26560-60e5-4236-bbdb-9aa5a8d5ee19","25":"0","26":"1","27":"0"},{"1":"chris brown","2":"02yRHV9Cgk8CUS2fx9lKVC","3":"Anyway","4":"130","5":"894216","6":"1","7":"0.47","8":"0.66","9":"7","10":"-7.2","11":"0.121","12":"0.057","13":"0.0000016","14":"0.482","15":"0.27","16":"125","17":"211413","18":"4","19":"USRC11502943","20":"7bXgB6jMjp9ATFy66eO08Z","21":"11.12.2015","22":"478","23":"4077185","24":"c234fa42-e6a6-443e-937e-2f4b073538a3","25":"US","26":"1","27":"0"},{"1":"5 seconds of summer","2":"0375PEO6HIwCHx5Y2sowQm","3":"Waste The Night","4":"182","5":"642784","6":"1","7":"0.29","8":"0.91","9":"8","10":"-4.7","11":"0.113","12":"0.014","13":"0.0000000","14":"0.268","15":"0.27","16":"76","17":"266640","18":"4","19":"GBUM71505159","20":"5Rl15oVamLq7FbSb0NNBNy","21":"23.10.2015","22":"527","23":"2221348","24":"830e5c4e-6b7d-431d-86ab-00c751281dc5","25":"AU","26":"1","27":"0"},{"1":"rihanna","2":"046irIGshCqu24AjmEWZtr","3":"Same Olâ\\200\\231 Mistakes","4":"163","5":"809256","6":"2","7":"0.45","8":"0.80","9":"8","10":"-5.4","11":"0.044","12":"0.211","13":"0.0016900","14":"0.072","15":"0.50","16":"151","17":"397093","18":"4","19":"QM5FT1600108","20":"5pKCCKE2ajJHZ9KAiaK11H","21":"29.01.2016","22":"429","23":"9687258","24":"73e5e69d-3554-40d8-8516-00cb38737a1c","25":"0","26":"1","27":"0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
<img src="07-supervised_learning_files/figure-html/unnamed-chunk-45-1.png" alt="The same binary data explained by two models; A linear probability model (on the left) and a logistic regression model (on the right)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-45)The same binary data explained by two models; A linear probability model (on the left) and a logistic regression model (on the right)</p>
</div>

A key insight at this point is that the connection between $\mathbf{X}$ and $Y$ is __non-linear__ in the logistic regression model. As we can see in the plot, the probability of success is most strongly affected by danceability around values of $0.5$, while higher and lower values have a smaller marginal effect. This obviously also has consequences for the interpretation of the coefficients later on.  

### Technical details of the model

As the name suggests, the logistic function is an important component of the logistic regression model. It has the following form:

$$
f(\mathbf{X}) = \frac{1}{1 + e^{-\mathbf{X}}}
$$
This function transforms all real numbers into the range between 0 and 1. We need this to model probabilities, as probabilities can only be between 0 and 1. 


```
## 
## Attaching package: 'latex2exp'
```

```
## The following object is masked from 'package:plotly':
## 
##     TeX
```

<img src="07-supervised_learning_files/figure-html/unnamed-chunk-46-1.png" width="672" />



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
# Run the glm
logit_model <- glm(top10 ~ danceability, family = binomial(link = "logit"),
    data = chart_data)
# Inspect model summary
summary(logit_model)
```

```
## 
## Call:
## glm(formula = top10 ~ danceability, family = binomial(link = "logit"), 
##     data = chart_data)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -2.885  -0.501  -0.238   0.293   2.820  
## 
## Coefficients:
##              Estimate Std. Error z value            Pr(>|z|)    
## (Intercept)   -10.041      0.896   -11.2 <0.0000000000000002 ***
## danceability   17.094      1.602    10.7 <0.0000000000000002 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 539.05  on 421  degrees of freedom
## Residual deviance: 258.49  on 420  degrees of freedom
## AIC: 262.5
## 
## Number of Fisher Scoring iterations: 6
```

Noticeably this output does not include an $R^2$ value to asses model fit. Multiple "Pseudo $R^2$s", similar to the one used in OLS, have been developed. There are packages that return the $R^2$ given a logit model (see ```rcompanion``` or ```pscl```). The calculation by hand is also fairly simple. We define the function ```logisticPseudoR2s()``` that takes a logit model as an input and returns three popular pseudo $R^2$ values.


```r
logisticPseudoR2s <- function(LogModel) {
    dev <- LogModel$deviance
    nullDev <- LogModel$null.deviance
    modelN <- length(LogModel$fitted.values)
    R.l <- 1 - dev/nullDev
    R.cs <- 1 - exp(-(nullDev - dev)/modelN)
    R.n <- R.cs/(1 - (exp(-(nullDev/modelN))))
    cat("Pseudo R^2 for logistic regression\n")
    cat("Hosmer and Lemeshow R^2  ", round(R.l, 3),
        "\n")
    cat("Cox and Snell R^2        ", round(R.cs, 3),
        "\n")
    cat("Nagelkerke R^2           ", round(R.n, 3),
        "\n")
}
# Inspect Pseudo R2s
logisticPseudoR2s(logit_model)
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.52 
## Cox and Snell R^2         0.49 
## Nagelkerke R^2            0.67
```

The coefficients of the model give the change in the [log odds](https://en.wikipedia.org/wiki/Odds#Statistical_usage) of the dependent variable due to a unit change in the regressor. This makes the exact interpretation of the coefficients difficult, but we can still interpret the signs and the p-values which will tell us if a variable has a significant positive or negative impact on the probability of the dependent variable being $1$. In order to get the odds ratios we can simply take the exponent of the coefficients. 


```r
exp(coef(logit_model))
```

```
##     (Intercept)    danceability 
##        0.000044 26532731.711423
```

Notice that the coefficient is extremely large. That is (partly) due to the fact that the danceability variable is constrained to values between $0$ and $1$ and the coefficients are for a unit change. We can make the "unit-change" interpretation more meaningful by multiplying the danceability index by $100$. This linear transformation does not affect the model fit or the p-values.


```r
# Re-scale independet variable
chart_data$danceability_100 <- chart_data$danceability *
    100
# Run the regression model
logit_model <- glm(top10 ~ danceability_100, family = binomial(link = "logit"),
    data = chart_data)
# Inspect model summary
summary(logit_model)
```

```
## 
## Call:
## glm(formula = top10 ~ danceability_100, family = binomial(link = "logit"), 
##     data = chart_data)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -2.885  -0.501  -0.238   0.293   2.820  
## 
## Coefficients:
##                  Estimate Std. Error z value            Pr(>|z|)    
## (Intercept)       -10.041      0.896   -11.2 <0.0000000000000002 ***
## danceability_100    0.171      0.016    10.7 <0.0000000000000002 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 539.05  on 421  degrees of freedom
## Residual deviance: 258.49  on 420  degrees of freedom
## AIC: 262.5
## 
## Number of Fisher Scoring iterations: 6
```

```r
# Inspect Pseudo R2s
logisticPseudoR2s(logit_model)
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.52 
## Cox and Snell R^2         0.49 
## Nagelkerke R^2            0.67
```

```r
# Convert coefficients to odds ratios
exp(coef(logit_model))
```

```
##      (Intercept) danceability_100 
##         0.000044         1.186418
```

We observe that danceability positively affects the likelihood of becoming at top-10 hit. To get the confidence intervals for the coefficients we can use the same function as with OLS


```r
confint(logit_model)
```

```
##                   2.5 % 97.5 %
## (Intercept)      -11.92   -8.4
## danceability_100   0.14    0.2
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
##                    dF/dx Std. Err.    z      P>|z|    
## danceability_100 0.01573   0.00298 5.29 0.00000013 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This now gives the average partial effects in percentage points. An additional point on the danceability scale (from $1$ to $100$), on average, makes it $1.57%$ more likely for a song to become at top-10 hit.

To get the effect of an additional point at a specific value, we can calculate the odds ratio by predicting the probability at a value and at the value $+1$. For example if we are interested in how much more likely a song with 51 compared to 50 danceability is to become a hit we can simply calculate the following


```r
# Probability of a top 10 hit with a danceability
# of 50
prob_50 <- exp(-(-summary(logit_model)$coefficients[1,
    1] - summary(logit_model)$coefficients[2, 1] *
    50))
prob_50
```

```
## [1] 0.22
```

```r
# Probability of a top 10 hit with a danceability
# of 51
prob_51 <- exp(-(-summary(logit_model)$coefficients[1,
    1] - summary(logit_model)$coefficients[2, 1] *
    51))
prob_51
```

```
## [1] 0.27
```

```r
# Odds ratio
prob_51/prob_50
```

```
## [1] 1.2
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
multiple_logit_model <- glm(top10 ~ danceability_100 +
    spotify_followers_m + weeks_since_release, family = binomial(link = "logit"),
    data = chart_data)
summary(multiple_logit_model)
```

```
## 
## Call:
## glm(formula = top10 ~ danceability_100 + spotify_followers_m + 
##     weeks_since_release, family = binomial(link = "logit"), data = chart_data)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -2.886  -0.439  -0.208   0.231   2.801  
## 
## Coefficients:
##                     Estimate Std. Error z value             Pr(>|z|)    
## (Intercept)         -9.60376    0.99048   -9.70 < 0.0000000000000002 ***
## danceability_100     0.16624    0.01636   10.16 < 0.0000000000000002 ***
## spotify_followers_m  0.19772    0.06003    3.29              0.00099 ***
## weeks_since_release -0.01298    0.00496   -2.62              0.00883 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 534.91  on 416  degrees of freedom
## Residual deviance: 239.15  on 413  degrees of freedom
##   (5 observations deleted due to missingness)
## AIC: 247.1
## 
## Number of Fisher Scoring iterations: 6
```

```r
logisticPseudoR2s(multiple_logit_model)
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.55 
## Cox and Snell R^2         0.51 
## Nagelkerke R^2            0.7
```

```r
exp(coef(multiple_logit_model))
```

```
##         (Intercept)    danceability_100 spotify_followers_m weeks_since_release 
##            0.000067            1.180851            1.218617            0.987108
```

```r
confint(multiple_logit_model)
```

```
## Waiting for profiling to be done...
```

```
##                       2.5 %  97.5 %
## (Intercept)         -11.680 -7.7821
## danceability_100      0.136  0.2006
## spotify_followers_m   0.081  0.3171
## weeks_since_release  -0.023 -0.0036
```


#### Model selection

The question remains, whether a variable *should* be added to the model. We will present two methods for model selection for logistic regression. The first is based on the _Akaike Information Criterium_ (AIC). It is reported with the summary output for logit models. The value of the AIC is __relative__, meaning that it has no interpretation by itself. However, it can be used to compare and select models. The model with the lowest AIC value is the one that should be chosen. Note that the AIC does not indicate how well the model fits the data, but is merely used to compare models. 

For example, consider the following model, where we exclude the ```followers``` covariate. Seeing as it was able to contribute significantly to the explanatory power of the model, the AIC increases, indicating that the model including ```followers``` is better suited to explain the data. We always want the lowest possible AIC. 


```r
multiple_logit_model2 <- glm(top10 ~ danceability_100 +
    weeks_since_release, family = binomial(link = "logit"),
    data = chart_data)

summary(multiple_logit_model2)
```

```
## 
## Call:
## glm(formula = top10 ~ danceability_100 + weeks_since_release, 
##     family = binomial(link = "logit"), data = chart_data)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -2.958  -0.472  -0.219   0.256   2.876  
## 
## Coefficients:
##                     Estimate Std. Error z value            Pr(>|z|)    
## (Intercept)         -8.98023    0.93065   -9.65 <0.0000000000000002 ***
## danceability_100     0.16650    0.01611   10.34 <0.0000000000000002 ***
## weeks_since_release -0.01281    0.00484   -2.65              0.0081 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 534.91  on 416  degrees of freedom
## Residual deviance: 250.12  on 414  degrees of freedom
##   (5 observations deleted due to missingness)
## AIC: 256.1
## 
## Number of Fisher Scoring iterations: 6
```

As a second measure for variable selection, you can use the pseudo $R^2$s as shown above. The fit is distinctly worse according to all three values presented here, when excluding the Spotify followers. 


```r
logisticPseudoR2s(multiple_logit_model2)
```

```
## Pseudo R^2 for logistic regression
## Hosmer and Lemeshow R^2   0.53 
## Cox and Snell R^2         0.49 
## Nagelkerke R^2            0.68
```


#### Predictions

We can predict the probability given an observation using the ```predict(my_logit, newdata = ..., type = "response")``` function. Replace ```...``` with the observed values for which you would like to predict the outcome variable.



```r
# Prediction for one observation
predict(multiple_logit_model, newdata = data.frame(danceability_100 = 50,
    spotify_followers_m = 10, weeks_since_release = 1),
    type = "response")
```

```
##    1 
## 0.66
```

The prediction indicates that a song with danceability of $50$ from an artist with $10M$ Spotify followers has a $66%$ chance of being in the top-10, 1 week after its release. 

#### Perfect Prediction Logit

Perfect prediction occurs whenever a linear function of $X$ can perfectly separate the $1$s from the $0$s in the dependent variable. This is problematic when estimating a logit model as it will result in biased estimators (also check to p-values in the example!). R will return the following message if this occurs:

```glm.fit: fitted probabilities numerically 0 or 1 occurred```

Given this error, one should not use the output of the ```glm(...)``` function for the analysis. There are [various ways](https://stats.stackexchange.com/a/68917) to deal with this problem, one of which is to use Firth's bias-reduced penalized-likelihood logistic regression with the ```logistf(Y~X)``` function in the ```logistf``` package.  

##### Example

In this example data $Y = 0$ if $x_1 <0$ and $Y=1$ if $x_1>0$ and we thus have perfect prediction. As we can see the output of the regular logit model is not interpretable. The standard errors are huge compared to the coefficients and thus the p-values are $1$ despite $x_1$ being a predictor of $Y$. Thus, we turn to the penalized-likelihood version. This model correctly indicates that $x_1$ is in fact a predictor for $Y$ as the coefficient is significant.  


```r
Y <- c(0, 0, 0, 0, 1, 1, 1, 1)
X <- cbind(c(-1, -2, -3, -3, 5, 6, 10, 11), c(3, 2,
    -1, -1, 2, 4, 1, 0))

# Perfect prediction with regular logit
summary(glm(Y ~ X, family = binomial(link = "logit")))
```

```
## 
## Call:
## glm(formula = Y ~ X, family = binomial(link = "logit"))
## 
## Deviance Residuals: 
##            1             2             3             4             5  
## -0.000010220  -0.000001230  -0.000003368  -0.000003368   0.000010589  
##            6             7             8  
##  0.000006079   0.000000021   0.000000021  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)
## (Intercept)     -6.94  113859.81       0        1
## X1               7.36   15925.25       0        1
## X2              -3.12   43853.49       0        1
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
# Perfect prediction with penalized-likelihood
# logit
summary(logistf(Y ~ X))
```

```
## logistf(formula = Y ~ X)
## 
## Model fitted by Penalized ML
## Coefficients:
##               coef se(coef) lower 0.95 upper 0.95 Chisq     p method
## (Intercept) -0.989     1.21    -10.217        1.9  0.59 0.442      2
## X1           0.332     0.18      0.042        1.5  5.32 0.021      2
## X2           0.083     0.51     -2.179        3.4  0.02 0.888      2
## 
## Method: 1-Wald, 2-Profile penalized log-likelihood, 3-None
## 
## Likelihood ratio test=5.8 on 2 df, p=0.055, n=8
## Wald test = 3.7 on 2 df, p = 0.15
```


## Learning check {-}

**(LC6.1) What is a correlation coefficient?**

- [ ] It describes the difference in means of two variables
- [ ] It describes the causal relation between two variables
- [x] It is the standardized covariance
- [x] It describes the degree to which the variation in one variable is related to the variation in another variable
- [ ] None of the above 

**(LC6.2) Which line through a scatterplot produces the best fit in a linear regression model?**

- [ ] The line associated with the steepest slope parameter
- [x] The line that minimizes the sum of the squared deviations of the predicted values (regression line) from the observed values
- [x] The line that minimizes the sum of the squared residuals
- [ ] The line that maximizes the sum of the squared residuals
- [ ] None of the above 

**(LC6.3) Which of the following statements about the adjusted R-squared is TRUE?**

- [ ] It is always larger than the regular $R^{2}$
- [ ] It increases with every additional variable
- [x] It increases only with additional variables that add more explanatory power than pure chance
- [x] It contains a “penalty” for including unnecessary variables
- [ ] None of the above 

**(LC6.4) When do you use a logistic regression model?**

- [ ] When the dependent variable is continuous
- [ ] When the independent and dependent variables are binary
- [x] When the dependent variable is binary
- [ ] None of the above 

**(LC6.5) What is the correct way to implement a linear regression model in R? (x = independent variable, y = dependent variable)?**

- [x] `lm(y~x, data=data)`
- [ ] `lm(x~y + error, data=data)`
- [ ] `lm(x~y, data=data)`
- [ ] `lm(y~x + error, data=data)`
- [ ] None of the above 

**(LC6.6) Consider the output from a bivariate correlation below**

- [ ] …lower prices cause higher sales.
- [x] …lower prices are associated with higher sales and vice versa.
- [ ] None of the above


<img src="./images/cor_table11.png" width="75%" style="display: block; margin: auto;" />
**(LC6.7) When interpreting the statistical significance of a regression coefficient, the p-value…**

- [ ] …of 0.05 means that, if the null hypothesis is true (i.e., if the independent variable would NOT affect the outcome), the odds are 19 in 20 of getting a regression coefficient as large or larger than the estimated coefficient
- [x] …of 0.05 means that, if the null hypothesis is true (i.e., if the independent variable would NOT affect the outcome), the odds are 1 in 20 of getting a regression coefficient as large or larger than the estimated coefficient
- [x] ...of 0.05 means that the effect is statistically significant at the 5% level. 
- [x] ...does not tell you anything about the importance of the effect
- [x] …will get smaller, the larger the calculated value of the test statistic (t-value).

**(LC6.8) In which setting(s) would a regression coefficient be interpreted as "statistically significant"?**

- [x] When the absolute value of the calculated test-statistic (e.g., t-value) exceeds the critical value of the test statistic at your specified significance level (e.g., 0.05)
- [ ] When the test-statistic (e.g., t-value) is lower than the critical value of the test statistic at your specified significance level (e.g., 0.05)
- [x] When the confidence interval associated with the test does not contain zero
- [x] When the p-value is smaller than your specified significance level (e.g., 0.05)

**(LC6.9) When interpreting the significance of the coefficients in a regression model, what is the relationship between the test statistic (e.g., t-value) and the p-value?**

- [ ] The lower the absolute value of the test statistic, the lower the p-value
- [ ] The higher the absolute value of the test statistic, the higher the p-value
- [ ] There is no connection between the test statistic and the p-value
- [x] The higher the absolute value of the test statistic, the lower the p-value

**(LC6.10) What does the term overfitting refer to?**

- [ ] A regression model that fits to a specific data set so poorly, that it will not generalize to other samples
- [ ] A regression model that fits to a specific data set so well, that it will generalize to other samples particularly well
- [ ] A regression model that has too many predictor variables
- [x] A regression model that fits to a specific data set so well, that it will only predict well within the sample but not generalize to other samples

## References {-}

* Field, A., Miles J., & Field, Z. (2012): Discovering Statistics Using R. Sage Publications (**chapters 6, 7, 8**).
* James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013): An Introduction to Statistical Learning with Applications in R, Springer (**chapter 3**)
