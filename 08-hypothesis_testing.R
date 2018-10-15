## ---- echo=FALSE, warning=FALSE------------------------------------------
library(knitr)
#This code automatically tidies code so that it does not reach over the page
opts_chunk$set(tidy.opts=list(width.cutoff=50),tidy=TRUE, rownames.print = FALSE, rows.print = 10)
options(scipen = 999, digits = 7)

## ---- message = FALSE, warning=FALSE-------------------------------------
library(tidyverse)
library(ggplot2)
library(latex2exp)
set.seed(321)
hours <- rgamma(25000, shape = 2, scale = 10)
ggplot(data.frame(hours)) +
  geom_histogram(aes(x = hours), bins = 30, fill='white', color='black') +
    geom_vline(xintercept = mean(hours), size = 1)  +  theme_bw() +
  labs(title = "Histogram of listening times",
       subtitle = TeX(sprintf("Population mean ($\\mu$) = %.2f; population standard deviation ($\\sigma$) = %.2f",round(mean(hours),2),round(sd(hours),2))),
       y = 'Number of students', 
       x = 'Hours') 

## ------------------------------------------------------------------------
mean_pop <- mean(hours)
sigma <- sd(hours) #population standard deviation
n <- 50 #sample size
standard_error <- sigma/sqrt(n) #standard error
standard_error

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 4, fig.width = 8----
library(latex2exp)
H_0 <- 10
p1 <- 0.025
p2 <- 0.975
min <- 0
max <- 20
norm1 <- round(qnorm(p1), digits = 3)
norm2 <- round(qnorm(p2), digits = 3)
ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dnorm, args = list(mean = H_0, sd = standard_error)) + 
  stat_function(fun = dnorm, args = list(mean = H_0, sd = standard_error), xlim = c(min, qnorm(p1, mean = H_0, sd = standard_error)), geom = "area") +
  stat_function(fun = dnorm, args = list(mean = H_0, sd = standard_error), xlim = c(max, qnorm(p2, mean = H_0, sd = standard_error)), geom = "area") +
  scale_x_continuous(breaks=c(0,qnorm(p1, mean = H_0, sd = standard_error),10,qnorm(p2, mean = H_0, sd = standard_error),20), labels=c("0",TeX(sprintf("%.2f $* \\sigma_{\\bar x}$",qnorm(p1))),"10",TeX(sprintf("%.2f $* \\sigma_{\\bar x}$",qnorm(p2))),"20")) +
  labs(title = TeX(sprintf("Theoretical density given null hypothesis $\\mu_0=$ 10 ($\\sigma_{\\bar x}$ = %.2f)",standard_error)),x = "Hours", y = "Density") +
  theme(legend.position="none") + 
  theme_bw()

## ------------------------------------------------------------------------
set.seed(12567)
student_sample <- sample(1:25000, size = 50, replace = FALSE)
student_sample <- hours[student_sample]
mean_sample <- mean(student_sample)
ggplot(data.frame(student_sample)) + 
  geom_histogram(aes(x = student_sample), fill = 'white', color = 'black', bins = 20) +
  theme_bw() +  geom_vline(xintercept = mean(student_sample), color = 'black', size=1) +
  labs(title = TeX(sprintf("Distribution of values in the sample ($n =$ %.0f, $\\bar{x] = $ %.2f, s = %.2f)",n,mean(student_sample),sd(student_sample))),x = "Hours", y = "Frequency") 

## ------------------------------------------------------------------------
z_score <- (mean_sample - H_0)/(sigma/sqrt(n))
z_score

## ------------------------------------------------------------------------
z_crit <- qnorm(0.975)
z_crit

## ------------------------------------------------------------------------
abs(z_score) > abs(z_crit)

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 8, fig.width = 8----
library(cowplot)
library(gridExtra)
library(grid)

df <- 5
p1 <- 0.025
p2 <- 0.975
min <- -5
max <- 5
t1 <- round(qt(p1, df = df), digits = 3)
t2 <- round(qt(p2, df = df), digits = 3)
plot1 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dnorm, color = "grey") + 
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min, qt(p1, df = df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max, qt(p2, df = df)), geom = "area") +
  stat_function(fun = dnorm, color = "grey") + 
  scale_x_continuous(breaks = c(t1, 0, t2)) +
    labs(title = paste0("df= ", df),x = "x", y = "Density") +
  theme(legend.position="none") + 
  theme_bw()

