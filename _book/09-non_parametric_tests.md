---
output:
  html_document:
    toc: yes
  html_notebook: default
  pdf_document:
    toc: yes
---


```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```
## 
## Attaching package: 'ggplot2'
```

```
## The following objects are masked from 'package:psych':
## 
##     %+%, alpha
```

```
## Loading required package: lattice
```

```
## Loading required package: survival
```

```
## Loading required package: Formula
```

```
## 
## Attaching package: 'Hmisc'
```

```
## The following object is masked from 'package:psych':
## 
##     describe
```

```
## The following objects are masked from 'package:dplyr':
## 
##     src, summarize
```

```
## The following objects are masked from 'package:base':
## 
##     format.pval, units
```

## Non-parametric tests

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/O1Xpedqwr3o" frameborder="0" allowfullscreen></iframe>
</div>
<br>

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/08-non_parametric.R)
:::

**Non-Parametric tests** do not require the sampling distribution to be normally distributed (a.k.a. "assumption free tests"). These tests may be used when the variable of interest is measured on an ordinal scale or when the parametric assumptions do not hold. They often rely on ranking the data instead of analyzing the actual scores. By ranking the data, information on the magnitude of differences is lost. Thus, parametric tests are more powerful if the sampling distribution is normally distributed and you have a continuous variable.

When should you use non-parametric tests?

* When your DV is measured on an ordinal scale
* When your data is better represented by the median (e.g., there are outliers that you can’t remove)
* When the assumptions of parametric tests are not met (e.g., normally distributed sampling distribution)
* You have a very small sample size (i.e., the central limit theorem does not apply)

In these cases, you should resort to the non-parametric equivalent of the tests we have discussed so far, as summarized in the following table.  

Parametric test | Non-parametric equivalent 
------------------------------ | ------------------------------  
Independent-means t-test | Mann-Whitney U Test 
Dependent-means t-test  | Wilcoxon signed-rank test
ANOVA |  Kruskal-Wallis test

These non-parametric tests will be briefly discussed in the following sections.  

### Mann-Whitney U Test (a.k.a. Wilcoxon rank-sum test)

The Mann-Whitney U test is a non-parametric test of differences between groups (i.e., it is the non-parametric equivalent of the independent-means t-test). In contrast to the independent-means t-test it only requires ordinally scaled data and relies on weaker assumptions. Thus it is often useful if the assumptions of the t-test are violated, especially if the data is not on a continuous scale. The following assumptions must be fulfilled for the test to be applicable:

* The dependent variable is at least ordinally scaled (i.e. a ranking between values can be established)
* The independent variable has only two levels
* A between-subjects design is used (i.e., the subjects are not matched across conditions)

Intuitively, the test compares the frequency of low and high ranks between groups. Under the null hypothesis, the amount of high and low ranks should be roughly equal in the two groups. This is achieved through comparing the expected sum of ranks to the actual sum of ranks. 

As an example, we will be using data obtained from a field experiment with random assignment. In a music download store, new releases were randomly assigned to an experimental group and sold at a reduced price (i.e., 7.95€), or a control group and sold at the standard price (9.95€). A representative sample of 102 new releases were sampled and these albums were randomly assigned to the experimental groups (i.e., 51 albums per group). The sales were tracked over one day. 

Let's load and investigate the data first:    


```r
library(psych)
library(ggplot2)
rm(music_sales)
music_sales <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_experiment.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
music_sales$group <- factor(music_sales$group, levels = c(1:2), labels = c("low_price", "high_price")) #convert grouping variable to factor
str(music_sales) #inspect data
```

```
## 'data.frame':	102 obs. of  3 variables:
##  $ product_id: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ unit_sales: int  6 27 30 24 21 11 18 15 18 13 ...
##  $ group     : Factor w/ 2 levels "low_price","high_price": 1 1 1 1 1 1 1 1 1 1 ...
```

```r
head(music_sales) #inspect data
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["product_id"],"name":[1],"type":["int"],"align":["right"]},{"label":["unit_sales"],"name":[2],"type":["int"],"align":["right"]},{"label":["group"],"name":[3],"type":["fct"],"align":["left"]}],"data":[{"1":"1","2":"6","3":"low_price"},{"1":"2","2":"27","3":"low_price"},{"1":"3","2":"30","3":"low_price"},{"1":"4","2":"24","3":"low_price"},{"1":"5","2":"21","3":"low_price"},{"1":"6","2":"11","3":"low_price"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Inspect descriptives (overall and by group).


```r
psych::describe(music_sales$unit_sales) #overall descriptives
```

```
##    vars   n mean   sd median trimmed  mad min max range skew kurtosis   se
## X1    1 102 7.12 6.26      6     6.1 4.45   0  30    30 1.71     3.02 0.62
```

```r
describeBy(music_sales$unit_sales, music_sales$group) #descriptives by group
```

```
## 
##  Descriptive statistics by group 
## group: low_price
##    vars  n mean   sd median trimmed  mad min max range skew kurtosis  se
## X1    1 51 8.37 6.44      6    7.17 4.45   2  30    28 1.66     2.22 0.9
## ------------------------------------------------------------ 
## group: high_price
##    vars  n mean   sd median trimmed  mad min max range skew kurtosis   se
## X1    1 51 5.86 5.87      3     4.9 4.45   0  30    30 1.84      4.1 0.82
```

In the case of non-parametric tests, the data is better represented by the median (compared to the mean). Thus, we will visualize the data using a boxplot.


```r
ggplot(music_sales,aes(x = group, y = unit_sales)) + 
  geom_boxplot() +
  geom_jitter(colour="red", alpha = 0.1) +
  theme_bw() +
  labs(x = "Group", y = "Sales", title = "Sales by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-4-1.png" alt="Boxplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-4)Boxplot</p>
</div>

Let's assume that one of the parametric assumptions has been violated and we needed to conduct a non-parametric test. Then, the  Mann-Whitney U test is implemented in R using the function ```wilcox.test()```. Using the ranking data as an independent variable and the listening time as a dependent variable, the test could be executed as follows:


```r
wilcox.test(unit_sales ~ group, data = music_sales) #Mann-Whitney U Test
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  unit_sales by group
## W = 1710, p-value = 0.005374
## alternative hypothesis: true location shift is not equal to 0
```

The p-value is smaller than 0.05, which leads us to reject the null hypothesis, i.e. the test yields evidence that the new service feature leads to higher music listening times.

Alternatively, you could also use the `ggstatsplot` package to obtain the result of the test by specifying the argument `type = "nonparametric"` as follows:


```r
library(ggstatsplot)
ggbetweenstats(
  data = music_sales,
  plot.type = "box",
  x = group, # 2 groups
  y = unit_sales ,
  type = "nonparametric",
  effsize.type = "r", # display effect size (Cohen's d in output)
  messages = FALSE,
  bf.message = FALSE,
  mean.ci = TRUE,
  title = "Mean sales for different groups"
)
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-6-1.png" alt="Mann-Whitney U Test using ggstatsplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-6)Mann-Whitney U Test using ggstatsplot</p>
</div>

### Wilcoxon signed-rank test

The Wilcoxon signed-rank test is a non-parametric test used to analyze the difference between paired observations, analogously to the dependent-means t-test. It can be used when measurements come from the same observational units but the distributional assumptions of the dependent-means t-test do not hold, because it does not require any assumptions about the distribution of the measurements. Since we subtract two values, however, the test requires that the dependent variable is at least interval scaled, meaning that intervals have the same meaning for different points on our measurement scale. 

Under the null hypothesis $H_0$, the differences of the measurements should follow a symmetric distribution around 0, meaning that, on average, there is no difference between the two matched samples. $H_1$ states that the distributions mean is non-zero.

As an example, let's consider a slightly different experimental setup for the music download store. Imagine that new releases were either sold at a reduced price (i.e., 7.95€), or at the standard price (9.95€). Every time a customer came to the store, the prices were randomly determined for every new release. This means that the same 51 albums were either sold at the standard price or at the reduced price and this price was determined randomly. The sales were then recorded over one day. Note the difference to the previous case, where we randomly split the sample and assigned 50% of products to each condition. Now, we randomly vary prices for all albums between high and low prices. 

Let's load and investigate the data first:    


```r
rm(music_sales_dep)
music_sales_dep <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_experiment_dependent.dat", 
                              sep = "\t", 
                              header = TRUE) #read in data
str(music_sales_dep) #inspect data
```

```
## 'data.frame':	51 obs. of  3 variables:
##  $ product_id           : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ unit_sales_low_price : int  6 27 30 24 21 11 18 15 18 13 ...
##  $ unit_sales_high_price: int  9 12 30 18 20 15 2 3 3 9 ...
```

```r
head(music_sales_dep) #inspect data
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["product_id"],"name":[1],"type":["int"],"align":["right"]},{"label":["unit_sales_low_price"],"name":[2],"type":["int"],"align":["right"]},{"label":["unit_sales_high_price"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"1","2":"6","3":"9"},{"1":"2","2":"27","3":"12"},{"1":"3","2":"30","3":"30"},{"1":"4","2":"24","3":"18"},{"1":"5","2":"21","3":"20"},{"1":"6","2":"11","3":"15"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

We can visualize the data using a boxplot as follows:


```r
library(reshape2)
music_sales_dep_long <- melt(music_sales_dep[, c("unit_sales_low_price", "unit_sales_high_price")]) 
names(music_sales_dep_long) <- c("group","sales")
head(music_sales_dep_long)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["group"],"name":[1],"type":["fct"],"align":["left"]},{"label":["sales"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"unit_sales_low_price","2":"6"},{"1":"unit_sales_low_price","2":"27"},{"1":"unit_sales_low_price","2":"30"},{"1":"unit_sales_low_price","2":"24"},{"1":"unit_sales_low_price","2":"21"},{"1":"unit_sales_low_price","2":"11"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
ggplot(music_sales_dep_long,aes(x = group, y = sales)) + 
  geom_boxplot() +
  geom_jitter(colour="red", alpha = 0.1) +
  theme_bw() +
  labs(x = "Group", y = "Average number of sales", title = "Average number of sales by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-8-1.png" alt="Boxplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-8)Boxplot</p>
</div>

Again, let's assume that one of the parametric assumptions has been violated and we needed to conduct a non-parametric test. Then the Wilcoxon signed-rank test can be performed with the same command as the Mann-Whitney U test, provided that the argument ```paired``` is set to ```TRUE```.


```r
wilcox.test(music_sales_dep$unit_sales_low_price, music_sales_dep$unit_sales_high_price, paired = TRUE) #Wilcoxon signed-rank test
```

```
## 
## 	Wilcoxon signed rank test with continuity correction
## 
## data:  music_sales_dep$unit_sales_low_price and music_sales_dep$unit_sales_high_price
## V = 867.5, p-value = 0.004024
## alternative hypothesis: true location shift is not equal to 0
```

Using the 95% confidence level, the result would suggest a significant effect of price on sales (i.e., p < 0.05).

Again, you could also use the `ggstatsplot` package to obtain the result of the test by specifying the argument `type = "nonparametric"` as follows:


```r
library(ggstatsplot)
ggwithinstats(
  data = music_sales_dep_long,
  x = group,
  y = sales,
  path.point = FALSE,
  type="nonparametric",
  sort = "descending", # ordering groups along the x-axis based on
  sort.fun = median, # values of `y` variable
  title = "Mean sales for different treatments",
  messages = FALSE,
  bf.message = FALSE,
  mean.ci = TRUE,
  mean.plotting = F,
  effsize.type = "r" # display effect size (Cohen's d in output)
)
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-10-1.png" alt="Wilcoxon signed-rank test using ggstatsplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-10)Wilcoxon signed-rank test using ggstatsplot</p>
</div>

### Kruskal-Wallis test

The Kruskal–Wallis test is the non-parametric counterpart of the one-way ANOVA. It is designed to test for significant differences in population medians when you have more than two groups (with two groups, you would use the Mann-Whitney U-test). The theory is very similar to that of the Mann–Whitney U-test since it is also based on ranked data. 

As an example, let's use a data set containing data from an experiment at an online store where products were randomly assigned to three groups with three different levels of promotion (i.e., "low", "medium", "high") and the sales where recorded for these groups. 


```r
online_store_promo <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/online_store_promo.dat", 
                                 sep = "\t", 
                                 header = TRUE) #read in data
online_store_promo$Promotion <- factor(online_store_promo$Promotion, levels = c(1:3), labels = c("high", "medium","low")) #convert grouping variable to factor
head(online_store_promo)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Obs"],"name":[1],"type":["int"],"align":["right"]},{"label":["Promotion"],"name":[2],"type":["fct"],"align":["left"]},{"label":["Newsletter"],"name":[3],"type":["int"],"align":["right"]},{"label":["Sales"],"name":[4],"type":["int"],"align":["right"]}],"data":[{"1":"1","2":"high","3":"1","4":"10"},{"1":"2","2":"high","3":"1","4":"9"},{"1":"3","2":"high","3":"1","4":"10"},{"1":"4","2":"high","3":"1","4":"8"},{"1":"5","2":"high","3":"1","4":"9"},{"1":"6","2":"high","3":"0","4":"8"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

To get a first impression, we can plot the data using a boxplot:


```r
#Boxplot
ggplot(online_store_promo,aes(x = Promotion, y = Sales)) + 
  geom_boxplot() +
  geom_jitter(colour="red", alpha = 0.1) +
  theme_bw() +
  labs(x = "Experimental group (promotion level)", y = "Number of sales", title = "Number of sales by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-12-1.png" alt="Boxplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-12)Boxplot</p>
</div>

To test if there is a difference in medians between the groups, we can carry out the Kruskal-Wallis test using the ```kruskal.test()``` function: 


```r
kruskal.test(Sales ~ Promotion, data = online_store_promo) 
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  Sales by Promotion
## Kruskal-Wallis chi-squared = 16.529, df = 2, p-value = 0.0002575
```

The test-statistic follows a chi-square distribution and since the test is significant (p < 0.05), we can conclude that there are significant differences in population medians. Provided that the overall effect is significant, you may perform a post hoc test to find out which groups are different. 

To test for differences between groups, we can, for example, apply post-hoc tests according to Nemenyi for pairwise multiple comparisons of the ranked data using the appropriate function from the ```PMCMR``` package.


```r
library(PMCMR)
library(PMCMRplus)
kwAllPairsNemenyiTest(x = online_store_promo$Sales, g = online_store_promo$Promotion, dist = "Tukey")
```

```
##        high    medium 
## medium 0.09887 -      
## low    0.00016 0.11683
```
The results reveal that there is a significant difference between the "low" and "high" promotion groups. Note that the results are different compared to the results from a parametric test, which we could obtain as follows: 


```r
pairwise.t.test(online_store_promo$Sales, online_store_promo$Promotion, data = online_store_promo, p.adjust.method = "bonferroni")
```

```
## 
## 	Pairwise comparisons using t tests with pooled SD 
## 
## data:  online_store_promo$Sales and online_store_promo$Promotion 
## 
##        high    medium
## medium 0.0329  -     
## low    6.6e-06 0.0092
## 
## P value adjustment method: bonferroni
```
This difference occurs because non-parametric tests have less power to detect differences between groups since we lose information by ranking the data. Thus, you should rely on parametric tests if the assumptions are met.

Again, you could also use the `ggstatsplot` package to obtain the result of the test by specifying the argument `type = "nonparametric"` as follows:


```r
library(ggstatsplot)
ggbetweenstats(
  data = online_store_promo,
  plot.type = "box",
  x = Promotion, # 2 groups
  y = Sales ,
  type = "nonparametric",
  messages = FALSE,
  title = "Mean sales for different groups"
)
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-16-1.png" alt="Kruskal-Wallis test using ggstatsplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-16)Kruskal-Wallis test using ggstatsplot</p>
</div>

## Categorical data

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/4x0KYLGZXKc" frameborder="0" allowfullscreen></iframe>
</div>
<br>

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/09-categorical_data.R)
:::

