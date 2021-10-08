---
output:
  html_document:
    df_print: paged
    toc: yes
  html_notebook: default
  pdf_document:
    toc: yes
---


# Hypothesis testing

## Introduction

::: {.infobox .download data-latex="{download}"}
[You can download the corresponding R-Code here](./Code/06-hypothesis_testing.R)
:::

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/cJRwmWWCpZE" frameborder="0" allowfullscreen></iframe>
</div>
<br>

We test hypotheses because we are confined to taking samples – we rarely work with the entire population. In the previous chapter, we introduced the standard error (i.e., the standard deviation of a large number of hypothetical samples) as an estimate of how well a particular sample represents the population. We also saw how we can construct confidence intervals around the sample mean $\bar x$ by computing $SE_{\bar x}$ as an estimate of $\sigma_{\bar x}$ using $s$ as an estimate of $\sigma$ and calculating the 95% CI as $\bar x \pm 1.96 * SE_{\bar x}$. Although we do not know the true population mean ($\mu$), we might have an hypothesis about it and this would tell us how the corresponding sampling distribution looks like. Based on the sampling distribution of the hypothesized population mean, we could then determine the probability of a given sample **assuming that the hypothesis is true**. 

Let us again begin by assuming we know the entire population using the example of music listening times among students from the previous example. As a reminder, the following plot shows the distribution of music listening times in the population of WU students. 


```r
library(tidyverse)
library(ggplot2)
library(latex2exp)
set.seed(321)
hours <- rgamma(n = 25000, shape = 2, scale = 10)
ggplot(data.frame(hours)) + geom_histogram(aes(x = hours),
    bins = 30, fill = "white", color = "black") + geom_vline(xintercept = mean(hours),
    size = 1) + theme_bw() + labs(title = "Histogram of listening times",
    subtitle = TeX(sprintf("Population mean ($\\mu$) = %.2f; population standard deviation ($\\sigma$) = %.2f",
        round(mean(hours), 2), round(sd(hours), 2))),
    y = "Number of students", x = "Hours")
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-2-1.png" width="672" />

In this example, the population mean ($\mu$) is equal to 19.98, and the population standard deviation $\sigma$ is equal to 14.15. 

### The null hypothesis

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/DZOVAkWNgTg" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Let us assume that we were planning to take a random sample of 50 students from this population and our hypothesis was that the mean listening time is equal to some specific value $\mu_0$, say $10$. This would be our **null hypothesis**. The null hypothesis refers to the statement that is being tested and is usually a statement of the status quo, one of no difference or no effect. In our example, the null hypothesis would state that there is no difference between the true population mean $\mu$ and the hypothesized value $\mu_0$ (in our example $10$), which can be expressed as follows:

$$
H_0: \mu = \mu_0
$$
When conducting research, we are usually interested in providing evidence against the null hypothesis. If we then observe sufficient evidence against it and our estimate is said to be significant. If the null hypothesis is rejected, this is taken as support for the **alternative hypothesis**. The alternative hypothesis assumes that some difference exists, which can be expressed as follows: 

$$
H_1: \mu \neq \mu_0
$$
Accepting the alternative hypothesis in turn will often lead to changes in opinions or actions. Note that while the null hypothesis may be rejected, it can never be accepted based on a single test. If we fail to reject the null hypothesis, it means that we simply haven't collected enough evidence against the null hypothesis to disprove it. In classical hypothesis testing, there is no way to determine whether the null hypothesis is true. **Hypothesis testing** provides a means to quantify to what extent the data from our sample is in line with the null hypothesis.

In order to quantify the concept of "sufficient evidence" we look at the theoretical distribution of the sample means given our null hypothesis and the sample standard error. Using the available information we can infer the sampling distribution for our null hypothesis. Recall that the standard deviation of the sampling distribution (i.e., the standard error of the mean) is given by $\sigma_{\bar x}={\sigma \over \sqrt{n}}$, and thus can be computed as follows:


```r
mean_pop <- mean(hours)
sigma <- sd(hours)  #population standard deviation
n <- 50  #sample size
standard_error <- sigma/sqrt(n)  #standard error
standard_error
```

```
## [1] 2.001639
```

Since we know from the central limit theorem that the sampling distribution is normal for large enough samples, we can now visualize the expected sampling distribution **if our null hypothesis was in fact true** (i.e., if the was no difference between the true population mean and the hypothesized mean of 10). 

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-4-1.png" width="768" style="display: block; margin: auto;" />

We also know that 95% of the probability is within 1.96 standard deviations from the mean. Values higher than that are rather unlikely, if our hypothesis about the population mean was indeed true. This is shown by the shaded area, also known as the "rejection region". To test our hypothesis that the population mean is equal to $10$, let us take a random sample from the population.


```r
set.seed(12567)
H_0 <- 10
student_sample <- sample(1:25000, size = 50, replace = FALSE)
music_listening_sample <- data.frame(hours = hours[student_sample])
mean_sample <- mean(music_listening_sample$hours)
ggplot(music_listening_sample) + geom_histogram(aes(x = hours),
    fill = "white", color = "black", bins = 20) + theme_bw() +
    geom_vline(xintercept = mean_sample, color = "black",
        size = 1) + labs(title = TeX(sprintf("Distribution of values in the sample ($n =$ %.0f, $\\bar{x] = $ %.2f, s = %.2f)",
    n, mean_sample, sd(music_listening_sample$hours))),
    x = "Hours", y = "Frequency")
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-5-1.png" width="672" />

The mean listening time in the sample (black line) $\bar x$ is 18.59. We can already see from the graphic above that such a value is rather unlikely under the hypothesis that the population mean is $10$. Intuitively, such a result would therefore provide evidence against our null hypothesis. But how could we quantify specifically how unlikely it is to obtain such a value and decide whether or not to reject the null hypothesis? Significance tests can be used to provide answers to these questions. 

### Statistical inference on a sample

#### Test statistic

##### z-scores

Let's go back to the sampling distribution above. We know that 95% of all values will fall within 1.96 standard deviations from the mean. So if we could express the distance between our sample mean and the null hypothesis in terms of standard deviations, we could make statements about the probability of getting a sample mean of the observed magnitude (or more extreme values). Essentially, we would like to know how many standard deviations ($\sigma_{\bar x}$) our sample mean ($\bar x$) is away from the population mean if the null hypothesis was true ($\mu_0$). This can be formally expressed as follows:

$$
\bar x-  \mu_0 = z \sigma_{\bar x}
$$

In this equation, ```z``` will tell us how many standard deviations the sample mean $\bar x$ is away from the null hypothesis $\mu_0$. Solving for ```z``` gives us:

$$
z = {\bar x-  \mu_0 \over \sigma_{\bar x}}={\bar x-  \mu_0 \over \sigma / \sqrt{n}}
$$

This standardized value (or "z-score") is also referred to as a **test statistic**. Let's compute the test statistic for our example above:


