setwd("D:/Dropbox/Dropbox/XChange/MRDA_DATA/homework3")
x3 <- round(rnorm(250,1200,400))
#x3 <- rlnorm(250, log(1), log(0.6))
x1 <- round(rnorm(250,200,50))
x2 <- round(rnorm(250,75,40))
x <- data.frame(x1,x2,x3)
x <- subset(x,x3>0)
x <- subset(x,x2>0)
x <- subset(x,x1>0)
summary(x)
nrow(x)
names(x)<-c('price','adspend','adm')
error <- 15*rnorm(nrow(x))
sales <- round(5000 + -3*x$price + .28*x$adspend + .1*x$adm + 4*error)
sales_data <- data.frame(sales,x$price,x$adspend,x$adm) 
names(sales_data)<-c('sales', 'price','adspend','adm')
summary(sales_data)
sales_data <- subset(sales_data,sales_data$sales>0)
summary(sales_data)
sales_data
nrow(sales_data)
l<-lm(sales~price+adspend+adm,data=x)
summary(l)
shapiro.test(resid(l))
plot(l)
plot(predict(l), sales)
abline(a=0,b=1)
library(car)
vif(l)
cor(sales_data)
hist(sales_data$sales)
hist(sales_data$price)
hist(sales_data$adspend)
hist(sales_data$adm)
scatterplot(sales_data$sales,sales_data$price)
scatterplot(sales_data$sales,sales_data$adspend)
scatterplot(sales_data$sales,sales_data$adm)
write.table(sales_data,"SalesData4.dat",sep = "\t", row.names=FALSE)
summary(l)$coefficients[1,1] + summary(l)$coefficients[2,1]*150 + summary(l)$coefficients[3,1]*800 + summary(l)$coefficients[4,1]*1000
x.new <- cbind(as.data.frame(sales),x)

write.table(sales_data,"Exam3.dat",sep = "\t", row.names=FALSE)
l<-lm(sales~price+adspend+adm,data=sales_data)
summary(l)

















store_data <- read.delim("assignment.dat", sep="\t")
store_data
lm <- lm(achievement ~  duration + friends, data=store_data)
summary(lm)
plot(lm)
lm1 <- lm(log(achievement) ~ log(duration) + log(friends), data=store_data)
summary(lm1)



x=data.frame(matrix(rlnorm(3*150),ncol=3))
names(x)<-c('price','advertising','socialmedia')
beta<-c(-3,1,.1) # these are the regression coefficients
trait<- as.matrix(x)%*%beta + 2*rnorm(nrow(x),0,1)
l<-lm(log(trait+1)~log(price+1)+log(advertising+1)+log(socialmedia+1),data=x)
summary(l)
summary(l)$coefficients[1,1] + summary(l)$coefficients[2,1]*150 + summary(l)$coefficients[3,1]*500 + summary(l)$coefficients[4,1]*1000
summary(sales)
shapiro.test(resid(l))
plot(l)


























head(store_data)
str(store_data)
lm <- lm(Absatzmenge ~ VKF + Preis + Werbebudget, data=store_data)
summary(lm)
lm1 <- lm(log(Absatzmenge) ~ log(VKF) + log(Preis) + log(Werbebudget), data=store_data)
summary(lm1)

plot(predict(lm), store_data$Absatzmenge)
plot(lm)

sample=rlnorm(100, meanlog=log(20000), sdlog=0.5)
hist(sample)

weedsmokingstar <- -3.5 + 2.5 * exp(parents) - 0.25 * sport + 1.2 * lazy - 0.01 *   distance + error
# check whether there a negative grams...  hint: weedsmokingstar == 0
weedsmoking <- rep(0, 1000)
weedsmoking[weedsmokingstar > 6] <- 1

# true model
gpa <- 7.8 - 0.2 * weedsmoking - 0.2 * parents - 0.15 * sport - 0.4 * lazy+1 + 2*u


sport <- rbeta(250, 1, 8) 
sport <- rlnorm(250, meanlog=log(1), sdlog=0.7)
hist(sport)
error <- rnorm(250)
dv <- 4 + 1.2*sport + error
lm <- lm(dv~sport)
summary(lm)
lm1 <- lm(log(dv)~log(sport))
summary(lm1)
plot(lm1)



store_data_subs <- subset(store_data, , select=c(countryid, year,totalsalespcmio))
newdata <-  na.omit(store_data)
newdata <- subset(newdata, downloadunits<200)

x=data.frame(matrix(rlnorm(3*350,0,3),ncol=3))
names(x)<-c('Noise','PC1','PC2')
beta<-c(-3,3,.1)
trait<- as.matrix(x)%*%beta + 50*rnorm(nrow(x),0,1)
l<-lm(trait~Noise+PC1+PC2,data=x)
summary(l)
plot(predict(l), trait)
abline(a=0,b=1)




















setwd("C:/Users/NilsComp/Dropbox/BA_MR_DATA/Data/data_session4")
store_data <- read.delim("salesdata.csv", sep=",")
head(store_data)
store_data_subs <- subset(store_data, , select=c(countryid, year,totalsalespcmio))
newdata <-  na.omit(store_data)
newdata <- subset(newdata, downloadunits<200)

