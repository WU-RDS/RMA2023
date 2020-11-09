# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/regression.html 

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("Hmisc", "psych", "plyr", "ggplot2", "lm.beta", "car", "ggstatsplot", "stargazer", "sandwich", "lmtest", "boot")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)

#-------------------------------------------------------------------#
#----------------------------Correlation----------------------------#
#-------------------------------------------------------------------#

#set options
options(scipen = 999, digits = 8) 

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
  geom_point(size=3) + 
  labs(x = "Duration",y = "Attitude", size = 12) +
  theme_bw()

# Compute covariance
# ... manually
## ------------------------------------------------------------------------
x <- att_data$duration
x_bar <- mean(att_data$duration)
y <- att_data$attitude
y_bar <- mean(att_data$attitude)
N <- nrow(att_data)
cov_x_y <- (sum((x - x_bar)*(y - y_bar))) / (N - 1)
cov_x_y
# ... using the cov function 
## ------------------------------------------------------------------------
cov(att_data$duration, att_data$attitude)          

# Compute correlation coefficient
# ... manually
## ------------------------------------------------------------------------
x_sd <- sd(att_data$duration)
y_sd <- sd(att_data$attitude)
r <- cov_x_y/(x_sd*y_sd)
r
# ... using functions
## ------------------------------------------------------------------------
cor(att_data[, c("attitude", "duration")], method = "pearson")
## ------------------------------------------------------------------------
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "pearson", conf.level = 0.95)

# Non-parametric test
## ------------------------------------------------------------------------
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "spearman", conf.level = 0.95, exact = FALSE)

# Spurious correlation
## ------------------------------------------------------------------------
drownings <- c(109,102,102,98,85,95,96,98,123,94,102)
years <- c(1999:2009)
cage_movies <- c(2,2,2,3,1,1,2,3,4,1,4)
data_cage <- data.frame(years,drownings,cage_movies)
cor.test(data_cage$drownings, data_cage$cage_movies, alternative = "two.sided", method = "pearson", conf.level = 0.95)

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
  geom_hline(yintercept = mean(regression$sales), linetype="dotted") + #mean of sales
  geom_vline(xintercept = mean(regression$adspend), linetype="dotted") + #mean of advertising
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales") + 
  theme_bw()

# Alternatively, using ggstatsplot
library(ggstatsplot)
scatterplot <- ggscatterstats(
  data = regression,
  x = adspend,
  y = sales,
  xlab = "Advertising expenditure (EUR)", # label for x axis
  ylab = "Sales", # label for y axis
  line.color = "black", # changing regression line color line
  title = "Advertising expenditure and Sales", # title text for the plot
  marginal.type = "histogram", # type of marginal distribution to be displayed
  xfill = "steelblue", # color fill for x-axis marginal distribution
  yfill = "darkgrey", # color fill for y-axis marginal distribution
  xalpha = 0.6, # transparency for x-axis marginal distribution
  yalpha = 0.6, # transparency for y-axis marginal distribution
  bf.message = FALSE,
  messages = FALSE # turn off messages and notes
)
scatterplot
#save plot (optional)
## ------------------------------------------------------------------------
ggsave("scatterplot.jpg", height = 6, width = 7.5,scatterplot)

# Compute regression coefficients 
# ... manually
## ------------------------------------------------------------------------
cov_y_x <- cov(regression$adspend, regression$sales)
cov_y_x
var_x <- var(regression$adspend)
var_x
beta_1 <- cov_y_x/var_x
beta_1
# ... or, alternatively
cor_y_x <- cor(regression$adspend, regression$sales)
beta_1_a <- cor_y_x * (sd(regression$sales)/sd(regression$adspend))
beta_1_a

## ------------------------------------------------------------------------
beta_0 <- mean(regression$sales) - beta_1*mean(regression$adspend)
beta_0

# ... using the lm()-function
## ------------------------------------------------------------------------
simple_regression <- lm(sales ~ adspend, data = regression) #estimate linear model
summary(simple_regression) #summary of results