In some instances, you will be confronted with differences between proportions, rather than differences between means. For example, you may conduct an A/B-Test and wish to compare the conversion rates between two advertising campaigns. In this case, your data is binary (0 = no conversion, 1 = conversion) and the sampling distribution for such data is binomial. While binomial probabilities are difficult to calculate, we can use a Normal approximation to the binomial when ```n``` is large (>100) and the true likelihood of a 1 is not too close to 0 or 1. 

Let's use an example: assume a call center where service agents call potential customers to sell a product. We consider two call center agents:

* Service agent 1 talks to 300 customers and gets 200 of them to buy (conversion rate=2/3)
* Service agent 2 talks to 300 customers and gets 100 of them to buy (conversion rate=1/3)

As always, we load the data first:


```r
call_center <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/call_center.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
call_center$conversion <- factor(call_center$conversion , levels = c(0:1), labels = c("no", "yes")) #convert to factor
call_center$agent <- factor(call_center$agent , levels = c(0:1), labels = c("agent_1", "agent_2")) #convert to factor
```

Next, we create a table to check the relative frequencies:


```r
rel_freq_table <- as.data.frame(prop.table(table(call_center), 2)) #conditional relative frequencies
rel_freq_table
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["agent"],"name":[1],"type":["fct"],"align":["left"]},{"label":["conversion"],"name":[2],"type":["fct"],"align":["left"]},{"label":["Freq"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"agent_1","2":"no","3":"0.3333333"},{"1":"agent_2","2":"no","3":"0.6666667"},{"1":"agent_1","2":"yes","3":"0.6666667"},{"1":"agent_2","2":"yes","3":"0.3333333"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

We could also plot the data to visualize the frequencies using ggplot:


```r
ggplot(rel_freq_table, aes(x = agent, y = Freq, fill = conversion)) + #plot data
  geom_col(width = .7) + #position
  geom_text(aes(label = paste0(round(Freq*100,0),"%")), position = position_stack(vjust = 0.5), size = 4) + #add percentages
  ylab("Proportion of conversions") + xlab("Agent") + # specify axis labels
  theme_bw()
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-19-1.png" alt="proportion of conversions per agent (stacked bar chart)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-19)proportion of conversions per agent (stacked bar chart)</p>
</div>

