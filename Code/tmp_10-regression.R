## ----message=FALSE, warning=FALSE, echo=F, eval=TRUE,paged.print = FALSE------------------------------------------------
options(digits = 8)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,paged.print = FALSE---------------------------------------------
library(psych)
attitude <- c(6,9,8,3,10,4,5,2,11,9,10,2)
duration <- c(10,12,12,4,12,6,8,2,18,9,17,2)
att_data <- data.frame(attitude, duration)
att_data <- att_data[order(-attitude), ]
att_data$respodentID <- c(1:12)
str(att_data)
psych::describe(att_data[, c("attitude","duration")])
att_data


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Scores for duration of residency variable"----
library(ggplot2)
h <- round(mean(att_data$duration), 2)
ggplot(att_data, aes(x = respodentID, y = duration)) + 
  geom_point(size = 3, color = "deepskyblue4") + 
  scale_x_continuous(breaks = 1:12) + 
  geom_hline(data = att_data, aes(yintercept = mean(duration)), color ="deepskyblue4") +
  labs(x = "Observations",y = "Duration of residency", size = 11) +
  coord_cartesian(ylim = c(0, 18)) +
  geom_segment(aes(x = respodentID,y = duration, xend = respodentID, 
                   yend = mean(duration)), color = "deepskyblue4", size = 1) + 
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size=16),
        strip.text.x = element_text(size = 16),
        legend.position="none") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Scores for attitude variable"----
ggplot(att_data, aes(x = respodentID, y = attitude)) + 
  geom_point(size = 3, color = "#f9756d") + 
  scale_x_continuous(breaks = 1:12) + 
  geom_hline(data = att_data, aes(yintercept = mean(attitude)), color = "#f9756d") +
  labs(x = "Observations",y = "Attitude", size = 11) +
  coord_cartesian(ylim = c(0,18)) +
  geom_segment(aes(x = respodentID, y = attitude, xend = respodentID, 
                   yend = mean(attitude)), color = "#f9756d", size = 1) + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE,fig.align="center", fig.cap = "Scores for attitude and duration of residency variables"----
ggplot(att_data) + 
  geom_point(size = 3, aes(respodentID, attitude), color = "#f9756d") +
  geom_point(size = 3, aes(respodentID, duration), color = "deepskyblue4")  + 
  scale_x_continuous(breaks = 1:12) + 
  geom_hline(data = att_data, aes(yintercept = mean(duration)), color = "deepskyblue4") +
  geom_hline(data = att_data, aes(yintercept = mean(attitude)), color = "#f9756d") +
  labs(x = "Observations", y = "Duration/Attitude", size = 11) +
  coord_cartesian(ylim = c(0, 18)) +
  scale_color_manual(values = c("#f9756d", "deepskyblue4")) +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Scatterplot for durationand attitute variables"----
ggplot(att_data) + 
  geom_point(size = 3, aes(duration, attitude)) + 
  labs(x = "Duration",y = "Attitude", size = 11) +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
x <- att_data$duration
x_bar <- mean(att_data$duration)
y <- att_data$attitude
y_bar <- mean(att_data$attitude)
N <- nrow(att_data)
cov <- (sum((x - x_bar)*(y - y_bar))) / (N - 1)
cov


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
cov(att_data$duration, att_data$attitude)          # apply the cov function 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
x_sd <- sd(att_data$duration)
y_sd <- sd(att_data$attitude)
r <- cov/(x_sd*y_sd)
r


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
cor(att_data[, c("attitude", "duration")], method = "pearson", use = "complete")


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
t_calc <- r*sqrt(N - 2)/sqrt(1 - r^2) #calculated test statistic
t_calc
df <- (N - 2) #degrees of freedom
t_crit <- qt(0.975, df) #critical value
t_crit
pt(q = t_calc, df = df, lower.tail = F) * 2 #p-value 


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "pearson", conf.level = 0.95)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "spearman", conf.level = 0.95)
cor.test(att_data$attitude, att_data$duration, alternative = "two.sided", method = "kendall", conf.level = 0.95)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
regression <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_sales_regression.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
regression$country <- factor(regression$country, levels = c(0:1), labels = c("local", "international")) #convert grouping variable to factor
regression$genre <- factor(regression$genre, levels = c(1:3), labels = c("rock", "pop","electronic")) #convert grouping variable to factor
head(regression)


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE, paged.print = FALSE--------------------------------------------
psych::describe(regression) #descriptive statistics using psych


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Ordinary least squares (OLS)"----
library(dplyr)
options(scipen = 999)
rm(regression)
rm(advertising)
regression <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/multiple_regression.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
lm <- lm(sales ~ adspend, data = regression)
regression$yhat <- predict(lm)

