#-------------------------------------------------------------------#
#---------------------Descriptive statistics------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/summarizing-data.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych","summarytools")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 2)

#-------------------------------------------------------------------#
#----------------------Categorical variables------------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
music_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/music_data_at.csv", 
                         sep = ",", header = TRUE)
dim(music_data)

# Convert variables to correct data type
## ------------------------------------------------------------------------
music_data$release_date <- as.Date(music_data$release_date)  #convert to date
music_data$explicit <- factor(music_data$explicit, 
                              levels = 0:1, labels = c("not explicit", "explicit"))  #convert to factor
music_data$label <- as.factor(music_data$label)  #convert to factor
music_data$rep_ctry <- as.factor(music_data$rep_ctry)  #convert to factor
music_data$genre <- as.factor(music_data$genre)  #convert to factor

# The table function creates frequency tables
## ------------------------------------------------------------------------
table(music_data[, c("genre")]) 
table(music_data[, c("label")])  #absolute frequencies
table(music_data[, c("rep_ctry")])  #absolute frequencies
table(music_data[, c("explicit")])  #absolute frequencies

# The prop.table function produces relative frequency tables
## ------------------------------------------------------------------------
prop.table(table(music_data[, c("genre")]))  #relative frequencies
prop.table(table(music_data[, c("label")]))  #relative frequencies
prop.table(table(music_data[, c("rep_ctry")]))  #relative frequencies
prop.table(table(music_data[, c("explicit")]))  #relative frequencies

# By adding a second column we can investigate the conditional relative frequencies 
## ------------------------------------------------------------------------
prop.table(table(music_data[, c("genre", "explicit")]), 1)  #conditional relative frequencies 

# Median of rank variable
median(music_data$min_rank)
# Quantile function
quantile(music_data$min_rank, c(0.25, 0.5, 0.75))
# Quantiles by genre
by(music_data$min_rank, music_data$genre, quantile, c(0.25, 0.5, 0.75))

#-------------------------------------------------------------------#
#----------------------Continuous variables-------------------------#
#-------------------------------------------------------------------#

# The psych package contains the useful describe function, which produces more summary statistics than
# the simple summary function contained in base R
## ------------------------------------------------------------------------
library(psych)
psych::describe(music_data[, c("streams", "duration_ms", "danceability", "valence")])

# describeBy produces the summary statistics grouped by a grouping variable, in our case this is genre
## ------------------------------------------------------------------------
describeBy(music_data[, c("streams", "duration_ms","danceability", "valence")], music_data$genre, 
           skew = FALSE, range = FALSE)

# Use the summarytools package for nice formatting
## ------------------------------------------------------------------------
library(summarytools)
view(dfSummary(music_data[, c("streams", "duration_ms","valence", "genre", "label", "explicit")], plain.ascii = FALSE, 
                style = "grid", valid.col = FALSE, tmp.img.dir = "tmp"),headings = FALSE, footnote = NA)

#-------------------------------------------------------------------#
#------------------------Creating subsets---------------------------#
#-------------------------------------------------------------------#

# Check for missing values
music_data <- music_data[!is.na(music_data$valence) & !is.na(music_data$duration_ms), ]

#-------------------------------------------------------------------#
#---------------------Going beyond the data-------------------------#
#-------------------------------------------------------------------#

# Histogram of tempo variable
hist(music_data$tempo)

# Standardize variable
music_data$tempo_std <- (music_data$tempo - mean(music_data$tempo))/sd(music_data$tempo)
hist(music_data$tempo_std)

# Standardize using the scale() function
music_data$tempo_std <- scale(music_data$tempo)

# Normal distribution function can be used to determine the probability of observations
pnorm(-1.96)
pnorm(-1.96) * 2
min(music_data$tempo_std)
pnorm(min(music_data$tempo_std)) * 2