# Compute the standard error by hand
SEE <- sqrt(sum((regression$sales - predict(simple_regression))^2)/198)
SEE
SE <- SEE*sqrt(1/sum((regression$adspend-mean(regression$adspend))^2))
SE
t_calc <- beta_1/SE
t_calc
t_crit <- qt(0.975,198)
t_crit
t_calc > t_crit

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
f_crit <- qf(.95, df1 = 1, df2 = 198) #critical value
f_crit
f_calc > f_crit #test if calculated test statistic is larger than critical value

# Using the model for making predictions
## ------------------------------------------------------------------------
prediction <- summary(simple_regression)$coefficients[1,1] + # the intercept
              summary(simple_regression)$coefficients[2,1]*1800 # the slope * 800
prediction

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

# visualization
## ------------------------------------------------------------------------
ggcoefstats(x = multiple_regression,
            title = "Sales predicted by adspend, airplay, & starpower")
#save plot (optional)
## ------------------------------------------------------------------------
ggsave("lm_out.jpg", height = 6, width = 7.5)

# reporting using stargazer
# https://www.jakeruss.com/cheatsheets/stargazer/
library(stargazer)
stargazer(multiple_regression, type = "text",ci = FALSE)
stargazer(multiple_regression, type = "text",ci = TRUE, ci.level = 0.95, ci.separator = "; ")

# Standardized coefficients
## ------------------------------------------------------------------------
library(lm.beta)
lm.beta(multiple_regression)
# The same can be achieved using the scale function on the variables in the regression equation
## ------------------------------------------------------------------------
multiple_regression_std <- lm(scale(sales) ~ scale(adspend) + scale(airplay) + scale(starpower), data = regression) #estimate linear model
summary(multiple_regression_std) #summary of results

# Plot of model fit (predicted vs. observed values)
## ------------------------------------------------------------------------
regression$yhat <- predict(multiple_regression)
## ------------------------------------------------------------------------
ggplot(regression,aes(x = yhat, y = sales)) +  
  geom_point(size=2,shape=1) +  #Use hollow circles
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()
# Plot model fit for bivariate model (predicted vs. observed values)
## ------------------------------------------------------------------------
regression$yhat_1 <- predict(simple_regression)
## ------------------------------------------------------------------------
ggplot(regression,aes(x = yhat_1, y = sales)) +  
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

# Influential observations
## ------------------------------------------------------------------------
plot(multiple_regression,4)
plot(multiple_regression,5)

# Linear specification
## ------------------------------------------------------------------------
avPlots(multiple_regression)

# Constant error variance (homoscedasticity)
## ------------------------------------------------------------------------
plot(multiple_regression, 1)
# Breusch-Pagan Test
library(lmtest)
bptest(multiple_regression)
# If test is significant, transform the data, or use robust SE's:
library(sandwich)
coeftest(multiple_regression, vcov = vcovHC(multiple_regression))

# Normal distribution of residuals
## ------------------------------------------------------------------------
plot(multiple_regression,2)
shapiro.test(resid(multiple_regression))
# If the residuals do not follow a normal distribution, transform the data or use bootstrapping
# To obtain confidence intervals
library(boot)
# function to obtain regression coefficients
bs <- function(formula, data, indices) {
  d <- data[indices,] # allows boot to select sample
  fit <- lm(formula, data=d)
  return(coef(fit))
}
# bootstrapping with 2000 replications
boot_out <- boot(data=regression, statistic=bs, R=2000, formula = sales ~ adspend + airplay + starpower)
# get 95% confidence intervals
boot.ci(boot_out, type="bca", index=1) # intercept
boot.ci(boot_out, type="bca", index=2) # adspend
boot.ci(boot_out, type="bca", index=3) # airplay
boot.ci(boot_out, type="bca", index=4) # starpower
# view results
plot(boot_out, index=1) # intercept
plot(boot_out, index=2) # adspend
plot(boot_out, index=3) # airplay
plot(boot_out, index=4) # starpower

# Multicollinearity
## ------------------------------------------------------------------------
library(Hmisc)
rcorr(as.matrix(regression[,c("adspend","airplay","starpower")]))
plot(regression[,c("adspend","airplay","starpower")])