```r
z_score <- (mean_sample - H_0)/(sigma/sqrt(n))
z_score
```

```
## [1] 4.292454
```

To make a decision on whether the difference can be deemed statistically significant, we now need to compare this calculated test statistic to a meaningful threshold. In order to do so, we need to decide on a significance level $\alpha$, which expresses the probability of finding an effect that does not actually exist (i.e., Type I Error). You can find a detailed discussion of this point at the end of this chapter. For now, we will adopt the widely accepted significance level of 5% and set $\alpha$ to 0.05. The critical value for the normal distribution and $\alpha$ = 0.05 can be computed using the ```qnorm()``` function as follows:


```r
z_crit <- qnorm(0.975)
z_crit
```

```
## [1] 1.959964
```

We use ```0.975``` and not ```0.95``` since we are running a two-sided test and need to account for the rejection region at the other end of the distribution. Recall that for the normal distribution, 95% of the total probability falls within 1.96 standard deviations of the mean, so that higher (absolute) values provide evidence against the null hypothesis. Generally, we speak of a statistically significant effect if the (absolute) calculated test statistic is larger than the (absolute) critical value. We can easily check if this is the case in our example:


```r
abs(z_score) > abs(z_crit)
```

```
## [1] TRUE
```

Since the absolute value of the calculated test statistic is larger than the critical value, we would reject $H_0$ and conclude that the true population mean $\mu$ is significantly different from the hypothesized value $\mu_0 = 10$.

##### t-statistic

You may have noticed that the formula for the z-score above assumes that we know the true population standard deviation ($\sigma$) when computing the standard deviation of the sampling distribution ($\sigma_{\bar x}$) in the denominator. However, the population standard deviation is usually not known in the real world and therefore represents another unknown population parameter which we have to estimate from the sample. We saw in the previous chapter that we usually use $s$ as an estimate of $\sigma$ and $SE_{\bar x}$ as and estimate of $\sigma_{\bar x}$. Intuitively, we should be more conservative regarding the critical value that we used above to assess whether we have a significant effect to reflect this uncertainty about the true population standard deviation. That is, the threshold for a "significant" effect should be higher to safeguard against falsely claiming a significant effect when there is none. If we replace $\sigma_{\bar x}$ by it's estimate $SE_{\bar x}$ in the formula for the z-score, we get a new test statistic (i.e, the **t-statistic**) with its own distribution (the **t-distribution**): 

$$
t = {\bar x-  \mu_0 \over SE_{\bar x}}={\bar x-  \mu_0 \over s / \sqrt{n}}
$$

Here, $\bar X$ denotes the sample mean and $s$ the sample standard deviation. The t-distribution has more probability in its "tails", i.e. farther away from the mean. This reflects the higher uncertainty introduced by replacing the population standard deviation by its sample estimate. Intuitively, this is particularly relevant for small samples, since the uncertainty about the true population parameters decreases with increasing sample size. This is reflected by the fact that the exact shape of the t-distribution depends on the **degrees of freedom**, which is the sample size minus one (i.e., $n-1$). To see this, the following graph shows the t-distribution with different degrees of freedom for a two-tailed test and $\alpha = 0.05$. The grey curve shows the normal distribution. 

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-9-1.png" width="768" style="display: block; margin: auto;" />

Notice that as $n$ gets larger, the t-distribution gets closer and closer to the normal distribution, reflecting the fact that the uncertainty introduced by $s$ is reduced. To summarize, we now have an estimate for the standard deviation of the distribution of the sample mean (i.e., $SE_{\bar x}$) and an appropriate distribution that takes into account the necessary uncertainty (i.e., the t-distribution). Let us now compute the t-statistic according to the formula above:


```r
SE <- (sd(music_listening_sample$hours)/sqrt(n))
t_score <- (mean_sample - H_0)/SE
t_score
```

```
## [1] 4.84204
```

Notice that the value of the t-statistic is higher compared to the z-score (4.29). This can be attributed to the fact that by using the $s$ as and estimate of $\sigma$, we underestimate the true population standard deviation. Hence, the critical value would need to be larger to adjust for this. This is what the t-distribution does. Let us compute the critical value from the t-distribution with ```n - 1```degrees of freedom.     


```r
df = n - 1
t_crit <- qt(0.975, df = df)
t_crit
```

```
## [1] 2.009575
```

Again, we use ```0.975``` and not ```0.95``` since we are running a two-sided test and need to account for the rejection region at the other end of the distribution. Notice that the new critical value based on the t-distributionis larger, to reflect the uncertainty when estimating $\sigma$ from $s$. Now we can see that the calculated test statistic is still larger than the critical value.  


```r
abs(t_score) > abs(t_crit)
```

```
## [1] TRUE
```

The following graphics shows that the calculated test statistic (red line) falls into the rejection region so that in our example, we would reject the null hypothesis that the true population mean is equal to $10$. 

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-13-1.png" width="768" style="display: block; margin: auto;" />

**Decision:** Reject $H_0$, given that the calculated test statistic is larger than critical value.

Something to keep in mind here is the fact the test statistic is a function of the sample size. This, as $n$ gets large, the test statistic gets larger as well and we are more likely to find a significant effect. This reflects the decrease in uncertainty about the true population mean as our sample size increases.  

#### P-values