ggplot(regression, aes(x = adspend,y = sales)) + 
  geom_point(size = 2, color = "deepskyblue4") + 
  labs(x = "Advertising expenditure (in Euros)", y = "Sales", size = 11) +
  geom_segment(aes(x = adspend, y = sales, xend = adspend, yend = yhat), 
               color = "grey",size = 0.5, linetype = "solid", alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size = 16),
        strip.text.x = element_text(size = 16),
        legend.position="none") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE-----------------------------------------------------------------
cov_y_x <- cov(regression$adspend, regression$sales)
cov_y_x
var_x <- var(regression$adspend)
var_x
beta_1 <- cov_y_x/var_x
beta_1


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE-----------------------------------------------------------------
beta_0 <- mean(regression$sales) - beta_1*mean(regression$adspend)
beta_0


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = "Scatterplot"--------------------
ggplot(regression, mapping = aes(adspend, sales)) + 
  geom_point(shape = 1) +
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
simple_regression <- lm(sales ~ adspend, data = regression) #estimate linear model
summary(simple_regression) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
confint(simple_regression)


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Total sum of squares"----------
library(dplyr)
options(scipen = 999)
rm(regression)
rm(advertising)
regression <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_sales_regression.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
lm <- lm(sales ~ adspend, data = regression)

regression$yhat <- predict(lm)

ggplot(regression, aes(x = adspend, y = sales)) + 
  geom_point(size = 2, color = "deepskyblue4") + 
  labs(x = "Advertising", y = "Sales", size = 11) +
  geom_segment(aes(x = adspend, y = sales, xend = adspend, 
                   yend = mean(sales)), color = "grey", 
               size = 0.5, linetype = "solid", alpha = 0.8) + 
  geom_hline(data = regression, aes(yintercept = mean(sales)), color = "black", size = 1) +
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size = 16),
        strip.text.x = element_text(size = 16),
        legend.position="none") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Ordinary least squares (OLS)"----
ggplot(regression, aes(x = adspend, y = sales)) + 
  geom_point(size = 2, color = "deepskyblue4") + 
  labs(x = "Advertising",y = "Sales", size = 11) +
  geom_segment(aes(x = adspend, y = yhat, xend = adspend, yend = mean(sales)), 
               color = "grey", size = 0.5, linetype = "solid", alpha = 0.8) + 
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  geom_hline(data = regression, aes(yintercept = mean(sales)), color = "black", size = 1) +
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size = 16),
        strip.text.x = element_text(size = 16),
        legend.position = "none") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Ordinary least squares (OLS)"----
ggplot(regression, aes(x = adspend, y = sales)) + 
  geom_point(size = 2, color = "deepskyblue4") + 
  labs(x = "Advertising",y = "Sales", size = 11) +
  geom_segment(aes(x = adspend, y = sales, xend = adspend, yend = yhat),
               color = "grey", size = 0.5, linetype = "solid", alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size = 16),
        strip.text.x = element_text(size = 16),
        legend.position = "none") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.height = 4, fig.width = 10, fig.cap="Good vs. bad model fit"----
library(cowplot)
library(gridExtra)
library(grid)
set.seed(44)
#x3 <- rlnorm(250, log(1), log(0.6))
options(scipen = 999)
options(digits = 2)
x1 <- rnorm(200,614.41,485)
x <- as.data.frame(subset(x1,x1>0))
names(x)<-c('adspend')
error <- rnorm(nrow(x))
sales <- round(134 + 0.094*x$adspend + 50*error)
sales_data <- data.frame(sales,x$adspend) 
names(sales_data)<-c('sales','adspend')
examplereg <- subset(sales_data,sales>0 & adspend>0)
#summary(examplereg)
lm <- lm(sales ~ adspend, data = examplereg)
#summary(lm)
examplereg$yhat <- predict(lm)