### Confidence intervals for proportions

Recall that we can use confidence intervals to determine the range of values that the true population parameter will take with a certain level of confidence based on the sample. Similar to the confidence interval for means, we can compute a confidence interval for proportions. The (1-$\alpha$)% confidence interval for proportions is approximately 

$$
CI = p\pm z_{1-\frac{\alpha}{2}}*\sqrt{\frac{p*(1-p)}{N}}
$$

where $\sqrt{p(1-p)}$ is the equivalent to the standard deviation in the formula for the confidence interval for means. Based on the equation, it is easy to compute the confidence intervals for the conversion rates of the call center agents:


```r
n1 <- nrow(subset(call_center,agent=="agent_1")) #number of observations for agent 1
n2 <- nrow(subset(call_center,agent=="agent_2")) #number of observations for agent 1
n1_conv <- nrow(subset(call_center,agent=="agent_1" & conversion=="yes")) #number of conversions for agent 1
n2_conv <- nrow(subset(call_center,agent=="agent_2" & conversion=="yes")) #number of conversions for agent 2
p1 <- n1_conv/n1  #proportion of conversions for agent 1
p2 <- n2_conv/n2  #proportion of conversions for agent 2

error1 <- qnorm(0.975)*sqrt((p1*(1-p1))/n1)
ci_lower1 <- p1 - error1
ci_upper1 <- p1 + error1
ci_lower1
```