# alternatively...
library(ggstatsplot)
ggcorrmat(
  data = regression[,c("adspend","airplay","starpower")],
  matrix.type = "lower", # type of visualization matrix
  colors = c("darkgrey", "white", "steelblue"),
  title = "Correlalogram of independent variables")

# compute variance inflation factors
vif(multiple_regression)

#-------------------------------------------------------------------#
#----------------------Out-of-sample prediction---------------------#
#-------------------------------------------------------------------#

# randomly split into training and test data:
set.seed(123)
n <- nrow(regression)
train <- sample(1:n,round(n*2/3))
test <- (1:n)[-train]

# estimate linear model based on training data
multiple_train <- lm(sales ~ adspend + airplay + starpower, data = regression, subset=train) 
summary(multiple_train) #summary of results

# using coefficients to predict test data
pred_lm <- predict(multiple_train,newdata = regression[test,])
cor(regression[test,"sales"],pred_lm)^2 # R^2 for test data

# plot predicted vs. observed values for test data
plot(regression[test,"sales"],pred_lm,xlab="y measured",ylab="y predicted",cex.lab=1.3)
abline(c(0,1))

#-------------------------------------------------------------------#
#-------------------------Variable selection------------------------#
#-------------------------------------------------------------------#

set.seed(123)
# Add another random variable
regression$var_test <- rnorm(nrow(regression),0,1)

# Model comparison with anova
lm0 <- lm(sales ~ 1, data = regression) 
lm1 <- lm(sales ~ adspend, data = regression) 
lm2 <- lm(sales ~ adspend + airplay, data = regression) 
lm3 <- lm(sales ~ adspend + airplay + starpower, data = regression) 
lm4 <- lm(sales ~ adspend + airplay + starpower + var_test, data = regression) 
anova(lm0, lm1, lm2, lm3, lm4)

# Stepwise variable selection
# Automatic model selection with step
model_lmstep <- step(lm4)
model_lmstep

# Comparison of the models
anova(model_lmstep,lm4)

#-------------------------------------------------------------------#
#-----------------------Categorical predictors----------------------#
#-------------------------------------------------------------------#

# Two categories
## ------------------------------------------------------------------------
multiple_regression_bin <- lm(sales ~ adspend + airplay + starpower + country, data = regression) 
summary(multiple_regression_bin)
# More than two categories
## ------------------------------------------------------------------------
multiple_regression_ext <- lm(sales ~ adspend + airplay + starpower+ country + genre, data = regression) 
summary(multiple_regression_ext) 
## ------------------------------------------------------------------------
multiple_regression_ext <- lm(sales ~ adspend + airplay + starpower+ country + relevel(genre,ref=2), data = regression) 
summary(multiple_regression_ext) #summary of results

# visualization
## ------------------------------------------------------------------------
ggcoefstats(x = multiple_regression_ext,
            title = "Sales predicted by adspend, airplay, starpower, country, & genre")
#save plot (optional)
## ------------------------------------------------------------------------
ggsave("lm_out_ext.jpg", height = 6, width = 8.5)
# reporting using stargazer
stargazer(multiple_regression, multiple_regression_ext, type = "text",ci = TRUE, ci.level = 0.95, ci.separator = "; ")


#-------------------------------------------------------------------#
#------------------------Interaction Effects------------------------#
#-------------------------------------------------------------------#

# Categorical x continuous
## ------------------------------------------------------------------------
ggplot(regression, aes(adspend, sales, colour = as.factor(country))) +
  geom_point() + 
  geom_smooth(method="lm", alpha=0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour="country") + 
  theme_bw()
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower + country + adspend:country, data = regression) 
summary(multiple_regression)

# Continuous x continuous
## ------------------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower + adspend:airplay, data = regression)
summary(multiple_regression) 

# Mean centering variables
## ------------------------------------------------------------------------
regression$c_adspend <- regression$adspend-mean(regression$adspend)
regression$c_airplay <- regression$airplay-mean(regression$airplay)
regression$c_starpower <- regression$starpower-mean(regression$starpower)
multiple_regression <- lm(sales ~ c_adspend + c_airplay + c_starpower + c_adspend:c_airplay, data = regression)
summary(multiple_regression) 

