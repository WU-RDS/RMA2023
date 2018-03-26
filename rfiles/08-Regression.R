# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2017/_book/regression.html


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "plyr", "ggplot2", "Hmisc", "lm.beta", "car")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#----------------------------Correlation----------------------------#
#-------------------------------------------------------------------#

# Create data set
## ------------------------------------------------------------------------
library(psych)
attitude <- c(6,9,8,3,10,4,5,2,11,9,10,2)
duration <- c(10,12,12,4,12,6,8,2,18,9,17,2)
att_data <- data.frame(attitude, duration)
att_data <- att_data[order(-attitude), ]
att_data$respodentID <- c(1:12)
str(att_data)
psych::describe(att_data[, c("attitude","duration")])

# Scatterplot
## ------------------------------------------------------------------------
library(ggplot2)
ggplot(att_data,aes(duration, attitude)) + 
  geom_point() + 
  labs(x = "Duration",y = "Attitude", size = 11) +
  theme_bw()

# Compute covariance
# ... manually
## ------------------------------------------------------------------------
x <- att_data$duration
x_bar <- mean(att_data$duration)
y <- att_data$attitude
y_bar <- mean(att_data$attitude)
N <- nrow(att_data)
cov <- (sum((x - x_bar)*(y - y_bar))) / (N - 1)
cov
# ... using the cov function 
## ------------------------------------------------------------------------
cov(att_data$duration, att_data$attitude)          

# Compute correlation coefficient
# ... manually
## ------------------------------------------------------------------------
x_sd <- sd(att_data$duration)
y_sd <- sd(att_data$attitude)
r <- cov/(x_sd*y_sd)
r
# ... using functions
## ------------------------------------------------------------------------
cor(att_data[, c("attitude", "duration")], method = "pearson", use = "complete")
## ------------------------------------------------------------------------
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "pearson", conf.level = 0.95)

# Non-parametric tests
## ------------------------------------------------------------------------
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "spearman", conf.level = 0.95)
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "kendall", conf.level = 0.95)


#-------------------------------------------------------------------#
#----------------------Simple linear regression---------------------#
#-------------------------------------------------------------------#

# Load and inspect data
## ------------------------------------------------------------------------
regression <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_sales_regression.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
regression$country <- factor(regression$country, levels = c(0:1), labels = c("local", "international")) #convert grouping variable to factor
regression$genre <- factor(regression$genre, levels = c(1:3), labels = c("rock", "pop","electronic")) #convert grouping variable to factor
head(regression)

# Descriptive statistics
## ------------------------------------------------------------------------
psych::describe(regression)

# Plot the data 
## ------------------------------------------------------------------------
ggplot(regression, mapping = aes(adspend, sales)) + 
  geom_point(shape = 1) +
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour = "store") + 
  theme_bw()

# Compute regression coefficients 
# ... manually
## ------------------------------------------------------------------------
cov_y_x <- cov(regression$adspend, regression$sales)
cov_y_x
var_x <- var(regression$adspend)
var_x
beta_1 <- cov_y_x/var_x
beta_1
## ------------------------------------------------------------------------
beta_0 <- mean(regression$sales) - beta_1*mean(regression$adspend)
beta_0
# ... using functions
## ------------------------------------------------------------------------
simple_regression <- lm(sales ~ adspend, data = regression) #estimate linear model
summary(simple_regression) #summary of results

# Confidence intervals
## ------------------------------------------------------------------------
confint(simple_regression)

# Compute R2 manually
## ------------------------------------------------------------------------
anova(simple_regression)
## ------------------------------------------------------------------------
r2 <- anova(simple_regression)$'Sum Sq'[1]/(anova(simple_regression)$'Sum Sq'[1] + anova(simple_regression)$'Sum Sq'[2]) #compute R2
r2

# Compute F-test manually
## ------------------------------------------------------------------------
anova(simple_regression) #anova results
f_calc <- anova(simple_regression)$'Mean Sq'[1]/anova(simple_regression)$'Mean Sq'[2] #compute F
f_calc
f_crit <- qf(.95, df1 = 1, df2 = 100) #critical value
f_crit
f_calc > f_crit #test if calculated test statistic is larger than critical value

# Using the model for making predictions
## ------------------------------------------------------------------------
summary(simple_regression)$coefficients[1,1] + # the intercept
summary(simple_regression)$coefficients[2,1]*800 # the slope * 800


#-------------------------------------------------------------------#
#--------------------Multiple linear regression---------------------#
#-------------------------------------------------------------------#

# Run the model
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower, data = regression) #estimate linear model
summary(multiple_regression) #summary of results

# Confidence intervals
## ------------------------------------------------------------------------
confint(multiple_regression)

