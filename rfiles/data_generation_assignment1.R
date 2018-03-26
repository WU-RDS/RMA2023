#options(scipen=999)
#gc()

setwd("D:/Teaching/MRDA2016_MA/Homework1")
#generate second data matrix
no.dld1=data.frame(downloadsSD=round(rnorm(16,1000,150)),academyAward=0,customerRating=1)
no.dld2=data.frame(downloadsSD=round(rnorm(17,1500,450)),academyAward=0,customerRating=2)
no.dld3=data.frame(downloadsSD=round(rnorm(24,2000,550)),academyAward=0,customerRating=3)
no.dld4=data.frame(downloadsSD=round(rnorm(21,2500,550)),academyAward=0,customerRating=4)
no.dld5=data.frame(downloadsSD=round(rnorm(22,3000,550)),academyAward=0,customerRating=5)
nodld1 <- rbind(no.dld1,no.dld2,no.dld3,no.dld4,no.dld5)

no.dld6=data.frame(downloadsSD=round(rnorm(5,2500,550)),academyAward=1,customerRating=1)
no.dld7=data.frame(downloadsSD=round(rnorm(9,3000,750)),academyAward=1,customerRating=2)
no.dld8=data.frame(downloadsSD=round(rnorm(24,3250,800)),academyAward=1,customerRating=3)
no.dld9=data.frame(downloadsSD=round(rnorm(28,3500,900)),academyAward=1,customerRating=4)
no.dld10=data.frame(downloadsSD=round(rnorm(34,3600,1000)),academyAward=1,customerRating=5)
nodld2 <- rbind(no.dld6,no.dld7,no.dld8,no.dld9,no.dld10)

dld.full <- rbind(nodld1, nodld2)
dld.full$downloadsHD <-  c(round(rnorm(100,1500,450)),round(rnorm(100,2200,750)))
dld.full$movieID <- sample(1:200,200,replace=F) 
dld.full <- dld.full[order(dld.full$movieID),]
dld.full$genre <- ifelse(dld.full$movieID>0&dld.full$movieID<37,1,ifelse(dld.full$movieID>36&dld.full$movieID<83,2,ifelse(dld.full$movieID>82&dld.full$movieID<109,3,ifelse(dld.full$movieID>108&dld.full$movieID<166,4,ifelse(dld.full$movieID>165,5,NA)))))

#convert grouping variables to factors
dld.full$genre <- factor(dld.full$genre, levels = c(1:5))
dld.full$academyAward <- factor(dld.full$academyAward, levels = c(1:0))

#compute chi^2 test using the gmodels package
#install.packages("gmodels") #only run if you use a package for the first time
library(gmodels)
CrossTable(dld.full$genre,dld.full$academyAward,chisq = TRUE)

#t-test influence of academy award on downloads SD
library(car)
leveneTest(downloadsSD ~ academyAward, data=dld.full, center=mean)
#conduct independent t test for two samples
t.test(downloadsSD ~ academyAward, data = dld.full, var.equal = TRUE)

#t-test influence of academy award on downloads HD
leveneTest(downloadsHD ~ academyAward, data=dld.full, center=mean)
#conduct independent t test for two samples
#levene' test significant --> wilcoxon
wilcox.test(downloadsHD ~ academyAward,data = dld.full)

#influence of customer rating and academy awards
leveneTest(customerRating ~ academyAward, data=dld.full, center=mean)
#levene's test significant so we use non-parametric test
wilcox.test(customerRating ~ academyAward,data = dld.full)
#conduct independent t test for two samples
t.test(customerRating ~ academyAward, data = dld.full, var.equal = TRUE)

#difference between SD and HD movies
t.test(dld.full$downloadsSD, dld.full$downloadsHD, paired=TRUE)


write.table(dld.full,"hw1_6.dat",sep = "\t", row.names=FALSE)