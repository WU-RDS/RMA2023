# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2017/_book/summary-statistics.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "pastecs")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#----------------------Categorical variables------------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/survey2017.dat", 
                        sep = "\t", header = TRUE)
head(test_data)

# The factor function can transform variables into factors
## ------------------------------------------------------------------------
test_data$overall_knowledge_cat <- factor(test_data$overall_knowledge, levels = c(1:5), labels = c("none", "basic", "intermediate","advanced","proficient"))
test_data$gender_cat <- factor(test_data$gender, levels = c(1:2), labels = c("male", "female"))

# The table function creates frequency tables
## ------------------------------------------------------------------------
table(test_data[,c("overall_knowledge_cat")]) #absolute frequencies
table(test_data[,c("gender_cat")]) #absolute frequencies

# The median and summary function produce various summary statistics 
## ------------------------------------------------------------------------
median((test_data[,c("overall_knowledge")]))
summary((test_data[,c("overall_knowledge")]))

# The prop.table function produces relative frequency tables.
## ------------------------------------------------------------------------
prop.table(table(test_data[,c("overall_knowledge_cat")])) #relative frequencies
prop.table(table(test_data[,c("gender_cat")])) #relative frequencies

# By adding a second column we can investigate the frequency table by gender
## ------------------------------------------------------------------------
table(test_data[,c("overall_knowledge_cat", "gender_cat")]) #absolute frequencies

## ------------------------------------------------------------------------
prop.table(table(test_data[,c("overall_knowledge_cat", "gender_cat")])) #relative frequencies

## ------------------------------------------------------------------------
prop.table(table(test_data[,c("overall_knowledge_cat", "gender_cat")]), 2) #conditional relative frequencies


#-------------------------------------------------------------------#
#----------------------Continuous variables-------------------------#
#-------------------------------------------------------------------#

# The psych package contains the useful describe function, which produces more summary statistics than
# the simple summary function contained in base R
## ------------------------------------------------------------------------
library(psych)
psych::describe(test_data[,c("duration", "overall_100")])

# describeBy produces the summary statistics grouped by a grouping variable, in our case this is gender
## ------------------------------------------------------------------------
describeBy(test_data[,c("duration","overall_100")], test_data$gender_cat)

# The same could have been achieved by the stat.desc function from the pastecs package
## ------------------------------------------------------------------------
library(pastecs)
stat.desc(test_data[,c("duration", "overall_100")])

# The by function applies a function to data, grouped by a factor variable
## ------------------------------------------------------------------------
by(test_data[,c("duration", "overall_100")],test_data$gender_cat,stat.desc)

# Create subsets by excluding outliers
estimation_sample <- subset(test_data, duration < 900)
psych::describe(estimation_sample[, c("duration", "overall_100")])

# Confidence intervals can either be manually calculated with the formula 4.1 in the script
## ------------------------------------------------------------------------
mean(test_data$overall_100)
error <- qnorm(0.975)*sd(test_data$overall_100)/sqrt(nrow(test_data))
ci_lower <- mean(test_data$overall_100)-error
ci_upper <- mean(test_data$overall_100)+error
print(ci_lower)
print(ci_upper)

# Or they can be extracted from the stat.desc output
## ------------------------------------------------------------------------
mean_x <- stat.desc(test_data$overall_100)["mean"]
error_x <- stat.desc(test_data$overall_100)["CI.mean.0.95"]
ci_lower_x <- mean_x - error_x
ci_upper_x <- mean_x + error_x
ci_lower_x
ci_upper_x

