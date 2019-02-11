# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2018/_book/hypothesis-testing.html#non-parametric-tests


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "plyr", "ggplot2", "reshape2", "PMCMR", "car", "multcomp", "Hmisc")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#-----------Wilcoxon rank sum test (Mann-Whitney U Test)------------#
#-------------------------------------------------------------------#

# Load and inspect the data
## ------------------------------------------------------------------------
music_sales <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/music_sales_small.csv", 
                          sep = ";", 
                          header = TRUE) #read in data
music_sales$group <- factor(music_sales$group, levels = c(1:2), labels = c("low_price", "high_price")) #convert grouping variable to factor
str(music_sales) #inspect data
head(music_sales) #inspect data

# Descriptive statistics
## ------------------------------------------------------------------------
library(psych)
psych::describe(music_sales$sales) #overall descriptives
describeBy(music_sales$sales, music_sales$group) #descriptives by group

# Plot data 
## ------------------------------------------------------------------------
# Histogram
library(ggplot2)
ggplot(music_sales, aes(group, sales)) + 
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Group", y = "Average number of sales") +
  theme_bw()

# Non-parametric equivalent to the independent-means t test
## ------------------------------------------------------------------------
wilcox.test(sales ~ group, data = music_sales) 


#-------------------------------------------------------------------#
#---------------------Wilcoxon singed-rank test---------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
music_sales_dep <- read.table("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/music_sales_small_paired.csv",
                              sep = ";", 
                              header = TRUE) #read in data
str(music_sales_dep) #inspect data
head(music_sales_dep) #inspect data

# Descriptive statistics
## ------------------------------------------------------------------------
psych::describe(music_sales_dep[, c("sales_g1", "sales_g2")]) #overall descriptives

# Plot of means
## ------------------------------------------------------------------------
library(reshape2)
ggplot(data = melt(music_sales_dep[, c("sales_g1", "sales_g2")]), aes(x = variable, y = value)) +
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Group", y = "Average number of sales") +
  theme_bw()

# Non-parametric equivalent to the dependent-means t test
## ------------------------------------------------------------------------
wilcox.test(music_sales_dep$sales_g1, music_sales_dep$sales_g2, paired = TRUE) #Wilcoxon signed-rank test


#-------------------------------------------------------------------#
#---------------------- Kruskal-Wallis test ------------------------#
#-------------------------------------------------------------------#

# Plot the data
## ------------------------------------------------------------------------
# Boxplot
ggplot(online_store_promo, aes(x = Promotion, y = Sales)) + 
  geom_boxplot() + 
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw() 

# Run the test
## ------------------------------------------------------------------------
kruskal.test(Sales ~ Promotion, data = online_store_promo) 

# Post hoc test
## ------------------------------------------------------------------------
library(PMCMR)
posthoc.kruskal.nemenyi.test(x = online_store_promo$Sales, g = online_store_promo$Promotion, dist = "Tukey")