#-------------------------------------------------------------------#
#----------------------Non-linear relationships---------------------#
#-------------------------------------------------------------------#

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
confint(linear_reg)
## ------------------------------------------------------------------------
plot(linear_reg,1)
plot(linear_reg,2)
shapiro.test(resid(linear_reg))
# Multiplicative model (log transformation)
## ------------------------------------------------------------------------
ggplot(data = non_linear_reg, aes(x = log(advertising), y = log(sales))) + 
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) +
  theme_bw()
## ------------------------------------------------------------------------
log_reg <- lm(log(sales) ~ log(advertising), data = non_linear_reg)
summary(log_reg)
confint(log_reg)
## ------------------------------------------------------------------------
plot(log_reg,1)
plot(log_reg,2)
shapiro.test(resid(log_reg))
# Model comparison 
## ------------------------------------------------------------------------
non_linear_reg$pred_lin_reg <- predict(linear_reg)
non_linear_reg$pred_log_reg <- predict(log_reg)
ggplot(data = non_linear_reg) +
  geom_point(aes(x = advertising, y = sales),shape=1) + 
  geom_line(data = non_linear_reg,aes(x=advertising,y=pred_lin_reg),color="blue", size=1.05) + 
  geom_line(data = non_linear_reg,aes(x=advertising,y=exp(pred_log_reg)),color="red", size=1.05) + theme_bw()
# Making predictions
advertising <- 1000
pred <- exp(log_reg$coefficients[1] + log_reg$coefficients[2]*log(advertising))
pred

# Quadratic model
# Load and inspect data
## ------------------------------------------------------------------------
quad_reg <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/sales_quad.csv", 
                             sep = ";", 
                             header = TRUE) #read in data
head(quad_reg)
## ------------------------------------------------------------------------
ggplot(data = quad_reg, aes(x = advertising, y = sales)) +
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) + 
  theme_bw() + xlab("Advertising (thsd. Euro)") + ylab("Sales (million units)") 

# Linear model
## ------------------------------------------------------------------------
linear_reg <- lm(sales ~ advertising, data = quad_reg)
summary(linear_reg)
confint(linear_reg)
## ------------------------------------------------------------------------
plot(linear_reg,1)
plot(linear_reg,2)
shapiro.test(resid(linear_reg))
# Quadratic model
## ------------------------------------------------------------------------
quad_mod <- lm(sales ~ advertising + I(advertising^2), data = quad_reg)
summary(quad_mod)
confint(quad_mod)
quad_reg$predict <- predict(quad_mod)
ggplot(data = quad_reg, aes(x = predict, y = sales)) + 
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) +
  theme_bw()
## ------------------------------------------------------------------------
plot(quad_mod,1)
plot(quad_mod,2)
shapiro.test(resid(quad_mod))
# Model comparison 
## ------------------------------------------------------------------------
quad_reg$pred_lin_reg <- predict(linear_reg)
ggplot(data = quad_reg) +
  geom_point(aes(x = advertising, y = sales),shape=1) + 
  geom_line(data = quad_reg,aes(x=advertising,y=pred_lin_reg),color="blue", size=1.05) + 
  geom_line(data = quad_reg,aes(x=advertising,y=predict),color="red", size=1.05) + theme_bw() + xlab("Advertising (thsd. Euro)") + ylab("Sales (million units)") 
# Turning point
## ------------------------------------------------------------------------
x_turn <- -quad_mod$coefficients[2]/(2*quad_mod$coefficients[3])
ggplot(data = quad_reg) +
  geom_point(aes(x = advertising, y = sales),shape=1) + 
  geom_line(data = quad_reg,aes(x=advertising,y=predict),color="red", size=1.05) +
  geom_vline(xintercept = x_turn,color="black") +
  geom_vline(xintercept = mean(quad_reg$advertising),color="black", linetype = "dashed", size=1.05) + theme_bw() + xlab("Advertising (thsd. Euro)") + ylab("Sales (million units)") 
