## ---- echo=FALSE, warning=FALSE------------------------------------------
library(knitr)
#This code automatically tidies code so that it does not reach over the page
opts_chunk$set(tidy.opts=list(width.cutoff=50),tidy=TRUE, rownames.print = FALSE, rows.print = 10)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
online_store_promo <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/online_store_promo.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
online_store_promo$Promotion <- factor(online_store_promo$Promotion, levels = c(1:3), labels = c("high", "medium","low")) #convert grouping variable to factor
str(online_store_promo) #inspect data
print(online_store_promo) #inspect data

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, paged.print = FALSE----
library(psych)
describeBy(online_store_promo$Sales, online_store_promo$Promotion) #inspect data

## ----message=FALSE, warning=FALSE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Plot of means"), tidy = FALSE----
#Plot of means
library(plyr)
library(ggplot2)
ggplot(online_store_promo, aes(Promotion, Sales)) + 
  stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (promotion level)", y = "Sales (thsd. units)") + 
  theme_bw()

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=FALSE, fig.align="center", fig.height = 3, fig.width = 8, fig.cap="Decomposing variance"----
library(EBImage)
img = readImage("https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/sum_of_squares.JPG")
display(img, method = "raster")


## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Observations"), tidy = FALSE----
library(reshape2)
dcast(online_store_promo, Obs ~ Promotion, value.var = "Sales")

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
mean(online_store_promo$Sales) #grand mean
by(online_store_promo$Sales,online_store_promo$Promotion,mean) #category mean

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap="Sum of Squares"----
sales <- c(10,9,10,8,9,8,9,7,7,6,8,8,7,9,6,4,5,5,6,4,5,7,6,4,5,2,3,2,1,2)
promotion <-c(rep(1,10), rep(2,10), rep(3,10))
count <- c(rep(1:10,3))
d <- data.frame(sales,promotion,count)
d$promotion <- factor(d$promotion, levels = c(1:3), labels = c("High", "Medium", "Low"))
means <- aggregate(d[,1], list(d$promotion), mean)
means <- plyr::rename(means, c(Group.1="promotion"))
d$groupmean <- c(rep(means[1,2],10),rep(means[2,2],10),rep(means[3,2],10))
d$grandmean <- c(mean(d$sales))
d$group6 <- store <-c(rep(1,5),rep(2,5),rep(3,5),rep(4,5),rep(5,5),rep(6,5))
d$group6 <- factor(d$group6, levels = c(1:6), labels = c("High/Yes", "High/No", "Medium/Yes", "Medium/No","Low/Yes", "Low/No"))
means6 <- aggregate(d[,1], list(d$group6), mean)
means6 <- plyr::rename(means6, c(Group.1="group6"))
d$groupmean6 <- c(rep(means6[1,2],5),rep(means6[2,2],5),rep(means6[3,2],5),rep(means6[4,2],5),rep(means6[5,2],5),rep(means6[6,2],5))

ggplot(d, aes(x=count,y=sales,color=promotion)) + 
  geom_point(size=3) + facet_grid(~promotion, scales = "free_x") + 
  scale_x_continuous(breaks = 1:30) +
  labs(x = "Observations",y = "Sales (thsd. units)", colour="promotion",size=11, fill="") +
  theme(axis.title = element_text(size = 12),
        axis.text  = element_text(size=12),
        strip.text.x = element_text(size = 12),
        legend.position="none")+ theme_bw()

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap="Total Sum of Squares"----
ggplot(d, aes(x=count,y=sales,color=promotion)) + 
  geom_point(size=3) + facet_grid(~promotion, scales = "free_x") + 
  scale_x_continuous(breaks = 1:30) + geom_hline(aes(yintercept = grandmean,color=promotion)) +
  labs(x = "Observations",y = "Sales (thsd. units)", colour="promotion",size=11, fill="") +
  geom_segment(aes(x=count,y=grandmean, xend=count, yend=sales),size=1) + 
  theme(axis.title = element_text(size = 12),
        axis.text  = element_text(size=12),
        strip.text.x = element_text(size = 12),
        legend.position="none")+ theme_bw()

