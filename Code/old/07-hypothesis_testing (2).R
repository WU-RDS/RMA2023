# The following code is taken from the fifth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2018/_book/hypothesis-testing.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

req_pacakges <- c("ggplot2","psych","reshape2","lsr","pwr")
req_pacakges <- req_pacakges[!req_pacakges %in% installed.packages()]
lapply(req_pacakges, install.packages)
options(scipen = 999)

#-------------------------------------------------------------------#
#---------------------------Introduction----------------------------#
#-------------------------------------------------------------------#

# Read in population data 
## ------------------------------------------------------------------------
music_listening_population_2 <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/hours_population_gamma.csv", 
                                           sep = ";", 
                                           header = TRUE)
head(music_listening_population_2)
# Compute descriptives for population
psych::describe(music_listening_population_2)
# Create histogram
library(ggplot2)
ggplot(music_listening_population_2) +
  geom_histogram(aes(hours), bins = 50, fill = 'white', color = 'black') +
  labs(title = "Histogram of listening times in population",
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() 

# Compute descriptives for population
## ------------------------------------------------------------------------
n <- 50 #sample size
mean_pop <- mean(music_listening_population_2$hours) #population mean
sigma <- sd(music_listening_population_2$hours) #population standard deviation
sigma_x <- sigma/sqrt(n) #standard error
sigma_x


# Compute descriptives for population
## ------------------------------------------------------------------------
set.seed(12567)
student_sample <- sample(1:25000, size = n, replace = FALSE)
music_listening_sample <- data.frame(hours = music_listening_population_2[student_sample,"hours"])
# Compute descriptives for sample
psych::describe(music_listening_sample)
# Create histogram
ggplot(music_listening_sample) +
  geom_histogram(aes(x = hours), bins = 30, fill='white', color='black') +
  labs(title = "Histogram of listening times in sample",
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() 

# Compute test statistic
## ------------------------------------------------------------------------
H_0 <- 10
mean_sample <- mean(music_listening_sample$hours)
z_score <- (mean_sample - H_0)/(sigma/sqrt(n))
z_score

# Compute critical value
## ------------------------------------------------------------------------
z_crit <- qnorm(0.975)
z_crit

# Test if test statistic is larger than critical value
## ------------------------------------------------------------------------
abs(z_score) > abs(z_crit)

plot()
# Compute t-statistic
## ------------------------------------------------------------------------
SE <- (sd(music_listening_sample$hours)/sqrt(n))
SE
t_score <- (mean_sample - H_0)/SE
t_score

# Compute critical value
## ------------------------------------------------------------------------
df = n - 1
t_crit <- qt(0.975, df = df)
t_crit

# Test if test statistic is larger than critical value
## ------------------------------------------------------------------------
abs(t_score) > abs(t_crit)

# Compute p-value
## ------------------------------------------------------------------------
p_value <- 2*(1-pt(abs(t_score), df = df))
p_value

# Compute confidence interval
## ------------------------------------------------------------------------
ci_lower <- (mean_sample)-qt(0.975, df = df)*SE
ci_upper <- (mean_sample)+qt(0.975, df = df)*SE
ci_lower
ci_upper


#-------------------------------------------------------------------#
#-------------------------One-sample t-test-------------------------#
#-------------------------------------------------------------------#

# Descriptives
## ------------------------------------------------------------------------
library(psych)
psych::describe(music_listening_sample)

# Visualization
## ------------------------------------------------------------------------
ggplot(music_listening_sample) + 
  geom_histogram(aes(x = hours), fill = 'white', color = 'black', bins = 20) +
  theme_bw() +
  labs(title = "Distribution of values in the sample",x = "Hours", y = "Frequency") 

# Conduct hypothesis test
## ------------------------------------------------------------------------
H_0 <- 10
t.test(music_listening_sample$hours, mu = H_0, alternative = 'two.sided')

#-------------------------------------------------------------------#
#----------------------Independent means t-test---------------------#
#-------------------------------------------------------------------#

# Theory 
## ------------------------------------------------------------------------

# Read in data 
## ------------------------------------------------------------------------
hours_a_b <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/hours_a_b.csv", 
                                           sep = ";", 
                                           header = TRUE)
head(hours_a_b)

# Descriptives by group
## ------------------------------------------------------------------------
library(psych)
describeBy(hours_a_b$hours, hours_a_b$group)

# Inspect populations from which the samples were generated
## ------------------------------------------------------------------------
set.seed(321)
hours_population_1 <- rgamma(25000, shape = 2, scale = 10)
hours_population_2 <- rgamma(25000, shape = 2.5, scale = 11)

# True difference between population means
## ------------------------------------------------------------------------
delta_pop <- mean(hours_population_1)-mean(hours_population_2)
delta_pop

# Sampling distribution of mean differences between random samples
## ------------------------------------------------------------------------
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
  ggtitle("sampling distribution of differences")

# Compute difference between mean of sample 1 and mean of sample 2
## ------------------------------------------------------------------------
mean_x1 <- mean(hours_a_b[hours_a_b$group=="A","hours"])
mean_x2 <- mean(hours_a_b[hours_a_b$group=="B","hours"])
d <- mean_x1-mean_x2
d 

# Compute standard error
## ------------------------------------------------------------------------
n1 <- 98
n2 <- 112
s1 <- var(hours_a_b[hours_a_b$group=="A","hours"])
s2 <- var(hours_a_b[hours_a_b$group=="B","hours"])
SE_x1_x2 <- sqrt(s1/n1+s2/n2)
SE_x1_x2

# Compute test statistic
## ------------------------------------------------------------------------
t_score <- d/SE_x1_x2
t_score

# Application
## ------------------------------------------------------------------------

# Compute descriptives
## ------------------------------------------------------------------------
library(psych)
describeBy(hours_a_b$hours, hours_a_b$group)

# Visualization
## ------------------------------------------------------------------------
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

# Conduct t-test
## ------------------------------------------------------------------------
t.test(hours ~ group, data = hours_a_b, mu = 0, alternative = "two.sided", conf.level = 0.95, var.equal = FALSE)


#-------------------------------------------------------------------#
#-----------------------Dependent means t-test----------------------#
#-------------------------------------------------------------------#

# Theory 
## ------------------------------------------------------------------------

# Read in data 
## ------------------------------------------------------------------------
hours_a_b_paired <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/hours_a_b_paired.csv", 
                        sep = ";", 
                        header = TRUE)

