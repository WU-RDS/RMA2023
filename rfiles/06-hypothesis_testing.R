# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2017/_book/hypothesis-testing.html 


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "pwr", "car", "reshape2")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#---------------------Independent-means t test----------------------#
#-------------------------------------------------------------------#

# Load and inspect the data
## ------------------------------------------------------------------------
music_sales <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_experiment.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
music_sales$group <- factor(music_sales$group, levels = c(1:2), labels = c("low_price", "high_price")) #convert grouping variable to factor
str(music_sales) #inspect data
head(music_sales) #inspect data

# Frequency table
## ------------------------------------------------------------------------
table(music_sales$unit_sales, music_sales$group) 

# Descriptive statistics
## ------------------------------------------------------------------------
library(psych)
psych::describe(music_sales$unit_sales) #overall descriptives
describeBy(music_sales$unit_sales, music_sales$group) #descriptives by group

# Plot data 
## ------------------------------------------------------------------------
# Histogram
ggplot(music_sales,aes(unit_sales)) + 
  geom_histogram(binwidth = 4, col = "black", fill = "darkblue") + 
  facet_wrap(~group) +
  labs(x = "Number of sales", y = "Frequency") + 
  theme_bw()
## ------------------------------------------------------------------------
# Boxplot
library(ggplot2)
ggplot(music_sales, aes(x = group, y = unit_sales)) + 
  geom_boxplot() + 
  labs(x = "Experimental group", y = "Number of sales") + 
  theme_bw() 
## ------------------------------------------------------------------------
# Plot of means
ggplot(music_sales, aes(group, unit_sales)) + 
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Group", y = "Average number of sales") +
  theme_bw()

# Compute the required sample size
## ------------------------------------------------------------------------
library(pwr)
pwr.t.test(d = 0.6, sig.level = 0.05, power = 0.8, type = c("two.sample"), alternative = c("two.sided"))

# Compute the power of a test
## ------------------------------------------------------------------------
pwr.t.test(n = 51, d = 0.6, sig.level = 0.05, type = c("two.sample"), alternative = c("two.sided"))

# Compute test statistic by hand
# Step 1: compute means and variances of samples
## ------------------------------------------------------------------------
mean_1 <- mean(music_sales[music_sales$group=="low_price","unit_sales"])
mean_1
var_1 <- var(music_sales[music_sales$group=="low_price","unit_sales"])
var_1
mean_2 <- mean(music_sales[music_sales$group=="high_price","unit_sales"])
mean_2
var_2 <- var(music_sales[music_sales$group=="high_price","unit_sales"])
var_2

# Step 2: Compute the standard error of the difference
## ------------------------------------------------------------------------
se_x1_x2 <- sqrt((var_1/n_1)+(var_2/n_2))
se_x1_x2

# Step 3: compute pooled variance estimate from the sample variances (when sample sizes differ)
## ------------------------------------------------------------------------
n_1 <- nrow(music_sales[music_sales$group=="low_price",])
n_1
n_2 <- nrow(music_sales[music_sales$group=="high_price",])
n_2
var_pooled <- ((n_1-1)*var_1+(n_2-1)*var_2)/(n_1+n_2-2)
var_pooled
# Standard error based on pooled variance 
# In this case it's the same because sample sizes are the same
se_x1_x2 <- sqrt((var_pooled/n_1)+(var_pooled/n_2))
se_x1_x2

# Step 4: Compute the value of the test statistic
## ------------------------------------------------------------------------
t_cal <- (mean_1-mean_2)/se_x1_x2
t_cal

# Compute test statistic using the t.test() function (incl. Welch correction)
## ------------------------------------------------------------------------
t.test(unit_sales ~ group, data = music_sales)