In the previous section, we computed the test statistic, which tells us how close our sample is to the null hypothesis. The p-value corresponds to the probability that the test statistic would take a value as extreme or more extreme than the one that we actually observed, **assuming that the null hypothesis is true**. It is important to note that this is a **conditional probability**: we compute the probability of observing a sample mean (or a more extreme value) conditional on the assumption that the null hypothesis is true. The ```pnorm()```function can be used to compute this probability. It is the cumulative probability distribution function of the `normal distribution. Cumulative probability means that the function returns the probability that the test statistic will take a value **less than or equal to** the calculated test statistic given the degrees of freedom. However, we are interested in obtaining the probability of observing a test statistic **larger than or equal to** the calculated test statistic under the null hypothesis (i.e., the p-value). Thus, we need to subtract the cumulative probability from 1. In addition, since we are running a two-sided test, we need to multiply the probability by 2 to account for the rejection region at the other side of the distribution.  


```r
p_value <- 2 * (1 - pt(abs(t_score), df = df))
p_value
```

```
## [1] 0.00001326885
```

This value corresponds to the probability of observing a mean equal to or larger than the one we obtained from our sample, if the null hypothesis was true. As you can see, this probability is very low. A small p-value signals that it is unlikely to observe the calculated test statistic under the null hypothesis. To decide whether or not to reject the null hypothesis, we would now compare this value to the level of significance ($\alpha$) that we chose for our test. For this example, we adopt the widely accepted significance level of 5%, so any test results with a p-value < 0.05 would be deemed statistically significant. Note that the p-value is directly related to the value of the test statistic. The relationship is such that the higher (lower) the value of the test statistic, the lower (higher) the p-value.   

**Decision:** Reject $H_0$, given that the p-value is smaller than 0.05. 

#### Confidence interval

For a given statistic calculated for a sample of observations (e.g., listening times), a 95% confidence interval can be constructed such that in 95% of samples, the true value of the true population mean will fall within its limits. If the parameter value specified in the null hypothesis (here $10$) does not lie within the bounds, we reject $H_0$. Building on what we learned about confidence intervals in the previous chapter, the 95% confidence interval based on the t-distribution can be computed as follows:

$$
CI_{lower} = {\bar x} - t_{1-{\alpha \over 2}} * SE_{\bar x} \\
CI_{upper} = {\bar x} + t_{1-{\alpha \over 2}} * SE_{\bar x}
$$ 

It is easy to compute this interval manually:


```r
ci_lower <- (mean_sample) - qt(0.975, df = df) * SE
ci_upper <- (mean_sample) + qt(0.975, df = df) * SE
ci_lower
```

```
## [1] 15.02606
```

```r
ci_upper
```

```
## [1] 22.15783
```

The interpretation of this interval is as follows: if we would (hypothetically) take 100 samples and calculated the mean and confidence interval for each of them, then the true population mean would be included in 95% of these intervals. The CI is informative when reporting the result of your test, since it provides an estimate of the uncertainty associated with the test result. From the test statistic or the p-value alone, it is not easy to judge in which range the true population parameter is located.  The CI provides an estimate of this range. 

**Decision:** Reject $H_0$, given that the parameter value from the null hypothesis ($10$) is not included in the interval. 

To summarize, you can see that we arrive at the same conclusion (i.e., reject $H_0$), irrespective if we use the test statistic, the p-value, or the confidence interval. However, keep in mind that rejecting the null hypothesis does not prove the alternative hypothesis (we can merely provide support for it). Rather, think of the p-value as the chance of obtaining the data we've collected assuming that the null hypothesis is true. You should report the confidence interval to provide an estimate of the uncertainty associated with your test results.  

### Choosing the right test

The test statistic, as we have seen, measures how close the sample is to the null hypothesis and often follows a well-known distribution (e.g., normal, t, or chi-square). To select the correct test, various factors need to be taken into consideration. Some examples are:

* On what scale are your variables measured (categorical vs. continuous)?
* Do you want to test for relationships or differences?
* If you test for differences, how many groups would you like to test?
* For parametric tests, are the assumptions fulfilled?

The previous discussion used a **one sample t-test** as an example, which requires that variable is measured on an interval or ratio scale. If you are confronted with other settings, the following flow chart provides a rough guideline on selecting the correct test:

![Flowchart for selecting an appropriate test (source: McElreath, R. (2016): Statistical Rethinking, p. 2)](https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/testselection.JPG)

For a detailed overview over the different type of tests, please also refer to <a href="https://stats.idre.ucla.edu/other/mult-pkg/whatstat/" target="_blank">this overview</a> by the UCLA.

#### Parametric vs. non-parametric tests

A basic distinction can be made between parametric and non-parametric tests. **Parametric tests** require that variables are measured on an interval or ratio scale and that the sampling distribution follows a known distribution. **Non-Parametric tests** on the other hand do not require the sampling distribution to be normally distributed (a.k.a. "assumption free tests"). These tests may be used when the variable of interest is measured on an ordinal scale or when the parametric assumptions do not hold. They often rely on ranking the data instead of analyzing the actual scores. By ranking the data, information on the magnitude of differences is lost. Thus, parametric tests are more powerful if the sampling distribution is normally distributed. In this chapter, we will first focus on parametric tests and cover non-parametric tests later. 

#### One-tailed vs. two-tailed test

For some tests you may choose between a **one-tailed test** versus a **two-tailed test**. The choice depends on the hypothesis you specified, i.e., whether you specified a directional or a non-directional hypotheses. In the example above, we used a **non-directional hypothesis**. That is, we stated that the mean is different from the comparison value $\mu_0$, but we did not state the direction of the effect. A **directional hypothesis** states the direction of the effect. For example, we might test whether the population mean is smaller than a comparison value:

$$
H_0: \mu \ge \mu_0 \\
H_1: \mu < \mu_0
$$

Similarly, we could test whether the population mean is larger than a comparison value:

$$
H_0: \mu \le \mu_0 \\
H_1: \mu > \mu_0
$$

Connected to the decision of how to phrase the hypotheses (directional vs. non-directional) is the choice of a **one-tailed test** versus a **two-tailed test**. Let's first think about the meaning of a one-tailed test. Using a significance level of 0.05, a one-tailed test means that 5% of the total area under the probability distribution of our test statistic is located in one tail. Thus, under a one-tailed test, we test for the possibility of the relationship in one direction only, disregarding the possibility of a relationship in the other direction. In our example, a one-tailed test could test either if the mean listening time is significantly larger or smaller compared to the control condition, but not both. Depending on the direction, the mean listening time is significantly larger (smaller) if the test statistic is located in the top (bottom) 5% of its probability distribution. 

The following graph shows the critical values that our test statistic would need to surpass so that the difference between the population mean and the comparison value would be deemed statistically significant.

<img src="07-hypothesis_testing_files/figure-html/fig2-1.png" width="960" style="display: block; margin: auto;" />

It can be seen that under a one-sided test, the rejection region is at one end of the distribution or the other. In a two-sided test, the rejection region is split between the two tails. As a consequence, the critical value of the test statistic is smaller using a one-tailed test, meaning that it has more power to detect an effect. Having said that, in most applications, we would like to be able catch effects in both directions, simply because we can often not rule out that an effect might exist that is not in the hypothesized direction. For example, if we would conduct a one-tailed test for a mean larger than some specified value but the mean turns out to be substantially smaller, then testing a one-directional hypothesis ($H_0: \mu \le \mu_0 $) would not allow us to conclude that there is a significant effect because there is not rejection at this end of the distribution.   

As we have seen, the process of hypothesis testing consists of various steps:

1. Formulate null and alternative hypotheses
2. Select an appropriate test
3. Choose the level of significance ($\alpha$)
4. Descriptive statistics and data visualization
5. Conduct significance test
6. Report results and draw a marketing conclusion

In the following, we will go through the individual steps using examples for different tests. 

## One sample t-test

The example we used in the introduction was an example of the **one sample t-test** and we computed all statistics by hand to explain the underlying intuition. When you conduct hypothesis tests using R, you do not need to calculate these statistics by hand, since there are build-in routines to conduct the steps for you. Let us use the same example again to see how you would conduct hypothesis tests in R.  

**1. Formulate null and alternative hypotheses**

The null hypothesis states that there is no difference between the true population mean $\mu$ and the hypothesized value (i.e., $10$), while the alternative hypothesis states the opposite: 

$$
H_0: \mu = 10 \\
H_1: \mu \neq 10
$$

**2. Select an appropriate test**

Because we would like to test if the mean of a variable is different from a specified threshold, the one-sample t-test is appropriate. The assumptions of the test are 1) that the variable is measured using an interval or ratio scale, and 2) that the sampling distribution is normal. Both assumptions are met since 1) listening time is a ratio scale, and 2) we deem the sample size (n = 50) large enough to assume a normal sampling distribution according to the central limit theorem.  

**3. Choose the level of significance**

We choose the conventional 5% significance level. 

**4. Descriptive statistics and data visualization**

Provide descriptive statistics using the ```describe()``` function: 


```r
library(psych)
psych::describe(student_sample)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["vars"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["n"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["mean"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["sd"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["median"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["trimmed"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["mad"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["min"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["max"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["range"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["skew"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["kurtosis"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[13],"type":["dbl"],"align":["right"]}],"data":[{"1":"1","2":"50","3":"11457.94","4":"7943.54","5":"10494","6":"11277.4","7":"9759.215","8":"114","9":"24979","10":"24865","11":"0.179127","12":"-1.324842","13":"1123.386"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

From this, we can already see that the mean is different from the hypothesized value. The question however remains, whether this difference is significantly different, given the sample size and the variability in the data. Since we only have one continuous variable, we can visualize the distribution in a histogram. 


```r
ggplot(music_listening_sample) + geom_histogram(aes(x = hours),
    fill = "white", color = "black", bins = 20) + theme_bw() +
    labs(title = "Distribution of values in the sample",
        x = "Hours", y = "Frequency")
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-17-1.png" width="672" />

**5. Conduct significance test**

In the beginning of the chapter, we saw, how you could conduct significance test by hand. However, R has built-in routines that you can use to conduct the analyses. The ```t.test()``` function can be used to conduct the test. To test if the listening time among WU students was 10, you can use the following code:


```r
H_0 <- 10
t.test(music_listening_sample$hours, mu = H_0, alternative = "two.sided")
```

```
## 
## 	One Sample t-test
## 
## data:  music_listening_sample$hours
## t = 4.842, df = 49, p-value = 0.00001327
## alternative hypothesis: true mean is not equal to 10
## 95 percent confidence interval:
##  15.02606 22.15783
## sample estimates:
## mean of x 
##  18.59194
```

Note that if you would have stated a directional hypothesis (i.e., the mean is either greater or smaller than 10 hours), you could easily amend the code to conduct a one sided test by changing the argument ```alternative```from ```'two.sided'``` to either ```'less'``` or ```'greater'```.

Note that you could also combine the results from the statistical test and the visualization using the `ggstatsplot` package as follows. 


```r
library(ggstatsplot)
gghistostats(
  data = music_listening_sample, # dataframe from which variable is to be taken
  x = hours, # numeric variable whose distribution is of interest
  title = "Distribution of listening times", # title for the plot
  caption = "Notes: Test based on a random sample of 50 students.",
  type = "parametric", # one sample t-test
  conf.level = 0.95, # changing confidence level for effect size
  bar.measure = "mix", # what does the bar length denote
  test.value = 10, # default value is 0
  test.value.line = TRUE, # display a vertical line at test value
  effsize.type = "d", # display effect size (Cohen's d in output)
  test.value.color = "#0072B2", # color for the line for test value
  centrality.para = "mean", # which measure of central tendency is to be plotted
  centrality.color = "darkred", # decides color for central tendency line
  binwidth = 2, # binwidth value (experiment)
  messages = FALSE, # turn off the messages
  bf.message = FALSE
)
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />

You may nice some additional output in this plot related to the measure of effect size (Cohen's d). Don't worry about it at this stage, we will come back to this later in this chapter. 

**6. Report results and draw a marketing conclusion**

Note that the results are the same as above, when we computed the test by hand. You could summarize the results as follows:

On average, the listening times in our sample were different form 10 hours per month (Mean = 18.59 hours, SE = 1.77). This difference was significant t(49) = 4.842, p < .05 (95% CI = [15.03; 22.16]). Based on this evidence, we can conclude that the mean in our sample is significantly lower compared to the hypothesized population mean of $10$ hours, providing evidence against the null hypothesis. 

Note that in the reporting above, the number ```49``` in parenthesis refers to the degrees of freedom that are available from the output. 


## Comparing two means

In the one-sample test above, we tested the hypothesis that the population mean has some specific value $\mu_0$ using data from only one sample. In marketing (as in many other disciplines), you will often be confronted with a situation where you wish to compare the means of two groups. For example, you may conduct an experiment and randomly split your sample into two groups, one of which receives a treatment (experimental group) while the other doesn't (control group). In this case, the units (e.g., participants, products) in each group are different ('between-subjects design') and the samples are said to be independent. Hence, we would use a **independent-means t-test**. If you run an experiment with two experimental conditions and the same units (e.g., participants, products) were observed in both experimental conditions, the sample is said to be dependent in the sense that you have the same units in each group ('within-subjects design'). In this case, we would need to conduct an **dependent-means t-test**. Both tests are described in the following sections, beginning with the independent-means t-test.      

### Independent-means t-test

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/7APeiQ3_46A" frameborder="0" allowfullscreen></iframe>
</div>
<br>

Using an independent-means t-test, we can compare the means of two possibly different populations. It is, for example, quite common for online companies to test new service features by running an experiment and randomly splitting their website visitors into two groups: one is exposed to the website with the new feature (experimental group) and the other group is not exposed to the new feature (control group). This is a typical A/B-Test scenario.

As an example, imagine that a music streaming service would like to introduce a new playlist feature that let's their users access playlists created by other users. The goal is to analyze how the new service feature impacts the listening time of users. The service randomly splits a representative subset of their users into two groups and collects data about their listening times over one month. Let's create a data set to simulate such a scenario. 

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["hours"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["group"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"2","2":"A"},{"1":"27","2":"A"},{"1":"25","2":"A"},{"1":"2","2":"A"},{"1":"46","2":"A"},{"1":"13","2":"A"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


```r
hours_a_b <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/hours_a_b.csv",
    sep = ",", header = TRUE)
head(hours_a_b)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["hours"],"name":[1],"type":["int"],"align":["right"]},{"label":["group"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"2","2":"A"},{"1":"27","2":"A"},{"1":"25","2":"A"},{"1":"2","2":"A"},{"1":"46","2":"A"},{"1":"13","2":"A"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

This data set contains two variables: the variable ```hours``` indicates the music listening times (in hours) and the variable ```group``` indicates from which group the observation comes, where 'A' refers to the control group (with the standard service) and 'B' refers to the experimental group (with the new playlist feature). Let's first look at the descriptive statistics by group using the ```describeBy``` function:


```r
library(psych)
describeBy(hours_a_b$hours, hours_a_b$group)
```

```
## 
##  Descriptive statistics by group 
## group: A
##    vars  n  mean   sd median trimmed   mad min max range skew kurtosis   se
## X1    1 98 18.11 12.1     15   16.88 10.38   2  65    63 1.08     1.21 1.22
## ------------------------------------------------------------ 
## group: B
##    vars   n mean    sd median trimmed   mad min max range skew kurtosis  se
## X1    1 112 28.5 17.97   24.5   26.56 15.57   1  83    82 0.96     0.82 1.7
```

From this, we can already see that there is a difference in means between groups A and B. We can also see that the number of observations is different, as is the standard deviation. The question that we would like to answer is whether there is a significant difference in mean listening times between the groups. Remember that different users are contained in each group ('between-subjects design') and that the observations in one group are independent of the observations in the other group. Before we will see how you can easily conduct an independent-means t-test, let's go over some theory first.

#### Theory

As a starting point, let us label the unknown population mean of group A (control group) in our experiment $\mu_1$, and that of group B (experimental group) $\mu_2$. In this setting, the null hypothesis would state that the mean in group A is equal to the mean in group B:

$$
H_0: \mu_1=\mu_2
$$

This is equivalent to stating that the difference between the two groups ($\delta$) is zero:

$$
H_0: \mu_1 - \mu_2=0=\delta
$$

That is, $\delta$ is the new unknown population parameter, so that the null and alternative hypothesis become:   

$$
H_0: \delta = 0 \\
H_1: \delta \ne 0
$$

Remember that we usually don't have access to the entire population so that we can not observe $\delta$ and have to estimate is from a sample statistic, which we define as $d = \bar x_1-\bar x_2$, i.e., the difference between the sample means from group a ($\bar x_1$) and group b ($\bar x_2$). But can we really estimate $d$ from $\delta$? Remember from the previous chapter, that we could estimate $\mu$ from $\bar x$, because if we (hypothetically) take a larger number of samples, the distribution of the means of these samples (the sampling distribution) will be normally distributed and its mean will be (in the limit) equal to the population mean. It turns out that we can use the same underlying logic here. The above samples were drawn from two different populations with $\mu_1$ and $\mu_2$. Let us compute the difference in means between these two populations:       


```r
delta_pop <- mean(hours_population_1) - mean(hours_population_2)
delta_pop
```

```
## [1] -7.422855
```

This means that the true difference between the mean listening times of groups a and b is -7.42. Let us now repeat the exercise from the previous chapter: let us repeatedly draw a large number of $20,000$ random samples of 100 users from each of these populations, compute the difference (i.e., $d$, our estimate of $\delta$), store the difference for each draw and create a histogram of $d$.


```r
set.seed(321)
hours_population_1 <- rgamma(25000, shape = 2, scale = 10)
hours_population_2 <- rgamma(25000, shape = 2.5, scale = 11)

samples <- 20000
mean_delta <- matrix(NA, nrow = samples)
for (i in 1:samples) {
    student_sample <- sample(1:25000, size = 100, replace = FALSE)
    mean_delta[i, ] <- mean(hours_population_1[student_sample]) -
        mean(hours_population_2[student_sample])
}

ggplot(data.frame(mean_delta)) + geom_histogram(aes(x = mean_delta),
    bins = 30, fill = "white", color = "black") + theme_bw() +
    theme(legend.title = element_blank()) + geom_vline(aes(xintercept = mean(mean_delta)),
    size = 1) + xlab("d") + ggtitle(TeX(sprintf("%d samples; $d_{\\bar{x}}$ = %.2f",
    samples, round(mean(mean_delta), 2))))
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-24-1.png" width="672" />

This gives us the sampling distribution of the mean differences between the samples. You will notice that this distribution follows a normal distribution and is centered around the true difference between the populations. This means that, on average, the difference between two sample means $d$ is a good estimate of $\delta$. In our example, the difference between $\bar x_1$ and $\bar x_2$ is:


```r
mean_x1 <- mean(hours_a_b[hours_a_b$group == "A", "hours"])
mean_x1
```

```
## [1] 18.11224
```

```r
mean_x2 <- mean(hours_a_b[hours_a_b$group == "B", "hours"])
mean_x2
```

```
## [1] 28.5
```

```r
d <- mean_x1 - mean_x2
d
```

```
## [1] -10.38776
```

Now that we have $d$ as an estimate of $\delta$, how can we find out if the observed difference is significantly different from the null hypothesis (i.e., $\delta = 0$)?

Recall from the previous section, that the standard deviation of the sampling distribution $\sigma_{\bar x}$ (i.e., the standard error) gives us indication about the precision of our estimate. Further recall that the standard error can be calculated as $\sigma_{\bar x}={\sigma \over \sqrt{n}}$. So how can we calculate the standard error of the difference between two population means? According to the **variance sum law**, to find the variance of the sampling distribution of differences, we merely need to add together the variances of the sampling distributions of the two populations that we are comparing. To find the standard error, we only need to take the square root of the variance (because the standard error is the standard deviation of the sampling distribution and the standard deviation is the square root of the variance), so that we get:

$$
\sigma_{\bar x_1-\bar x_2} = \sqrt{{\sigma_1^2 \over n_1}+{\sigma_2^2 \over n_2}}
$$

But recall that we don't actually know the true population standard deviation, so we use $SE_{\bar x_1-\bar x_2}$ as an estimate of $\sigma_{\bar x_1-\bar x_2}$:

$$
SE_{\bar x_1-\bar x_2} = \sqrt{{s_1^2 \over n_1}+{s_2^2 \over n_2}}
$$

Hence, for our example, we can calculate the standard error as follows: 


```r
n1 <- 98
n2 <- 112
s1 <- var(hours_a_b[hours_a_b$group == "A", "hours"])
s1
```

```
## [1] 146.4924
```

```r
s2 <- var(hours_a_b[hours_a_b$group == "B", "hours"])
s2
```

```
## [1] 322.9189
```

```r
SE_x1_x2 <- sqrt(s1/n1 + s2/n2)
SE_x1_x2
```

```
## [1] 2.092373
```

Recall from above that we can calculate the t-statistic as:

$$
t= {\bar x - \mu_0 \over {s \over \sqrt{n}}} 
$$

Exchanging $\bar x$ for $d$, we get

$$
t= {(\bar{x}_1 - \bar{x}_2) - (\mu_1 - \mu_2) \over {\sqrt{{s_1^2 \over n_1}+{s_2^2 \over n_2}}}} 
$$

Note that according to our hypothesis $\mu_1-\mu_2=0$, so that we can calculate the t-statistic as: 


```r
t_score <- d/SE_x1_x2
t_score
```

```
## [1] -4.964581
```

Following the example of our one sample t-test above, we would now need to compare this calculated test statistic to a critical value in order to assess if $d$ is sufficiently far away from the null hypothesis to be statistically significant. To do this, we would need to know the exact t-distribution, which depends on the degrees of freedom. The problem is that deriving the degrees of freedom in this case is not that obvious. If we were willing to assume that $\sigma_1=\sigma_2$, the correct t-distribution has $n_1 -1 + n_2-1$ degrees of freedom (i.e., the sum of the degrees of freedom of the two samples). However, because in real life we don not know if $\sigma_1=\sigma_2$, we need to account for this additional uncertainty. We will not go into detail here, but R automatically uses a sophisticated approach to correct the degrees of freedom called the Welch's correction, as we will see in the subsequent application. 

#### Application

The section above explained the theory behind the independent-means t-test and showed how to compute the statistics manually. Obviously you don't have to compute these statistics by hand in this section shows you how to conduct an independent-means t-test in R using the example from above.  

**1. Formulate null and alternative hypotheses**

We wish to analyze whether there is a significant difference in music listening times between groups A and B. So our null hypothesis is that the means from the two populations are the same (i.e., there is no difference), while the alternative hypothesis states the opposite:   

$$
H_0: \mu_1=\mu_2\\
H_1: \mu_1 \ne \mu_2
$$

**2. Select an appropriate test**

Since we have a ratio scaled variable (i.e., listening times) and two independent groups, where the mean of one sample is independent of the group of the second sample (i.e., the groups contain different units), the independent-means t-test is appropriate. 

**3. Choose the level of significance**

We choose the conventional 5% significance level. 

**4. Descriptive statistics and data visualization**

We can compute the descriptive statistics for each group separately, using the ```describeBy()``` function:


```r
library(psych)
describeBy(hours_a_b$hours, hours_a_b$group)
```

```
## 
##  Descriptive statistics by group 
## group: A
##    vars  n  mean   sd median trimmed   mad min max range skew kurtosis   se
## X1    1 98 18.11 12.1     15   16.88 10.38   2  65    63 1.08     1.21 1.22
## ------------------------------------------------------------ 
## group: B
##    vars   n mean    sd median trimmed   mad min max range skew kurtosis  se
## X1    1 112 28.5 17.97   24.5   26.56 15.57   1  83    82 0.96     0.82 1.7
```

This already shows us that the mean between groups A and B are different. We can visualize the data using a boxplot and a histogram. 


```r
ggplot(hours_a_b, aes(x = group, y = hours)) + geom_boxplot() +
    geom_jitter(alpha = 0.2, color = "red") + labs(x = "Group",
    y = "Listening time (hours)") + ggtitle("Boxplot of listening times") +
    theme_bw()
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-29-1.png" width="672" />

```r
ggplot(hours_a_b, aes(hours)) + geom_histogram(col = "black",
    fill = "darkblue") + labs(x = "Listening time (hours)",
    y = "Frequency") + ggtitle("Histogram of listening times") +
    facet_wrap(~group) + theme_bw()
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-29-2.png" width="672" />

**5. Conduct significance test**

To conduct the independent means t-test, we can use the ```t.test()``` function:


```r
t.test(hours ~ group, data = hours_a_b, mu = 0, alternative = "two.sided",
    conf.level = 0.95, var.equal = FALSE)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  hours by group
## t = -4.9646, df = 195.73, p-value = 0.000001494
## alternative hypothesis: true difference in means between group A and group B is not equal to 0
## 95 percent confidence interval:
##  -14.514246  -6.261264
## sample estimates:
## mean in group A mean in group B 
##        18.11224        28.50000
```

Again, we could combine the results of the statistical test and the visualization using the `ggstatsplot` package. 


```r
library(ggstatsplot)
ggbetweenstats(
  data = hours_a_b,
  plot.type = "box",
  x = group, # 2 groups
  y = hours ,
  type = "p", # default
  effsize.type = "d", # display effect size (Cohen's d in output)
  messages = FALSE,
  bf.message = FALSE,
  mean.ci = TRUE,
  title = "Mean listening times for different groups"
)
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-31-1.png" width="672" style="display: block; margin: auto;" />

**6. Report results and draw a marketing conclusion**

The results showed that listening times were higher in the experimental group (Mean = 28.50, SE = 1.70) compared to the control group (Mean = 18.11, SE = 1.22). This means that the listening times were 10.39 hours higher on average in the experimental group, compared to the control group. An independent-means t-test showed that this difference is significant t(195.73) = 4.96, p < .05 (95% CI = [6.26, 14.51]).


### Dependent-means t-test

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/vIcrWJ6sJu8" frameborder="0" allowfullscreen></iframe>
</div>
<br>

While the independent-means t-test is used when different units (e.g., participants, products) were assigned to the different condition, the **dependent-means t-test** is used when there are two experimental conditions and the same units (e.g., participants, products) were observed in both experimental conditions.

Imagine, for example, a slightly different experimental setup for the above experiment. Imagine that we do not assign different users to the groups, but that a sample of 100 users gets to use the music streaming service with the new feature for one month and we compare the music listening times of these users during the month of the experiment with the listening time in the previous month. Let us generate data for this example: 

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["hours_a"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["hours_b"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"2","2":"24"},{"1":"27","2":"21"},{"1":"25","2":"51"},{"1":"2","2":"12"},{"1":"46","2":"54"},{"1":"13","2":"18"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


```r
hours_a_b_paired <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/hours_a_b_paired.csv",
    sep = ",", header = TRUE)
head(hours_a_b_paired)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["hours_a"],"name":[1],"type":["int"],"align":["right"]},{"label":["hours_b"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"2","2":"24"},{"1":"27","2":"21"},{"1":"25","2":"51"},{"1":"2","2":"12"},{"1":"46","2":"54"},{"1":"13","2":"18"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Note that the data set has almost the same structure as before only that we know have two variables representing the listening times of each user in the month before the experiment and during the month of the experiment when the new feature was tested.

#### Theory

In this case, we want to test the hypothesis that there is no difference in mean the mean listening times between the two months. This can be expressed as follows:

$$
H_0: \mu_D = 0 \\
$$
Note that the hypothesis only refers to one population, since both observations come from the same units (i.e., users). To use consistent notation, we replace $\mu_D$ with $\delta$ and get:

$$
H_0: \delta = 0 \\
H_1: \delta \neq 0
$$

where $\delta$ denotes the difference between the observed listening times from the two consecutive months **of the same users**. As is the previous example, since we do not observe the entire population, we estimate $\delta$ based on the sample using $d$, which is the difference in mean listening time between the two months for our sample. Note that we assume that everything else (e.g., number of new releases) remained constant over the two month to keep it simple. We can show as above that the sampling distribution follows a normal distribution with a mean that is (in the limit) the same as the population mean. This means, again, that the difference in sample means is a good estimate for the difference in population means. Let's compute a new variable $d$, which is the difference between two month. 


```r
hours_a_b_paired$d <- hours_a_b_paired$hours_a - hours_a_b_paired$hours_b
head(hours_a_b_paired)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["hours_a"],"name":[1],"type":["int"],"align":["right"]},{"label":["hours_b"],"name":[2],"type":["int"],"align":["right"]},{"label":["d"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"2","2":"24","3":"-22"},{"1":"27","2":"21","3":"6"},{"1":"25","2":"51","3":"-26"},{"1":"2","2":"12","3":"-10"},{"1":"46","2":"54","3":"-8"},{"1":"13","2":"18","3":"-5"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Note that we now have a new variable, which is the difference in listening times (in hours) between the two months. The mean of this difference is:


```r
mean_d <- mean(hours_a_b_paired$d)
mean_d
```

```
## [1] -11.65
```

Again, we use $SE_{\bar x}$ as an estimate of $\sigma_{\bar x}$:

$$
SE_{\bar d}={s \over \sqrt{n}}
$$
Hence, we can compute the standard error as:


```r
n <- nrow(hours_a_b_paired)
SE_d <- sd(hours_a_b_paired$d)/sqrt(n)
SE_d
```

```
## [1] 2.151503
```

The test statistic is therefore:

$$
t = {\bar d-  \mu_0 \over SE_{\bar d}}
$$
on 99 (i.e., n-1) degrees of freedom. Now we can compute the t-statistic as follows:


```r
t_score <- mean_d/SE_d
t_score
```

```
## [1] -5.41482
```

```r
qt(0.975, df = 99)
```

```
## [1] 1.984217
```

Note that in the case of the dependent-means t-test, we only base our hypothesis on one population and hence there is only one population variance. This is because in the dependent sample test, the observations come from the same observational units (i.e., users). Hence, there is no unsystematic variation due to potential differences between users that were assigned to the experimental groups. This means that the influence of unobserved factors (unsystematic variation) relative to the variation due to the experimental manipulation (systematic variation) is not as strong in the dependent-means test compared to the independent-means test and we don't need to correct for differences in the population variances. 

#### Application

Again, we don't have to compute all this by hand since the ```t.test(...)``` function can be used to do it for us. Now we have to use the argument ```paired=TRUE``` to let R know that we are working with dependent observations. 

**1. Formulate null and alternative hypotheses**

We would like to the test if there is a difference in music listening times between the two consecutive months, so our null hypothesis is that there is no difference, while the alternative hypothesis states the opposite:

$$
H_0: \mu_D = 0 \\
H_0: \mu_D \ne 0
$$

**2. Select an appropriate test**

Since we have a ratio scaled variable (i.e., listening times) and two observations of the same group of users (i.e., the groups contain the same units), the dependent-means t-test is appropriate. 

**3. Choose the level of significance**

We choose the conventional 5% significance level. 

**4. Descriptive statistics and data visualization**

We can compute the descriptive statistics for each month separately, using the ```describe()``` function:


```r
library(psych)
describe(hours_a_b_paired)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["vars"],"name":[1],"type":["int"],"align":["right"]},{"label":["n"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["mean"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["sd"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["median"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["trimmed"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["mad"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["min"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["max"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["range"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["skew"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["kurtosis"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[13],"type":["dbl"],"align":["right"]}],"data":[{"1":"1","2":"100","3":"17.93","4":"12.06988","5":"15","6":"16.5875","7":"10.3782","8":"2","9":"65","10":"63","11":"1.0913320","12":"1.2549609","13":"1.206988"},{"1":"2","2":"100","3":"29.58","4":"18.41562","5":"25","6":"27.6250","7":"17.0499","8":"3","9":"83","10":"80","11":"0.8966967","12":"0.5662360","13":"1.841562"},{"1":"3","2":"100","3":"-11.65","4":"21.51503","5":"-9","6":"-10.6000","7":"19.2738","8":"-76","9":"51","10":"127","11":"-0.3750444","12":"0.7209769","13":"2.151503"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

This already shows us that the mean between the two months are different. We can visiualize the data using a plot of means, boxplot, and a histogram. 

To plot the data, we need to do some restructuring first, since the variables are now stored in two different columns ("hours_a" and "hours_b"). This is also known as the "wide" format. To plot the data we need all observations to be stored in one variable. This is also known as the "long" format. We can use the ```melt(...)``` function from the ```reshape2```package to "melt" the two variable into one column to plot the data. 


```r
library(reshape2)
hours_a_b_paired_long <- melt(hours_a_b_paired[, c("hours_a",
    "hours_b")])
names(hours_a_b_paired_long) <- c("group", "hours")
head(hours_a_b_paired_long)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["group"],"name":[1],"type":["fct"],"align":["left"]},{"label":["hours"],"name":[2],"type":["int"],"align":["right"]}],"data":[{"1":"hours_a","2":"2"},{"1":"hours_a","2":"27"},{"1":"hours_a","2":"25"},{"1":"hours_a","2":"2"},{"1":"hours_a","2":"46"},{"1":"hours_a","2":"13"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Now we are ready to plot the data:


```r
ggplot(hours_a_b_paired_long, aes(x = group, y = hours)) +
    geom_boxplot() + geom_jitter(alpha = 0.2, color = "red") +
    labs(x = "Group", y = "Listening time (hours)") +
    ggtitle("Boxplot of listening times") + theme_bw()
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-40-1.png" width="672" />

```r
ggplot(hours_a_b_paired_long, aes(hours)) + geom_histogram(col = "black",
    fill = "darkblue") + labs(x = "Listening time (hours)",
    y = "Frequency") + ggtitle("Histogram of listening times") +
    facet_wrap(~group) + theme_bw()
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-40-2.png" width="672" />

**5. Conduct significance test**

To conduct the independent means t-test, we can use the ```t.test()``` function with the argument ```paired = TRUE```:


```r
t.test(hours_a_b_paired$hours_a, hours_a_b_paired$hours_b,
    mu = 0, alternative = "two.sided", conf.level = 0.95,
    paired = TRUE)
```

```
## 
## 	Paired t-test
## 
## data:  hours_a_b_paired$hours_a and hours_a_b_paired$hours_b
## t = -5.4148, df = 99, p-value = 0.00000043
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -15.919048  -7.380952
## sample estimates:
## mean of the differences 
##                  -11.65
```
Again, we could combine the results of the statistical test and the visualization using the `ggstatsplot` package. 


```r
library(ggstatsplot)
ggwithinstats(
  data = hours_a_b_paired_long,
  x = group,
  y = hours,
  path.point = FALSE,
  path.mean = TRUE,
  sort = "descending", # ordering groups along the x-axis based on
  sort.fun = median, # values of `y` variable
  title = "Mean listening times for different treatments",
  messages = FALSE,
  bf.message = FALSE,
  mean.ci = TRUE,
  effsize.type = "d" # display effect size (Cohen's d in output)
)
```

<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-42-1.png" width="672" style="display: block; margin: auto;" />

**6. Report results and draw a marketing conclusion**

On average, the same users used the service more when it included the new feature (M = 29.58, SE = 1.84) compared to the service without the feature (M = 17.93, SE = 1.21). This difference was significant t(99) = 5.41, p < .05 (95% CI = [7.38, 15.91]).


## NHST considerations 

<br>
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/ctwQn6YYUBM" frameborder="0" allowfullscreen></iframe>
</div>
<br>

### Type I and Type II Errors

When choosing the level of significance ($\alpha$). It is important to note that the choice of the significance level affects the type 1 and type 2 error:

* Type I error: When we believe there is a genuine effect in our population, when in fact there isn't. Probability of type I error ($\alpha$) = level of significance.
* Type II error: When we believe that there is no effect in the population, when in fact there is. 

This following table shows the possible outcomes of a test (retain vs. reject $H_0$), depending on whether $H_0$ is true or false in reality.

&nbsp; | Retain <b>H<sub>0</sub></b>	 | Reject <b>H<sub>0</sub></b>	
--------------- | -------------------------------------- | --------------------------------------
<b>H<sub>0</sub> is true</b>  | Correct decision:<br>1-&alpha; (probability of correct retention); | Type 1 error:<br> &alpha; (level of significance)
<b>H<sub>0</sub> is false</b>  | Type 2 error:<br>&beta; (type 2 error rate) | Correct decision:<br>1-&beta; (power of the test)

### Significance level, sample size, power, and effect size

When you plan to conduct an experiment, there are some factors that are under direct control of the researcher:

* **Significance level ($\alpha$)**: The probability of finding an effect that does not genuinely exist.
* **Sample size (n)**: The number of observations in each group of the experimental design.

Unlike &alpha; and n, which are specified by the researcher, the magnitude of &beta; depends on the actual value of the population parameter. In addition, &beta; is influenced by the effect size (e.g., Cohen’s d), which can be used to determine a standardized measure of the magnitude of an observed effect. The following parameters are affected more indirectly:

* **Power (1-&beta;)**: The probability of finding an effect that does genuinely exists. 
* **Effect size (d)**: Standardized measure of the effect size under the alternate hypothesis. 

Although &beta; is unknown, it is related to &alpha;. For example, if we would like to be absolutely sure that we do not falsely identify an effect which does not exist (i.e., make a type I error), this means that the probability of identifying an effect that does exist (i.e., 1-&beta;) decreases and vice versa. Thus, an extremely low value of &alpha; (e.g., &alpha; = 0.0001) will result in intolerably high &beta; errors. A common approach is to set &alpha;=0.05 and &beta;=0.80. 

Unlike the t-value of our test, the effect size (d) is unaffected by the sample size and can be categorized as follows (see Cohen, J. 1988): 

* 0.2 (small effect)
* 0.5 (medium effect)
* 0.8 (large effect)

In order to test more subtle effects (smaller effect sizes), you need a larger sample size compared to the test of more obvious effects. In <a href="https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2205186" target="_blank">this paper</a>, you can find a list of examples for different effect sizes and the number of observations you need to reliably find an effect of that magnitude. Although the exact effect size is unknown before the experiment, you might be able to make a guess about the effect size (e.g., based on previous studies).   

If you wish to obtain a standardized measure of the effect, you may compute the effect size (Cohen's d) using the ```cohensD()``` function from the ```lsr``` package. Using the examples from the independent-means t-test above, we would use: 


```r
library(lsr)
cohensD(hours ~ group, data = hours_a_b)
```

```
## [1] 0.6696301
```

According to the thresholds defined above, this effect would be judged to be a small-medium effect.

For the dependent-means t-test, we would use: 


```r
cohensD(hours_a_b_paired$hours_a, hours_a_b_paired$hours_b,
    method = "paired")
```

```
## [1] 0.541482
```

According to the thresholds defined above, this effect would also be judged to be a small-medium effect.

When constructing an experimental design, your goal should be to maximize the power of the test while maintaining an acceptable significance level and keeping the sample as small as possible. To achieve this goal, you may use the ```pwr``` package, which let's you compute ```n```, ```d```, ```alpha```, and ```power```. You only need to specify three of the four input variables to get the fourth.

For example, what sample size do we need (per group) to identify an effect with d = 0.6, &alpha; = 0.05, and power = 0.8:


```r
library(pwr)
pwr.t.test(d = 0.6, sig.level = 0.05, power = 0.8,
    type = c("two.sample"), alternative = c("two.sided"))
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 44.58577
##               d = 0.6
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

Or we could ask, what is the power of our test with 51 observations in each group, d = 0.6, and &alpha; = 0.05:


```r
pwr.t.test(n = 51, d = 0.6, sig.level = 0.05, type = c("two.sample"),
    alternative = c("two.sided"))
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 51
##               d = 0.6
##       sig.level = 0.05
##           power = 0.850985
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

### P-values, stopping rules and p-hacking

From my experience, students tend to place a lot of weight on p-values when interpreting their research findings. It is therefore important to note some points that hopefully help to put the meaning of a "significant" vs. "insignificant" test result into perspective. So what does a significant test result actually tell us? 

* The importance of an effect? &rarr; No, significance depends on sample size.
* That the null hypothesis is false? &rarr; No, it is always false.
* That the null hypothesis is true? &rarr; No, it is never true.

It is important to understand what the p-value actually tells you. 

::: {.infobox_orange .hint data-latex="{hint}"}
A p-value of < 0.05 means that the probability of finding a difference of at least the observed magnitude is less than 5% if the null hypothesis was true. In other words, if there really wouldn't be a difference between the groups, it tells you the probability of observing the difference that you found in your data (or more extreme differences).  
:::

The following points provide some guidance on how to interpret significant and insignificant test results. 

**Significant result**

* Even if the probability of the effect being a chance result is small (e.g., less than .05) it doesn't necessarily mean that the effect is important.
* Very small and unimportant effects can turn out to be statistically significant if the sample size is large enough. 

**Insignificant result**

* If the probability of the effect occurring by chance is large (greater than .05), the alternative hypothesis is rejected. However, this does not mean that the null hypothesis is true.
* Although an effect might not be large enough to be anything other than a chance finding, it doesn't mean that the effect is zero.
* In fact, two random samples will always have slightly different means that would deemed to be statistically significant if the samples were large enough.   

Thus, you should not base your research conclusion on p-values alone!

It is also crucial to **determine the sample size before you run the experiment** or before you start your analysis. Why? Consider the following example:

* You run an experiment
* After each respondent you analyze the data and look at the mean difference between the two groups with a t-test
* You stop when you have a significant effect

This is called p-hacking and should be avoided at all costs. Assuming that both groups come from the same population (i.e., there is **no difference** in the means): What is the likelihood that the result will be significant at some point? In other words, what is the likelihood that you will draw the wrong conclusion from your data that there is an effect, while there is none? This is shown in the following graph using simulated data - the color red indicates significant test results that arise although there is no effect (i.e., false positives).  

<div class="figure" style="text-align: center">
<img src="07-hypothesis_testing_files/figure-html/unnamed-chunk-47-1.png" alt="p-hacking (red indicates false positives)" width="672" />
<p class="caption">(\#fig:unnamed-chunk-47)p-hacking (red indicates false positives)</p>
</div>