df <- 10
p1 <- 0.025
p2 <- 0.975
min <- -5
max <- 5
t1 <- round(qt(p1, df = df), digits = 3)
t2 <- round(qt(p2, df = df), digits = 3)
plot2 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dnorm, color = "grey") + 
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min, qt(p1, df = df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max, qt(p2, df = df)), geom = "area") +
  scale_x_continuous(breaks = c(t1, 0, t2)) +
    labs(title = paste0("df= ",df),x = "x", y = "Density") +
  theme(legend.position = "none") + 
  theme_bw()

df <- 100
p1 <- 0.025
p2 <- 0.975
min <- -5
max <- 5
t1 <- round(qt(p1, df = df), digits = 3)
t2 <- round(qt(p2, df = df), digits = 3)
plot3 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dnorm, color = "grey") + 
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min, qt(p1, df = df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max, qt(p2, df = df)), geom = "area") +
  scale_x_continuous(breaks = c(t1, 0, t2)) +
    labs(title = paste0("df= ",df),x = "x", y = "Density") +
  theme(legend.position = "none") + 
  theme_bw()


df <- 1000
p1 <- 0.025
p2 <- 0.975
min <- -5
max <- 5
t1 <- round(qt(p1, df = df), digits = 3)
t2 <- round(qt(p2, df = df), digits = 3)
plot4 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dnorm, color = "grey") + 
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min, qt(p1, df = df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max, qt(p2, df = df)), geom = "area") +
  scale_x_continuous(breaks = c(t1, 0, t2)) +
    labs(title = paste0("df= ",df),
      x = "x", y = "Density") +
  theme(legend.position = "none") + 
  theme_bw()

p <- plot_grid(plot1, plot2, plot3, plot4, ncol = 2,
           labels = c("A", "B","C","D"))
title <- ggdraw() + draw_label('Degrees of freedom and the t-distribution', fontface='bold')
p <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
print(p)



## ------------------------------------------------------------------------
SE <- (sd(student_sample)/sqrt(n))
t_score <- (mean_sample - H_0)/SE
t_score

## ------------------------------------------------------------------------
df = n - 1
t_crit <- qt(0.975, df = df)
t_crit

## ------------------------------------------------------------------------
abs(t_score) > abs(t_crit)

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 6, fig.width = 8----
p1 <- 0.025
p2 <- 0.975
min <- -6
max <- 6
t1 <- round(qt(p1, df = df), digits = 3)
t2 <- round(qt(p2, df = df), digits = 3)
ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min, qt(p1, df = df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max, qt(p2, df = df)), geom = "area") +
  geom_vline(xintercept = t_score, color = 'red', size=1) +
  scale_x_continuous(breaks = c(t1, 0, t2)) +
    labs(title = "Theoretical density given null hypothesis 10 and sample t-statistic",
         x = "x", y = "Density") +
  theme(legend.position = "none") + 
  theme_bw()

## ------------------------------------------------------------------------
p_value <- 2*(1-pt(abs(t_score), df = df))
p_value

## ----message=FALSE, warning=FALSE----------------------------------------
ci_lower <- (mean_sample)-qt(0.975, df = df)*SE
ci_upper <- (mean_sample)+qt(0.975, df = df)*SE
ci_lower
ci_upper

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig2, fig.align="center", fig.height = 3, fig.width = 10----
library(cowplot)
library(gridExtra)
library(grid)

df <- n-1
p1 <- 0.025
p2 <- 0.975
min <- -5
max <- 5
t1 <- round(qt(p1, df = df), digits = 3)
t2 <- round(qt(p2, df = df), digits = 3)
plot1 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min, qt(p1, df = df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max, qt(p2, df = df)), geom = "area") +
  scale_x_continuous(breaks = c(t1, 0, t2)) +
    labs(title = paste0("Two-sided test"),
         subtitle = "0.025 of total area on each side; df = 49",
         x = "x", y = "Density") +
  theme(legend.position = "none") + 
  theme_bw()

df <- n-1
p1 <- 0.000
p2 <- 0.950
min <- -5
max <- 5
t1 <- round(qt(p1,df=df), digits = 3)
t2 <- round(qt(p2,df=df), digits = 3)
plot2 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(min,qt(p1,df=df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(max,qt(p2,df=df)), geom = "area") +
  scale_x_continuous(breaks = c(t1,0,t2)) +
    labs(title = paste0("One-sided test (right)"),
         subtitle = "0.05 of total area on the right; df = 49",
         x = "x", y = "Density") +
  theme(legend.position="none") + theme_bw()

df <- n-1
p1 <- 0.000
p2 <- 0.050
min <- -5
max <- 5
t1 <- round(qt(p1,df=df), digits = 3)
t2 <- round(qt(p2,df=df), digits = 3)
plot3 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = dt, args = list(df = df)) + 
  stat_function(fun = dt, args = list(df = df), xlim = c(max,qt(p1,df=df)), geom = "area") +
  stat_function(fun = dt, args = list(df = df), xlim = c(min,qt(p2,df=df)), geom = "area") +
  scale_x_continuous(breaks = c(t1,0,t2)) +
  labs(title = paste0("One-sided test (left)"),
         subtitle = "0.05 of total area on the left; df = 49",
         x = "x", y = "Density") +
  theme(legend.position="none") + theme_bw()