```
## [1] 0.6133232
```

```r
ci_upper1
```

```
## [1] 0.7200101
```

```r
error2 <- qnorm(0.975)*sqrt((p2*(1-p2))/n2)
ci_lower2 <- p2 - error2
ci_upper2 <- p2 + error2
ci_lower2
```

```
## [1] 0.2799899
```

```r
ci_upper2
```

```
## [1] 0.3866768
```

Similar to testing for differences in means, we could also ask: Is agent 1 twice as likely as agent 2 to convert a customer? Or, to state it formally:

$$H_0: \pi_1=\pi_2 \\
H_1: \pi_1\ne \pi_2$$ 

where $\pi$ denotes the population parameter associated with the proportion in the respective population. One approach to test this is based on confidence intervals to estimate the difference between two populations. We can compute an approximate confidence interval for the difference between the proportion of successes in group 1 and group 2, as:

$$
CI = p_1-p_2\pm z_{1-\frac{\alpha}{2}}*\sqrt{\frac{p_1*(1-p_1)}{n_1}+\frac{p_2*(1-p_2)}{n_2}}
$$ 

If the confidence interval includes zero, then the data does not suggest a difference between the groups. Let's compute the confidence interval for differences in the proportions by hand first:


```r
ci_lower <- p1 - p2 - qnorm(0.975)*sqrt(p1*(1 - p1)/n1 + p2*(1 - p2)/n2) #95% CI lower bound
ci_upper <- p1 - p2 + qnorm(0.975)*sqrt(p1*(1 - p1)/n1 + p2*(1 - p2)/n2) #95% CI upper bound
ci_lower
```