## ------------------------------------------------------------------------
SST <- sum((online_store_promo$Sales - mean(online_store_promo$Sales))^2)
SST

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap="Model Sum of Squares"----
ggplot(d, aes(x=count,y=sales,color=promotion)) + 
  geom_point(size=3) + facet_grid(~promotion, scales = "free_x") + 
  scale_x_continuous(breaks = 1:30) + geom_hline(aes(yintercept = grandmean,color=promotion)) +
  geom_hline(aes(yintercept = groupmean,color=promotion)) +
  labs(x = "Observations",y = "Sales (thsd. units)", colour="promotion",size=11, fill="") +
  geom_segment(aes(x=count,y=grandmean, xend=count, yend=groupmean),size=1) + 
  theme(axis.title = element_text(size = 12),
        axis.text  = element_text(size=12),
        strip.text.x = element_text(size = 12),
        legend.position="none")+ theme_bw()

## ------------------------------------------------------------------------
SSM <- sum(10*(by(online_store_promo$Sales, online_store_promo$Promotion, mean) - mean(online_store_promo$Sales))^2)
SSM

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap="Residual Sum of Squares"----
ggplot(d, aes(x=count,y=sales,color=promotion)) + 
  geom_point(size=3) + facet_grid(~promotion, scales = "free_x") + 
  scale_x_continuous(breaks = 1:30) + geom_hline(data = means, aes(yintercept = x,color=promotion)) +
  labs(x = "Observations",y = "Sales (thsd. units)", colour="promotion",size=11, fill="") +
  geom_segment(aes(x=count,y=groupmean, xend=count, yend=sales),size=1) + 
  theme(axis.title = element_text(size = 12),
        axis.text  = element_text(size=12),
        strip.text.x = element_text(size = 12),
        legend.position="none")+ theme_bw()

## ------------------------------------------------------------------------
SSR <- sum((online_store_promo$Sales - rep(by(online_store_promo$Sales, online_store_promo$Promotion, mean), each = 10))^2)
SSR

## ------------------------------------------------------------------------
eta <- SSM/SST
eta

## ------------------------------------------------------------------------
f_ratio <- (SSM/2)/(SSR/27)
f_ratio

## ----echo = F, message=FALSE, warning=FALSE, eval=T, fig.align="center", fig.cap = "The F distribution"----
library(ggplot2)
a <- seq(0,4, 2)
ggplot(data.frame(x=c(0,4)), aes(x))+
  stat_function(fun = df, args = list(2,2), aes(colour = paste0("m = 2",", n = 2"))) +
  stat_function(fun = df, args = list(2,5), aes(colour = paste0("m = 2",", n = 5")))+
  stat_function(fun = df, args = list(2,10), aes(colour = paste0("m = 2",", n = 10")))+
  stat_function(fun = df, args = list(5,2), aes(colour = paste0("m = 5",", n = 2")))+
  stat_function(fun = df, args = list(5,5), aes(colour = paste0("m = 5",", n = 5")))+
  stat_function(fun = df, args = list(5,10), aes(colour = paste0("m = 5",", n = 10")))+
  stat_function(fun = df, args = list(10,2), aes(colour = paste0("m = 10",", n = 2")))+
  stat_function(fun = df, args = list(10,5), aes(colour = paste0("m = 10",", n = 5")))+
  stat_function(fun = df, args = list(10,10), aes(colour = paste0("m = 10",", n = 10")))+
  stat_function(fun = df, args = list(20,20), aes(colour = paste0("m = 20",", n = 20")))+
  ylim(min=0, max=1) +
  labs(colour = 'Degrees of Freedom', x = 'Value', y = 'Density') + theme_bw()