scatter_plot1 <- ggplot(examplereg,aes(adspend,sales)) +  
  geom_point(size=2,shape=1) +    # Use hollow circles
  geom_smooth(method="lm") + # Add linear examplereg line (by default includes 95% confidence region);
  scale_x_continuous(name="advertising expenditures", limits=c(0, 1800)) +
  scale_y_continuous(name="sales", limits=c(0, 400)) +
  theme_bw() +
  labs(title = paste0("R-squared: ",round(summary(lm)$r.squared,2))) 

#x3 <- rlnorm(250, log(1), log(0.6))
options(scipen = 999)
options(digits = 2)
x1 <- rnorm(200,614.41,485)
x <- as.data.frame(subset(x1,x1>0))
names(x)<-c('adspend')
error <- rnorm(nrow(x))
sales <- round(134 + 0.094*x$adspend + 20*error)
sales_data <- data.frame(sales,x$adspend) 
names(sales_data)<-c('sales','adspend')
#summary(sales_data)
examplereg <- subset(sales_data,sales>0 & adspend>0)
#summary(examplereg)

lm <- lm(sales ~ adspend, data = examplereg)
examplereg$yhat <- predict(lm)

scatter_plot2 <- ggplot(examplereg,aes(adspend,sales)) +  
  geom_point(size=2,shape=1) +    # Use hollow circles
  geom_smooth(method="lm") + # Add linear examplereg line (by default includes 95% confidence region);
  scale_x_continuous(name="advertising expenditures", limits=c(0, 1800)) +
  scale_y_continuous(name="sales", limits=c(0, 400)) +
  theme_bw() +
  labs(title = paste0("R-squared: ",round(summary(lm)$r.squared,2))) 

#p <- plot_grid(plot1, plot2, ncol = 2)
p <- plot_grid(scatter_plot1,scatter_plot2, ncol = 2)
print(p)
# now add the title
#title <- ggdraw() + draw_label("", fontface='bold')
#plot_full <- plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins
#print(plot_full)


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE,paged.print = FALSE---------------------------------------------
anova(simple_regression) #anova results


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE,paged.print = FALSE---------------------------------------------
r2 <- anova(simple_regression)$'Sum Sq'[1]/(anova(simple_regression)$'Sum Sq'[1] + anova(simple_regression)$'Sum Sq'[2]) #compute R2
r2


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE,paged.print = FALSE---------------------------------------------
anova(simple_regression) #anova results
f_calc <- anova(simple_regression)$'Mean Sq'[1]/anova(simple_regression)$'Mean Sq'[2] #compute F
f_calc
f_crit <- qf(.95, df1 = 1, df2 = 100) #critical value
f_crit
f_calc > f_crit #test if calculated test statistic is larger than critical value


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE-----------------------------------------------------------------
summary(simple_regression)$coefficients[1,1] + # the intercept
summary(simple_regression)$coefficients[2,1]*800 # the slope * 800


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE,fig.align="center", fig.cap = "Regression plane"---------------
#https://stackoverflow.com/questions/44322350/add-regression-plane-in-r-using-plotly
library(plotly)
library(reshape2)
n <- nrow(regression)
x1 <- regression$adspend
x2 <- regression$airplay
x3 <- rnorm(n)>0.5
y <- regression$sales
df <- data.frame(y, x1, x2)

### Estimation of the regression plane
mod <- lm(y ~ x1+x2)
cf.mod <- coef(mod)

### Calculate z on a grid of x-y values
x1.seq <- seq(min(x1),max(x1),length.out=25)
x2.seq <- seq(min(x2),max(x2),length.out=25)
z <- t(outer(x1.seq, x2.seq, function(x,y) cf.mod[1]+cf.mod[2]*x+cf.mod[3]*y))

#### Draw the plane with "plot_ly" and add points with "add_trace"
cols <- c("darkgray", "steelblue")
cols <- cols[x3+1] 
library(plotly)
p <- plot_ly(x=~x1.seq, y=~x2.seq, z=~z,
  colors = c("#A9D0F5", "#08088A"),type="surface") %>%
  add_trace(data=df, x=x1, y=x2, z=y, mode="markers", type="scatter3d",
  marker = list(color=cols, size=3, opacity=0.8, symbol=75)) %>%
  layout(scene = list(
    xaxis = list(title = "adspend"),
    yaxis = list(title = "airplay"),
    zaxis = list(title = "sales")))
