# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/hypothesis-testing.html#non-parametric-tests


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "plyr", "ggplot2", "reshape2", "PMCMR", "car", "multcomp", "Hmisc", "ggstatsplot")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#-----------Wilcoxon rank sum test (Mann-Whitney U Test)------------#
#-------------------------------------------------------------------#

# Load and inspect the data
## ------------------------------------------------------------------------
music_sales <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_experiment.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
music_sales$group <- factor(music_sales$group, levels = c(1:2), labels = c("low_price", "high_price")) #convert grouping variable to factor
str(music_sales) #inspect data
head(music_sales) #inspect data

# Descriptive statistics
## ------------------------------------------------------------------------
library(psych)
psych::describe(music_sales$unit_sales) #overall descriptives
describeBy(music_sales$unit_sales, music_sales$group) #descriptives by group

# Plot data 
## ------------------------------------------------------------------------
# Histogram
library(ggplot2)
ggplot(music_sales, aes(group, unit_sales)) + 
  geom_boxplot() +
  geom_jitter(color="red",alpha=0.2) +
  labs(x = "Group", y = "sales") +
  theme_bw()

# Non-parametric equivalent to the independent-means t test
## ------------------------------------------------------------------------
wilcox.test(unit_sales ~ group, data = music_sales) 

# Alternatively you can use the "ggstatsplot" package
## ------------------------------------------------------------------------
ggbetweenstats(
  data = music_sales,
  plot.type = "box",
  x = group, # 2 groups
  y = unit_sales ,
  type = "nonparametric",
  effsize.type = "r", # display effect size (Cohen's d in output)
  messages = FALSE,
  bf.message = FALSE,
  mean.ci = TRUE,
  title = "Mean sales for different groups"
)
#save the plot (optional)
ggsave("u_test.jpg", height = 5, width = 7.5)

#-------------------------------------------------------------------#
#---------------------Wilcoxon singed-rank test---------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
music_sales_dep <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_experiment_dependent.dat", 
                              sep = "\t", 
                              header = TRUE) #read in data
str(music_sales_dep) #inspect data
head(music_sales_dep) #inspect data

# Descriptive statistics
## ------------------------------------------------------------------------
psych::describe(music_sales_dep[, c("unit_sales_low_price", "unit_sales_high_price")]) #overall descriptives

# Plot of means
## ------------------------------------------------------------------------
music_sales_dep_long <- melt(music_sales_dep[, c("unit_sales_low_price", "unit_sales_high_price")])
library(reshape2)
names(music_sales_dep_long) <- c("group","sales")
ggplot(music_sales_dep_long,aes(x = group, y = sales)) + 
  geom_boxplot() +
  geom_jitter(colour="red", alpha = 0.1) +
  theme_bw() +
  labs(x = "Group", y = "Average number of sales", title = "Average number of sales by group")+
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5,color = "#666666")) 

# Non-parametric equivalent to the dependent-means t test
## ------------------------------------------------------------------------
wilcox.test(music_sales_dep$unit_sales_low_price, music_sales_dep$unit_sales_high_price, paired = TRUE) #Wilcoxon signed-rank test

# Alternatively you can use the "ggstatsplot" package
## ------------------------------------------------------------------------
library(ggstatsplot)
ggwithinstats(
  data = music_sales_dep_long,
  x = group,
  y = sales,
  path.point = FALSE,
  type="nonparametric",
  sort = "descending", # ordering groups along the x-axis based on
  sort.fun = median, # values of `y` variable
  title = "Mean sales for different treatments",
  messages = FALSE,
  bf.message = FALSE,
  mean.ci = TRUE,
  mean.plotting = F,
  effsize.type = "r" # display effect size (Cohen's d in output)
)
#save the plot (optional)
ggsave("wilcoxon_test.jpg", height = 5, width = 7.5)

#-------------------------------------------------------------------#
#---------------------- Kruskal-Wallis test ------------------------#
#-------------------------------------------------------------------#

# Load and inspect the data
## ------------------------------------------------------------------------
online_store_promo <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/online_store_promo.dat", 
                                 sep = "\t", 
                                 header = TRUE) #read in data
online_store_promo$Promotion <- factor(online_store_promo$Promotion, levels = c(1:3), labels = c("high", "medium","low")) #convert grouping variable to factor
str(online_store_promo) #inspect data
print(online_store_promo) #inspect data

# Plot the data
## ------------------------------------------------------------------------
# Boxplot
ggplot(online_store_promo, aes(x = Promotion, y = Sales)) + 
  geom_boxplot() + 
  geom_jitter(color="red",alpha=0.2) +
  labs(x = "Experimental group (promotion level)", y = "Number of sales") + 
  theme_bw() 

# Run the test
## ------------------------------------------------------------------------
kruskal.test(Sales ~ Promotion, data = online_store_promo) 

# Post hoc test
## ------------------------------------------------------------------------
library(PMCMR)
posthoc.kruskal.nemenyi.test(x = online_store_promo$Sales, g = online_store_promo$Promotion, dist = "Tukey")

# Alternatively you can use the "ggstatsplot" package
## ------------------------------------------------------------------------
ggbetweenstats(
  data = online_store_promo,
  plot.type = "box",
  x = Promotion, # 2 groups
  y = Sales ,
  type = "nonparametric",
  messages = FALSE,
  title = "Mean sales for different groups"
)
#save the plot (optional)
ggsave("kruskal.jpg", height = 5, width = 7.5)


