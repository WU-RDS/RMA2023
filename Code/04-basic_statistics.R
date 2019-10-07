#-------------------------------------------------------------------#
#---------------------Descriptive statistics------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2019/_book/summarizing-data.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "pastecs","dplyr","summarytools","devtools","ggplot2","Hmisc","PerformanceAnalytics")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
if(!"ggstatsplot" %in% installed.packages()) {
  library(devtools)
  devtools::install_github('IndrajeetPatil/ggstatsplot', force = TRUE)
}
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 2)

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

# The prop.table function produces relative frequency tables
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

# Correlation matrix
library("Hmisc")
rcorr(as.matrix(test_data[,c("overall_knowledge", "overall_100")]))
library("PerformanceAnalytics")
cor_vars <- test_data[,c("overall_100", "overall_knowledge", "theory_ht", "theory_anova", "theory_reg", "theory_fa")]
# another option
chart.Correlation(cor_vars, histogram=TRUE, pch=19)
# another option
cor.plot(cor_vars,show.legend=TRUE,numbers=TRUE,main="Correlation plot")
# another option
ggstatsplot::ggcorrmat(
  data = cor_vars,
  sig.level = 0.01, # threshold of significance
  matrix.type = "upper", # type of visualization matrix
  title = "Correlation table"
)

#-------------------------------------------------------------------#
#------------------------Creating subsets---------------------------#
#-------------------------------------------------------------------#

# Check for outliers in the data
# Compute standardized duration variable using the scale function and filter values > 3
test_data$duration_std <- scale(test_data$duration)
subset(test_data,abs(duration_std) > 3)

# Create subsets by excluding outliers
estimation_sample <- subset(test_data,abs(duration_std) < 3)
psych::describe(estimation_sample[, c("duration", "overall_100")])

#-------------------------------------------------------------------#
#--------------------------Further options--------------------------#
#-------------------------------------------------------------------#

# There are packages available to help you to output the results in a nice way
# For example, the "summarytools" package or ggstatsplot
# https://cran.r-project.org/web/packages/summarytools/vignettes/Introduction.html
# https://indrajeetpatil.github.io/ggstatsplot_slides/slides/ggstatsplot_presentation.html
# https://github.com/IndrajeetPatil/ggstatsplot
library(summarytools)
freq(test_data$overall_knowledge_cat, plain.ascii = FALSE, style = "rmarkdown")
view(freq(test_data$overall_knowledge_cat, plain.ascii = FALSE, style = "rmarkdown"))
view(freq(test_data$overall_knowledge_cat, report.nas = FALSE, headings = FALSE))
view(ctable(test_data$overall_knowledge_cat, test_data$gender_cat, prop = "r"))
view(dfSummary(estimation_sample[, c("duration", "overall_100","overall_knowledge_cat")]))
view(ctable(estimation_sample$group, estimation_sample$gender_cat, prop = "r", method = "render"))
view(ctable(estimation_sample$group, estimation_sample$gender_cat, chisq = TRUE, headings = FALSE, method = "render"))

library(ggstatsplot)
library(ggplot2)
# example for the summary of a statistical test
ggbetweenstats(
  data = estimation_sample,
  plot.type = "box",
  x = gender_cat, # 2 groups
  y = overall_100 ,
  type = "p", # default
  messages = FALSE,
  bf.message = FALSE
)
