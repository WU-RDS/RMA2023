par(mfrow=c(1,1))
setwd("D:/Teaching/MRDA2017/RIntro-master/MRDA2017/Assignments/Assignment4")
x1 <- round(runif(250,0,300),1)
x2 <- round(100 * rbeta(250, 2, 6),1)
x3 <- round(rnorm(250,25,15))
x4 <- rbinom(250, 1, 0.2)
x <- data.frame(x1,x2,x3,x4)
x <- subset(x,x3>0)
x <- subset(x,x2>0)
x <- subset(x,x1>0)
sales <- round(2.9 + 0.046*x$x1 + .189*x$x2 + .005*x$x3 + 2*rnorm(nrow(x)),1)
sales_data <- data.frame(tv_adspend=x$x1,online_adspend=x$x2,radio_adspend=x$x3,store_type=x$x4,sales=sales)
sales_data$store_id <- 1:nrow(sales_data)
l <- lm(sales~tv_adspend+online_adspend+radio_adspend, data = sales_data)
summary(l)
psych::describe(sales_data)

sales_data$yhat <- predict(l)
## ------------------------------------------------------------------------
ggplot(sales_data,aes(yhat,sales)) +  
  geom_point(size=2,shape=1) +  #Use hollow circles
  scale_x_continuous(name="predicted values") +
  scale_y_continuous(name="observed values") +
  geom_abline(intercept = 0, slope = 1) +
  theme_bw()

# Added variable plots
## ------------------------------------------------------------------------
library(car)
avPlots(l)

# Standardized coefficients
## ------------------------------------------------------------------------
library(lm.beta)
lm.beta(l)

# Outliers
## ------------------------------------------------------------------------
sales_data$stud_resid <- rstudent(l)
head(sales_data)
## ------------------------------------------------------------------------
plot(1:nrow(sales_data),sales_data$stud_resid, ylim=c(-3.3,3.3)) #create scatterplot 
abline(h=c(-3,3),col="red",lty=2) #add reference lines
## ------------------------------------------------------------------------
outliers <- subset(sales_data,abs(stud_resid)>3)
outliers

# Influencial observations
## ------------------------------------------------------------------------
plot(l,4)
plot(l,5)

# Linear specification
## ------------------------------------------------------------------------
avPlots(l)

# Constant error variance (homoscedasticity)
## ------------------------------------------------------------------------
plot(l, 1)

# Normal distribution of residuals
## ------------------------------------------------------------------------
par(mfrow=c(1,1))
plot(l,2)
shapiro.test(resid(l))

# Multicollinearity
## ------------------------------------------------------------------------
library(Hmisc)
rcorr(as.matrix(sales_data[,c("tv_adspend","online_adspend","radio_adspend")]))
plot(sales_data[,c("tv_adspend","online_adspend","radio_adspend")])
options(digits = 3)
vif(l)


# Using the model for making predictions
## ------------------------------------------------------------------------
summary(l)$coefficients[1,1] + 
  summary(l)$coefficients[2,1]*150 + 
  summary(l)$coefficients[3,1]*26 + 
  summary(l)$coefficients[4,1]*15

write.table(sales_data[,c("tv_adspend","online_adspend","radio_adspend","sales")],"D:/Teaching/MRDA2017/RIntro-master/MRDA2017/Assignments/Assignment4/assignment4.6.dat",sep = "\t",row.names = F)



data11 <- read.csv2("D:/Teaching/MRDA2017/Data/Advertising.csv",sep = ",",header = T, dec = ".")
data11$TV <- as.numeric(data11$TV ) 
data11$radio <- as.numeric(data11$radio ) 
data11$newspaper <- as.numeric(data11$newspaper ) 
data11$sales <- as.numeric(data11$sales ) 
hist(data11$sales)
hist(data11$newspaper)
hist(data11$radio)
hist(data11$TV)
l<-lm(sales~TV+radio+newspaper,data=data11)
summary(l)
str(data11)
summary(data11)
mean(data11$sales)
