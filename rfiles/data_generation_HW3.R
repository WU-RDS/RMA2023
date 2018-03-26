setwd("D:/Dropbox/Dropbox/XChange/MRDA_DATA/homework2")

#generate second data matrix
no.dld1=data.frame(downloads=round(rnorm(33,1200,800)),academyAward=0,customerRating=1)
no.dld2=data.frame(downloads=round(rnorm(52,1500,800)),academyAward=0,customerRating=2)
no.dld3=data.frame(downloads=round(rnorm(65,1800,800)),academyAward=0,customerRating=3)
nodld1 <- rbind(no.dld1,no.dld2,no.dld3)
?rnorm
no.dld6=data.frame(downloads=round(rnorm(20,1400,800)),academyAward=1,customerRating=1)
no.dld7=data.frame(downloads=round(rnorm(45,1700,800)),academyAward=1,customerRating=2)
no.dld8=data.frame(downloads=round(rnorm(85,2500,800)),academyAward=1,customerRating=3)
nodld2 <- rbind(no.dld6,no.dld7,no.dld8)

dld.full <- rbind(nodld1, nodld2)
#dld.full$downloadsHD <-  c(round(rnorm(100,1500,450)),round(rnorm(100,2200,750)))
dld.full$movieID <- sample(1:300,300,replace=F) 
dld.full <- dld.full[order(dld.full$movieID),]

#Explore the data
#investigate descriptive statistics using the pastecs-package
library(pastecs)
#by groups
by(dld.full$downloads,dld.full$customerRating,stat.desc)
library(car)
dld.full$customerRating <- factor(dld.full$customerRating, levels = c(1,2,3), labels = c("negative", "neutral", "positive"))
dld.full$academyAward <- factor(dld.full$academyAward, levels = c(1,0), labels = c("yes", "no"))

leveneTest(downloads ~ customerRating, data=dld.full, center=mean)
leveneTest(dld.full$downloads, interaction(dld.full$customerRating,dld.full$academyAward), center=mean)

aov <- aov(downloads~customerRating, data = dld.full)
#summary(aov)
#if levene's test would be significant compute the Welch's F-ration instead
#oneway.test(downloads ~ customerRating, data=dld.full)

#bonferroni
pairwise.t.test(dld.full$downloads, dld.full$customerRating, data=dld.full,p.adjust.method = "bonferroni")
#tukey correction using the mult-comp package
#install.packages("multcomp")
#library(multcomp)
#tukeys <- glht(aov,linfct=mcp(customerRating = "Tukey"))
#summary(tukeys)
#confint(tukeys)
#plot(tukeys)

#compute the basic anova
aov <- aov(downloads~customerRating+academyAward+customerRating:academyAward, data = dld.full)
summary(aov)


library(foreign)
write.foreign(dld.full, "c:/mydata.txt", "c:/mydata.sps",   package="SPSS")
write.table(dld.full,"HW2_1.dat",sep = "\t", row.names=FALSE)