p


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower, data = regression) #estimate linear model
summary(multiple_regression) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
confint(multiple_regression)


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE,fig.align="center", fig.cap = "Confidence intervals for regression model"----
library(ggstatsplot)
ggcoefstats(x = multiple_regression,
            title = "Sales predicted by adspend, airplay, & starpower")


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE-----------------------------------------------------------------
regression$yhat <- predict(simple_regression)


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE,fig.align="center", fig.cap = "Model fit"-----------------------
ggplot(regression,aes(yhat,sales)) +  
  geom_point(size=2,shape=1) +  #Use hollow circles
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Partial plots"-------------------
library(car)
avPlots(multiple_regression)


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE-----------------------------------------------------------------
summary(multiple_regression)$coefficients[1,1] + 
  summary(multiple_regression)$coefficients[2,1]*800 + 
  summary(multiple_regression)$coefficients[3,1]*30 + 
  summary(multiple_regression)$coefficients[4,1]*5


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE-----------------------------------------------------------------
library(lm.beta)
lm.beta(multiple_regression)


## ---- message=F, warning=F, echo = FALSE, eval = TRUE, fig.cap = "Effects of outliers", fig.align="center"--------------
set.seed(123)
x <- 1:30
y <- x*2.8 + rnorm(30, sd = 10)

y_altered <- y
y_altered[29] <- -50
y_altered[27] <- -47

ggplot(data = data.frame(X = x, Y = y, Y_alt = y_altered), aes(x = X, y = Y)) + 
  geom_point(aes(x = X, y = Y_alt), col = "red") + 
  geom_point() + 
  geom_point(aes(x = 27, y = Y[27]), col = "green") +
  geom_point(aes(x = 29, y = Y[29]), col = "green") +
  geom_smooth(method = "lm", se = FALSE, col = "firebrick", lwd = 0.5) + 
  geom_smooth(aes(x = X, y = Y_alt), method = "lm", se = FALSE, col = "black", lwd = 0.5, lty = 2) +
  theme_bw()




## ---- warning=FALSE, message=FALSE--------------------------------------------------------------------------------------
regression$stud_resid <- rstudent(multiple_regression)
head(regression)


## ---- warning=FALSE, message=FALSE, fig.cap="Plot of the studentized residuals", fig.align="center"---------------------
plot(1:nrow(regression),regression$stud_resid, ylim=c(-3.3,3.3)) #create scatterplot 
abline(h=c(-3,3),col="red",lty=2) #add reference lines


## ---- warning = FALSE, message = FALSE----------------------------------------------------------------------------------
outliers <- subset(regression,abs(stud_resid)>3)
outliers


## ---- warning = FALSE, message = FALSE,fig.align="center", fig.cap = "Cook's distance"----------------------------------
plot(multiple_regression,4)


## ---- warning = FALSE, message = FALSE,fig.align="center", fig.cap = "Residuals vs. Leverage"---------------------------
plot(multiple_regression,5)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Partial plots"-------------------
library(car)
avPlots(multiple_regression)


## ---- warning = FALSE, message = FALSE,fig.align="center", fig.cap = "Residuals vs. fitted values"----------------------
plot(multiple_regression, 1)


## ---- warning = FALSE, message = FALSE----------------------------------------------------------------------------------
library(lmtest)
bptest(multiple_regression)


## ---- warning = FALSE, message = FALSE----------------------------------------------------------------------------------
library(sandwich)
coeftest(multiple_regression, vcov = vcovHC(multiple_regression))


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE, fig.align = "center", fig.cap = "Q-Q plot"------------
plot(multiple_regression,2)


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE, fig.align = "center", fig.cap = "Normally distributed Q-Q plot"----
shapiro.test(resid(multiple_regression))


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
# function to obtain regression coefficients
bs <- function(formula, data, indices) {
  d <- data[indices,] # allows boot to select sample
  fit <- lm(formula, data=d)
  return(coef(fit))
}


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
# If the residuals do not follow a normal distribution, transform the data or use bootstrapping
library(boot)
# bootstrapping with 2000 replications
boot_out <- boot(data=regression, statistic=bs, R=2000, formula = sales ~ adspend + airplay + starpower)


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
# get 95% confidence intervals
boot.ci(boot_out, type="bca", index=1) # intercept


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
# get 95% confidence intervals
boot.ci(boot_out, type="bca", index=2) # adspend
boot.ci(boot_out, type="bca", index=3) # airplay
boot.ci(boot_out, type="bca", index=4) # starpower


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
# get 95% confidence intervals for standard model
confint(multiple_regression)


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
plot(boot_out, index=1) # intercept
plot(boot_out, index=2) # adspend
plot(boot_out, index=3) # airplay
plot(boot_out, index=4) # starpower


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
library("Hmisc")
rcorr(as.matrix(regression[,c("adspend","airplay","starpower")]))


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE, fig.align = "center", fig.cap = "Bivariate correlation plots"----
plot(regression[,c("adspend","airplay","starpower")])