# Making predictions
advertising <- 100
pred <- quad_mod$coefficients[1] + quad_mod$coefficients[2]*advertising+quad_mod$coefficients[3]*(advertising^2)
pred

# Mean centering
## ------------------------------------------------------------------------
quad_reg$c_advertising <- quad_reg$advertising - mean(quad_reg$advertising)
quad_mod_c <- lm(sales ~ c_advertising + I(c_advertising^2), data = quad_reg)
summary(quad_mod_c)
confint(quad_mod_c)

#-------------------------------------------------------------------#
#------------------------Logistic regression------------------------#
#-------------------------------------------------------------------#

#Create a function we will be using
logisticPseudoR2s <- function(LogModel) {
  dev <- LogModel$deviance 
  nullDev <- LogModel$null.deviance 
  modelN <- length(LogModel$fitted.values)
  R.l <-  1 -  dev / nullDev
  R.cs <- 1- exp ( -(nullDev - dev) / modelN)
  R.n <- R.cs / ( 1 - ( exp (-(nullDev / modelN))))
  cat("Pseudo R^2 for logistic regression\n")
  cat("Hosmer and Lemeshow R^2  ", round(R.l, 3), "\n")
  cat("Cox and Snell R^2        ", round(R.cs, 3), "\n")
  cat("Nagelkerke R^2           ", round(R.n, 3),    "\n")
}

#Import data
## ------------------------------------------------------------------------
chart_data <- read.delim2("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/chart_data_logistic.dat",header=T, sep = "\t",stringsAsFactors = F, dec = ".")
# Inspect data
head(chart_data)
str(chart_data)
#Create a new dummy variable "top10", which is 1 if a song made it to the top10 and 0 else:
chart_data$top10 <- ifelse(chart_data$rank<11,1,0)

#Scatterplot showing the association between two variables using a linear model
ggplot(chart_data,aes(danceability,top10)) +  
  geom_point(shape=1) +
  geom_smooth(method = "lm") +
  theme_bw()

#Scatterplot showing the association between two variables using a glm
ggplot(chart_data,aes(danceability,top10)) +  
  geom_point(shape=1) +
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"), 
              se = FALSE) +
  theme_bw()

#Run the glm
logit_model <- glm(top10 ~ danceability,family=binomial(link='logit'),data=chart_data)
#Inspect model summary
summary(logit_model )
#Inspect Pseudo R2s
logisticPseudoR2s(logit_model )
#Convert coefficients to odds ratios
exp(coef(logit_model ))

#Re-scale independet variable
chart_data$danceability_100 <- chart_data$danceability*100 
#Run the regression model
logit_model <- glm(top10 ~ danceability_100,family=binomial(link='logit'),data=chart_data)
#Inspect model summary
summary(logit_model )
#Inspect Pseudo R2s
logisticPseudoR2s(logit_model )
#Convert coefficients to odds ratios
exp(coef(logit_model ))
#Confidence interval
confint(logit_model)
#Overall model test
llh_ratio <- logit_model$null.deviance-logit_model$deviance
llh_ratio
library(lmtest)
lrtest(logit_model)

#Probability of a top 10 hit with a danceability of 50
prob_50 <- exp(-(-summary(logit_model)$coefficients[1,1]-summary(logit_model)$coefficients[2,1]*50 ))
prob_50

#Probability of a top 10 hit with a danceability of 51
prob_51 <- exp(-(-summary(logit_model)$coefficients[1,1]-summary(logit_model)$coefficients[2,1]*51 ))
prob_51

#Odds ratio
prob_51/prob_50

#Logistic model with multiple predictors
#Convert variables
chart_data$spotify_followers_m <- chart_data$spotifyFollowers/1000000
chart_data$weeks_since_release <- chart_data$daysSinceRelease/7
#Run model
multiple_logit_model <- glm(top10 ~ danceability_100 + spotify_followers_m + weeks_since_release,family=binomial(link='logit'),data=chart_data)
summary(multiple_logit_model)
logisticPseudoR2s(multiple_logit_model)
exp(coef(multiple_logit_model))
confint(multiple_logit_model)

