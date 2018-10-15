## ---- include=FALSE------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
options(digits = 7)

## ---- message = FALSE, warning=FALSE-------------------------------------
library(tidyverse)
library(ggplot2)
library(latex2exp)
set.seed(321)
hours <- rnorm(25000, 50, 10)

ggplot(data.frame(hours)) +
  geom_histogram(aes(hours), bins = 50, fill = 'white', color = 'black') +
  labs(title = "Histogram of listening times",
       subtitle = TeX(sprintf("Population mean ($\\mu$) = %.2f; population standard deviation ($\\sigma$) = %.2f",round(mean(hours),2),round(sd(hours),2))),
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() +
  geom_vline(xintercept = mean(hours), size = 1) +
  geom_vline(xintercept = mean(hours)+2*sd(hours), colour = "red", size = 1) +
  geom_vline(xintercept = mean(hours)-2*sd(hours), colour = "red", size = 1) +
  geom_segment(aes(x = mean(hours), y = 1100, yend = 1100, xend = (mean(hours) - 2*sd(hours))), lineend = "butt", linejoin = "round",
     size = 0.5, arrow = arrow(length = unit(0.2, "inches"))) +
  geom_segment(aes(x = mean(hours), y = 1100, yend = 1100, xend = (mean(hours) + 2*sd(hours))), lineend = "butt", linejoin = "round",
     size = 0.5, arrow = arrow(length = unit(0.2, "inches"))) +
  annotate("text", x = mean(hours) + 28, y = 1100, label = "Mean + 2 * SD" )+
  annotate("text", x = mean(hours) -28, y = 1100, label = "Mean - 2 * SD" )

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 4, fig.width = 6----
student_sample <- sample(1:25000, size = 100, replace = FALSE)
sample_1 <- hours[student_sample]
ggplot(data.frame(sample_1)) +
  geom_histogram(aes(x = sample_1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(sample_1)), size=1) +
  ggtitle(TeX(sprintf("Distribution of listening times ($\\bar{x}$ = %.2f)",round(mean(sample_1),2))))

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 6, fig.width = 8----
#student_sample <- sample(1:25000, size = 100, replace = FALSE)
#means <- hours[student_sample]
library(cowplot)
set.seed(8830)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot1 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}_1$ = %.2f",round(mean(means1),2))))

set.seed(6789)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot2 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}_2$ = %.2f",round(mean(means1),2))))

set.seed(3904)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot3 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}_3$ = %.2f",round(mean(means1),2))))

set.seed(3333)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot4 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}_4$ = %.2f",round(mean(means1),2))))

p <- plot_grid(plot1, plot2, plot3, plot4, ncol = 2,
           labels = c("A", "B","C","D"))
title <- ggdraw() + draw_label('Distribution of listening times in four different samples', fontface='bold')
p <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
print(p)


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 4, fig.width = 6----
set.seed(12345)
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}

meansdf <- data.frame('true' = mean(hours), 'sample' = mean(means))
meansdf <- gather(meansdf)
ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.title = element_blank(),
        legend.position = "bottom") +
  labs(title = "Histogram of listening times",
       subtitle = TeX(sprintf("Population mean ($\\mu$) = %.2f; population standard deviation ($\\sigma$) = %.2f",round(mean(hours),2),round(sd(hours),2))),
       y = 'Number of students', 
       x = 'Hours') 

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=FALSE, fig.align="center", fig.cap="Relationship between the sample size and the standard error"----
set.seed(321)
hours <- rnorm(25000, 50, 10)

R <- 1000
sems <- numeric()
replication <- numeric()

for (r in 10:R) {
  y_sample <- sample(hours, r)
  sem <- sd(hours)/sqrt(length(y_sample))
  sems <- rbind(sems, sem)
  replication <- rbind(replication, r)
}

df <- as.data.frame(cbind(replication, sems))
ggplot(data=df, aes(y = sems, x = replication)) + 
  geom_line() + 
  ylab("Standard error of the mean") + 
  xlab("Sample size") + 
  ggtitle('Relationship between sample size and standard error') +
  theme_bw()

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 6, fig.width = 8----
library(cowplot)
library(gridExtra)
library(grid)
library(latex2exp)
set.seed(12345)

sample_size = 10
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}
meansdf <- data.frame('true' = mean(hours), 'sample' = mean(means))
meansdf <- gather(meansdf)
plot1 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.position = "none") +  ggtitle(TeX(sprintf("n = 10; $\\sigma_{\\bar x}$ = %.2f",round(sd(hours)/sqrt(sample_size),2))))

