---
output:
  html_document:
    toc: yes
  html_notebook: 
    default: TRUE
  pdf_document:
    toc: yes
---





## Comparing several means

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/9cGZcALfU5k" frameborder="0" allowfullscreen></iframe>
</div>
<br>

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/07-anova.R)
:::

### Introduction


In the previous section we learned how to compare two means using a t-test. The t-test has some limitations since it only lets you compare two means and you can only use it with one independent variable. However, often we would like to compare means from 3 or more groups. In addition, there may be instances in which you manipulate more than one independent variable. For these applications, ANOVA (<u>AN</u>alysis <u>O</u>f <u>VA</u>riance) can be used. Hence, to conduct ANOVA you need: 

* A metric dependent variable (i.e., measured using an interval or ratio scale)
* One or more non-metric (categorical) independent variables (also called factors) 

A **treatment** is a particular combination of factor levels, or categories. So-called **one-way ANOVA** is used when there is only one categorical variable (factor). In this case, a treatment is the same as a factor level. **N-way ANOVA** is used with two or more factors. Note that we are only going to talk about a single independent variable in the context of ANOVA on this website. If you have multiple independent variables please refer to the chapter on **Regression**.

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/cG0HAWqObJs" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Let's use an example to see how ANOVA works. Similar to the previous example, imagine that the music streaming service experiments with a recommender system and manipulates the intensity of personalized recommendations using three levels: 'low', 'medium', and 'high'. The service randomly assigns 100 users to each condition and records the listening times in hours in the following week. As always, we load and inspect the data first:


```r
hours_abc <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/hours_abc.dat", 
                                 sep = "\t", 
                                 header = TRUE) #read in data
hours_abc$group <- factor(hours_abc$group, levels = c("A","B","C"), labels = c("low", "medium","high")) #convert grouping variable to factor
str(hours_abc) #inspect data
```

```
## 'data.frame':	300 obs. of  3 variables:
##  $ hours: int  18 13 3 13 20 18 18 10 11 20 ...
##  $ group: Factor w/ 3 levels "low","medium",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ index: int  1 2 3 4 5 6 7 8 9 10 ...
```



The null hypothesis, typically, is that all means are equal (non-directional hypothesis). Hence, in our case:

$$H_0: \mu_1 = \mu_2 = \mu_3$$

The alternative hypothesis is simply that the means are not all equal, i.e., 

$$H_1: \textrm{Means are not all equal}$$

If you wanted to put this in mathematical notation, you could also write:

$$H_1: \exists {i,j}: {\mu_i \ne \mu_j} $$

To get a first impression if there are any differences in listening times across the experimental groups, we use the ```describeBy(...)``` function from the ```psych``` package:


```r
library(psych)
describeBy(hours_abc$hours, hours_abc$group) #inspect data
```

```
## 
##  Descriptive statistics by group 
## group: low
##    vars   n  mean   sd median trimmed  mad min max range  skew kurtosis   se
## X1    1 100 14.34 4.62     14   14.36 4.45   3  25    22 -0.03    -0.32 0.46
## ------------------------------------------------------------ 
## group: medium
##    vars   n mean   sd median trimmed  mad min max range skew kurtosis   se
## X1    1 100 24.7 5.81     25   24.79 5.93  12  42    30 0.05      0.2 0.58
## ------------------------------------------------------------ 
## group: high
##    vars   n  mean   sd median trimmed  mad min max range  skew kurtosis   se
## X1    1 100 34.99 6.42   34.5   35.02 6.67  17  50    33 -0.05    -0.23 0.64
```

In addition, you should visualize the data using appropriate plots. Appropriate plots in this case would be a plot of means, including the 95% confidence interval around the mean, or a boxplot. 


