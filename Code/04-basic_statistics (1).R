#-------------------------------------------------------------------#
#---------------------Descriptive statistics------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the fourth chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2019/_book/summary-statistics.html

#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("psych", "pastecs","dplyr")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 2)

#-------------------------------------------------------------------#
#----------------------Categorical variables------------------------#
#-------------------------------------------------------------------#

# Load data
## ------------------------------------------------------------------------
library(openssl)
url <- "https://raw.githubusercontent.com/IMSMWU/mrda_data_pub/master/secret-music_data.rds"
download.file(url, "./data/secret_music_data.rds", method = "auto", quiet=FALSE)
encrypted_music_data <- readRDS("./data/secret_music_data.rds")
music_data <- unserialize(aes_cbc_decrypt(encrypted_music_data, key = key))

head(music_data)

# The as.factor function can transform characters into factors
## ------------------------------------------------------------------------
s.genre <- c("pop","hip hop","rock","rap","indie")
music_data <- subset(music_data, top.genre %in% s.genre)

music_data$genre_cat <- as.factor(music_data$top.genre)
music_data$explicit_cat <- factor(music_data$explicit, levels = c(0:1), 
                                  labels = c("not explicit", "explicit"))

# The table function creates frequency tables
## ------------------------------------------------------------------------
table(music_data[,c("genre_cat")]) #absolute frequencies
table(music_data[,c("explicit_cat")]) #absolute frequencies

# The median and summary function produce various summary statistics 
## ------------------------------------------------------------------------
median((music_data[,c("explicit")]))
summary((music_data[,c("explicit")]))

# The prop.table function produces relative frequency tables
## ------------------------------------------------------------------------
prop.table(table(music_data[,c("genre_cat")])) #relative frequencies
prop.table(table(music_data[,c("explicit_cat")])) #relative frequencies

# By adding a second column we can investigate the frequency table by explicitness
## ------------------------------------------------------------------------
table(music_data[,c("genre_cat", "explicit_cat")]) #absolute frequencies

## ------------------------------------------------------------------------
prop.table(table(music_data[,c("genre_cat", "explicit_cat")])) #relative frequencies

## ------------------------------------------------------------------------
prop.table(table(music_data[,c("genre_cat", "explicit_cat")]),2) #conditional relative frequencies


#-------------------------------------------------------------------#
#----------------------Continuous variables-------------------------#
#-------------------------------------------------------------------#

# The psych package contains the useful describe function, which produces more summary statistics than
# the simple summary function contained in base R
## ------------------------------------------------------------------------
library(psych)
psych::describe(music_data[,c("trackPopularity", "total_releases")])

# describeBy produces the summary statistics grouped by a grouping variable, in our case this is explicitness
## ------------------------------------------------------------------------
describeBy(music_data[,c("trackPopularity", "total_releases")], music_data$explicit_cat)

# The same could have been achieved by the stat.desc function from the pastecs package
## ------------------------------------------------------------------------
library(pastecs)
stat.desc(music_data[,c("trackPopularity", "total_releases")])

# The by function applies a function to data, grouped by a factor variable
## ------------------------------------------------------------------------
by(music_data[,c("trackPopularity", "total_releases")],music_data$explicit_cat,stat.desc)

#-------------------------------------------------------------------#
#------------------------Creating subsets---------------------------#
#-------------------------------------------------------------------#

# Check for outliers in the data
# Compute standardized duration variable using the scale function and filter values > 3
music_data$total_releases_sd <- scale(music_data$total_releases)
subset(music_data,abs(total_releases_sd) > 3)

# Create subsets by excluding outliers
estimation_sample <- subset(music_data,abs(total_releases_sd) > 3)
psych::describe(estimation_sample[,c("trackPopularity", "total_releases")])