head(hours_a_b_paired)

# Compute difference between conditions a and b
## ------------------------------------------------------------------------
hours_a_b_paired$d <- hours_a_b_paired$hours_a - hours_a_b_paired$hours_b
head(hours_a_b_paired)

# Compute mean difference between conditions a and b
## ------------------------------------------------------------------------
mean_d <- mean(hours_a_b_paired$d)
mean_d

# Compute standard error
## ------------------------------------------------------------------------
n <- nrow(hours_a_b_paired)
SE_d <- sd(hours_a_b_paired$d)/sqrt(n)
SE_d

# Compute test statistic
## ------------------------------------------------------------------------
t_score <- mean_d/SE_d
t_score

# Application 
## ------------------------------------------------------------------------

# Compute descriptives
## ------------------------------------------------------------------------
library(psych)
psych::describe(hours_a_b_paired)

# Visualization
## ------------------------------------------------------------------------
library(reshape2)
# Convert data to long format
hours_a_b_paired_long <- melt(hours_a_b_paired[, c("hours_a", "hours_b")]) 
names(hours_a_b_paired_long) <- c("group","hours")
head(hours_a_b_paired_long)

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

# Conduct t-test
## ------------------------------------------------------------------------
t.test(hours_a_b_paired$hours_a, hours_a_b_paired$hours_b, mu = 0, alternative = "two.sided", conf.level = 0.95, paired=TRUE)


#-------------------------------------------------------------------#
#-----------------------------Sample size---------------------------#
#-------------------------------------------------------------------#

# Compute sample size
## ------------------------------------------------------------------------
library(pwr)
pwr.t.test(d = 0.6, sig.level = 0.05, power = 0.8, type = c("two.sample"), alternative = c("two.sided"))

# Compute power
## ------------------------------------------------------------------------
pwr.t.test(n = 51, d = 0.6, sig.level = 0.05, type = c("two.sample"), alternative = c("two.sided"))


#-------------------------------------------------------------------#
#-----------------------------Effect size---------------------------#
#-------------------------------------------------------------------#

# Compute effect sizes
## ------------------------------------------------------------------------
library(lsr)
# Independent-means t-test
cohensD(hours ~ group, data = hours_a_b)
# Dependent-means t-test
cohensD(hours_a_b_paired$hours_a, hours_a_b_paired$hours_b, method="paired")