p <- plot_grid(plot3,plot1, plot2, ncol = 3)
print(p)

## ------------------------------------------------------------------------
library(psych)
describe(student_sample)

## ------------------------------------------------------------------------
ggplot(data.frame(student_sample)) + 
  geom_histogram(aes(x = student_sample), fill = 'white', color = 'black', bins = 20) +
  theme_bw() +
  labs(title = "Distribution of values in the sample",x = "Hours", y = "Frequency") 

## ------------------------------------------------------------------------
H_0 <- 10
t.test(student_sample, mu = H_0, alternative = 'two.sided')

## ---- message = FALSE, warning=FALSE-------------------------------------
set.seed(321)
hours_population_1 <- rgamma(25000, shape = 2, scale = 10)
set.seed(12567)
sample_1 <- sample(1:25000, size = 98, replace = FALSE)
sample_1_hours <- hours_population_1[sample_1]
sample_1_df <- data.frame(hours = round(sample_1_hours,0), group = "A")
set.seed(321)
hours_population_2 <- rgamma(25000, shape = 2.5, scale = 11)
set.seed(12567)
sample_2 <- sample(1:25000, size = 112, replace = FALSE)
sample_2_hours <- hours_population_2[sample_2]
sample_2_df <- data.frame(hours = round(sample_2_hours,0), group = "B")
hours_a_b <- rbind(sample_1_df,sample_2_df) 
head(hours_a_b)

## ------------------------------------------------------------------------
library(psych)
describeBy(hours_a_b$hours, hours_a_b$group)

## ------------------------------------------------------------------------
delta_pop <- mean(hours_population_1)-mean(hours_population_2)
delta_pop

## ------------------------------------------------------------------------
set.seed(321)
hours_population_1 <- rgamma(25000, shape = 2, scale = 10)
hours_population_2 <- rgamma(25000, shape = 2.5, scale = 11)

samples <- 20000
mean_delta <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  mean_delta[i,] <- mean(hours_population_1[student_sample])-mean(hours_population_2[student_sample])
}

ggplot(data.frame(mean_delta)) +
  geom_histogram(aes(x = mean_delta), bins = 30, fill='white', color='black') +
  theme_bw() +
  theme(legend.title = element_blank()) +
  geom_vline(aes(xintercept = mean(mean_delta)), size=1) + xlab("d") +
  ggtitle(TeX(sprintf("%d samples; $d_{\\bar{x}}$ = %.2f",samples, round(mean(mean_delta),2))))

## ------------------------------------------------------------------------
mean_x1 <- mean(hours_a_b[hours_a_b$group=="A","hours"])
mean_x2 <- mean(hours_a_b[hours_a_b$group=="B","hours"])
d <- mean_x1-mean_x2
d 

## ------------------------------------------------------------------------
n1 <- 98
n2 <- 112
s1 <- var(hours_a_b[hours_a_b$group=="A","hours"])
s2 <- var(hours_a_b[hours_a_b$group=="B","hours"])
SE_x1_x2 <- sqrt(s1/n1+s2/n2)
SE_x1_x2

## ------------------------------------------------------------------------
t_score <- d/SE_x1_x2
t_score

## ------------------------------------------------------------------------
library(psych)
describeBy(hours_a_b$hours, hours_a_b$group)

## ---- message = FALSE, warning=FALSE-------------------------------------
ggplot(hours_a_b,aes(group, hours)) + 
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Group", y = "Listening time (hours)") +
  ggtitle("Means and standard errors of listining times") +
  theme_bw()

ggplot(hours_a_b, aes(x = group, y = hours)) + 
  geom_boxplot() + 
  labs(x = "Group", y = "Listening time (hours)") + 
  ggtitle("Boxplot of listening times") +
  theme_bw() 

ggplot(hours_a_b,aes(hours)) + 
  geom_histogram(col = "black", fill = "darkblue") + 
  labs(x = "Listening time (hours)", y = "Frequency") + 
  ggtitle("Histogram of listening times") +
  facet_wrap(~group) +
  theme_bw()

