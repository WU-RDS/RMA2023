# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/hypothesis-testing.html#comparing-several-means

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "plyr", "ggplot2", "reshape2", "PMCMR", "car", "multcomp", "Hmisc", "ggstatsplot", "tidyr")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)

#-------------------------------------------------------------------#
#---------------------------One-way ANOVA---------------------------#
#-------------------------------------------------------------------#

# Load and inspect the data
## ------------------------------------------------------------------------
hours_abc <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/hours_abc.dat", 
                                 sep = "\t", 
                                 header = TRUE) #read in data
hours_abc$group <- factor(hours_abc$group, levels = c("A","B","C"), labels = c("low", "medium","high")) #convert grouping variable to factor
str(hours_abc) #inspect data
head(hours_abc) #inspect data

# Descriptive statistics
## ------------------------------------------------------------------------
library(psych)
describeBy(hours_abc$hours,hours_abc$group) #inspect data

# Plot data
## ------------------------------------------------------------------------
# plot of means
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

# boxplot
ggplot(hours_abc,aes(x = group, y = hours)) + 
  geom_boxplot() +
  geom_jitter(colour="red", alpha = 0.1) +
  theme_bw() +
  labs(x = "Group", y = "Average number of hours", title = "Average number of hours by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

# Inspect data in wide format
## ------------------------------------------------------------------------
library(reshape2)
dcast(hours_abc, index ~ group, value.var = "hours")

# Compute grand mean and category means
## ------------------------------------------------------------------------
mean(hours_abc$hours) #grand mean
by(hours_abc$hours,hours_abc$group,mean) #category mean

# Compute total sum of squares
## ------------------------------------------------------------------------
SST <- sum((hours_abc$hours - mean(hours_abc$hours))^2)
SST

# Compute model sum of squares
## ------------------------------------------------------------------------
SSM <- sum(100*(by(hours_abc$hours, hours_abc$group, mean) - mean(hours_abc$hours))^2)
SSM

# Compute residual sum of squares
## ------------------------------------------------------------------------
SSR <- sum((hours_abc$hours - rep(by(hours_abc$hours, hours_abc$group, mean), each = 100))^2)
SSR

# Compute effect strength (eta)
# http://imaging.mrc-cbu.cam.ac.uk/statswiki/FAQ/effectSize
## ------------------------------------------------------------------------
eta <- SSM/SST
eta

# Compute F-ratio
## ------------------------------------------------------------------------
f_ratio <- (SSM/2)/(SSR/297)
f_ratio

# Test if calculated test statistic is larger than critical value
## ------------------------------------------------------------------------
f_crit <- qf(.95, df1 = 2, df2 = 297) #critical value
f_crit 
f_ratio > f_crit 

# Testing assumptions
## ------------------------------------------------------------------------
# Normality test (optional here, since n > 30)
by(hours_abc$hours, hours_abc$group, shapiro.test)

# Q-Q plots
qqnorm(hours_abc[hours_abc$group=="low",]$hours) 
qqline(hours_abc[hours_abc$group=="low",]$hours)
qqnorm(hours_abc[hours_abc$group=="medium",]$hours) 
qqline(hours_abc[hours_abc$group=="medium",]$hours)
qqnorm(hours_abc[hours_abc$group=="high",]$hours) 
qqline(hours_abc[hours_abc$group=="high",]$hours)

# Run the ANOVA
## ------------------------------------------------------------------------
aov <- aov(hours ~ group, data = hours_abc)
summary(aov)

# Compute eta from output
## ------------------------------------------------------------------------
summary(aov)[[1]]$'Sum Sq'[1]/(summary(aov)[[1]]$'Sum Sq'[1] + summary(aov)[[1]]$'Sum Sq'[2])

# Test residual variance
## ------------------------------------------------------------------------
# Homogeneity of variances
plot(aov,1)
# Normal distribution of residuals (plot)
plot(aov,2)
# Normal distribution of residuals (test)
shapiro.test(resid(aov))

# Homogeneity of variances
## ------------------------------------------------------------------------
library(car)
leveneTest(hours ~ group, data = hours_abc, center = mean)

# Robust ANOVA in case the variances between groups are not equal (which is the case in the example)
## ------------------------------------------------------------------------
oneway.test(hours ~ group, data = hours_abc)

# Post hoc tests
## ------------------------------------------------------------------------
# Bonferroni
pairwise.t.test(hours_abc$hours, hours_abc$group, data = hours_abc, p.adjust.method = "bonferroni")

# Tukey
## ------------------------------------------------------------------------
# derive q
q <- qtukey(0.95, nm = 3, df = 297)
q
# compute hsd
hsd <- q * sqrt(summary(aov)[[1]]$'Mean Sq'[2]/100)
hsd
# compute tukeys using the multcomp package
library(multcomp)
tukeys <- glht(aov, linfct = mcp(group = "Tukey"))
summary(tukeys)
# compute CIs
confint(tukeys)
# plot CIs
plot(tukeys)

# Using the ggstatsplot package
## ------------------------------------------------------------------------
library(ggstatsplot)
ggbetweenstats(
  data = hours_abc,
  x = group,
  y = hours,
  plot.type = "box",
  pairwise.comparisons = TRUE,
  pairwise.annotation = "p.value",
  p.adjust.method = "bonferroni",
  effsize.type = "partial_eta",
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
#save plot (optional)
## ------------------------------------------------------------------------
ggsave("anova.jpg", height = 6, width = 7.5)