linmod <- lm(downloadunits ~ price_new + adspend_all + google + product_age, data=newdata)
summary(linmod)
plot(predict(linmod), newdata$downloadunits)


linmod <- lm(log(downloadunits+1) ~ log(price_new+1) + log(adspend_all+1) + log(google+1) + log(product_age+1), data=newdata)
summary(linmod)
plot(predict(linmod), newdata$downloadunits)
plot(linmod)








LM2 = function(n){
  x = rnorm(n)
  y = rnorm(n)
  eps = 0.1 * rnorm(n)
  z = 0.5 + 0.75 * x + 0.25 * y + eps
  data.frame(Z = z, X = x, Y = y)
}
for (FUN in c("LM2", "LM3")) {
  cat(FUN, ":\n", sep = "")
  print(regSim(model = FUN, n = 10))
}



LM3(n = 100, seed = 4711)


set.seed(23)
# The Utopia example... omitted variable bias and so on...
sport <- 10 * rbeta(10000, 2, 6) 
lazy <- rnorm(10000, 8, 1)
parents <- rbinom(10000, 1, 0.1)
# instrument
distance <- rnorm(10000, 100, 30)
u <- 0.2 * rnorm(10000)
# true model:
error <- rnorm(1000)
weedsmokingstar <- -3.5 + 2.5 * exp(parents) - 0.25 * sport + 1.2 * lazy - 0.01 *   distance + error
# check whether there a negative grams...  hint: weedsmokingstar == 0
weedsmoking <- rep(0, 1000)
weedsmoking[weedsmokingstar > 6] <- 1

# true model
gpa <- 7.8 - 0.2 * weedsmoking - 0.2 * parents - 0.15 * sport - 0.4 * lazy+1 + 2*u

model <- lm(gpa~weedsmoking+parents+sport+lazy)
summary(model)
hist(sport)
hist(lazy)
hist(parents)
hist(distance)
hist(weedsmoking)

hist(multreg)


x <- rnbinom(250,100,0.8)
hist(x)




onlineReviews <- rnorm(250,5000,500)^2
hist(onlineReviews)*1000
error <- rnorm(250,200,50)
#trait <- onlineReviews+lazy+x+error
trait <- onlineReviews+ error
model <- lm(trait~onlineReviews)
summary(model)
model1 <- lm(log(trait+1)~log(onlineReviews+1))
summary(model1)
plot(model1)

summary(onlineReviews)

scatterplot(trait,onlineReviews)










plot(predict(model), gpa)
plot(predict(model), resid(model) )
abline(a=0,b=1)
scatterplot(log,trait)
#check multicollinearity using vif-values
vif(model)
#also check correlation plot
cor(model)

model <- lm(Y~X1+X2+X3)


histogram <- ggplot(multreg, aes(rstudent(mreg)))
histogram + geom_histogram(binwidth = .3, col="black", fill="white") +
  labs(x = "Standardized Residual", y = "Frequency") + 
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size=16),
        strip.text.x = element_text(size = 16))
#check multicollinearity using vif-values
vif(mreg)
#also check correlation plot
cor(multreg)




plot(model)

model <- lm(log(gpa+1)~log(weedsmoking+1)+log(parents+1)+log(sport+1)+log(lazy))
summary(model)









l1<-lm(log(trait+1)~log(Noise+1)+log(PC1+1)+log(PC2+1),data=x)
summary(l1)

hist(x)

scatterplot(trait[,1],x$Noise)

















options(scipen=999) 
library(plyr)
#generate first data matrix
sigma <- matrix(c(350,300,300,3260),2,2)
x=data.frame(matrix(rnorm(3*350,1200),ncol=3))
y=data.frame(round(mvrnorm(350,c(100,2000),sigma)))
#library(pastecs)
#overall descriptives
stat.desc(y)
cor(y)
names(y) <- c('price','advertising')
names(x)<-c('Noise','PC1','PC2')
datafull <- data.frame(y,x)
error <- rnorm(350,0,1)
trait<-  -2.8*datafull$price+4*datafull$advertising+.1*datafull$PC1+1.3*datafull$PC1+5*error
l<-lm(trait~price+advertising+PC1+PC2,data=datafull)
summary(l)
l1<-lm(log(trait)~log(price)+log(advertising)+log(PC1)+log(PC2),data=datafull)
summary(l1)

y=data.frame(round(mvrnorm(350,c(100,2000),sigma)))


x <- data.frame("x1" = rlnorm(350,1,.50))
hist(x)
summary(exp(x))
error <- rnorm(350,0,1)
trait <- -2.8*x+5*error
model <- lm(trait ~ x1, data=x)


l<-lm(trait~price+advertising+PC1+PC2,data=datafull)


rnbinom()

x=data.frame(matrix(rnbinom(1500, 10, .7),ncol=3))


x=data.frame(matrix(rnorm(3*1500,1200, 450)^3,ncol=3))
names(x)<-c('Noise','PC1','PC2')
trait <- -3*log(x$Noise+1) + 3*log(x$PC1+1) + .1*log(x$PC2+1) 
l<-lm(trait~Noise+PC1+PC2,data=x)
summary(l)