# Plot of model fit (predicted vs. observed values)
## ------------------------------------------------------------------------
regression$yhat <- predict(simple_regression)
## ------------------------------------------------------------------------
ggplot(regression,aes(yhat,sales)) +  
  geom_point(size=2,shape=1) +  #Use hollow circles
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()

# Added variable plots
## ------------------------------------------------------------------------
library(car)
avPlots(multiple_regression)

# Using the model for making predictions
## ------------------------------------------------------------------------
summary(multiple_regression)$coefficients[1,1] + 
  summary(multiple_regression)$coefficients[2,1]*800 + 
  summary(multiple_regression)$coefficients[3,1]*30 + 
  summary(multiple_regression)$coefficients[4,1]*5

# Standardized coefficients
## ------------------------------------------------------------------------
library(lm.beta)
lm.beta(multiple_regression)


#-------------------------------------------------------------------#
#-------------------------Potential problems------------------------#
#-------------------------------------------------------------------#

# Outliers
## ------------------------------------------------------------------------
regression$stud_resid <- rstudent(multiple_regression)
head(regression)
## ------------------------------------------------------------------------
plot(1:nrow(regression),regression$stud_resid, ylim=c(-3.3,3.3)) #create scatterplot 
abline(h=c(-3,3),col="red",lty=2) #add reference lines
## ------------------------------------------------------------------------
outliers <- subset(regression,abs(stud_resid)>3)
outliers

# Influencial observations
## ------------------------------------------------------------------------
plot(multiple_regression,4)
plot(multiple_regression,5)

# Linear specification
## ------------------------------------------------------------------------
avPlots(multiple_regression)

# Constant error variance (homoscedasticity)
## ------------------------------------------------------------------------
plot(multiple_regression, 1)

# Normal distribution of residuals
## ------------------------------------------------------------------------
plot(multiple_regression,2)
shapiro.test(resid(multiple_regression))

# Multicollinearity
## ------------------------------------------------------------------------
library(Hmisc)
rcorr(as.matrix(regression[,c("adspend","airplay","starpower")]))
plot(regression[,c("adspend","airplay","starpower")])
vif(multiple_regression)


#-------------------------------------------------------------------#
#-----------------------Categorical predictors----------------------#
#-------------------------------------------------------------------#

# Two categories
## ------------------------------------------------------------------------
multiple_regression_bin <- lm(sales ~ adspend + airplay + starpower + country, data = regression) 
summary(multiple_regression_bin)

# More than two categories
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower+ country + genre, data = regression) 
summary(multiple_regression) 
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower+ country + relevel(genre,ref=2), data = regression) 
summary(multiple_regression) #summary of results


#-------------------------------------------------------------------#
#------------------Extensions of the linear model-------------------#
#-------------------------------------------------------------------#

# Interaction effects

# Categorical x continuous
## ------------------------------------------------------------------------
ggplot(regression, aes(adspend, sales, colour = as.factor(country))) +
  geom_point() + 
  geom_smooth(method="lm", alpha=0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour="store") + 
  theme_bw()
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower + country + adspend:country, data = regression) 
summary(multiple_regression)

# Continuous x continuous
## ------------------------------------------------------------------------
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower + adspend:airplay, data = regression)
summary(multiple_regression) 

# Non-linear relationships

# Multiplicative model (aka log-log model)
# Load and inspect data
## ------------------------------------------------------------------------
non_linear_reg <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/non_linear.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
head(non_linear_reg)
## ------------------------------------------------------------------------
ggplot(data = non_linear_reg, aes(x = advertising, y = sales)) +
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) + 
  theme_bw()
# Linear model
## ------------------------------------------------------------------------
linear_reg <- lm(sales ~ advertising, data = non_linear_reg)
summary(linear_reg)
## ------------------------------------------------------------------------
plot(linear_reg,1)
plot(linear_reg,2)
# Multiplicative model (log transformation)
## ------------------------------------------------------------------------
ggplot(data = non_linear_reg, aes(x = log(advertising), y = log(sales))) + 
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) +
  theme_bw()
## ------------------------------------------------------------------------
log_reg <- lm(log(sales) ~ log(advertising), data = non_linear_reg)
summary(log_reg)
## ------------------------------------------------------------------------
plot(log_reg,1)
plot(log_reg,2)
# Model comparison 
## ------------------------------------------------------------------------
non_linear_reg$pred_lin_reg <- predict(linear_reg)
non_linear_reg$pred_log_reg <- predict(log_reg)
ggplot(data = non_linear_reg) +
  geom_point(aes(x = advertising, y = sales),shape=1) + 
  geom_line(data = non_linear_reg,aes(x=advertising,y=pred_lin_reg),color="blue", size=1.05) + 
  geom_line(data = non_linear_reg,aes(x=advertising,y=exp(pred_log_reg)),color="red", size=1.05) + theme_bw()