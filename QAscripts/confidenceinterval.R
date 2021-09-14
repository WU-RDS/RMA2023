set.seed(1)
## True standard deviation
sigma <- 10
## Number of observations
n1 <- 1000
## 95 % CI
alpha <- 0.05
## Sample
sample1 <- rnorm(n1, 0, sd = sigma)

## Plot histogram of sample
hist(sample1)
range(sample1)

mean1 <- mean(sample1)
## Standard error of the mean depends on sample size
se1 <- sigma/sqrt(n1)
## Calculate CI
CI1 <- c(mean1 - qnorm(alpha/2) * se1, mean1 + qnorm(alpha/2) * se1)
CI1
## Add CI to plot
abline(v = CI1, col = "red")


## Same calculations with lower sample size
n2 <- 100
sample2 <- rnorm(n2, 0, sd = sigma)
hist(sample2)
range(sample2)
mean2 <- mean(sample2)
se2 <- sigma/sqrt(n2)
CI2 <- c(mean2 - qnorm(alpha/2) * se2, mean2 + qnorm(alpha/2) * se2)
## Now CI is much wider
CI2
abline(v = CI2, col = "red")