# Compute test statistic using the t.test() function (excl. Welch correction)
# Test homogeneity of variances assumption
## ------------------------------------------------------------------------
library(car)
leveneTest(unit_sales ~ group, data = music_sales)
# Run the test using the "var.equal= TRUE" argument
## ------------------------------------------------------------------------
t.test(unit_sales ~ group, data = music_sales, var.equal = TRUE)

# Compute the effect size
## ------------------------------------------------------------------------
d <- (mean_1 - mean_2)/sqrt(var_pooled + var_pooled/2)
d

# Reject or do not reject H0
# P-value
## ------------------------------------------------------------------------
df <- (n_1 + n_2 - 2)
2*(1-pt(abs(t_cal), df))
# T-value
## ------------------------------------------------------------------------
df <- (n_1 + n_2 - 2)
t_cal > qt(0.975, df)
# Confidence interval
## ------------------------------------------------------------------------
(mean_1-mean_2)-qt(0.975,df)*se_x1_x2
(mean_1-mean_2)+qt(0.975,df)*se_x1_x2


#-------------------------------------------------------------------#
#----------------------Dependent-means t test-----------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
music_sales_dep <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_experiment_dependent.dat", 
                              sep = "\t", 
                              header = TRUE) #read in data
str(music_sales_dep) #inspect data
head(music_sales_dep) #inspect data

# Frequency table
## ------------------------------------------------------------------------
table(music_sales_dep[, c("unit_sales_low_price")]) #frequencies low price
table(music_sales_dep[, c("unit_sales_high_price")]) #frequencies high price
psych::describe(music_sales_dep[, c("unit_sales_low_price", "unit_sales_high_price")]) #overall descriptives

# Plot of means
## ------------------------------------------------------------------------
library(reshape2)
ggplot(data = melt(music_sales_dep[, c("unit_sales_low_price", "unit_sales_high_price")]), aes(x = variable, y = value)) +
  geom_bar(stat = "summary",  color = "black", fill = "white", width = 0.7) +
  geom_pointrange(stat = "summary") + 
  labs(x = "Group", y = "Average number of sales") +
  theme_bw()

# Compute test statistic by hand
# Compute the difference between the two experimental groups in a new variable
## ------------------------------------------------------------------------
music_sales_dep$difference <- music_sales_dep$unit_sales_low_price - music_sales_dep$unit_sales_high_price
head(music_sales_dep)
# Compute the mean difference
## ------------------------------------------------------------------------
mean_d <- sum(music_sales_dep$difference)/length(music_sales_dep$difference)
mean_d

# Compute the standard error
## ------------------------------------------------------------------------
sd_d <- sd(music_sales_dep$difference) #standard deviation
sd_d
n_d <- nrow(music_sales_dep) #number of observations
n_d
se_d <- sd(music_sales_dep$difference)/sqrt(n_d) #standard error
se_d

# Compute the test statistic
## ------------------------------------------------------------------------
t_cal <- mean_d/se_d
t_cal

# Compute the confidence interval
## ------------------------------------------------------------------------
df <- nrow(music_sales_dep)-1
(mean_d)-qt(0.975,df)*se_d
(mean_d)+qt(0.975,df)*se_d

# Compute test statistic using the t.test() function
## ------------------------------------------------------------------------
t.test(music_sales_dep$unit_sales_low_price, music_sales_dep$unit_sales_high_price, paired=TRUE)

# Reject or do not reject H0
## ------------------------------------------------------------------------
df <- (n_d - 1) #degrees of freedom
qt(0.975, df) #critical value
t_cal #calculated value
t_cal > qt(0.975, df) #check if calculated value is larger than critical


#-------------------------------------------------------------------#
#-------------------------One-sample t test-------------------------#
#-------------------------------------------------------------------#

# Test if the average sales level is greater than 4
## ------------------------------------------------------------------------
t.test(music_sales$unit_sales, mu = 4, alternative = "greater")


#-------------------------------------------------------------------#
#-----------Wilcoxon rank sum test (Mann-Whitney U Test)------------#
#-------------------------------------------------------------------#