## ------------------------------------------------------------------------
t.test(hours ~ group, data = hours_a_b, mu = 0, alternative = "two.sided", conf.level = 0.95, var.equal = FALSE)

## ---- message = FALSE, warning=FALSE-------------------------------------
set.seed(321)
hours_population_1 <- rgamma(25000, shape = 2, scale = 10)
set.seed(12567)
sample_1 <- sample(1:25000, size = 100, replace = FALSE)
sample_1_hours <- hours_population_1[sample_1]
set.seed(321)
hours_population_2 <- rgamma(25000, shape = 2.5, scale = 11)
set.seed(12567)
sample_2 <- sample(1:25000, size = 100, replace = FALSE)
sample_2_hours <- hours_population_2[sample_2]
hours_a_b_paired <- data.frame(hours_a = round(sample_1_hours,0),hours_b = round(sample_2_hours,0)) 
head(hours_a_b_paired)

## ------------------------------------------------------------------------
hours_a_b_paired$d <- hours_a_b_paired$hours_a - hours_a_b_paired$hours_b
head(hours_a_b_paired)

## ------------------------------------------------------------------------
mean_d <- mean(hours_a_b_paired$d)
mean_d

## ------------------------------------------------------------------------
n <- nrow(hours_a_b_paired)
SE_d <- sd(hours_a_b_paired$d)/sqrt(n)
SE_d

## ------------------------------------------------------------------------
t_score <- mean_d/SE_d
t_score

## ------------------------------------------------------------------------
library(psych)
describe(hours_a_b_paired)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "plot of means (dependent test)"----
library(reshape2)
hours_a_b_paired_long <- melt(hours_a_b_paired[, c("hours_a", "hours_b")]) 
names(hours_a_b_paired_long) <- c("group","hours")
head(hours_a_b_paired_long)

## ---- message = FALSE, warning=FALSE-------------------------------------
ggplot(hours_a_b_paired_long,aes(group, hours)) + 
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Group", y = "Listening time (hours)") +
  ggtitle("Means and standard errors of listining times") +
  theme_bw()

ggplot(hours_a_b_paired_long, aes(x = group, y = hours)) + 
  geom_boxplot() + 
  labs(x = "Group", y = "Listening time (hours)") + 
  ggtitle("Boxplot of listening times") +
  theme_bw() 

ggplot(hours_a_b_paired_long,aes(hours)) + 
  geom_histogram(col = "black", fill = "darkblue") + 
  labs(x = "Listening time (hours)", y = "Frequency") + 
  ggtitle("Histogram of listening times") +
  facet_wrap(~group) +
  theme_bw()

## ---- message = FALSE, warning=FALSE-------------------------------------
t.test(hours_a_b_paired$hours_a, hours_a_b_paired$hours_b, mu = 0, alternative = "two.sided", conf.level = 0.95, paired=TRUE)

## ----message=FALSE, warning=FALSE----------------------------------------
library(lsr)
cohensD(hours ~ group, data = hours_a_b)

## ----message=FALSE, warning=FALSE----------------------------------------
library(pwr)
pwr.t.test(d = 0.6, sig.level = 0.05, power = 0.8, type = c("two.sample"), alternative = c("two.sided"))

## ----message=FALSE, warning=FALSE----------------------------------------
pwr.t.test(n = 51, d = 0.6, sig.level = 0.05, type = c("two.sample"), alternative = c("two.sided"))

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "p-hacking (red indicates false positives)"----
set.seed(300)
R <- 1000 
tvalues <- numeric()
tcrit <- numeric()
replication <- numeric()
group1 <- rnorm(3,1,10)
group2 <- rnorm(3,1,10)

for (r in 1:R) {
  newobs <- rnorm(1,1,10)
  if (runif(1 )> .5) {
    group1 <- c(group1, newobs)
  } else {
    group2 <- c(group2, newobs)
  }
  t <- t.test(group1, group2, var.equal = TRUE)
  tvalues[r] <- t$statistic
  replication[r] <- r
  degf <- (length(group1) + length(group2)-2)
  tcrit[r] <- qt(0.975,degf)
}
df <- as.data.frame(cbind(replication, tvalues,tcrit))
df$col <- ifelse(abs(df$tvalues)>abs(df$tcrit),1,0)

ggplot(data=df,aes(y=tvalues, x=replication,color = col)) +
  geom_line()+theme_bw() +
  theme(legend.position="none") +scale_colour_gradientn(colours=c("black","red"))

