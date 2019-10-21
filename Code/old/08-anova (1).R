# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2018/_book/hypothesis-testing.html#comparing-several-means 


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "plyr", "ggplot2", "reshape2", "PMCMR", "car", "multcomp", "Hmisc")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#---------------------------One-way ANOVA---------------------------#
#-------------------------------------------------------------------#

# Load and inspect the data
## ------------------------------------------------------------------------
online_store_promo <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/online_store_promo.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
online_store_promo$Promotion <- factor(online_store_promo$Promotion, levels = c(1:3), labels = c("high", "medium","low")) #convert grouping variable to factor
str(online_store_promo) #inspect data
print(online_store_promo) #inspect data

# Descriptive statistics
## ------------------------------------------------------------------------
library(psych)
describeBy(online_store_promo$Sales, online_store_promo$Promotion) #inspect data

# Plot data
## ------------------------------------------------------------------------
library(ggplot2)
ggplot(online_store_promo, aes(Promotion, Sales)) + 
  stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (promotion level)", y = "Sales (thsd. units)") + 
  theme_bw()


# Inspect data in wide format
## ------------------------------------------------------------------------
library(reshape2)
dcast(online_store_promo, Obs ~ Promotion, value.var = "Sales")

# Compute grand mean and category means
## ------------------------------------------------------------------------
mean(online_store_promo$Sales) #grand mean
by(online_store_promo$Sales,online_store_promo$Promotion,mean) #category mean

# Compute total sum of squares
## ------------------------------------------------------------------------
SST <- sum((online_store_promo$Sales - mean(online_store_promo$Sales))^2)
SST

# Compute model sum of squares
## ------------------------------------------------------------------------
SSM <- sum(10*(by(online_store_promo$Sales, online_store_promo$Promotion, mean) - mean(online_store_promo$Sales))^2)
SSM

# Compute residual sum of squares
## ------------------------------------------------------------------------
SSR <- sum((online_store_promo$Sales - rep(by(online_store_promo$Sales, online_store_promo$Promotion, mean), each = 10))^2)
SSR

# Compute effect strength (eta)
## ------------------------------------------------------------------------
eta <- SSM/SST
eta

# Compute F-ratio
## ------------------------------------------------------------------------
f_ratio <- (SSM/2)/(SSR/27)
f_ratio


# Test if calculated test statistic is larger than critical value
## ------------------------------------------------------------------------
f_crit <- qf(.95, df1 = 2, df2 = 27) #critical value
f_crit 
f_ratio > f_crit 

# Testing assumptions
## ------------------------------------------------------------------------
# Normality test
shapiro.test(online_store_promo[online_store_promo$Promotion == "low", ]$Sales)
shapiro.test(online_store_promo[online_store_promo$Promotion == "medium", ]$Sales)
shapiro.test(online_store_promo[online_store_promo$Promotion == "high", ]$Sales)
# Q-Q plots
qqnorm(online_store_promo[online_store_promo$Promotion=="low",]$Sales) 
qqline(online_store_promo[online_store_promo$Promotion=="low",]$Sales)
qqnorm(online_store_promo[online_store_promo$Promotion=="medium",]$Sales) 
qqline(online_store_promo[online_store_promo$Promotion=="medium",]$Sales)
qqnorm(online_store_promo[online_store_promo$Promotion=="high",]$Sales) 
qqline(online_store_promo[online_store_promo$Promotion=="high",]$Sales)
# Homogeneity of variances
## ------------------------------------------------------------------------
library(car)
leveneTest(Sales ~ Promotion, data = online_store_promo, center = mean)

# Run the ANOVA
## ------------------------------------------------------------------------
aov <- aov(Sales ~ Promotion, data = online_store_promo)
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

# Robust ANOVA in case the variances between groups are not equal
## ------------------------------------------------------------------------
oneway.test(Sales ~ Promotion, data=online_store_promo)

# Post hoc tests
## ------------------------------------------------------------------------
# Bonferroni
pairwise.t.test(online_store_promo$Sales, online_store_promo$Promotion, data = online_store_promo, p.adjust.method = "bonferroni")
# compare results to a normal t-test without correction
## ------------------------------------------------------------------------
data_subset <- subset(online_store_promo,Promotion != "low")
t.test(Sales ~ Promotion, data = data_subset)
# Tukey
## ------------------------------------------------------------------------
# derive q
q <- qtukey(0.95, nm = 3, df = 27)
q
# compute hsd
hsd <- q * sqrt(summary(aov)[[1]]$'Mean Sq'[2]/10)
hsd
# compute tukeys using the multcomp package
library(multcomp)
tukeys <- glht(aov, linfct = mcp(Promotion = "Tukey"))
summary(tukeys)
# compute CIs
confint(tukeys)
# plot CIs
plot(tukeys)
## ------------------------------------------------------------------------
# compute CIs manually
# compute means
mean1 <- mean(online_store_promo[online_store_promo$Promotion=="high","Sales"]) #mean group "high"
mean1
mean2 <- mean(online_store_promo[online_store_promo$Promotion=="medium","Sales"]) #mean group "medium"
mean2
mean3 <- mean(online_store_promo[online_store_promo$Promotion=="low","Sales"]) #mean group "low"
mean3
# CI high vs. medium
mean_diff_high_med <- mean2-mean1
mean_diff_high_med
ci_med_high_lower <- mean_diff_high_med-hsd
ci_med_high_upper <- mean_diff_high_med+hsd
ci_med_high_lower
ci_med_high_upper
# CI high vs.low
mean_diff_high_low <- mean3-mean1
mean_diff_high_low
ci_low_high_lower <- mean_diff_high_low-hsd
ci_low_high_upper <- mean_diff_high_low+hsd
ci_low_high_lower
ci_low_high_upper
# CI medium vs.low
mean_diff_med_low <- mean3-mean2
mean_diff_med_low
ci_low_med_lower <- mean_diff_med_low-hsd
ci_low_med_upper <- mean_diff_med_low+hsd
ci_low_med_lower
ci_low_med_upper