l1<-lm(log(trait+1)~log(Noise+1)+log(PC1+1)+log(PC2+1), data=x)
summary(l1)



plot(l1)
plot(l)













N <- 10000
x <- rnbinom(N, 10, .7)
hist(x, 
     xlim=c(min(x),max(x)), probability=T, nclass=max(x)-min(x)+1, 
     col='lightblue', xlab=' ', ylab=' ', axes=F,
     main='Positive Skewed')
lines(density(x,bw=1), col='red', lwd=3)

#regression diagnistics plots
#residuals vs. fitted values, QQ-Plot ...
plot(l1)
#predicted values against actual values
plot(predict(mreg), multreg$sales)
abline(a=0,b=1)
#shapiro-wilk test of normality
shapiro.test(resid(mreg))
#histogram of rsiduals
histogram <- ggplot(multreg, aes(rstudent(mreg)))
histogram + geom_histogram(binwidth = .3, col="black", fill="white") +
  labs(x = "Standardized Residual", y = "Frequency") + 
  theme(axis.title = element_text(size = 16),
        axis.text  = element_text(size=16),
        strip.text.x = element_text(size = 16))





























x1 <- 11:30
x2 <- runif(20,5,95)
x3 <- rbinom(20,1,.5)

b0 <- 17
b1 <- 0.5
b2 <- 0.037
b3 <- -5.2
sigma <- 1.4

eps <- rnorm(x1,0,sigma)
y <- b0 + b1*x1  + b2*x2  + b3*x3 + eps

summary(lm(y~x1+x2+x3))











cor(datafull)

var(mvrnorm(n = 1000, rep(0, 2), Sigma))





x1 <- 11:30
x2 <- runif(20,5,95)
x3 <- rbinom(20,1,.5)

b0 <- 17
b1 <- 0.5
b2 <- 0.037
b3 <- -5.2
sigma <- 1.4

eps <- rnorm(x1,0,sigma)
y <- b0 + b1*x1  + b2*x2  + b3*x3 + eps
model <- lm(y~x1+x2+x3)
summary(model)








Sigma <- matrix(c(10,3,3,2),2,2)
Sigma
var(mvrnorm(n = 1000, rep(0, 2), Sigma))
var(mvrnorm(n = 1000, rep(0, 2), Sigma, empirical = TRUE))

## LM2 -
# Data for a user defined linear regression model:
install.packages("fRegression")
library(fRegression)
LM2 = function(n){
  x = rnorm(n)
  y = rnorm(n)
  eps = 0.1 * rnorm(n)
  z = 0.5 + 0.75 * x + 0.25 * y + eps
  r111 <- data.frame(Z = z, X = x, Y = y)
}
for (FUN in c("LM2", "LM3")) {
  cat(FUN, ":\n", sep = "")
  new <- print(regSim(model = FUN, n = 10))
}
lm <- lm(z~x+y, data=new)






Sigma <- matrix(c(10,3,3,2),2,2)
Sigma
var(mvrnorm(n = 1000, rep(0, 2), Sigma))
var(mvrnorm(n = 1000, rep(0, 2), Sigma, empirical = TRUE))




###########
# VIF######
###########


library(car)     # for vif

# number of observations to simulate
nobs = 100

# Using a correlation matrix (let' assume that all variables
# have unit variance
M = matrix(c(1, 0.7, 0.7, 0.5,
             0.7, 1, 0.95, 0.3,
             0.7, 0.95, 1, 0.3,
             0.5, 0.3, 0.3, 1), nrow=4, ncol=4)

# Cholesky decomposition             
L = chol(M)
nvars = dim(L)[1]


# R chol function produces an upper triangular version of L
# so we have to transpose it.
# Just to be sure we can have a look at t(L) and the
# product of the Cholesky decomposition by itself

t(L)
t(L) %*% L

# Random variables that follow an M correlation matrix
r = t(L) %*% matrix(rnorm(nvars*nobs), nrow=nvars, ncol=nobs)
r = t(r)

rdata = as.data.frame(r)
names(rdata) = c('resp', 'pred1', 'pred2', 'pred3')

# Plotting and basic stats
splom(rdata)
cor(rdata)

m1 = lm(resp ~ pred1 + pred3, rdata)
summary(m1)

m2 = lm(resp ~ pred2 + pred3, rdata)
summary(m2)

m3 = lm(resp ~ pred1 + pred2 + pred3, rdata)
summary(m3)

vif(m3)

#Exercise
url <- "https://raw.githubusercontent.com/IMSMWU/Teaching/master/"
url <- paste(url,"exercise_bivariate.dat", sep="")
exercise <- getURL(url,ssl.verifypeer=FALSE)
exercise <- read.delim(textConnection(exercise), header=TRUE)
lm1 <- lm(y1 ~ x1, data=exercise)
summary(lm1)
lm2 <- lm(y2 ~ x2, data=exercise)
summary(lm2)
lm3 <- lm(y3 ~ x3, data=exercise)
summary(lm3)
lm4 <- lm(y4 ~ x4, data=exercise)
summary(lm4)