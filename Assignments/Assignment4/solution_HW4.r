data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/assignment4.1.dat", 
                       sep = "\t", 
                       header = TRUE) #read in data

#Q1: Regression equation

#Q2: Plots & descriptives
library(psych)
psych::describe(data)
#Three scatterplots, for example: 
library(ggplot2)
ggplot(data, mapping = aes(online_adspend, sales)) + 
  geom_point(shape = 1) +
  geom_smooth(method = "lm", fill = "blue", alpha = 0.1) + 
  geom_hline(yintercept = mean(data$sales), linetype="dotted") + #mean of sales
  geom_vline(xintercept = mean(data$online_adspend), linetype="dotted") + #mean of advertising
  labs(x = "Online advertising expenditures (EUR)", y = "Number of sales") + 
  theme_bw()

#Q3: Regression diagnistics
linear_model <- lm(sales~tv_adspend+online_adspend+radio_adspend, data = data)

# Outliers
## ------------------------------------------------------------------------
data$stud_resid <- rstudent(linear_model)
head(data)
## ------------------------------------------------------------------------
plot(1:nrow(data),data$stud_resid, ylim=c(-3.3,3.3)) #create scatterplot 
abline(h=c(-3,3),col="red",lty=2) #add reference lines

# Influencial observations
# Cook's Distance > 1
## ------------------------------------------------------------------------
plot(linear_model,4)
plot(linear_model,5)

# Linear specification
## ------------------------------------------------------------------------
#install.packages("car")
library(car)
#AV plots
avPlots(linear_model)
#residuals plot (deviation of red line from dashed grey line)
plot(linear_model, 1)

# Constant error variance (homoscedasticity)
## ------------------------------------------------------------------------
plot(linear_model, 1)

# Normal distribution of residuals
## ------------------------------------------------------------------------
plot(linear_model,2)
shapiro.test(resid(linear_model))

# Multicollinearity
## ------------------------------------------------------------------------
# test bivariate correlations
library(Hmisc)
rcorr(as.matrix(data[,c("tv_adspend","online_adspend","radio_adspend")]))
plot(data[,c("tv_adspend","online_adspend","radio_adspend")])
vif(linear_model)
avPlots(linear_model)#otional


#Q4: Regression results
#a:Which variables have a significant influence on sales and what is the interpretation of the coefficients?
summary(linear_model)
#Interpretation example: if tv advertising increases by 1 EUR, sales will change ...
#b:What is the relative importance of the predictor variables?
library(lm.beta)
lm.beta(linear_model)
avPlots(linear_model) #optional
#c:Interpret the F-test
#null hypothesis that all coefficients are zero is rejected
#d:How do you judge the fit of the model? Please also visualize the model fit using an appropriate graph.
data$yhat <- predict(linear_model)
## ------------------------------------------------------------------------
ggplot(data,aes(yhat,sales)) +  
  geom_point(size=2,shape=1) +  #Use hollow circles
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()

#Q5:What sales quantity would you predict based on your model for a product when the marketing activities are planned as follows: TV: 150 thsd. €, Online: 26 thsd. €, Radio: 15 thsd. €? Please provide the equation you used to make the prediction. 
## ------------------------------------------------------------------------
summary(linear_model)$coefficients[1,1] + 
  summary(linear_model)$coefficients[2,1]*150 + 
  summary(linear_model)$coefficients[3,1]*26 + 
  summary(linear_model)$coefficients[4,1]*15



