# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/exploratory-factor-analysis.html


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("Hmisc", "ggplot2", "car", "psych", "GPArotation","hornpa")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#-------------------Principal Component Analysis--------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
raq_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/raq.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
head(raq_data)

# STEP 1

# Inspect correlation matrix
## ------------------------------------------------------------------------
raq_matrix <- cor(raq_data) #create matrix
round(raq_matrix,3)

# Low correlations by variable
## ------------------------------------------------------------------------
correlations <- as.data.frame(raq_matrix)
# Correlation plot
## ------------------------------------------------------------------------
library(psych)
corPlot(correlations,numbers=TRUE,upper=FALSE,diag=FALSE,main="Correlations between variables")
# Check number of low correlations and mean correlation per variable
## ------------------------------------------------------------------------
diag(correlations) <- NA #set diagonal elements to missing
apply(abs(correlations) < 0.3, 1, sum, na.rm = TRUE) #count number of low correlations for each variable
apply(abs(correlations),1,mean,na.rm=TRUE) #mean correlation per variable
# Conduct Bartlett's test (p should be < 0.05)
## ------------------------------------------------------------------------
cortest.bartlett(raq_matrix, n = nrow(raq_data))
# Count number of high correlations for each variable
## ------------------------------------------------------------------------
apply(abs(correlations) > 0.8, 1, sum, na.rm = TRUE)
# Compute determinant (should be > 0.00001)
## ------------------------------------------------------------------------
det(raq_matrix)
det(raq_matrix) > 0.00001

# Compute MSA statistic (should be > 0.5)
## ------------------------------------------------------------------------
KMO(raq_data)

# STEP 2

# Deriving factors
## ------------------------------------------------------------------------
# Find the number of factors to extract
pc1 <- principal(raq_data, nfactors = 23, rotate = "none")
pc1
## ------------------------------------------------------------------------
plot(pc1$values, type="b")
abline(h=1, lty=2)

# Alternative way to derive the number of factors to retain
library(hornpa)
hornpa(k=23,size=2571,reps=500,seed=1234) 

# Run model with appropriate number of factors
## ------------------------------------------------------------------------
pc2 <- principal(raq_data, nfactors = 4, rotate = "none")
pc2
# Inspect residuals
## ------------------------------------------------------------------------
# Create residuals matrix
residuals <- factor.residuals(raq_matrix, pc2$loadings)
round(residuals,3)
## ------------------------------------------------------------------------
# Create reproduced matrix
reproduced_matrix <- factor.model(pc2$loadings)
round(reproduced_matrix,3)
# Compute model fit manually (optional - also included in output)
## ------------------------------------------------------------------------
ssr <- (sum(residuals[upper.tri((residuals))]^2)) #sum of squared residuals 
ssc <- (sum(raq_matrix[upper.tri((raq_matrix))]^2)) #sum of squared correlations
ssr/ssc #ratio of ssr and ssc
1-(ssr/ssc) #model fit
# Share of residuals > 0.05 (should be < 50%)
## ------------------------------------------------------------------------
residuals <- as.matrix(residuals[upper.tri((residuals))])
large_res <- abs(residuals) > 0.05
sum(large_res)
sum(large_res)/nrow(residuals)
# Compute root mean square of the residuals manually (also included in output)
## ------------------------------------------------------------------------
sqrt(mean(residuals^2))
# Test if residuals are approximately normally distributed
## ------------------------------------------------------------------------
hist(residuals)
qqnorm(residuals) 
qqline(residuals)
shapiro.test(residuals)

# STEP 3

# Orthogonal factor rotation 
## ------------------------------------------------------------------------
pc3 <- principal(raq_data, nfactors = 4, rotate = "varimax")
pc3
print.psych(pc3, cut = 0.3, sort = TRUE)

# Oblique factor rotation 
## ------------------------------------------------------------------------
pc4 <- principal(raq_data, nfactors = 4, rotate = "oblimin", scores = TRUE)
print.psych(pc4, cut = 0.3, sort = TRUE)

# STEP 4

# Compute factor scores 
## ------------------------------------------------------------------------
head(pc4$scores)
# Add factor scores to dataframe 
## ------------------------------------------------------------------------
raq_data <- cbind(raq_data, pc4$scores)


#-------------------------------------------------------------------#
#-----------------------Reliability Analysis------------------------#
#-------------------------------------------------------------------#

# Specify subscales according to results of PCA
## ------------------------------------------------------------------------
computer_fear <- raq_data[,c(6,7,10,13,14,15,18)]
statistics_fear <- raq_data[,c(1,3,4,5,12,16,20,21)]
math_fear <- raq_data[,c(8,11,17)]
peer_evaluation <- raq_data[,c(2,9,19,22,23)]
# Test reliability of subscales
## ------------------------------------------------------------------------
psych::alpha(computer_fear)
psych::alpha(statistics_fear, keys=c(1,-1,1,1,1,1,1,1))
psych::alpha(math_fear)
psych::alpha(peer_evaluation)

# Example of multi-item scales
## ------------------------------------------------------------------------
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/survey2017.dat", 
                        sep = "\t", header = TRUE)
head(test_data)
# Test reliability
## ------------------------------------------------------------------------
psych::alpha(test_data[,c("multi_1","multi_2","multi_3","multi_4")], keys=c(1,1,1,-1))
# Recode variable
## ------------------------------------------------------------------------
library(car)
test_data$multi_4_rec = recode(test_data$multi_4, "1=5; 2=4; 3=3; 4=2; 5=1")
# Compute new variable
## ------------------------------------------------------------------------
test_data$new_variable = (test_data$multi_1 + test_data$multi_2 + test_data$multi_3 + test_data$multi_4_rec) / 4