## ---- eval = TRUE, echo = TRUE, warning = FALSE, message = FALSE--------------------------------------------------------
library(car)
vif(multiple_regression)


## ---- echo = FALSE------------------------------------------------------------------------------------------------------
set.seed(123)
popularity <- runif(200, 0, 10) 
playlists <- round(rnorm(200,10,10)*popularity,0)
streams <- 40*popularity + 2*playlists +1000+ rnorm(200, 100, 100)
streaming_data <- data.frame(popularity, playlists, streams)
streaming_data <- subset(streaming_data,playlists>=0)


## -----------------------------------------------------------------------------------------------------------------------
head(streaming_data)


## -----------------------------------------------------------------------------------------------------------------------
stream_model_1 <- lm(streams ~ playlists , data = streaming_data)
summary(stream_model_1)


## -----------------------------------------------------------------------------------------------------------------------
stream_model_2 <- lm(streams ~ playlists + popularity, data = streaming_data)
summary(stream_model_2)


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
# randomly split into training and test data:
set.seed(123)
n <- nrow(regression)
train <- sample(1:n,round(n*2/3))
test <- (1:n)[-train]


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
# estimate linear model based on training data
multiple_train <- lm(sales ~ adspend + airplay + starpower, data = regression, subset=train) 
summary(multiple_train) #summary of results


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
# using coefficients to predict test data
pred_lm <- predict(multiple_train,newdata = regression[test,])
cor(regression[test,"sales"],pred_lm)^2 # R^2 for test data


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
# plot predicted vs. observed values for test data
plot(regression[test,"sales"],pred_lm,xlab="y measured",ylab="y predicted",cex.lab=1.3)
abline(c(0,1))


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
set.seed(123)
# Add another random variable
regression$var_test <- rnorm(nrow(regression),0,1)


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
# Model comparison with anova
lm0 <- lm(sales ~ 1, data = regression) 
lm1 <- lm(sales ~ adspend, data = regression) 
lm2 <- lm(sales ~ adspend + airplay, data = regression) 
lm3 <- lm(sales ~ adspend + airplay + starpower, data = regression) 
lm4 <- lm(sales ~ adspend + airplay + starpower + var_test, data = regression) 
anova(lm0, lm1, lm2, lm3, lm4)


## ----echo=T, eval=T-----------------------------------------------------------------------------------------------------
options(digits = 8)
# Stepwise variable selection
# Automatic model selection with step
model_lmstep <- step(lm4)
model_lmstep


## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE----------------------------------------------------------------
regression$country <- factor(regression$country, levels = c(0:1), labels = c("local", "international")) #convert grouping variable to factor
regression$genre <- factor(regression$genre, levels = c(1:3), labels = c("rock", "pop","electronic")) #convert grouping variable to factor


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
multiple_regression_bin <- lm(sales ~ adspend + airplay + starpower + country, data = regression) #estimate linear model
summary(multiple_regression_bin) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower+ country + genre, data = regression) #estimate linear model
summary(multiple_regression) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower+ country + relevel(genre,ref=2), data = regression) #estimate linear model
summary(multiple_regression) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Effect of advertising by group"----
ggplot(regression, aes(adspend, sales, colour = as.factor(country))) +
  geom_point() + 
  geom_smooth(method="lm", alpha=0.1) + 
  labs(x = "Advertising expenditures (EUR)", y = "Number of sales", colour="country") + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower + country + adspend:country, data = regression) #estimate linear model
