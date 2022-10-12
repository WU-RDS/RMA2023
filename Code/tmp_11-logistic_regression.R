## ----eval=TRUE, echo=F, message=FALSE, warning=FALSE--------------------------------------------------------------------
unloadNamespace("latex2exp") # unloads latex2exp to fix the specific error, that the chart in 6.6.2 didn't display TeX output properly


## ---- echo=TRUE, warning=FALSE, message=FALSE, fig.align='center', fig.cap="Simulated binary outcome data"--------------
library(ggplot2)
library(gridExtra)

chart_data <- read.delim2("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/chart_data_logistic.dat",header=T, sep = "\t",stringsAsFactors = F, dec = ".")
#Create a new dummy variable "top10", which is 1 if a song made it to the top10 and 0 else:
chart_data$top10 <- ifelse(chart_data$rank<11,1,0)

# Inspect data
head(chart_data)
str(chart_data)


## ---- echo=FALSE, warning=FALSE, message=FALSE, fig.align='center', fig.cap="The same binary data explained by two models; A linear probability model (on the left) and a logistic regression model (on the right)"----
#Scatterplot showing the association between two variables using a linear model
plt.lin <- ggplot(chart_data,aes(danceability,top10)) +  
  geom_point(shape=1) +
  geom_smooth(method = "lm") +
  theme_bw()

#Scatterplot showing the association between two variables using a glm
plt.logit <- ggplot(chart_data,aes(danceability,top10)) +  
  geom_point(shape=1) +
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"), 
              se = FALSE) +
  theme_bw()
grid.arrange(plt.lin, plt.logit, ncol = 2)


## ---- echo = FALSE------------------------------------------------------------------------------------------------------
library(latex2exp)
x <- seq(-10, 10, length.out = 1000)
fx <- 1/(1+exp(-x))
df <- data.frame(x = x, fx = fx)
ggplot(df, aes(x = x, y = fx)) + 
  geom_line()+
  labs(y = TeX("$\\frac{1}{1+e^{-\\mathbf{X}}}$"), x = TeX("$\\mathbf{X}$"))+
  theme(axis.title.y = element_text(angle = 0, vjust = 0.5)) + 
  theme_bw()


## -----------------------------------------------------------------------------------------------------------------------
#Run the glm
logit_model <- glm(top10 ~ danceability,family=binomial(link='logit'),data=chart_data)
#Inspect model summary
summary(logit_model )


## -----------------------------------------------------------------------------------------------------------------------
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
#Inspect Pseudo R2s
logisticPseudoR2s(logit_model )


## -----------------------------------------------------------------------------------------------------------------------
exp(coef(logit_model ))


## ----message=FALSE, warning=FALSE---------------------------------------------------------------------------------------
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


## ----message=FALSE, warning=FALSE---------------------------------------------------------------------------------------
confint(logit_model)


## ---- message = FALSE, warning = FALSE----------------------------------------------------------------------------------
library(mfx)
# Average partial effect
logitmfx(logit_model, data = chart_data, atmean = FALSE)


## -----------------------------------------------------------------------------------------------------------------------
#Probability of a top 10 hit with a danceability of 50
prob_50 <- exp(-(-summary(logit_model)$coefficients[1,1]-summary(logit_model)$coefficients[2,1]*50 ))
prob_50

#Probability of a top 10 hit with a danceability of 51
prob_51 <- exp(-(-summary(logit_model)$coefficients[1,1]-summary(logit_model)$coefficients[2,1]*51 ))
prob_51

#Odds ratio
prob_51/prob_50


## -----------------------------------------------------------------------------------------------------------------------
chart_data$spotify_followers_m <- chart_data$spotifyFollowers/1000000
chart_data$weeks_since_release <- chart_data$daysSinceRelease/7


## -----------------------------------------------------------------------------------------------------------------------
multiple_logit_model <- glm(top10 ~ danceability_100 + spotify_followers_m + weeks_since_release,family=binomial(link='logit'),data=chart_data)
summary(multiple_logit_model)
logisticPseudoR2s(multiple_logit_model)
exp(coef(multiple_logit_model))
confint(multiple_logit_model)


## ---- message = FALSE, warning = FALSE----------------------------------------------------------------------------------
multiple_logit_model2 <- glm(top10 ~ danceability_100 + weeks_since_release,family=binomial(link='logit'),data=chart_data)

summary(multiple_logit_model2)



## -----------------------------------------------------------------------------------------------------------------------
logisticPseudoR2s(multiple_logit_model2)


## ---- message = FALSE, warning = FALSE----------------------------------------------------------------------------------
# Prediction for one observation
predict(multiple_logit_model, newdata = data.frame(danceability_100=50, spotify_followers_m=10, weeks_since_release=1), type = "response")


## ---- message = FALSE, warning = FALSE----------------------------------------------------------------------------------
Y <- c(0,0,0,0,1,1,1,1)
X <- cbind(c(-1,-2,-3,-3,5,6,10,11),c(3,2,-1,-1,2,4,1,0))

# Perfect prediction with regular logit
summary(glm(Y~X, family=binomial(link="logit")))

library(logistf)
# Perfect prediction with penalized-likelihood logit
summary(logistf(Y~X))

