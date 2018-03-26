## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
rm(factor_analysis)
factor_analysis <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/toothpaste.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
str(factor_analysis) #inspect data
head(factor_analysis) #inspect data

## ---- warning=FALSE, message=FALSE---------------------------------------
library("Hmisc")
rcorr(as.matrix(factor_analysis))

## ---- message=FALSE, warning=FALSE, eval=TRUE, echo=FALSE, fig.align="center", fig.cap="Factor loadings"----
library(ggplot2)
library(psych)
library(GPArotation)
#values1 <- c(0.93,0.94,0.87,-0.30,-0.34,-0.18)
#values2 <- c(-0.08,-0.04,0.1,0.78,0.85,0.95)
values1 <- principal(factor_analysis, nfactors = 2, rotate = "none")$Structure[,1]
values2 <- principal(factor_analysis, nfactors = 2, rotate = "none")$Structure[,2]
group <- c(1,2,1,2,1,2)
label <- c("X1","X2","X3","X4","X5","X6")
df <- data.frame(values1,values2)
ggplot(df, aes(x=values2,y=values1)) +
  geom_point(size=3,color=group,shape=group) +
  geom_text(aes(x=values2, y=values1, label=label), size=4, vjust=c(1.5,-1,1.5,1.5,1.5,1.5), hjust=c(0.5,0.5,0.5,0.5,0.5,0.5)) +
  labs(x = "Health benefits",y = "Social benefits", size=11) +
  geom_hline(size=1,aes(yintercept=0))+
  geom_vline(size=1,aes(xintercept=0))+
  scale_y_continuous(breaks=seq(-1, 2, 0.25)) +
  scale_x_continuous(breaks=seq(-1, 2, 0.25)) +
  coord_cartesian(ylim=c(-1,1),xlim=c(-1,1)) +
  theme_bw() +
  theme(axis.title = element_text(size = 18),
        axis.text  = element_text(size=14),
        strip.text.x = element_text(size = 14),
        legend.position="none")

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=FALSE, fig.align="center", fig.height = 6, fig.cap="The R anxiety questionnaire (source: Field, A. et al. (2012): Discovering Statistics Using R, p. 768)"----
library(EBImage)
img = readImage("https://github.com/IMSMWU/Teaching/raw/master/MRDA2017/ra_anx_quest.JPG")
display(img, method = "raster")


## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
raq_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/raq.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
raq_matrix <- cor(raq_data)
round(raq_matrix,3)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
correlations <- as.data.frame(raq_matrix)
diag(correlations) <- NA

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
apply(abs(correlations) < 0.3, 1, sum, na.rm = TRUE)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE, fig.align="center", fig.width=10, fig.cap="Correlation matrix"----
apply(abs(correlations),1,mean,na.rm=TRUE)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE, fig.align="center", fig.width=10, fig.cap="Correlation matrix"----
corPlot(correlations,numbers=TRUE,upper=FALSE,diag=FALSE,main="Correlations between variables")

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
library(psych)
cortest.bartlett(raq_matrix, n = nrow(raq_data))

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
apply(abs(correlations) > 0.8, 1, sum, na.rm = TRUE)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
det(raq_matrix)
det(raq_matrix) > 0.00001

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
KMO(raq_data)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
pc1 <- principal(raq_data, nfactors = 23, rotate = "none")
pc1

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE, fig.align="center", fig.cap="Scree plot"----
plot(pc1$values, type="b")
abline(h=1, lty=2)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
pc2 <- principal(raq_data, nfactors = 4, rotate = "none")
pc2

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
residuals <- factor.residuals(raq_matrix, pc2$loadings)
round(residuals,3)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
reproduced_matrix <- factor.model(pc2$loadings)
round(reproduced_matrix,3)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
ssr <- (sum(residuals[upper.tri((residuals))]^2)) #sum of squared residuals 
ssc <- (sum(raq_matrix[upper.tri((raq_matrix))]^2)) #sum of squared correlations
1-(ssr/ssc) #model fit

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
residuals <- as.matrix(residuals[upper.tri((residuals))])
large_res <- abs(residuals) > 0.05
sum(large_res)
sum(large_res)/nrow(residuals)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
sqrt(mean(residuals^2))

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE, fig.align="center", fig.cap="Hinstogram of residuals"----
hist(residuals)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE, fig.align="center", fig.cap="Q-Q plot"----
qqnorm(residuals) 
qqline(residuals)
shapiro.test(residuals)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
pc3 <- principal(raq_data, nfactors = 4, rotate = "varimax")
pc3

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
print.psych(pc3, cut = 0.3, sort = TRUE)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
pc4 <- principal(raq_data, nfactors = 4, rotate = "oblimin", scores = TRUE)
print.psych(pc4, cut = 0.3, sort = TRUE)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
head(pc4$scores)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
raq_data <- cbind(raq_data, pc4$scores)

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
computer_fear <- raq_data[,c(6,7,10,13,14,15,18)]
statistics_fear <- raq_data[,c(1,3,4,5,12,16,20,21)]
math_fear <- raq_data[,c(8,11,17)]
peer_evaluation <- raq_data[,c(2,9,19,22,23)]

## ----message=FALSE, warning=FALSE, eval=TRUE, echo=TRUE------------------
psych::alpha(computer_fear)
psych::alpha(statistics_fear, keys=c(1,-1,1,1,1,1,1,1))
psych::alpha(math_fear)
psych::alpha(peer_evaluation)

## ----message=FALSE, warning=FALSE----------------------------------------
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/survey2017.dat", 
                        sep = "\t", header = TRUE)
head(test_data)

## ----message=FALSE, warning=FALSE----------------------------------------
psych::alpha(test_data[,c("multi_1","multi_2","multi_3","multi_4")], keys=c(1,1,1,-1))

## ---- warning=FALSE, message=FALSE---------------------------------------
library(car)
test_data$multi_4_rec = recode(test_data$multi_4, "1=5; 2=4; 3=3; 4=2; 5=1")

## ---- warning=FALSE, message=FALSE---------------------------------------
library(car)
test_data$new_variable = (test_data$multi_1 + test_data$multi_2 + test_data$multi_3 + test_data$multi_4_rec) / 4

