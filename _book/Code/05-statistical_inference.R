# The following code is taken from the fifth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/introduction-to-statistical-inference.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

req_pacakges <- c("ggplot2","psych","tidyverse","ggplot2")
req_pacakges <- req_pacakges[!req_pacakges %in% installed.packages()]
lapply(req_pacakges, install.packages)
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 4)

#-------------------------------------------------------------------#
#-----------------Sampling from a known population------------------#
#-------------------------------------------------------------------#

# Generate population data 
## ------------------------------------------------------------------------
set.seed(321)
music_listening_population <- data.frame(hours = rnorm(n = 25000, mean = 50, sd = 10))

# Compute descriptives for population
psych::describe(music_listening_population$hours)
# Create histogram
library(ggplot2)
ggplot(music_listening_population) +
  geom_histogram(aes(hours), bins = 50, fill = 'white', color = 'black') +
  geom_vline(xintercept = mean(music_listening_population$hours),size=1) +
  labs(title = "Histogram of listening times in population",
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() 

# Take a random sample of 100 students from the population
## ------------------------------------------------------------------------
n <- 100 #sample size
student_sample <- sample(1:25000, size = n, replace = FALSE)
music_listening_sample <- data.frame(hours = music_listening_population[student_sample,"hours"])
# Compute descriptives for sample
psych::describe(music_listening_sample)
# Create histogram
ggplot(music_listening_sample) +
  geom_histogram(aes(x = hours), bins = 30, fill='white', color='black') +
  geom_vline(xintercept = mean(music_listening_population$hours),size=1,color="red") +
  geom_vline(xintercept = mean(music_listening_sample$hours),size=1) +
  labs(title = "Histogram of listening times in sample",
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() 

# Repeated sampling and the sampling distribution
## ------------------------------------------------------------------------
set.seed(12345)
samples <- 20000 #number of samples
n <- 100 #set sample size
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = n, replace = FALSE)
  means[i,] <- mean(music_listening_population[student_sample,"hours"])
}
means <- data.frame(means = means)
# Compute mean and standard error
mean(means$means) #mean
sd(means$means) #standard error of the mean

# Create histogram
ggplot(means) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  labs(title = "Histogram of mean listening times (sampling distribution)",
       y = 'Number of samples', 
       x = 'Hours') +
  theme_bw() 


#-------------------------------------------------------------------#
#-----------------------Central limit theorem-----------------------#
#-------------------------------------------------------------------#

# Generate population data 
## ------------------------------------------------------------------------
set.seed(321)
music_listening_population_2 <- data.frame(hours = rgamma(25000, shape = 2, scale = 10))

# Compute descriptives for population
psych::describe(music_listening_population_2)
# Create histogram
ggplot(music_listening_population_2) +
  geom_histogram(aes(hours), bins = 50, fill = 'white', color = 'black') +
  geom_vline(xintercept = mean(music_listening_population_2$hours),size=1) +
  labs(title = "Histogram of listening times in population",
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() 

# Take a random sample of 100 students from the population
## ------------------------------------------------------------------------
n <- 100 #sample size
student_sample <- sample(1:25000, size = n, replace = FALSE)
music_listening_sample <- data.frame(hours = music_listening_population_2[student_sample,"hours"])
# Compute descriptives for sample
psych::describe(music_listening_sample)
# Create histogram
ggplot(music_listening_sample) +
  geom_histogram(aes(x = hours), bins = 30, fill='white', color='black') +
  geom_vline(xintercept = mean(music_listening_population_2$hours),size=1,color="red") +
  geom_vline(xintercept = mean(music_listening_sample$hours),size=1) +
  labs(title = "Histogram of listening times in sample",
       y = 'Number of students', 
       x = 'Hours') +
  theme_bw() 

# Repeated sampling and the sampling distribution
## ------------------------------------------------------------------------
set.seed(12345)
samples <- 20000 #number of samples
n <- 100 #set sample size
means <- matrix(NA, nrow = samples)
for (i in 1:samples){
  student_sample <- sample(1:25000, size = n, replace = FALSE)
  means[i,] <- mean(music_listening_population_2[student_sample,"hours"])
}
means <- data.frame(means = means)
# Compute mean and standard error
mean(means$means) #mean
sd(means$means) #standard error of the mean
sd(music_listening_population_2$hours)/sqrt(n) #also the standard error of the mean

# Create histogram
ggplot(means) +
  geom_histogram(aes(x = means), bins = 30, fill='white', color='black') +
  labs(title = "Histogram of mean listening times (sampling distribution)",
       y = 'Number of samples', 
       x = 'Hours') +
  theme_bw() 

#-------------------------------------------------------------------#
#-----------------------Confidence intervals------------------------#
#-------------------------------------------------------------------#

# Draw random sample
## ------------------------------------------------------------------------
set.seed(6789)
n <- 100
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

# Compute mean, critical z-score, and standard error
## ------------------------------------------------------------------------
mean <- mean(music_listening_sample$hours)
mean
se <- sd(music_listening_sample$hours)/sqrt(n)
se
z_crit <- qnorm(0.975)
z_crit

# Compute 95% confidence interval
## ------------------------------------------------------------------------
ci_lower <- mean - z_crit*se
ci_upper <- mean + z_crit*se
ci_lower
ci_upper
