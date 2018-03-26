setwd("D:/Teaching/MRDA2017/RIntro-master/MRDA2017/Assignments/Assignment3")

#generate second data matrix
no.dld1=data.frame(revenue=round(rnorm(55,1200,800)),gender=0,retargeting=1)
no.dld2=data.frame(revenue=round(rnorm(45,1500,800)),gender=0,retargeting=2)
no.dld3=data.frame(revenue=round(rnorm(50,1800,800)),gender=0,retargeting=3)
nodld1 <- rbind(no.dld1,no.dld2,no.dld3)

no.dld6=data.frame(revenue=round(rnorm(55,1400,800)),gender=1,retargeting=1)
no.dld7=data.frame(revenue=round(rnorm(45,1700,800)),gender=1,retargeting=2)
no.dld8=data.frame(revenue=round(rnorm(50,2500,800)),gender=1,retargeting=3)
nodld2 <- rbind(no.dld6,no.dld7,no.dld8)

library(data.table)
dld.full <- rbind(nodld1, nodld2)
#dld.full$downloadsHD <-  c(round(rnorm(100,1500,450)),round(rnorm(100,2200,750)))
dld.full$customerID <- sample(1:300,300,replace=F) 
dld.full <- dld.full[order(-dld.full$revenue),]
#library(data.table)
dld.fullDT <- data.table(dld.full)
dld.fullDT[, rank := seq_len(.N)]
dld.full <- as.data.frame(dld.fullDT)
dld.full <- dld.full[order(dld.full$customerID),]
dld.full <- subset(dld.full,revenue>0)

#Explore the data
#investigate descriptive statistics using the pastecs-package
#library(pastecs)
#by groups
dld.full <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/assignment3.1.dat", 
                            sep = "\t", 
                            header = TRUE) #read in data

by(dld.full$revenue,dld.full$retargeting,stat.desc)
#library(car)
dld.full$retargeting <- factor(dld.full$retargeting, levels = c(1,2,3))
dld.full$gender <- factor(dld.full$gender, levels = c(1,0))

library(plyr)
library(ggplot2)
ggplot(dld.full, aes(retargeting, revenue)) + 
  stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw()

leveneTest(revenue ~ retargeting, data=dld.full, center=mean)
leveneTest(dld.full$revenue, interaction(dld.full$retargeting,dld.full$gender), center=mean)

shapiro.test(dld.full[dld.full$retargeting == 1, ]$revenue)
shapiro.test(dld.full[dld.full$retargeting == 2, ]$revenue)
shapiro.test(dld.full[dld.full$retargeting == 3, ]$revenue)

qqnorm(dld.full[dld.full$retargeting == 1, ]$revenue) 
qqline(dld.full[dld.full$retargeting == 1, ]$revenue)
qqnorm(dld.full[dld.full$retargeting == 2, ]$revenue) 
qqline(dld.full[dld.full$retargeting == 2, ]$revenue)
qqnorm(dld.full[dld.full$retargeting == 3, ]$revenue) 
qqline(dld.full[dld.full$retargeting == 3, ]$revenue)

aov <- aov(revenue~retargeting, data = dld.full)
summary(aov)
#if levene's test would be significant compute the Welch's F-ration instead
#oneway.test(downloads ~ customerRating, data=dld.full)
plot(aov,1)
plot(aov,2)

#bonferroni
pairwise.t.test(dld.full$revenue, dld.full$retargeting, data=dld.full,p.adjust.method = "bonferroni")
#tukey correction using the mult-comp package
#install.packages("multcomp")
library(multcomp)
tukeys <- glht(aov,linfct=mcp(retargeting = "Tukey"))
summary(tukeys)
confint(tukeys)
plot(tukeys)

#compute the basic anova
dld.full$Group <- paste(dld.full$retargeting, dld.full$gender, sep = "_") #create new grouping variable
table(dld.full$Group)
shapiro.test(dld.full[dld.full$Group == "1_0", ]$revenue)
shapiro.test(dld.full[dld.full$Group == "1_1", ]$revenue)
shapiro.test(dld.full[dld.full$Group == "2_0", ]$revenue)
shapiro.test(dld.full[dld.full$Group == "2_1", ]$revenue)
shapiro.test(dld.full[dld.full$Group == "3_0", ]$revenue)
shapiro.test(dld.full[dld.full$Group == "3_1", ]$revenue)

ggplot(dld.full, aes(x = interaction(gender, retargeting), y = revenue, fill = gender)) +
  stat_summary(fun.y = mean, geom = "bar", position = position_dodge()) +
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + 
  theme_bw()

aov <- aov(revenue~retargeting+gender+retargeting:gender, data = dld.full)
summary(aov)

plot(aov,1)
plot(aov,2)

#library(foreign)
#write.foreign(dld.full, "HW2_1.sav",   package="SPSS", codefile = "tesst")
head(dld.full)
kruskal.test(rank ~ retargeting, data = dld.full) 
library(PMCMR)
posthoc.kruskal.nemenyi.test(x = dld.full$rank, g = dld.full$retargeting, dist = "Tukey")
dld.full <- subset(dld.full,select = -c(Group))
write.table(dld.full,"assignment3.4.dat",sep = "\t", row.names=FALSE)