# Non-parametric equivalent to the independent-means t test
## ------------------------------------------------------------------------
wilcox.test(unit_sales ~ group, data = music_sales) 


#-------------------------------------------------------------------#
#---------------------Wilcoxon singed-rank test---------------------#
#-------------------------------------------------------------------#

# Non-parametric equivalent to the dependent-means t test
## ------------------------------------------------------------------------
wilcox.test(music_sales_dep$unit_sales_low_price, music_sales_dep$unit_sales_high_price, paired = TRUE) #Wilcoxon signed-rank test


#-------------------------------------------------------------------#
#-----------------------Comparing proportions-----------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
call_center <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/call_center.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
call_center$conversion <- factor(call_center$conversion , levels = c(0:1), labels = c("no", "yes")) #convert to factor
call_center$agent <- factor(call_center$agent , levels = c(0:1), labels = c("agent_1", "agent_2")) #convert to factor

# Conditional relative frequencies
## ------------------------------------------------------------------------
rel_freq_table <- as.data.frame(prop.table(table(call_center), 2))
rel_freq_table

# Plot proportions using ggplot
## ------------------------------------------------------------------------
ggplot(rel_freq_table, aes(x = agent, y = Freq, fill = conversion)) + #plot data
  geom_col(width = .7) + 
  geom_text(aes(label = paste0(round(Freq*100,0),"%")), position = position_stack(vjust = 0.5), size = 4) + #add value labels
  ylab("Proportion of conversions") + xlab("Agent") + # specify axis labels
  theme_bw()

# Plot proportions using mosaicplot()
## ------------------------------------------------------------------------
contigency_table <- table(call_center)
mosaicplot(contigency_table, main = "Proportion of conversions by agent")

# Compute confidence intervals for conversion rates by call center agent
## ------------------------------------------------------------------------
n1 <- nrow(subset(call_center,agent=="agent_1")) #number of observations for agent 1
n2 <- nrow(subset(call_center,agent=="agent_2")) #number of observations for agent 1
n1_conv <- nrow(subset(call_center,agent=="agent_1" & conversion=="yes")) #number of conversions for agent 1
n2_conv <- nrow(subset(call_center,agent=="agent_2" & conversion=="yes")) #number of conversions for agent 2
p1 <- n1_conv/n1  #proportion of conversions for agent 1
p2 <- n2_conv/n2  #proportion of conversions for agent 2
# Agent 1
error1 <- qnorm(0.975)*sqrt((p1*(1-p1))/n1)
ci_lower1 <- p1 - error1
ci_upper1 <- p1 + error1
ci_lower1
ci_upper1
# Agent 2
error2 <- qnorm(0.975)*sqrt((p2*(1-p2))/n2)
ci_lower2 <- p2 - error2
ci_upper2 <- p2 + error2
ci_lower2
ci_upper2

# Test the difference between conversion rates between call center agents
## ------------------------------------------------------------------------
ci_lower <- p1 - p2 - qnorm(0.975)*sqrt(p1*(1 - p1)/n1 + p2*(1 - p2)/n2) #95% CI lower bound
ci_upper <- p1 - p2 + qnorm(0.975)*sqrt(p1*(1 - p1)/n1 + p2*(1 - p2)/n2) #95% CI upper bound
ci_lower
ci_upper
## ------------------------------------------------------------------------
prop.test(x = c(n1_conv, n2_conv), n = c(n1, n2), conf.level = 0.95)

# Determine the required sample size for a test of proportions
## ------------------------------------------------------------------------
power.prop.test(p1=0.01,p2=0.15,sig.level=0.05,power=0.8)


#-------------------------------------------------------------------#
#-----------------------------Chi^2 test----------------------------#
#-------------------------------------------------------------------#

# Load data 
## ------------------------------------------------------------------------
cross_tab <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/cross_tab.dat", 
                        sep = "\t", 
                        header = TRUE) #read data
