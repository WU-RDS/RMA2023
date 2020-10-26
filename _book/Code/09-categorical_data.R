# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/hypothesis-testing.html#categorical-data

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "plyr", "ggplot2", "reshape2", "PMCMR", "car", "multcomp", "Hmisc", "ggstatsplot")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)

#-------------------------------------------------------------------#
#--------------------------Categorical data-------------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
call_center <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/call_center.dat", 
                          sep = "\t", 
                          header = TRUE) #read in data
call_center$conversion <- factor(call_center$conversion , levels = c(0:1), labels = c("no", "yes")) #convert to factor
call_center$agent <- factor(call_center$agent , levels = c(0:1), labels = c("agent_1", "agent_2")) #convert to factor
# Inspect data
head(call_center)
table(call_center)

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

#-------------------------------------------------------------------#
#-------------------------Confidence interval-----------------------#
#-------------------------------------------------------------------#

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
prop.test(x = c(n1_conv, n2_conv), n = c(n1, n2), conf.level = 0.95, correct = FALSE)


#-------------------------------------------------------------------#
#-----------------------------Chi^2 test----------------------------#
#-------------------------------------------------------------------#

# Compute test by hand
## ------------------------------------------------------------------------
## Create contingency table
contigency_table <- table(call_center)

## Compute observed cell frequencies
obs_cell1 <- contigency_table[1,1]
obs_cell2 <- contigency_table[1,2]
obs_cell3 <- contigency_table[2,1]
obs_cell4 <- contigency_table[2,2]

## Compute expected cell frequencies
n <- nrow(call_center)
exp_cell1 <- (nrow(call_center[call_center$agent=="agent_1",])*nrow(call_center[call_center$conversion=="no",]))/n
exp_cell2 <- (nrow(call_center[call_center$agent=="agent_1",])*nrow(call_center[call_center$conversion=="yes",]))/n
exp_cell3 <- (nrow(call_center[call_center$agent=="agent_2",])*nrow(call_center[call_center$conversion=="no",]))/n
exp_cell4 <- (nrow(call_center[call_center$agent=="agent_2",])*nrow(call_center[call_center$conversion=="yes",]))/n

## Expected cell frequencies
data.frame(conversion_no = rbind(exp_cell1,exp_cell3),conversion_yes = rbind(exp_cell2,exp_cell4), row.names = c("agent_1","agent_2")) 

## Observed cell frequencies
data.frame(conversion_no = rbind(obs_cell1,obs_cell2),conversion_yes = rbind(obs_cell3,obs_cell4), row.names = c("agent_1","agent_2")) 

## Compute test statistic
chisq_cal <-  sum(((obs_cell1 - exp_cell1)^2/exp_cell1),
                  ((obs_cell2 - exp_cell2)^2/exp_cell2),
                  ((obs_cell3 - exp_cell3)^2/exp_cell3),
                  ((obs_cell4 - exp_cell4)^2/exp_cell4))
chisq_cal

## Compute degrees of freedom
df <-  (nrow(contigency_table) - 1) * (ncol(contigency_table) -1)
df

## Test if calculated test statistic is larger than critical value
chisq_crit <- qchisq(0.95, df = df)
chisq_crit
chisq_cal > chisq_crit

## Compute p-value
p_val <- 1-pchisq(chisq_cal,df)
p_val

# Compute the chi^2 test using chisq.test() function
## ------------------------------------------------------------------------
chisq.test(contigency_table, correct = FALSE)

## result with smaller sample size
chisq.test(contigency_table/10, correct = FALSE)

## Effect size
test_stat <- chisq.test(contigency_table, correct = FALSE)$statistic
phi1 <- sqrt(test_stat/n)
test_stat <- chisq.test(contigency_table/10, correct = FALSE)$statistic
phi2 <- sqrt(test_stat/(n/10))
phi1
phi2

## Use Yates correction
chisq.test(contigency_table)

## The same can be achieved using prop.test()
prop.test(contigency_table)

# Alternatively you can use the "ggstatsplot" package
## ------------------------------------------------------------------------
library(ggstatsplot)
ggbarstats(
  data = call_center,
  x = conversion,
  y = agent,
  title = "Conversion by agent",
  xlab = "Agent",
  palette = "Blues",
  messages = FALSE,
  bar.proptest = FALSE,
  bf.message = FALSE
)
#save the plot (optional)
ggsave("chi_squared.jpg", height = 5, width = 7.5)

# Use Fisher's exact test (if any cell frequencies are < 5)
## ------------------------------------------------------------------------
fisher.test(contigency_table)
contigency_table
odds1 <- 100/200
odds2 <- 200/100
odds1/odds2

#-------------------------------------------------------------------#
#-----------------------------Sample size---------------------------#
#-------------------------------------------------------------------#

# Determine the required sample size for a test of proportions
## ------------------------------------------------------------------------
power.prop.test(p1=0.02,p2=0.025,sig.level=0.05,power=0.8)