```r
#Plot of mean
library(Rmisc)
library(ggplot2)
mean_data <- summarySE(hours_abc, measurevar="hours", groupvars=c("group"))
ggplot(mean_data,aes(x = group, y = hours)) + 
  geom_bar(position=position_dodge(1), colour="black", fill = "#CCCCCC", stat="identity", width = 0.65) +
  geom_errorbar(position=position_dodge(.9), width=.15, aes(ymin=hours-ci, ymax=hours+ci)) +
  theme_bw() +
  labs(x = "Group", y = "Average number of hours", title = "Average number of hours by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-6-1.png" alt="Plot of means" width="672" />
<p class="caption">(\#fig:unnamed-chunk-6)Plot of means</p>
</div>


```r
ggplot(hours_abc,aes(x = group, y = hours)) + 
  geom_boxplot() +
  geom_jitter(colour="red", alpha = 0.1) +
  theme_bw() +
  labs(x = "Group", y = "Average number of hours", title = "Average number of hours by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-7-1.png" alt="Boxplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-7)Boxplot</p>
</div>

Note that ANOVA is an omnibus test, which means that we test for an overall difference between groups. Hence, the test will only tell you if the group means are different, but it won't tell you exactly which groups are different from another.

So why don’t we then just conduct a series of t-tests for all combinations of groups (i.e., "low" vs. "medium", "low" vs. "high", "medium" vs. "high")? The reason is that if we assume each test to be independent, then there is a 5% probability of falsely rejecting the null hypothesis (Type I error) for each test. In our case:

* "low" vs. "medium" (&alpha; = 0.05)
* "low" vs. "high" (&alpha; = 0.05)
* "medium" vs. "high" (&alpha; = 0.05)

This means that the overall probability of making a Type I error is 1-(0.95<sup>3</sup>) = 0.143, since the probability of no Type I error is 0.95 for each of the three tests. Consequently, the Type I error probability would be 14.3%, which is above the conventional standard of 5%. This is also known as the family-wise or experiment-wise error.

### Decomposing variance

The basic concept underlying ANOVA is the decomposition of the variance in the data. There are three variance components which we need to consider:

* We calculate how much variability there is overall between scores: <b>Total sum of squares (SS<sub>T</sub>)</b>
* We then calculate how much of this variability can be explained by the model we fit to the data (i.e., how much variability is due to the experimental manipulation): <b>Model sum of squares (SS<sub>M</sub>)</b>
* … and how much cannot be explained (i.e., how much variability is due to individual differences in performance): <b>Residual sum of squares (SS<sub>R</sub>)</b>

The following figure shows the different variance components using a generalized data matrix:

<p style="text-align:center;">
<img src="https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/sum_of_squares.JPG" alt="decomposing_variance"/>
</p>

The total variation is determined by the variation between the categories (due to our experimental manipulation) and the within-category variation that is due to extraneous factors (e.g., unobserved factors such as the promotion of artists on a social network):   

$$SS_T= SS_M+SS_R$$

To get a better feeling how this relates to our data set, we can look at the data in a slightly different way. Specifically, we can use the ```dcast(...)``` function from the ```reshape2``` package to convert the data to wide format: 


```r
library(reshape2)
dcast(hours_abc, index ~ group, value.var = "hours")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["index"],"name":[1],"type":["int"],"align":["right"]},{"label":["low"],"name":[2],"type":["int"],"align":["right"]},{"label":["medium"],"name":[3],"type":["int"],"align":["right"]},{"label":["high"],"name":[4],"type":["int"],"align":["right"]}],"data":[{"1":"1","2":"18","3":"26","4":"34"},{"1":"2","2":"13","3":"32","4":"34"},{"1":"3","2":"3","3":"29","4":"32"},{"1":"4","2":"13","3":"31","4":"25"},{"1":"5","2":"20","3":"13","4":"35"},{"1":"6","2":"18","3":"31","4":"20"},{"1":"7","2":"18","3":"26","4":"30"},{"1":"8","2":"10","3":"21","4":"33"},{"1":"9","2":"11","3":"31","4":"31"},{"1":"10","2":"20","3":"24","4":"42"},{"1":"11","2":"23","3":"13","4":"40"},{"1":"12","2":"14","3":"21","4":"44"},{"1":"13","2":"25","3":"31","4":"39"},{"1":"14","2":"16","3":"21","4":"33"},{"1":"15","2":"14","3":"28","4":"27"},{"1":"16","2":"14","3":"39","4":"48"},{"1":"17","2":"22","3":"22","4":"32"},{"1":"18","2":"23","3":"27","4":"35"},{"1":"19","2":"20","3":"28","4":"32"},{"1":"20","2":"15","3":"19","4":"35"},{"1":"21","2":"19","3":"20","4":"44"},{"1":"22","2":"16","3":"20","4":"32"},{"1":"23","2":"15","3":"26","4":"39"},{"1":"24","2":"15","3":"26","4":"35"},{"1":"25","2":"6","3":"12","4":"42"},{"1":"26","2":"12","3":"25","4":"29"},{"1":"27","2":"12","3":"23","4":"45"},{"1":"28","2":"15","3":"24","4":"27"},{"1":"29","2":"11","3":"24","4":"35"},{"1":"30","2":"10","3":"22","4":"38"},{"1":"31","2":"14","3":"16","4":"44"},{"1":"32","2":"5","3":"14","4":"39"},{"1":"33","2":"13","3":"29","4":"38"},{"1":"34","2":"12","3":"32","4":"44"},{"1":"35","2":"22","3":"29","4":"17"},{"1":"36","2":"16","3":"20","4":"38"},{"1":"37","2":"7","3":"32","4":"34"},{"1":"38","2":"20","3":"34","4":"31"},{"1":"39","2":"13","3":"27","4":"29"},{"1":"40","2":"21","3":"26","4":"46"},{"1":"41","2":"13","3":"20","4":"36"},{"1":"42","2":"13","3":"23","4":"32"},{"1":"43","2":"12","3":"42","4":"35"},{"1":"44","2":"5","3":"19","4":"30"},{"1":"45","2":"17","3":"26","4":"27"},{"1":"46","2":"18","3":"32","4":"44"},{"1":"47","2":"12","3":"29","4":"40"},{"1":"48","2":"8","3":"22","4":"31"},{"1":"49","2":"5","3":"25","4":"21"},{"1":"50","2":"18","3":"24","4":"29"},{"1":"51","2":"18","3":"28","4":"29"},{"1":"52","2":"19","3":"38","4":"32"},{"1":"53","2":"12","3":"26","4":"33"},{"1":"54","2":"11","3":"16","4":"28"},{"1":"55","2":"13","3":"21","4":"44"},{"1":"56","2":"16","3":"27","4":"37"},{"1":"57","2":"5","3":"24","4":"33"},{"1":"58","2":"17","3":"28","4":"45"},{"1":"59","2":"9","3":"28","4":"41"},{"1":"60","2":"8","3":"24","4":"33"},{"1":"61","2":"11","3":"32","4":"31"},{"1":"62","2":"12","3":"25","4":"42"},{"1":"63","2":"13","3":"18","4":"31"},{"1":"64","2":"10","3":"29","4":"25"},{"1":"65","2":"15","3":"25","4":"43"},{"1":"66","2":"16","3":"20","4":"38"},{"1":"67","2":"22","3":"18","4":"40"},{"1":"68","2":"10","3":"28","4":"36"},{"1":"69","2":"16","3":"27","4":"25"},{"1":"70","2":"18","3":"32","4":"30"},{"1":"71","2":"12","3":"22","4":"36"},{"1":"72","2":"22","3":"21","4":"46"},{"1":"73","2":"13","3":"28","4":"33"},{"1":"74","2":"14","3":"30","4":"39"},{"1":"75","2":"10","3":"30","4":"40"},{"1":"76","2":"9","3":"12","4":"31"},{"1":"77","2":"9","3":"21","4":"39"},{"1":"78","2":"11","3":"23","4":"43"},{"1":"79","2":"17","3":"22","4":"36"},{"1":"80","2":"17","3":"17","4":"37"},{"1":"81","2":"16","3":"29","4":"46"},{"1":"82","2":"14","3":"29","4":"28"},{"1":"83","2":"16","3":"22","4":"30"},{"1":"84","2":"14","3":"12","4":"31"},{"1":"85","2":"19","3":"23","4":"32"},{"1":"86","2":"24","3":"32","4":"31"},{"1":"87","2":"17","3":"21","4":"29"},{"1":"88","2":"12","3":"18","4":"50"},{"1":"89","2":"12","3":"27","4":"37"},{"1":"90","2":"17","3":"31","4":"32"},{"1":"91","2":"14","3":"23","4":"41"},{"1":"92","2":"20","3":"21","4":"36"},{"1":"93","2":"10","3":"27","4":"33"},{"1":"94","2":"13","3":"17","4":"40"},{"1":"95","2":"12","3":"21","4":"25"},{"1":"96","2":"20","3":"22","4":"38"},{"1":"97","2":"9","3":"25","4":"31"},{"1":"98","2":"16","3":"28","4":"28"},{"1":"99","2":"12","3":"27","4":"39"},{"1":"100","2":"17","3":"19","4":"34"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

In this example, X<sub>1</sub> from the generalized data matrix above would refer to the factor level "low", X<sub>2</sub> to the level "medium", and X<sub>3</sub> to the level "high". Y<sub>11</sub> refers to the first data point in the first row (i.e., "13"), Y<sub>12</sub> to the second data point in the first row (i.e., "21"), etc.. The grand mean ($\overline{Y}$) and the category means ($\overline{Y}_c$) can be easily computed: 


```r
mean(hours_abc$hours) #grand mean
```

```
## [1] 24.67667
```

```r
by(hours_abc$hours, hours_abc$group, mean) #category mean
```

```
## hours_abc$group: low
## [1] 14.34
## ------------------------------------------------------------ 
## hours_abc$group: medium
## [1] 24.7
## ------------------------------------------------------------ 
## hours_abc$group: high
## [1] 34.99
```

To see how each variance component can be derived, let's look at the data again. The following graph shows the individual observations by experimental group:

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-10-1.png" alt="Sum of Squares" width="672" />
<p class="caption">(\#fig:unnamed-chunk-10)Sum of Squares</p>
</div>

#### Total sum of squares

To compute the total variation in the data, we consider the difference between each observation and the grand mean. The grand mean is the mean over all observations in the data set. The vertical lines in the following plot measure how far each observation is away from the grand mean:

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-11-1.png" alt="Total Sum of Squares" width="672" />
<p class="caption">(\#fig:unnamed-chunk-11)Total Sum of Squares</p>
</div>

The formal representation of the total sum of squares (SS<sub>T</sub>) is:

$$
SS_T= \sum_{i=1}^{N} (Y_i-\bar{Y})^2
$$

This means that we need to subtract the grand mean from each individual data point, square the difference, and sum up over all the squared differences. Thus, in our example, the total sum of squares can be calculated as:

$$ 
\begin{align}
SS_T =&(13−24.67)^2 + (14−24.67)^2 + … + (2−24.67)^2\\
      &+(21−24.67)^2 + (18-24.67)^2 + … + (17−24.67)^2\\
      &+(30−24.67)^2 + (37−24.67)^2 + … + (28−24.67)^2\\ 
      &=30855.64
\end{align}
$$

You could also compute this in R using:



```r
SST <- sum((hours_abc$hours - mean(hours_abc$hours))^2)
SST
```

```
## [1] 30855.64
```

For the subsequent analyses, it is important to understand the concept behind the <b>degrees of freedom</b> (df). Remember that in order to estimate a population value from a sample, we need to hold something in the population constant. In ANOVA, the df are generally one less than the number of values used to calculate the SS. For example, when we estimate the population mean from a sample, we assume that the sample mean is equal to the population mean. Then, in order to estimate the population mean from the sample, all but one scores are free to vary and the remaining score needs to be the value that keeps the population mean constant. Thus, the degrees of freedom of an estimate can also be thought of as the number of independent pieces of information that went into calculating the estimate. In our example, we used all 300 observations to calculate the sum of square, so the total degrees of freedom (df<sub>T</sub>) are:

\begin{equation} 
\begin{split}
df_T = N-1=300-1=299
\end{split}
(\#eq:dfT)
\end{equation} 

::: {.infobox_orange .hint data-latex="{hint}"}
Why do we subtract 1 from the number of items when computing the **degrees of freedom**? As mentioned above, the degrees of freedom refer to the number of values that are free to vary in a data set. To understand what this means, imagine that we try to estimate the mean hours of music listening in a population and that mean is 20 hours. We could take different samples from the population and we assume that the sample mean is equal to the population mean. Imagine, we only take three small samples of 3 students each: i) 19, 20, 21, ii) 18, 20, 22, iii) 15, 20, 25. Once you have chosen the first two values in each set, the third item cannot be chosen freely (i.e., it is fixed) because it needs to be the value that gets you to the population mean. Hence, only the first two values are 'free to vary'. You can select 19 + 20 or 15 + 25, but once you have chosen the first two values, you must choose a particular value that will give you the population mean you are looking for (i.e., 20 hours). In this case, the degrees of freedom for each set of three numbers is two.
:::

#### Model sum of squares

Now we know that there are 30855.64 units of total variation in our data. Next, we compute how much of the total variation can be explained by the differences between groups (i.e., our experimental manipulation). To compute the explained variation in the data, we consider the difference between the values predicted by our model for each observation (i.e., the group mean) and the grand mean. The group mean refers to the mean value within the experimental group. The vertical lines in the following plot measure how far the predicted value for each observation (i.e., the group mean) is away from the grand mean:

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-13-1.png" alt="Model Sum of Squares" width="672" />
<p class="caption">(\#fig:unnamed-chunk-13)Model Sum of Squares</p>
</div>

The formal representation of the model sum of squares (SS<sub>M</sub>) is:

$$
SS_M= \sum_{j=1}^{c} n_j(\bar{Y}_j-\bar{Y})^2
$$

where c denotes the number of categories (experimental groups). This means that we need to subtract the grand mean from each group mean, square the difference, and sum up over all the squared differences. Thus, in our example, the model sum of squares can be calculated as:

$$ 
\begin{align}
SS_M &= 100*(15.47−24.67)^2 + 100*(24.88−24.67)^2 + 100*(33.66−24.67)^2 \\
     &= 21321.21
\end{align}
$$

You could also compute this manually in R using:


```r
SSM <- sum(100*(by(hours_abc$hours, hours_abc$group, mean) - mean(hours_abc$hours))^2)
SSM
```

```
## [1] 21321.21
```

In this case, we used the three group means to calculate the sum of squares, so the model degrees of freedom (df<sub>M</sub>) are:

$$
df_M= c-1=3-1=2
$$

#### Residual sum of squares

Lastly, we calculate the amount of variation that cannot be explained by our model. In ANOVA, this is the sum of squared distances between what the model predicts for each data point (i.e., the group means) and the observed values. In other words, this refers to the amount of variation that is caused by extraneous factors, such as differences between product characteristics of the products in the different experimental groups. The vertical lines in the following plot measure how far each observation is away from the group mean:

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-15-1.png" alt="Residual Sum of Squares" width="672" />
<p class="caption">(\#fig:unnamed-chunk-15)Residual Sum of Squares</p>
</div>

The formal representation of the residual sum of squares (SS<sub>R</sub>) is:

$$
SS_R= \sum_{j=1}^{c} \sum_{i=1}^{n} ({Y}_{ij}-\bar{Y}_{j})^2
$$

This means that we need to subtract the group mean from each individual observation, square the difference, and sum up over all the squared differences. Thus, in our example, the model sum of squares can be calculated as:

$$ 
\begin{align}
SS_R =& (13−14.34)^2 + (14−14.34)^2 + … + (2−14.34)^2 \\
     +&(21−24.7)^2 + (18−24.7)^2 + … + (17−24.7)^2 \\
     +& (30−34.99)^2 + (37−34.99)^2 + … + (28−34.99)^2 \\
     =&  9534.43
\end{align}
$$

You could also compute this in R using:


```r
SSR <- sum((hours_abc$hours - rep(by(hours_abc$hours, hours_abc$group, mean), each = 100))^2)
SSR
```

```
## [1] 9534.43
```

In this case, we used the 10 values for each of the SS for each group, so the residual degrees of freedom (df<sub>R</sub>) are:

$$
\begin{align}
df_R=& (n_1-1)+(n_2-1)+(n_3-1) \\
    =&(100-1)+(100-1)+(100-1)=297
\end{align}
$$

#### Effect strength

Once you have computed the different sum of squares, you can investigate the effect strength. $\eta^2$ is a measure of the variation in Y that is explained by X:

$$
\eta^2= \frac{SS_M}{SS_T}=\frac{21321.21}{30855.64}=0.69
$$

To compute this in R:


```r
eta <- SSM/SST
eta
```

```
## [1] 0.6909988
```

The statistic can only take values between 0 and 1. It is equal to 0 when all the category means are equal, indicating that X has no effect on Y. In contrast, it has a value of 1 when there is no variability within each category of X but there is some variability between categories. You can think of it as the equivalent to the R-squared statistic in regression model since it also represents a measure of the share of explained variance. 

#### Test of significance

How can we determine whether the effect of X on Y is significant?

* First, we calculate the fit of the most basic model (i.e., the grand mean)
* Then, we calculate the fit of the “best” model (i.e., the group means)
* A good model should fit the data significantly better than the basic model
* The F-statistic, or F-ratio, compares the amount of systematic variance in the data to the amount of unsystematic variance

The F-statistic uses the ratio of mean square related to X (explained variation) and the mean square related to the error (unexplained variation):

$$\frac{SS_M}{SS_R}$$

However, since these are summed values, their magnitude is influenced by the number of scores that were summed. For example, to calculate SS<sub>M</sub> we only used the sum of 3 values (the group means), while we used 300 values to calculate SS<sub>T</sub> and SS<sub>R</sub>, respectively. Thus, we calculate the average sum of squares (“mean square”) to compare the average amount of systematic vs. unsystematic variation by dividing the SS values by the degrees of freedom associated with the respective statistic.

Mean square due to X:

$$
MS_M= \frac{SS_M}{df_M}=\frac{SS_M}{c-1}=\frac{21321.21}{(3-1)}
$$

Mean square due to error:

$$
MS_R= \frac{SS_R}{df_R}=\frac{SS_R}{N-c}=\frac{9534.43}{(300-3)}
$$

Now, we compare the amount of variability explained by the model (experiment), to the error in the model (variation due to extraneous variables). If the model explains more variability than it can’t explain, then the experimental manipulation has had a significant effect on the outcome (DV). The F-ratio can be derived as follows:

$$
F= \frac{MS_M}{MS_R}=\frac{\frac{SS_M}{c-1}}{\frac{SS_R}{N-c}}=\frac{\frac{21321.21}{(3-1)}}{\frac{9534.43}{(300-3)}}=332.08
$$

You can easily compute this in R:


```r
f_ratio <- (SSM/2)/(SSR/297)
f_ratio
```

```
## [1] 332.0806
```

Similar to the t-test, the outcome of the significance test will be one of the following:

* If the null hypothesis of equal category means is not rejected, then the independent variable does not have a significant effect on the dependent variable
* If the null hypothesis is rejected, then the effect of the independent variable is significant  

To decide which one it is, we proceed as with the t-test. That is, we calculate the test statistic and compare it to the critical value for a given level of confidence. If the calculated test statistic is larger than the critical value, we can reject the null hypothesis of equal group means and conclude that the independent variable has a significant effect on our outcome. In this case, however, the test statistic follows a F distribution (instead of the t-distribution) with (m = c – 1) and (n = N – c) degrees of freedom. This means that the shape of the F-distribution depends on the degrees of freedom. In this case, the shape depends on the degrees of freedom associated with the numerator and denominator used to compute the F-ratio. The following figure shows the shape of the F-distribution for different degrees of freedom:  



![The F distribution](./fdistributions.png)

For 2 and 297 degrees of freedom, the critical value of F is 3.026 for &alpha;=0.05. As usual, you can either look up these values in a table or use the appropriate function in R:


```r
f_crit <- qf(.95, df1 = 2, df2 = 297) #critical value
f_crit 
```

```
## [1] 3.026153
```

```r
f_ratio > f_crit #test if calculated test statistic is larger than critical value
```

```
## [1] TRUE
```

The output tells us that the calculated test statistic exceeds the critical value. We can also show the test result visually:



![Visual depiction of the test result](./ftest.png)

Thus, we conclude that because F<sub>CAL</sub> = 332.08 > F<sub>CR</sub> = 3.03, H<sub>0</sub> is rejected!

Now we can interpret our findings as follows: one or more of the differences between means are statistically significant.

::: {.infobox_red .caution data-latex="{caution}"}
Remember: The ANOVA tests for an overall difference in means between the groups. It doesn’t tell us where the differences between groups lie, e.g., whether group "low" is different from "medium" or "high" is different from "medium" or "high" is different from "low". To find out which group means exactly differ, we need to use post-hoc procedures, which are described below. However, when the ANOVA tells you that the there is no differences between the means, then you also shouldn't proceed to conduct post-hoc tests. In other words, you should only proceed to conduct post-hoc tests when you found a significant overall effect in your ANOVA.  
:::

Finally, you should report your findings in an appropriate way. You could do this by saying: There was a significant effect of playlists and personalized recommendations on listening times, F(2,297) = 332.08, p < 0.05, $\eta^2$ = 0.69. 

As usual, you don't have to compute these statistics manually! Luckily, there is a function for ANOVA in R, which does the above calculations for you as we will see in the next section.

### One-way ANOVA

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/ElghkF6rwBQ" frameborder="0" allowfullscreen></iframe>
</div>
<br>

#### Basic ANOVA

As already indicated, one-way ANOVA is used when there is only one categorical variable (factor). Before conducting ANOVA, you need to check if the assumptions of the test are fulfilled. The assumptions of ANOVA are discussed in the following sections.

##### Independence of observations {-}

The observations in the groups should be independent. Because we randomly assigned the listeners to the experimental conditions, this assumption can be assumed to be met. 

##### Distributional assumptions {-}

ANOVA is relatively immune to violations to the normality assumption when sample sizes are large due to the Central Limit Theorem. However, if your sample is small (i.e., n < 30 per group) you may nevertheless want to check the normality of your data, e.g., by using the Shapiro-Wilk test or QQ-Plot. In our example, we have 100 observations in each group which is plenty but let's create another example with only 10 observations in each group. In the latter case we cannot rely on the Central Limit Theorem and we should test the normality of our data. This can be done using the Shapiro-Wilk Test, which has the Null Hypothesis that the data is normally distributed. Hence, an insignificant test results means that the data can be assumed to be approximately normally distributed:


```r
set.seed(321)
hours_fewobs <- data.frame(hours = c(rnorm(10, 20, 5), rnorm(10, 40, 5), rnorm(10, 60, 5)),
                          group =  c(rep('low', 10), rep('medium', 10), rep('high', 10)))
by(hours_fewobs$hours, hours_fewobs$group, shapiro.test)
```

```
## hours_fewobs$group: high
## 
## 	Shapiro-Wilk normality test
## 
## data:  dd[x, ]
## W = 0.9595, p-value = 0.7801
## 
## ------------------------------------------------------------ 
## hours_fewobs$group: low
## 
## 	Shapiro-Wilk normality test
## 
## data:  dd[x, ]
## W = 0.91625, p-value = 0.3267
## 
## ------------------------------------------------------------ 
## hours_fewobs$group: medium
## 
## 	Shapiro-Wilk normality test
## 
## data:  dd[x, ]
## W = 0.91486, p-value = 0.3161
```

Since the test result is insignificant for all groups, we can conclude that the data approximately follow a normal distribution. 

We could also test the distributional assumptions visually using a Q-Q plot (i.e., quantile-quantile plot). This plot can be used to assess if a set of data plausibly came from some theoretical distribution such as the Normal distribution. Since this is just a visual check, it is somewhat subjective. But it may help us to judge if our assumption is plausible, and if not, which data points contribute to the violation. A Q-Q plot is a scatterplot created by plotting two sets of quantiles against one another. If both sets of quantiles came from the same distribution, we should see the points forming a line that’s roughly straight. In other words, Q-Q plots take your sample data, sort it in ascending order, and then plot them versus quantiles calculated from a theoretical distribution. Quantiles are often referred to as “percentiles” and refer to the points in your data below which a certain proportion of your data fall. Recall, for example, the standard Normal distribution with a mean of 0 and a standard deviation of 1. Since the 50th percentile (or 0.5 quantile) is 0, half the data lie below 0. The 95th percentile (or 0.95 quantile), is about 1.64, which means that 95 percent of the data lie below 1.64. The 97.5th quantile is about 1.96, which means that 97.5% of the data lie below 1.96. In the Q-Q plot, the number of quantiles is selected to match the size of your sample data.

To create the Q-Q plot for the normal distribution, you may use the ```qqnorm()``` function, which takes the data to be tested as an argument. Using the ```qqline()``` function subsequently on the data creates the line on which the data points should fall based on the theoretical quantiles. If the individual data points deviate a lot from this line, it means that the data is not likely to follow a normal distribution. 


```r
qqnorm(hours_fewobs[hours_fewobs$group=="low",]$hours) 
qqline(hours_fewobs[hours_fewobs$group=="low",]$hours)
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-23-1.png" alt="Q-Q plot 1" width="672" />
<p class="caption">(\#fig:unnamed-chunk-23-1)Q-Q plot 1</p>
</div>

```r
qqnorm(hours_fewobs[hours_fewobs$group=="medium",]$hours) 
qqline(hours_fewobs[hours_fewobs$group=="medium",]$hours)
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-23-2.png" alt="Q-Q plot 2" width="672" />
<p class="caption">(\#fig:unnamed-chunk-23-2)Q-Q plot 2</p>
</div>

```r
qqnorm(hours_fewobs[hours_fewobs$group=="high",]$hours) 
qqline(hours_fewobs[hours_fewobs$group=="high",]$hours)
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-23-3.png" alt="Q-Q plot 3" width="672" />
<p class="caption">(\#fig:unnamed-chunk-23-3)Q-Q plot 3</p>
</div>

The Q-Q plots suggest an approximately Normal distribution. If the assumption had been violated, you might consider transforming your data or resort to a non-parametric test. 

##### Homogeneity of variance {-}

Let's return to our original data set with 100 observations in each group for the rest of the analysis.

You can test the homogeneity of variances in R using Levene's test:


```r
library(car)
leveneTest(hours ~ group, data = hours_abc, center = mean)
```

```
## Levene's Test for Homogeneity of Variance (center = mean)
##        Df F value   Pr(>F)   
## group   2  4.9678 0.007548 **
##       297                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The null hypothesis of the test is that the group variances are equal. Thus, if the test result is significant it means that the variances are not equal. If we cannot reject the null hypothesis (i.e., the group variances are not significantly different), we can proceed with the ANOVA as follows: 


```r
aov <- aov(hours ~ group, data = hours_abc)
summary(aov)
```

```
##              Df Sum Sq Mean Sq F value Pr(>F)    
## group         2  21321   10661   332.1 <2e-16 ***
## Residuals   297   9534      32                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

You can see that the p-value is smaller than 0.05. This means that, if there really was no difference between the population means (i.e., the Null hypothesis was true), the probability of the observed differences (or larger differences) is less than 5%.

To compute &eta;<sup>2</sup> from the output, we can extract the relevant sum of squares as follows


```r
summary(aov)[[1]]$'Sum Sq'[1]/(summary(aov)[[1]]$'Sum Sq'[1] + summary(aov)[[1]]$'Sum Sq'[2])
```

```
## [1] 0.6909988
```

You can see that the results match the results from our manual computation above ($\eta^2 =$ 0.69). 

The ```aov()``` function also automatically generates some plots that you can use to judge if the model assumptions are met. We will inspect two of the plots here.

We will use the first plot to inspect if the residual variances are equal across the experimental groups:


```r
plot(aov,1)
```

<img src="08-Anova_files/figure-html/unnamed-chunk-27-1.png" width="672" />

Generally, the residual variance (i.e., the range of values on the y-axis) should be the same for different levels of our independent variable. The plot shows, that there are some slight differences. Notably, the range of residuals is higher in group "medium" than in group "high". However, the differences are not that large and since the Levene's test could not reject the Null of equal variances, we conclude that the variances are similar enough in this case. 

The second plot can be used to test the assumption that the residuals are approximately normally distributed. We use a Q-Q plot to test this assumption:


```r
plot(aov,2)
```

<img src="08-Anova_files/figure-html/unnamed-chunk-28-1.png" width="672" />

The plot suggests that, the residuals are approximately normally distributed. We could also test this by extracting the residuals from the anova output using the ```resid()``` function and using the Shapiro-Wilk test: 


```r
shapiro.test(resid(aov))
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  resid(aov)
## W = 0.99723, p-value = 0.8925
```

Confirming the impression from the Q-Q plot, we cannot reject the Null that the residuals are approximately normally distributed. 

Note that if Levene's test would have been significant (i.e., variances are not equal), we would have needed to either resort to non-parametric tests (see below), or compute the Welch's F-ratio instead, which is correcting for unequal variances between the groups:


```r
#oneway.test(hours ~ group, hours_abc)
```

You can see that the results are fairly similar, since the variances turned out to be fairly equal across groups.

#### Post-hoc tests

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/wNwKx0TZ7fQ" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Provided that significant differences were detected by the overall ANOVA you can find out which group means are different using post-hoc procedures. Post-hoc procedures are designed to conduct pairwise comparisons of all different combinations of the treatment groups by correcting the level of significance for each test such that the overall Type I error rate (&alpha;) across all comparisons remains at 0.05.

In other words, we rejected H<sub>0</sub>: &mu;<sub>low</sub>= &mu;<sub>medium</sub>= &mu;<sub>high</sub>, and now we would like to test:

Test1: 

$$H_0: \mu_{low} = \mu_{medium}$$

Test2: 

$$H_0: \mu_{low} = \mu_{high}$$

Test3: 

$$H_0: \mu_{medium} = \mu_{high}$$

There are several post-hoc procedures available to choose from. In this tutorial, we will cover Bonferroni and Tukey's HSD ("honest significant differences"). Both tests control for family-wise error. Bonferroni tends to have more power when the number of comparisons is small, whereas Tukey’s HSDs is better when testing large numbers of means. 

##### Bonferroni

One of the most popular (and easiest) methods to correct for the family-wise error rate is to conduct the individual t-tests and divide &alpha; by the number of comparisons („k“):

$$
p_{CR}= \frac{\alpha}{k}
$$

In our example with three groups:

$$p_{CR}= \frac{0.05}{3}=0.017$$

Thus, the “corrected” critical p-value is now 0.017 instead of 0.05 (i.e., the critical t value is higher). This means that the test is more conservative to account for the family-wise error. Remember that, to reject the null hypothesis at a 5%  significance level, we usually check if the p-value in our analysis is smaller than 0.05. The corrected p-value above requires us to obtain a p-value smaller than 0.017 in order to reject the null hypothesis at the 5% significance level, which means that the critical value of the test statistic is higher. You can implement the Bonferroni procedure in R using:


```r
bonferroni <- pairwise.t.test(hours_abc$hours, hours_abc$group, data = hours_abc, p.adjust.method = "bonferroni")
bonferroni
```

```
## 
## 	Pairwise comparisons using t tests with pooled SD 
## 
## data:  hours_abc$hours and hours_abc$group 
## 
##        low    medium
## medium <2e-16 -     
## high   <2e-16 <2e-16
## 
## P value adjustment method: bonferroni
```

In the output, you will get the corrected p-values for the individual tests. This mean, to reject the null hypothesis, we require the p-value to be smaller than 0.05 again, since the reported p-values are already corrected for the family-wise error. In our example, we can reject H<sub>0</sub> of equal means for all three tests, since p < 0.05 for all combinations of groups.

Note the difference between the results from the post-hoc test compared to individual t-tests. For example, when we test the "medium" vs. "high" groups, the result from a t-test would be: 


```r
data_subset <- subset(hours_abc, group != "low")
ttest <- t.test(hours ~ group, data = data_subset, var.equal= TRUE)
ttest
```

```
## 
## 	Two Sample t-test
## 
## data:  hours by group
## t = -11.884, df = 198, p-value < 2.2e-16
## alternative hypothesis: true difference in means between group medium and group high is not equal to 0
## 95 percent confidence interval:
##  -11.997471  -8.582529
## sample estimates:
## mean in group medium   mean in group high 
##                24.70                34.99
```

Usually the p-value is lower in the t-test, reflecting the fact that the family-wise error is not corrected (i.e., the test is less conservative). In this case the p-value is extremely small in both cases and thus indistinguishable. 

##### Tukey's HSD

Tukey's HSD also compares all possible pairs of means (two-by-two combinations; i.e., like a t-test, except that it corrects for family-wise error rate).

Test statistic:

\begin{equation} 
\begin{split}
HSD= q\sqrt{\frac{MS_R}{n_c}}
\end{split}
(\#eq:tukey)
\end{equation} 

where:

* q = value from studentized range table (see e.g., <a href="http://www.real-statistics.com/statistics-tables/studentized-range-q-table/" target="_blank">here</a>)
* MS<sub>R</sub> = Mean Square Error from ANOVA
* n<sub>c</sub> = number of observations per group
* Decision: Reject H<sub>0</sub> if

$$|\bar{Y}_i-\bar{Y}_j | > HSD$$

The value from the studentized range table can be obtained using the ```qtukey()``` function.


```r
q <- qtukey(0.95, nm = 3, df = 297)
q
```

```
## [1] 3.331215
```

Hence:

$$HSD= 3.33\sqrt{\frac{33.99}{100}}=1.94$$

Or, in R:


```r
hsd <- q * sqrt(summary(aov)[[1]]$'Mean Sq'[2]/100)
hsd
```

```
## [1] 1.887434
```

Since all mean differences between groups are larger than 1.906, we can reject the null hypothesis for all individual tests, confirming the results from the Bonferroni test. To compute Tukey's HSD, we can use the appropriate function from the ```multcomp``` package.


```r
library(multcomp)
aov$model$group <- as.factor(aov$model$group)
tukeys <- glht(aov, linfct = mcp(group = "Tukey"))
summary(tukeys)
```

```
## 
## 	 Simultaneous Tests for General Linear Hypotheses
## 
## Multiple Comparisons of Means: Tukey Contrasts
## 
## 
## Fit: aov(formula = hours ~ group, data = hours_abc)
## 
## Linear Hypotheses:
##                    Estimate Std. Error t value Pr(>|t|)    
## medium - low == 0   10.3600     0.8013   12.93   <2e-16 ***
## high - low == 0     20.6500     0.8013   25.77   <2e-16 ***
## high - medium == 0  10.2900     0.8013   12.84   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## (Adjusted p values reported -- single-step method)
```

```r
confint(tukeys)
```

```
## 
## 	 Simultaneous Confidence Intervals
## 
## Multiple Comparisons of Means: Tukey Contrasts
## 
## 
## Fit: aov(formula = hours ~ group, data = hours_abc)
## 
## Quantile = 2.3558
## 95% family-wise confidence level
##  
## 
## Linear Hypotheses:
##                    Estimate lwr     upr    
## medium - low == 0  10.3600   8.4723 12.2477
## high - low == 0    20.6500  18.7623 22.5377
## high - medium == 0 10.2900   8.4023 12.1777
```

We may also plot the result for the mean differences incl. their confidence intervals: 


```r
plot(tukeys)
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-36-1.png" alt="Tukey's HSD" width="672" />
<p class="caption">(\#fig:unnamed-chunk-36)Tukey's HSD</p>
</div>

You can see that the CIs do not cross zero, which means that the true difference between group means is unlikely zero. It is sufficient to report the results in the way described above. However, you could also manually compute the differences between the groups and their confidence interval as follows: 


```r
mean1 <- mean(hours_abc[hours_abc$group=="low","hours"]) #mean group "low"
mean1
```

```
## [1] 14.34
```

```r
mean2 <- mean(hours_abc[hours_abc$group=="medium","hours"]) #mean group "medium"
mean2
```

```
## [1] 24.7
```

```r
mean3 <- mean(hours_abc[hours_abc$group=="high","hours"]) #mean group "high"
mean3
```

```
## [1] 34.99
```

```r
#CI high vs. medium
mean_diff_high_med <- mean2-mean1
mean_diff_high_med
```

```
## [1] 10.36
```

```r
ci_med_high_lower <- mean_diff_high_med-hsd
ci_med_high_upper <- mean_diff_high_med+hsd
ci_med_high_lower
```

```
## [1] 8.472566
```

```r
ci_med_high_upper
```

```
## [1] 12.24743
```

```r
#CI high vs.low
mean_diff_high_low <- mean3-mean1
mean_diff_high_low
```

```
## [1] 20.65
```

```r
ci_low_high_lower <- mean_diff_high_low-hsd
ci_low_high_upper <- mean_diff_high_low+hsd
ci_low_high_lower
```

```
## [1] 18.76257
```

```r
ci_low_high_upper
```

```
## [1] 22.53743
```

```r
#CI medium vs.low
mean_diff_med_low <- mean3-mean2
mean_diff_med_low
```

```
## [1] 10.29
```

```r
ci_low_med_lower <- mean_diff_med_low-hsd
ci_low_med_upper <- mean_diff_med_low+hsd
ci_low_med_lower
```

```
## [1] 8.402566
```

```r
ci_low_med_upper
```

```
## [1] 12.17743
```
The results of a post-hoc test can be reported as follows:  

The post-hoc tests based on Bonferroni and Tukey’s HSD revealed that users listened to music significantly more when the intensity of personalized recommendations was increased. This is true for "low" vs. "medium" intensity, as well as for "low" vs. "high" and "medium" vs. "high" intensity. 

As with the t-test, you could also use the functions contained in the `ggstatsplot` package to combine a visual depiction of the data with the results of statistical tests. In the case of an ANOVA, the output would also include the pairwise comparisons. 


```r
library(ggstatsplot)
ggbetweenstats(
  data = hours_abc,
  x = group,
  y = hours,
  plot.type = "box",
  pairwise.comparisons = TRUE,
  pairwise.annotation = "p.value",
  p.adjust.method = "bonferroni",
  effsize.type = "eta",
  var.equal = FALSE,
  mean.plotting = TRUE, # whether mean for each group is to be displayed
  mean.ci = TRUE, # whether to display confidence interval for means
  mean.label.size = 2.5, # size of the label for mean
  type = "parametric", # which type of test is to be run
  k = 3, # number of decimal places for statistical results
  outlier.label.color = "darkgreen", # changing the color for the text label
  title = "Comparison of listening times between groups",
  xlab = "Experimental group", # label for the x-axis variable
  ylab = "Listening time", # label for the y-axis variable
  messages = FALSE,
  bf.message = FALSE
)
```

<div class="figure" style="text-align: center">
<img src="08-Anova_files/figure-html/unnamed-chunk-38-1.png" alt="ANOVA using ggstatsplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-38)ANOVA using ggstatsplot</p>
</div>


