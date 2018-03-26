dld.full <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/assignment3.6.dat", 
                            sep = "\t", 
                            header = TRUE) #read in data
#library(car)
dld.full$retargeting <- factor(dld.full$retargeting, levels = c(1,2,3), labels = c("no retargeting", "generic retargeting", "dynamic retargeting"))
dld.full$gender <- factor(dld.full$gender, levels = c(1,0),labels = c("female","male"))

#Question 1

#Descriptives & plot
library(plyr)
library(ggplot2)
library(pastecs)
by(dld.full$revenue,dld.full$retargeting,stat.desc)
ggplot(dld.full, aes(retargeting, revenue)) + 
  stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw()
#check number of observations by group
table(dld.full$retargeting)
#conclude that normal sampling distribution due to Central Limit Theorem
#Homogeneity of variances test:
library(car)
leveneTest(revenue ~ retargeting, data=dld.full, center=mean)
#Anova:
aov <- aov(revenue~retargeting, data = dld.full)
summary(aov)
#Inspect residuals
plot(aov,1)
plot(aov,2)
shapiro.test(resid(aov))
#conduct post hoc tests (one of the two methods is sufficient)
#bonferroni
pairwise.t.test(dld.full$revenue, dld.full$retargeting, data=dld.full,p.adjust.method = "bonferroni")
#tukey correction using the mult-comp package
#install.packages("multcomp")
library(multcomp)
tukeys <- glht(aov,linfct=mcp(retargeting = "Tukey"))
summary(tukeys)
confint(tukeys)
plot(tukeys)

#Question 2

#compute grouping variable
dld.full$Group <- paste(dld.full$retargeting, dld.full$gender, sep = "_") #create new grouping variable
#check descriptives and plot data
by(dld.full$revenue,dld.full$Group,stat.desc)
ggplot(dld.full, aes(gender, revenue)) + 
  stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw()
ggplot(dld.full, aes(x = interaction(gender, retargeting), y = revenue, fill = gender)) +
  stat_summary(fun.y = mean, geom = "bar", position = position_dodge()) +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  theme_bw()

#check number of obs per group
table(dld.full$Group)
#conclude that normal sampling distribution due to Central Limit Theorem
#test homogeneity of variances
leveneTest(dld.full$revenue, interaction(dld.full$retargeting,dld.full$gender), center=mean)

aov <- aov(revenue~retargeting+gender+retargeting:gender, data = dld.full)
summary(aov)
#Inspect residuals
plot(aov,1)
plot(aov,2)
shapiro.test(resid(aov))

#Question 3

#ordinal data so we use a non-parametric test
kruskal.test(rank ~ retargeting, data = dld.full) 
#install.packages("PMCMR")
library(PMCMR)
posthoc.kruskal.nemenyi.test(x = dld.full$rank, g = dld.full$retargeting, dist = "Tukey")

