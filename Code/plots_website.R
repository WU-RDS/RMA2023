library(tidyverse)
library(ggplot2)
library(latex2exp)
hours <- rnorm(25000, 50, 10)
set.seed(8830)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
means_df <- data.frame(mean=means1,respondent=1:100)
plot1 <- ggplot(means_df) +
  geom_point(aes(x = respondent,y=mean), color='black') +
  theme_bw() + xlab("Respondent number") + ylab("hours") +
  ylim(20,80) +
  geom_segment(aes(x = respondent, y = mean, xend = respondent, yend = mean(mean)), 
               color = "grey", size = 0.5, linetype = "solid", alpha = 0.8) + 
  geom_hline(aes(yintercept = mean(mean)), size=1) +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=16)) +
  ggtitle(TeX(sprintf("$\\bar{x}_1$ = %.2f; $s^2$ = %.2f; s = %.2f",round(mean(means1),2),round(var(means1),2),round(sd(means1),2))))
plot1
ggsave(paste0("D:/Teaching/MRDA2020/materials/means_1.jpg"), width=8, height=6)

plot1 <- ggplot(means_df) +
  ylim(0,10) + xlim(10,80) +
  geom_histogram(aes(x = mean), binwidth = 1, color='black', fill = 'steelblue') +
  theme_bw() + xlab("Respondent number") + ylab("hours") +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=16))
plot1
ggsave(paste0("D:/Teaching/MRDA2020/materials/hist_1.jpg"), width=8, height=6)


hours <- rnorm(25000, 50, 5)
set.seed(8830)
student_sample <- sample(1:25000, size = 100, replace = FALSE)
means1 <- hours[student_sample]
means_df <- data.frame(mean=means1,respondent=1:100)
plot1 <- ggplot(means_df) +
  geom_point(aes(x = respondent,y=mean), color='black') +
  ylim(20,80) +
  theme_bw() + xlab("Respondent number") + ylab("hours") +
  geom_segment(aes(x = respondent, y = mean, xend = respondent, yend = mean(mean)), 
               color = "grey", size = 0.5, linetype = "solid", alpha = 0.8) + 
  geom_hline(aes(yintercept = mean(mean)), size=1) +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=16)) +
  ggtitle(TeX(sprintf("$\\bar{x}_1$ = %.2f; $s^2$ = %.2f; s = %.2f",round(mean(means1),2),round(var(means1),2),round(sd(means1),2))))
plot1
ggsave(paste0("D:/Teaching/MRDA2020/materials/means_2.jpg"), width=8, height=6)
plot1 <- ggplot(means_df) +
  ylim(0,10) +  xlim(10,80) +
  geom_histogram(aes(x = mean), binwidth = 1, color='black', fill = 'steelblue') +
  theme_bw() + xlab("Respondent number") + ylab("hours") +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=16))
plot1
ggsave(paste0("D:/Teaching/MRDA2020/materials/hist_2.jpg"), width=8, height=6)