cross_tab$College <- factor(cross_tab$College , levels = c(0:1), labels = c("no", "yes")) #convert to factor
cross_tab$CarOwnership <- factor(cross_tab$CarOwnership , levels = c(0:1), labels = c("no", "yes")) #convert to factor

# Create contigency table
## ------------------------------------------------------------------------
cont_table <- table(cross_tab) 
cont_table #view table

# Plot data
## ------------------------------------------------------------------------
cont_table_df <- as.data.frame(prop.table(table(cross_tab),1)) #conditional relative frequencies
cont_table_df
ggplot(cont_table_df, aes(x = College, y = Freq, fill = CarOwnership)) + #plot data
  geom_col(width = .7) + #position
  geom_text(aes(label = paste0(round(Freq*100,0),"%")), position = position_stack(vjust = 0.5), size = 4) + #add percentages
  ylab("Expensive car ownership (proportion)") + xlab("College degree") + # specify axis labels
  theme_bw()

# Compute test by hand
## ------------------------------------------------------------------------
## Compute observed cell frequencies
obs_cell1 <- cont_table[1,1]
obs_cell2 <- cont_table[1,2]
obs_cell3 <- cont_table[2,1]
obs_cell4 <- cont_table[2,2]
## Compute expected cell frequencies
n <- nrow(cross_tab)
exp_cell1 <- (nrow(cross_tab[cross_tab$College=="no",])*nrow(cross_tab[cross_tab$CarOwnership=="no",]))/n
exp_cell2 <- (nrow(cross_tab[cross_tab$College=="no",])*nrow(cross_tab[cross_tab$CarOwnership=="yes",]))/n
exp_cell3 <- (nrow(cross_tab[cross_tab$College=="yes",])*nrow(cross_tab[cross_tab$CarOwnership=="no",]))/n
exp_cell4 <- (nrow(cross_tab[cross_tab$College=="yes",])*nrow(cross_tab[cross_tab$CarOwnership=="yes",]))/n
## Expected cell frequencies
data.frame(Car_no = rbind(exp_cell1,exp_cell2),Car_yes = rbind(exp_cell3,exp_cell4), row.names = c("College_no","College_yes")) 
## Observed cell frequencies
data.frame(Car_no = rbind(obs_cell1,obs_cell2),Car_yes = rbind(obs_cell3,obs_cell4), row.names = c("College_no","College_yes")) 
## Compute test statistic
chisq_cal <-  sum(((obs_cell1 - exp_cell1)^2/exp_cell1),
                  ((obs_cell2 - exp_cell2)^2/exp_cell2),
                  ((obs_cell3 - exp_cell3)^2/exp_cell3),
                  ((obs_cell4 - exp_cell4)^2/exp_cell4))
chisq_cal
## Compute degrees of freedom
df <-  (nrow(cont_table) - 1) * (ncol(cont_table) -1)
df
## Test if calculated test statistic is larger than critical value
chisq_crit <- qchisq(0.95, df)
chisq_crit
chisq_cal > chisq_crit
## Compute p-value
p_val <- 1-pchisq(chisq_cal,df)
p_val

# Compute the chi^2 test using chisq.test() function
## ------------------------------------------------------------------------
chisq.test(cont_table, correct = FALSE)
## result with smaller sample size
chisq.test(cont_table/10, correct = FALSE)
## Effect size
test_stat <- chisq.test(cont_table, correct = FALSE)$statistic
phi1 <- sqrt(test_stat/n)
test_stat <- chisq.test(cont_table/10, correct = FALSE)$statistic
phi2 <- sqrt(test_stat/(n/10))
phi1
phi2
## Use Yates correction
chisq.test(cont_table)
## The same can be achieved using prop.test()
prop.test(cont_table)

# Use Fisher's exact test (if any cell frequencies are < 5)
## ------------------------------------------------------------------------
fisher.test(cont_table)