sample_size = 100
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}
meansdf <- data.frame('true' = mean(hours), 'sample' = mean(means))
meansdf <- gather(meansdf)
plot2 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.position = "none") +  ggtitle(TeX(sprintf("n = 100; $\\sigma_{\\bar x}$ = %.2f",round(sd(hours)/sqrt(sample_size),2))))

sample_size = 1000
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}
meansdf <- data.frame('true' = mean(hours), 'sample' = mean(means))
meansdf <- gather(meansdf)
plot3 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.position = "none") +  ggtitle(TeX(sprintf("n = 1,000; $\\sigma_{\\bar x}$ = %.2f",round(sd(hours)/sqrt(sample_size),2))))

sample_size = 10000
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}
meansdf <- data.frame('true' = mean(hours), 'sample' = mean(means))
meansdf <- gather(meansdf)
plot4 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.position = "none") +  ggtitle(TeX(sprintf("n = 10,000; $\\sigma_{\\bar x}$ = %.2f",round(sd(hours)/sqrt(sample_size),2))))

p <- plot_grid(plot1, plot2, plot3, plot4, ncol = 2,
           labels = c("A", "B","C","D"))
title <- ggdraw() + draw_label('Relationship between sample size and standard error', fontface='bold')
p <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
print(p)
# now add the title
#title <- ggdraw() + draw_label("", fontface='bold')
#plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 3, fig.width = 8----
library(cowplot)
library(gridExtra)
library(grid)
set.seed(12345)

hours1 <- rnorm(25000, 50, 1)
sample_size = 100
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
  means[i,] <- mean(hours1[student_sample])
}
meansdf <- data.frame('true' = mean(hours1), 'sample' = mean(means))
meansdf <- gather(meansdf)
plot1 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.position = "none") +  ggtitle(TeX(sprintf("n = 100; $\\sigma = 1$; $\\sigma_{\\bar x}$ = %.2f",round(sd(hours1)/sqrt(sample_size),2))))


hours2 <- rnorm(25000, 50, 10)
sample_size = 100
samples <- 20000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
  means[i,] <- mean(hours2[student_sample])
}
meansdf <- data.frame('true' = mean(hours2), 'sample' = mean(means))
meansdf <- gather(meansdf)
plot2 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() +
  geom_vline(data = meansdf, aes(xintercept = value, color = key, linetype = key), size=1) +
  scale_color_discrete(labels = c("Mean of sample means", "Population mean")) +
  scale_linetype_discrete(labels = c("Mean of sample means", "Population mean")) +
  theme(legend.position = "none") +  ggtitle(TeX(sprintf("n = 100; $\\sigma = 10$; $\\sigma_{\\bar x}$ = %.2f",round(sd(hours2)/sqrt(sample_size),2))))

p <- plot_grid(plot1, plot2, ncol = 2, 
           labels = c("A", "B"))
title <- ggdraw() + draw_label('Relationship between population SD and standard error', fontface='bold')
p <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
print(p)
# now add the title
#title <- ggdraw() + draw_label("", fontface='bold')
#plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.height = 4, fig.width = 6----
set.seed(321)
hours <- rgamma(25000, shape = 2, scale = 10)
ggplot(data.frame(hours)) +
  geom_histogram(aes(x = hours), bins = 30, fill='white', color='black') +
    geom_vline(xintercept = mean(hours), size = 1)  +  theme_bw() +
  labs(title = "Histogram of listening times",
       subtitle = TeX(sprintf("Population mean ($\\mu$) = %.2f; population standard deviation ($\\sigma$) = %.2f",round(mean(hours),2),round(sd(hours),2))),
       y = 'Number of students', 
       x = 'Hours') 


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 6, fig.width = 8----
#student_sample <- sample(1:25000, size = 100, replace = FALSE)
#means <- hours[student_sample]

set.seed(8830)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot1 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}$ = %.2f",round(mean(means1),2))))

set.seed(6789)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot2 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}$ = %.2f",round(mean(means1),2))))

set.seed(3904)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot3 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}$ = %.2f",round(mean(means1),2))))

set.seed(3333)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
plot4 <- ggplot(data.frame(means1)) +
  geom_histogram(aes(x = means1), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(means1)), size=1) +
 ggtitle(TeX(sprintf("$\\bar{x}$ = %.2f",round(mean(means1),2))))