## ------------------------------------------------------------------------
f_crit <- qf(.95, df1 = 2, df2 = 27) #critical value
f_crit 
f_ratio > f_crit #test if calculated test statistic is larger than critical value

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap = "Visual depiction of the test result"----
df1 <- 2
df2 <- 27
p <- 0.95
min <- 0
max <- 20
f_crit <- round(qf(p,df1=df1,df2=df2), digits = 3)
f_cal <- f_ratio
plot1 <- ggplot(data.frame(x = c(min, max)), aes(x = x)) +
  stat_function(fun = df, args = list(df1,df2))+
  stat_function(fun = df, args = list(df1,df2), xlim = c(qf(p,df1=df1,df2=df2),max), geom = "area") +
  scale_x_continuous(breaks = c(0, f_crit, f_cal)) +
  geom_vline(xintercept = f_cal, color = "red") +
  labs(title = paste0("Result of F-test: reject H0"),
         subtitle = paste0("Red line: Calculated test statistic;"," Black area: Rejection region"),
         x = "x", y = "Density") +
  theme(legend.position="none") + 
  theme_bw()
plot1

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, paged.print = FALSE----
shapiro.test(online_store_promo[online_store_promo$Promotion == "low", ]$Sales)
shapiro.test(online_store_promo[online_store_promo$Promotion == "medium", ]$Sales)
shapiro.test(online_store_promo[online_store_promo$Promotion == "high", ]$Sales)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, paged.print = FALSE----
qqnorm(online_store_promo[online_store_promo$Promotion=="low",]$Sales) 
qqline(online_store_promo[online_store_promo$Promotion=="low",]$Sales)
qqnorm(online_store_promo[online_store_promo$Promotion=="medium",]$Sales) 
qqline(online_store_promo[online_store_promo$Promotion=="medium",]$Sales)
qqnorm(online_store_promo[online_store_promo$Promotion=="high",]$Sales) 
qqline(online_store_promo[online_store_promo$Promotion=="high",]$Sales)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, paged.print = FALSE----
library(car)
leveneTest(Sales ~ Promotion, data = online_store_promo, center = mean)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
aov <- aov(Sales ~ Promotion, data = online_store_promo)
summary(aov)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
summary(aov)[[1]]$'Sum Sq'[1]/(summary(aov)[[1]]$'Sum Sq'[1] + summary(aov)[[1]]$'Sum Sq'[2])

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
plot(aov,1)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
plot(aov,2)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
shapiro.test(resid(aov))

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
oneway.test(Sales ~ Promotion, data=online_store_promo)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
pairwise.t.test(online_store_promo$Sales, online_store_promo$Promotion, data = online_store_promo, p.adjust.method = "bonferroni")

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
data_subset <- subset(online_store_promo,Promotion != "low")
t.test(Sales ~ Promotion, data = data_subset)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
q <- qtukey(0.95, nm = 3, df = 27)
q

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
hsd <- q * sqrt(summary(aov)[[1]]$'Mean Sq'[2]/10)
hsd

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
library(multcomp)
tukeys <- glht(aov, linfct = mcp(Promotion = "Tukey"))
summary(tukeys)
confint(tukeys)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE, fig.align="center", fig.cap="Tukey's HSD"----
plot(tukeys)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
mean1 <- mean(online_store_promo[online_store_promo$Promotion=="high","Sales"]) #mean group "high"
mean1
mean2 <- mean(online_store_promo[online_store_promo$Promotion=="medium","Sales"]) #mean group "medium"
mean2
mean3 <- mean(online_store_promo[online_store_promo$Promotion=="low","Sales"]) #mean group "low"
mean3
#CI high vs. medium
mean_diff_high_med <- mean2-mean1
mean_diff_high_med
ci_med_high_lower <- mean_diff_high_med-hsd
ci_med_high_upper <- mean_diff_high_med+hsd
ci_med_high_lower
ci_med_high_upper
#CI high vs.low
mean_diff_high_low <- mean3-mean1
mean_diff_high_low
ci_low_high_lower <- mean_diff_high_low-hsd
ci_low_high_upper <- mean_diff_high_low+hsd
ci_low_high_lower
ci_low_high_upper
#CI medium vs.low
mean_diff_med_low <- mean3-mean2
mean_diff_med_low
ci_low_med_lower <- mean_diff_med_low-hsd
ci_low_med_upper <- mean_diff_med_low+hsd
ci_low_med_lower
ci_low_med_upper

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE-----------------
online_store_promo$Newsletter <- factor(online_store_promo$Newsletter, levels = c(0:1), labels = c("no", "yes")) #convert grouping variable to factor
head(online_store_promo)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
online_store_promo$Group <- paste(online_store_promo$Promotion, online_store_promo$Newsletter, sep = "_") #create new grouping variable
online_store_promo 

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
by(online_store_promo$Sales, online_store_promo$Group, mean) #category means