summary(multiple_regression) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
multiple_regression <- lm(sales ~ adspend + airplay + starpower + adspend:airplay, data = regression) #estimate linear model
summary(multiple_regression) #summary of results


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
non_linear_reg <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/non_linear.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
head(non_linear_reg)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Non-linear relationship"---------
ggplot(data = non_linear_reg, aes(x = advertising, y = sales)) +
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) + 
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
linear_reg <- lm(sales ~ advertising, data = non_linear_reg)
summary(linear_reg)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Residuals vs. Fitted"------------
plot(linear_reg,1)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Q-Q plot"------------------------
plot(linear_reg,2)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Linearized effect"---------------
ggplot(data = non_linear_reg, aes(x = log(advertising), y = log(sales))) + 
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) +
  theme_bw()


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE-----------------------------------------------------------------
log_reg <- lm(log(sales) ~ log(advertising), data = non_linear_reg)
summary(log_reg)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap = c("Residuals plot","Q-Q plot")----
plot(log_reg,1)
plot(log_reg,2)


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE,fig.align="center", fig.cap = "Comparison if model fit"---------
non_linear_reg$pred_lin_reg <- predict(linear_reg)
non_linear_reg$pred_log_reg <- predict(log_reg)
ggplot(data = non_linear_reg) +
  geom_point(aes(x = advertising, y = sales),shape=1) + 
  geom_line(data = non_linear_reg,aes(x=advertising,y=pred_lin_reg),color="blue", size=1.05) + 
  geom_line(data = non_linear_reg,aes(x=advertising,y=exp(pred_log_reg)),color="red", size=1.05) + theme_bw()


## -----------------------------------------------------------------------------------------------------------------------
set.seed(1234)
X <- as.integer(runif(1000, 0, 12000))
Y <- 80000 + 140 * X - 0.01 * (X^2) + rnorm(1000, 0,
                                           35000)
modLinear <- lm(Y/100000 ~ X)
sales_quad <- data.frame(sales = Y/100000, advertising = X*0.01,
                        Prediction = fitted(modLinear))
ggplot(sales_quad) +
  geom_point(aes(x = advertising, y = sales, color = "Data")) +
  geom_line(aes(x = advertising, y = Prediction, color = "Prediction")) +
  theme_bw() +
  ggtitle("Linear Predictor") +
  theme(legend.title = element_blank())


## -----------------------------------------------------------------------------------------------------------------------
top5 <- which(sales_quad$sales %in% head(sort(sales_quad$sales, decreasing = TRUE), 5))
dplyr::arrange(sales_quad[top5, ], desc(sales_quad[top5, 1]))


## -----------------------------------------------------------------------------------------------------------------------
quad_mod <- lm(sales ~ advertising + I(advertising^2), data = sales_quad)
summary(quad_mod)
confint(quad_mod)
sales_quad$Prediction <- predict(quad_mod)
ggplot(data = sales_quad, aes(x = Prediction, y = sales)) + 
  geom_point(shape=1) + 
  geom_smooth(method = "lm", fill = "blue", alpha=0.1) +
  theme_bw()

plot(quad_mod,1)
plot(quad_mod,2)
shapiro.test(resid(quad_mod))

sales_quad$pred_lin_reg <- predict(modLinear)
ggplot(data = sales_quad) +
  geom_point(aes(x = advertising, y = sales),shape=1) + 
  geom_line(data = sales_quad,aes(x=advertising,y=pred_lin_reg),color="blue", size=1.05) + 
  geom_line(data = sales_quad,aes(x=advertising,y=Prediction),color="red", size=1.05) + theme_bw() + xlab("Advertising (thsd. Euro)") + ylab("Sales (million units)") 


## -----------------------------------------------------------------------------------------------------------------------
top5 <- which(sales_quad$sales %in% head(sort(sales_quad$sales, decreasing = TRUE), 5))
dplyr::arrange(sales_quad[top5, ], desc(sales_quad[top5, 1]))


## -----------------------------------------------------------------------------------------------------------------------
predictionAll<- predict(quad_mod, newdata = data.frame(advertising = 1:200))
(optimalAdvertising <- as.integer(which.max(predictionAll)))

#Slope at optimum:
coef(quad_mod)[["advertising"]] + 2 * coef(quad_mod)[["I(advertising^2)"]] * optimalAdvertising

