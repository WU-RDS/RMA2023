#options(scipen=999)
#gc()

setwd("D:/Teaching/MRDA2017/RIntro-master/MRDA2017")

#PART A
#generate second data matrix
no.dld1=data.frame(streams_sd=round(rnorm(16,1000,150)),online_advertising=0,customer_rating=1)
no.dld2=data.frame(streams_sd=round(rnorm(17,1500,450)),online_advertising=0,customer_rating=2)
no.dld3=data.frame(streams_sd=round(rnorm(24,2000,550)),online_advertising=0,customer_rating=3)
no.dld4=data.frame(streams_sd=round(rnorm(21,2500,550)),online_advertising=0,customer_rating=4)
no.dld5=data.frame(streams_sd=round(rnorm(22,3000,550)),online_advertising=0,customer_rating=5)
nodld1 <- rbind(no.dld1,no.dld2,no.dld3,no.dld4,no.dld5)

no.dld6=data.frame(streams_sd=round(rnorm(5,2500,550)),online_advertising=1,customer_rating=1)
no.dld7=data.frame(streams_sd=round(rnorm(9,3000,750)),online_advertising=1,customer_rating=2)
no.dld8=data.frame(streams_sd=round(rnorm(24,3250,800)),online_advertising=1,customer_rating=3)
no.dld9=data.frame(streams_sd=round(rnorm(28,3500,900)),online_advertising=1,customer_rating=4)
no.dld10=data.frame(streams_sd=round(rnorm(34,3600,1000)),online_advertising=1,customer_rating=5)
nodld2 <- rbind(no.dld6,no.dld7,no.dld8,no.dld9,no.dld10)

dld.full <- rbind(nodld1, nodld2)
dld.full$streams_hd <-  c(round(rnorm(100,1500,450)),round(rnorm(100,2200,750)))
dld.full$movieID <- sample(1:200,200,replace=F) 
dld.full <- dld.full[order(dld.full$movieID),]
dld.full$genre <- ifelse(dld.full$movieID>0&dld.full$movieID<37,1,ifelse(dld.full$movieID>36&dld.full$movieID<83,2,ifelse(dld.full$movieID>82&dld.full$movieID<109,3,ifelse(dld.full$movieID>108&dld.full$movieID<166,4,ifelse(dld.full$movieID>165,5,NA)))))

#dld.full$order <- rnorm(200,0,1)
dld.full <- dld.full[order(dld.full$genre),]
dld.full$academy_award <- c(sample(1:0, 40, prob = c(0.7,0.3), replace = T),sample(1:0, 40, prob = c(0.6,0.4), replace = T),sample(1:0, 40, prob = c(0.5,0.5), replace = T),
                           sample(1:0, 40, prob = c(0.3,0.7), replace = T),sample(1:0, 40, prob = c(0.4,0.6), replace = T))

#convert grouping variables to factors
dld.full$genre <- factor(dld.full$genre, levels = c(1:5))
dld.full$online_advertising <- factor(dld.full$online_advertising, levels = c(1:0))

#compute chi^2 test using the gmodels package
#install.packages("gmodels") #only run if you use a package for the first time
#library(gmodels)
chisq.test(table(dld.full[,c("genre","academy_award")]),correct = F)
table(dld.full[,c("genre","academy_award")])

#t-test influence of academy award on downloads SD
#library(car)
#leveneTest(streams_sd ~ online_advertising, data=dld.full, center=mean)
#conduct independent t test for two samples
t.test(streams_sd ~ online_advertising,data = dld.full)

#t-test influence of academy award on downloads HD
#leveneTest(streams_hd ~ online_advertising, data=dld.full, center=mean)
#conduct independent t test for two samples
#levene' test significant --> wilcoxon
t.test(streams_hd ~ online_advertising,data = dld.full)

#influence of customer rating and academy awards
#leveneTest(customer_rating ~ online_advertising, data=dld.full, center=mean)
#levene's test significant so we use non-parametric test
table(dld.full$customer_rating,dld.full$academy_award)
wilcox.test(customer_rating ~ academy_award,data = dld.full)
#conduct independent t test for two samples
#t.test(customer_rating ~ academy_award, data = dld.full, var.equal = TRUE)

#difference between SD and HD movies
t.test(dld.full$streams_sd, dld.full$streams_hd, paired=TRUE)

write.table(dld.full,"assignment1.6.dat",sep = "\t", row.names=FALSE)

#PART B