p <- plot_grid(plot1, plot2, plot3, plot4, ncol = 2,
           labels = c("A", "B","C","D"))
title <- ggdraw() + draw_label('Distribution of listening times in four different samples', fontface='bold')
p <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
print(p)


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 6, fig.width = 8----
library(cowplot)
library(gridExtra)
library(grid)
set.seed(321)

hours <- rgamma(25000, shape = 2, scale = 10)

samples <- 10
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}

plot1 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() + xlim(14, 26) + 
  theme(legend.title = element_blank()) +
  geom_vline(aes(xintercept = mean(means)), size=1) +
  ggtitle(TeX(sprintf("%d samples; $\\mu_{\\bar x}$ = %.2f",samples, round(mean(means),2))))

samples <- 100
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}

plot2 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() + xlim(14, 26) +
  theme(legend.title = element_blank()) +
  geom_vline(aes(xintercept = mean(means)), size=1) +
  ggtitle(TeX(sprintf("%d samples; $\\mu_{\\bar x}$ = %.2f",samples, round(mean(means),2))))

samples <- 1000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}

plot3 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() + xlim(14, 26) +
  theme(legend.title = element_blank()) +
  geom_vline(aes(xintercept = mean(means)), size=1) +
  ggtitle(TeX(sprintf("%d samples; $\\mu_{\\bar x}$ = %.2f",samples, round(mean(means),2))))

samples <- 10000
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}

plot4 <- ggplot(data.frame(means)) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  theme_bw() + xlim(14, 26) +
  theme(legend.title = element_blank()) +
  geom_vline(aes(xintercept = mean(means)), size=1) +
  ggtitle(TeX(sprintf("%d samples; $\\mu_{\\bar x}$ = %.2f",samples, round(mean(means),2))))

p <- plot_grid(plot1, plot2, plot3, plot4, ncol = 2,
           labels = c("A", "B","C","D"))
title <- ggdraw() + draw_label('Distribution of sample means from gamma population', fontface='bold')
p <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
print(p)


## ---- fig.height = 4, fig.width=6----------------------------------------
set.seed(321)
hours <- rgamma(25000, shape = 2, scale = 10)

set.seed(6789)
sample_size <- 100
student_sample <- sample(1:25000, size = sample_size, replace = FALSE)
hours_s <- hours[student_sample]

plot2 <- ggplot(data.frame(hours_s)) +
  geom_histogram(aes(x = hours_s), bins = 30, fill='white', color='black') +
  theme_bw() + xlab("Hours") +
  geom_vline(aes(xintercept = mean(hours_s)), size=1) +
 ggtitle(TeX(sprintf("Random sample; $n$ = %d; $\\bar{x}$ = %.2f; $s$ = %.2f",sample_size,round(mean(hours_s),2),round(sd(hours_s),2))))
plot2

## ---- fig.height = 4, fig.width=6----------------------------------------
qnorm(0.975)

## ---- fig.height = 4, fig.width=6----------------------------------------
sample_mean <- mean(hours_s)
se <- sd(hours_s)/sqrt(sample_size)
ci_lower <- sample_mean - qnorm(0.975)*se
ci_upper <- sample_mean + qnorm(0.975)*se
ci_lower
ci_upper

## ---- fig.height = 15, fig.width=10--------------------------------------
set.seed(12)
samples <- 100
hours <- rgamma(25000, shape = 2, scale = 10)
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = 100, replace = FALSE)
  means[i,] <- mean(hours[student_sample])
}

means_sd <- data.frame(means, lower =  means - qnorm(0.975) * (sd(hours)/sqrt(100)), upper = means + qnorm(0.975) * (sd(hours)/sqrt(100)), y = 1:100)
means_sd$diff <- factor(ifelse(means_sd$lower > mean(hours) | means_sd$upper < mean(hours), 'No', 'Yes'))

ggplot2::ggplot(means_sd, aes(y = y)) +
  scale_y_continuous(breaks = seq(1, 100, by = 1), expand = c(0.005,0.005)) +
  geom_point(aes(x = means, color = diff)) +
  geom_errorbarh(aes(xmin = lower, xmax = upper, color = diff)) +
  geom_vline(xintercept = mean(hours)) +
  scale_color_manual(values = c("red", "black")) +
  guides(color=guide_legend(title="True mean in CI")) +
  theme_bw()