## ----message=FALSE, warning=FALSE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Plot of means (in-store promotion)"), tidy = FALSE----
#Plot of means
ggplot(online_store_promo, aes(Promotion, Sales)) + 
  stat_summary(fun.y = mean, geom = "bar", fill="White", colour="Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw()

## ----message=FALSE, warning=FALSE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Plot of means (newsletter)"), tidy = FALSE----
#Plot of means
ggplot(online_store_promo, aes(Newsletter, Sales)) + 
  stat_summary(fun.y = mean, geom = "bar", fill="White", colour="Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (newsletter)", y = "Number of sales") + 
  theme_bw()

## ----message=FALSE, warning=FALSE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Plot of means (interaction)"), tidy = FALSE----
ggplot(online_store_promo, aes(x = interaction(Newsletter, Promotion), y = Sales, fill = Newsletter)) +
  stat_summary(fun.y = mean, geom = "bar", position = position_dodge()) +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  theme_bw()

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, fig.align="center", fig.cap="Sum of Squares (N-way ANOVA)"----
count <- c(rep(1:5,6))
ggplot(d, aes(x=count,y=sales,color=group6)) + 
  geom_point(size=3) + facet_grid(~group6, scales = "free_x") + 
  scale_x_continuous(breaks = 1:30) + geom_hline(aes(yintercept = grandmean, color=group6)) +
  geom_hline(aes(yintercept = groupmean6,color=group6)) +
  labs(x = "Observations",y = "Sales (million units)", colour="promo/nl",size=11, fill="") +
  geom_segment(aes(x=count,y=grandmean, xend=count, yend=groupmean6),size=1) + 
  theme(axis.title = element_text(size = 12),
        axis.text  = element_text(size=12),
        strip.text.x = element_text(size = 12),
        legend.position="none") + theme_bw()

## ----message=FALSE, warning=FALSE, echo=FALSE, eval=TRUE, paged.print = FALSE, fig.align="center", fig.cap="Tukey's HSD"----
library(car)
leveneTest(online_store_promo$Sales, interaction(online_store_promo$Promotion, online_store_promo$Newsletter), center = mean) #test for homogeneity of variances
aov <- aov(Sales ~ Promotion + Newsletter + Promotion:Newsletter, data = online_store_promo) #compute the basic anova
summary(aov)

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
(summary(aov)[[1]]$'Sum Sq'[1] + summary(aov)[[1]]$'Sum Sq'[2] + summary(aov)[[1]]$'Sum Sq'[3])/(summary(aov)[[1]]$'Sum Sq'[1] + summary(aov)[[1]]$'Sum Sq'[2] + summary(aov)[[1]]$'Sum Sq'[3] + summary(aov)[[1]]$'Sum Sq'[4])

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
plot(aov,1) #homogeneity of variances
plot(aov,2) #normal distribution of residuals

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
kruskal.test(Sales ~ Promotion, data = online_store_promo) 

## ----message=FALSE, warning=FALSE, eval=TRUE, fig.align="center", echo=TRUE, fig.cap=c("Boxplot"), tidy = FALSE----
#Boxplot
ggplot(online_store_promo, aes(x = Promotion, y = Sales)) + 
  geom_boxplot() + 
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw() 

## ----message=FALSE, warning=FALSE, echo=TRUE, eval=TRUE------------------
library(PMCMR)
posthoc.kruskal.nemenyi.test(x = online_store_promo$Sales, g = online_store_promo$Promotion, dist = "Tukey")