```
## [1] 0.2578943
```

```r
ci_upper
```

```
## [1] 0.4087724
```

Now we can see that the 95% confidence interval estimate of the difference between the proportion of conversions for agent 1 and the proportion of conversions for agent 2 is between 26% and 41%. This interval tells us the range of plausible values for the difference between the two population proportions. According to this interval, zero is not a plausible value for the difference (i.e., interval does not cross zero), so we reject the null hypothesis that the population proportions are the same.

Instead of computing the intervals by hand, we could also use the ```prop.test()``` function:


```r
prop.test(x = c(n1_conv, n2_conv), n = c(n1, n2), conf.level = 0.95)
```

```
## 
## 	2-sample test for equality of proportions with continuity correction
## 
## data:  c(n1_conv, n2_conv) out of c(n1, n2)
## X-squared = 65.34, df = 1, p-value = 6.303e-16
## alternative hypothesis: two.sided
## 95 percent confidence interval:
##  0.2545610 0.4121057
## sample estimates:
##    prop 1    prop 2 
## 0.6666667 0.3333333
```

Note that the ```prop.test()``` function uses a slightly different (more accurate) way to compute the confidence interval (Wilson's score method is used). It is particularly a better approximation for smaller N. That's why the confidence interval in the output slightly deviates from the manual computation above, which uses the Wald interval. 

You can also see that the output from the ```prop.test()``` includes the results from a &chi;<sup>2</sup> test for the equality of proportions (which will be  discussed below) and the associated p-value. Since the p-value is less than 0.05, we reject the null hypothesis of equal probability. Thus, the reporting would be: 

The test showed that the conversion rate for agent 1 was higher by 33%. This difference is significant &chi; (1) = 70, p < .05 (95% CI = [0.25,0.41]).


### Chi-square test

In the previous section, we saw how we can compute the confidence interval for the difference between proportions to decide on whether or not to reject the null hypothesis. Whenever you would like to investigate the relationship between two categorical variables, the $\chi^2$ test may be used to test whether the variables are independent of each other. It achieves this by comparing the expected number of observations in a group to the actual values. Let's continue with the example from the previous section. Under the null hypothesis, the two variables *agent* and *conversion* in our contingency table are independent (i.e., there is no relationship). This means that the frequency in each field will be roughly proportional to the probability of an observation being in that category, calculated under the assumption that they are independent. The difference between that expected quantity and the actual quantity can be used to construct the test statistic. The test statistic is computed as follows:

$$
\chi^2=\sum_{i=1}^{J}\frac{(f_o-f_e)^2}{f_e}
$$

where $J$ is the number of cells in the contingency table, $f_o$ are the observed cell frequencies and $f_e$ are the expected cell frequencies. The larger the differences, the larger the test statistic and the smaller the p-value. 

The observed cell frequencies can easily be seen from the contingency table: 


```r
contigency_table <- table(call_center)
obs_cell1 <- contigency_table[1,1]
obs_cell2 <- contigency_table[1,2]
obs_cell3 <- contigency_table[2,1]
obs_cell4 <- contigency_table[2,2]
```

The expected cell frequencies can be calculated as follows:

$$
f_e=\frac{(n_r*n_c)}{n}
$$

where $n_r$ are the total observed frequencies per row, $n_c$ are the total observed frequencies per column, and $n$ is the total number of observations. Thus, the expected cell frequencies under the assumption of independence can be calculated as: 


```r
n <- nrow(call_center)
exp_cell1 <- (nrow(call_center[call_center$agent=="agent_1",])*nrow(call_center[call_center$conversion=="no",]))/n
exp_cell2 <- (nrow(call_center[call_center$agent=="agent_1",])*nrow(call_center[call_center$conversion=="yes",]))/n
exp_cell3 <- (nrow(call_center[call_center$agent=="agent_2",])*nrow(call_center[call_center$conversion=="no",]))/n
exp_cell4 <- (nrow(call_center[call_center$agent=="agent_2",])*nrow(call_center[call_center$conversion=="yes",]))/n
```

To sum up, these are the expected cell frequencies


```r
data.frame(conversion_no = rbind(exp_cell1,exp_cell3),conversion_yes = rbind(exp_cell2,exp_cell4), row.names = c("agent_1","agent_2")) 
```

```
##         conversion_no conversion_yes
## agent_1           150            150
## agent_2           150            150
```

... and these are the observed cell frequencies


```r
data.frame(conversion_no = rbind(obs_cell1,obs_cell2),conversion_yes = rbind(obs_cell3,obs_cell4), row.names = c("agent_1","agent_2")) 
```

```
##         conversion_no conversion_yes
## agent_1           100            200
## agent_2           200            100
```

To obtain the test statistic, we simply plug the values into the formula: 


```r
chisq_cal <-  sum(((obs_cell1 - exp_cell1)^2/exp_cell1),
                  ((obs_cell2 - exp_cell2)^2/exp_cell2),
                  ((obs_cell3 - exp_cell3)^2/exp_cell3),
                  ((obs_cell4 - exp_cell4)^2/exp_cell4))
chisq_cal
```

```
## [1] 66.66667
```

The test statistic is $\chi^2$ distributed. The chi-square distribution is a non-symmetric distribution. Actually, there are many different chi-square distributions, one for each degree of freedom as show in the following figure. 

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-28-1.png" alt="The chi-square distribution" width="672" />
<p class="caption">(\#fig:unnamed-chunk-28)The chi-square distribution</p>
</div>

You can see that as the degrees of freedom increase, the chi-square curve approaches a normal distribution. To find the critical value, we need to specify the corresponding degrees of freedom, given by:

$$
df=(r-1)*(c-1)
$$

where $r$ is the number of rows and $c$ is the number of columns in the contingency table. Recall that degrees of freedom are generally the number of values that can vary freely when calculating a statistic. In a 2 by 2 table as in our case, we have 2 variables (or two samples) with 2 levels and in each one we have 1 that vary freely. Hence, in our example the degrees of freedom can be calculated as:


```r
df <-  (nrow(contigency_table) - 1) * (ncol(contigency_table) -1)
df
```

```
## [1] 1
```

Now, we can derive the critical value given the degrees of freedom and the level of confidence using the ```qchisq()``` function and test if the calculated test statistic is larger than the critical value:


```r
chisq_crit <- qchisq(0.95, df)
chisq_crit
```

```
## [1] 3.841459
```

```r
chisq_cal > chisq_crit
```

```
## [1] TRUE
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-31-1.png" alt="Visual depiction of the test result" width="672" />
<p class="caption">(\#fig:unnamed-chunk-31)Visual depiction of the test result</p>
</div>

We could also compute the p-value using the ```pchisq()``` function, which tells us the probability of the observed cell frequencies if the null hypothesis was true (i.e., there was no association):


```r
p_val <- 1-pchisq(chisq_cal,df)
p_val
```

```
## [1] 3.330669e-16
```

The test statistic can also be calculated in R directly on the contingency table with the function ```chisq.test()```.


```r
chisq.test(contigency_table, correct = FALSE)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  contigency_table
## X-squared = 66.667, df = 1, p-value = 3.215e-16
```

Since the p-value is smaller than 0.05 (i.e., the calculated test statistic is larger than the critical value), we reject H<sub>0</sub> that the two variables are independent. 

Note that the test statistic is sensitive to the sample size. To see this, let's assume that we have a sample of 100 observations instead of 1000 observations:


```r
chisq.test(contigency_table/10, correct = FALSE)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  contigency_table/10
## X-squared = 6.6667, df = 1, p-value = 0.009823
```

You can see that even though the proportions haven't changed, the test is insignificant now. The following equation lets you compute a measure of the effect size, which is insensitive to sample size: 

$$
\phi=\sqrt{\frac{\chi^2}{n}}
$$

The following guidelines are used to determine the magnitude of the effect size (Cohen, 1988): 

* 0.1 (small effect)
* 0.3 (medium effect)
* 0.5 (large effect)

In our example, we can compute the effect sizes for the large and small samples as follows:


```r
test_stat <- chisq.test(contigency_table, correct = FALSE)$statistic
phi1 <- sqrt(test_stat/n)
test_stat <- chisq.test(contigency_table/10, correct = FALSE)$statistic
phi2 <- sqrt(test_stat/(n/10))
phi1
```

```
## X-squared 
## 0.3333333
```

```r
phi2
```

```
## X-squared 
## 0.3333333
```

You can see that the statistic is insensitive to the sample size. 

Note that the &Phi; coefficient is appropriate for two dichotomous variables (resulting from a 2 x 2 table as above). If any your nominal variables has more than two categories, Cramer's V should be used instead:

$$
V=\sqrt{\frac{\chi^2}{n*df_{min}}}
$$

where $df_{min}$ refers to the degrees of freedom associated with the variable that has fewer categories (e.g., if we have two nominal variables with 3 and 4 categories, $df_{min}$ would be 3 - 1 = 2). The degrees of freedom need to be taken into account when judging the magnitude of the effect sizes (see e.g., <a href="http://www.real-statistics.com/chi-square-and-f-distributions/effect-size-chi-square/" target="_blank">here</a>). 

Note that the ```correct = FALSE``` argument above ensures that the test statistic is computed in the same way as we have done by hand above. By default, ```chisq.test()``` applies a correction to prevent overestimation of statistical significance for small data (called the Yates' correction). The correction is implemented by subtracting the value 0.5 from the computed difference between the observed and expected cell counts in the numerator of the test statistic. This means that the calculated test statistic will be smaller (i.e., more conservative). Although the adjustment may go too far in some instances, you should generally rely on the adjusted results, which can be computed as follows:


```r
chisq.test(contigency_table)
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  contigency_table
## X-squared = 65.34, df = 1, p-value = 6.303e-16
```

As you can see, the results don't change much in our example, since the differences between the observed and expected cell frequencies are fairly large relative to the correction.

As usual, you could also use the `ggstatsplot` package to obtain the result of the test, this time by using `ggbarstats` function:


```r
library(ggstatsplot)
ggbarstats(
  data = call_center,
  x = conversion,
  y = agent,
  title = "Conversion by agent",
  xlab = "Agent",
  palette = "Blues",
  messages = FALSE,
  bar.proptest = FALSE,
  bf.message = FALSE
)
```

<div class="figure" style="text-align: center">
<img src="09-non_parametric_tests_files/figure-html/unnamed-chunk-37-1.png" alt="Kruskal-Wallis test using ggstatsplot" width="672" />
<p class="caption">(\#fig:unnamed-chunk-37)Kruskal-Wallis test using ggstatsplot</p>
</div>

Caution is warranted when the cell counts in the contingency table are small. The usual rule of thumb is that all cell counts should be at least 5 (this may be a little too stringent though). When some cell counts are too small, you can use Fisher's exact test using the ```fisher.test()``` function. 


```r
fisher.test(contigency_table)
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  contigency_table
## p-value = 3.391e-16
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##  0.1754685 0.3560568
## sample estimates:
## odds ratio 
##  0.2506258
```

The Fisher test, while more conservative, also shows a significant difference between the proportions (p < 0.05). This is not surprising since the cell counts in our example are fairly large.

### Sample size

To **calculate the required sample size** when comparing proportions, the ```power.prop.test()``` function can be used. For example, we could ask how large our sample needs to be if we would like to compare two groups with conversion rates of 2% and 2.5%, respectively using the conventional settings for $\alpha$ and $\beta$:


```r
power.prop.test(p1=0.02,p2=0.025,sig.level=0.05,power=0.8)
```

```
## 
##      Two-sample comparison of proportions power calculation 
## 
##               n = 13808.92
##              p1 = 0.02
##              p2 = 0.025
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

The output tells us that we need 1.3809\times 10^{4} observations per group to detect a difference of the desired size.


## Learning check {-}

**(LC6.1) The Null Hypothesis ($H_0$) is a statement of:**

- [ ] The status-quo/no effect
- [ ] The desired status
- [ ] The expected status
- [ ] None of the above 

**(LC6.2) Which statements about the Null Hypothesis ($H_0$) are TRUE?**

- [ ] In scientific research, the goal is usually to confirm it
- [ ] In scientific research, the goal is usually to reject it
- [ ] It can be confirmed with one test
- [ ] None of the above 

**(LC6.3) The t-distribution:**

- [ ] Has more probability mass in its tails compared to the normal distribution and therefore corrects for small samples
- [ ] Approaches the normal distribution as n increases
- [ ] Is the distribution of the t-statistic
- [ ] Has less probability mass in its tails compared to the normal distribution and therefore corrects for small samples
- [ ] None of the above 

**(LC6.4) Type I vs. Type II Errors: Which of the following statements is TRUE?**

- [ ] Type II Error: We believe there is no effect, when in fact there is
- [ ] Type I Error: We believe there is an effect, when in fact there isn’t
- [ ] Type I Error: We believe there is no effect, when in fact there is
- [ ] Type II Error: We believe there is an effect, when in fact there isn’t
- [ ] None of the above 

**(LC6.5) When planning an experiment, which of the following information would you need to compute the required sample size?**

- [ ] The p-value (p)
- [ ] The significance level (alpha)
- [ ] The effect size (d)
- [ ] The critical value of the test statistic (t)
- [ ] None of the above 

**(LC6.6) In which setting would you reject the null hypothesis when conducting a statistical test?**

- [ ] When the absolute value of the calculated test-statistic (e.g., t-value) exceeds the critical value of the test statistic at your specified significance level (e.g., 0.05)
- [ ] When the p-value is smaller than your specified significance level (e.g., 0.05)
- [ ] When the confidence interval associated with the test does not contain zero
- [ ] When the test-statistic (e.g., t-value) is lower than the critical value of the test statistic at your specified significance level (e.g., 0.05)
- [ ] None of the above 

**(LC6.7) After conducting a statistical test, what is the relationship between the test statistic (e.g., t-value) and the p-value?**

- [ ] The lower the absolute value of the test statistic, the lower the p-value
- [ ] The higher the absolute value of the test statistic, the higher the p-value
- [ ] There is no connection between the test statistic and the p-value
- [ ] None of the above 

**(LC6.8) What does a significant test result tell you?**

- [ ] The importance of an effect
- [ ] That the null hypothesis is false
- [ ] That the null hypothesis is true
- [ ] None of the above 

**(LC6.9) In an experiment in which you compare the means between two groups, you should collect data until your test shows a significant results. True or false?**

- [ ] True
- [ ] False

**(LC6.10) If you have data from an within-subjects experimental design, you should use the independent-means t-test. True or false?**

- [ ] True
- [ ] False
 
-------------------------------------------------------
**Questions for chapters 6.4 and following from here**
-------------------------------------------------------

**(LC6.11) When should you use an ANOVA rather than a t-test?**   

- [ ] To compare the means for more than populations
- [ ] To compare the means of two groups
- [ ] To adjust the variance of different sets
- [ ] To test for causality
- [ ] None of the above 

**(LC6.12) What is the correct representation of the null hypothesis for an ANOVA??**   

- [ ] H0:μ1≠μ2≠μ3
- [ ] H1:μ1=μ2=μ3
- [ ] H0:μ1=μ2=μ3
- [ ] H0:μ1≠μ2=μ3
- [ ] None of the above 

**(LC6.13) Using an experimental design with three groups, why can't we just compare the means between the groups using multiple t-test?**   

- [ ] Because the parametric assumptions of the t-test are not met
- [ ] Because of deflated Type III Error rates
- [ ] Due to the family-wise error rate the Type II Error is inflated
- [ ] Because the Type I Error rate (alpha) wouldn't be 0.05
- [ ] None of the above 

**(LC6.14) Which assumptions have to be satisfied to be able to use ANOVA on data from a between-subject design with three groups?**   

- [ ] Same mean for all groups
- [ ] Normal distribution of data
- [ ] Homogeneity of variances
- [ ] Independence of observation
- [ ] None of the above 

**(LC6.15) What procedures are designed to correct of family-wise error rate in ANOVA?**   

- [ ] Bonferroni correction
- [ ] Tukey’s HSD
- [ ] t-test
- [ ] Post-hoc tests
- [ ] None of the above 

**(LC6.16) Which of the following are examples for non-parametric tests?**   

- [ ] Chi-Squared test
- [ ] ANOVA
- [ ] Kruskal-Wilcoxon test
- [ ] T-test
- [ ] None of the above 

**(LC6.17) When should you use non-parametric tests?**   

- [ ] When the assumptions of parametric tests are not met (e.g., normally distributed sampling distribution)
- [ ] You have a very small sample size
- [ ] When your dependent variable is measured on an ordinal scale
- [ ] When your data is better represented by the median
- [ ] None of the above 

**(LC6.18) When should you use a Wilcoxon Rank Sum Test (= Mann-Whitney U Test)?**   

- [ ] When the assumptions of the t-test have been violated
- [ ] The variances are not significantly different between groups
- [ ] As a non-parametric alternative to the independent-means t-test
- [ ] When the assumptions of the ANOVA have been violated
- [ ] None of the above 

**(LC6.19) What does a Chi squared test do?**   

- [ ] Tests the statistical significance of the observed association in a cross-tabulation
- [ ] Tests whether group A affects group B
- [ ] Produces a test statistic that is Chi Squared distributed
- [ ] Tests for the association between two or more categorical variables
- [ ] None of the above 

**(LC6.20) Which R-function would be suitable if you wanted to perform a test with ranked (ordinal) data in a two-group between-subject design?**   

- [ ] `kruskal.test(x, ...)`
- [ ] `wilcox.test(x, ...)`
- [ ] `aov(formula, data = ,...)`
- [ ] `t.test(x, ...)`
- [ ] None of the above 


## References {-}

* Field, A., Miles J., & Field, Z. (2012): Discovering Statistics Using R. Sage Publications, **chapters 5, 9, 10, 12, 15, 18**.
* McCullough, B.D. & Feit, E. (2020). Business Experiments with R.
