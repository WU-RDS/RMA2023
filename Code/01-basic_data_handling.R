#-------------------------------------------------------------------#
#-----------------------Basic data handling-------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the second chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/data-handling.html


#-------------------------------------------------------------------#
#------------------------Working directory--------------------------#
#-------------------------------------------------------------------#

# Make sure that your working directory is set correctly. 
# The working directory is the location where R will look for files you would like to load and where any files you write to disk will be saved.
## ------------------------------------------------------------------------
getwd() #check the current working directory
#setwd("path/to/file") #set working directory in case you would like to change it
#whenever setting paths in R, remember to use forward slashed (not backslashes)

#-------------------------------------------------------------------#
#----------------------------Functions------------------------------#
#-------------------------------------------------------------------#

# Functions take arguments to produce outputs. Arguments can either be supplied in the order of the function
# or by manually typing in the name of the argument
## ------------------------------------------------------------------------
seq(from = 1, to = 10) #creates sequence from 1 to 10
seq(1,10) #same result

# However, the following two do not produce the same result, seeing as the second version interprets it as seq(from = 1, to = 10)
seq(to = 10,from = 1) #produces desired results
seq(10,1) #produces reversed sequence

#-------------------------------------------------------------------#
#------------------------Installing packages------------------------#
#-------------------------------------------------------------------#

# Before using the functions contained in a package, the package needs to be installed using the "install.packages()" function
# For example, let's install the "plyr" package, which will will be using below
## ------------------------------------------------------------------------
install.packages("plyr")
# After a package is installed, you may access the functions by loading the package using the "library()" function
# Note that you only have to install packages once! After the package has been installed, you may load it anytime using "library()"
library(plyr)

# list all packages where an update is available
old.packages()

# update all available packages
# update.packages()

# update, without prompts for permission/clarification
# update.packages(ask = FALSE)

# update only a specific package use install.packages()
# install.packages("ggplot2")

#-------------------------------------------------------------------#
#--------------------------Creating objects-------------------------#
#-------------------------------------------------------------------#

# Assignment is done via the <- operator
## ------------------------------------------------------------------------
x <- "hello world" #assigns the words "hello world" to the object x

## ------------------------------------------------------------------------
x #print the value of x to the console

## ------------------------------------------------------------------------
print(x) #print the value of x to the console

## ------------------------------------------------------------------------
x <- 2 #assigns the value of 2 to the object x
print(x)
x == 2  #checks whether the value of x is equal to 2
x != 3  #checks whether the value of x is NOT equal to 3
x < 3   #checks whether the value of x is less than 3
x > 3   #checks whether the value of x is greater than 3

## ------------------------------------------------------------------------
y <- 5 #assigns the value of 2 to the object x
x == y #checks whether the value of x to the value of y
x*y #multiplication of x and y
x + y #adds the values of x and y together
y^2 + 3*x #adds the value of y squared and 3x the value of x together


#-------------------------------------------------------------------#
#-----------------------------Data types----------------------------#
#-------------------------------------------------------------------#

# Variables can be converted from one type to another using the appropriate functions 
# (e.g., as.factor(), as.character(), as.integer(), as.Date(), as.numeric(), etc.) 
## ------------------------------------------------------------------------
y <- as.character(y)
print(y)

##Creating vectors----------------------------------------------------------

#Numeric:
top10_track_streams <- c(163608, 126687, 120480, 110022, 108630, 95639, 94690, 89011, 87869, 85599) 

#Character:
top10_artist_names <- c("Axwell /\\ Ingrosso", "Imagine Dragons", "J Balvin", "Robin Schulz", "Jonas Blue", "David Guetta", "French Montana", "Calvin Harris", "Liam Payne", "Lauv") # Characters have to be put in ""

#Factor variable with two categories:
top10_track_explicit <- c(0,0,0,0,0,0,1,1,0,0)
top10_track_explicit <- factor(top10_track_explicit, 
                               levels = c(0:1), 
                               labels = c("not explicit", "explicit"))

#Factor variable with more than two categories:
top10_artist_genre <- c("Dance","Alternative","Latino","Dance","Dance","Dance","Hip-Hop/Rap","Dance","Pop","Pop")
top10_artist_genre <- as.factor(top10_artist_genre)

#Date:
top_10_track_release_date <- as.Date(c("2017-05-24", "2017-06-23", "2017-07-03", "2017-06-30", "2017-05-05", "2017-06-09", "2017-07-14", "2017-06-16", "2017-05-18", "2017-05-19"))

#Logical
top10_track_explicit_1 <- c(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE)  
 
## ------------------------------------------------------------------------
#print vectors to console 
top10_track_streams
top_10_track_release_date

# The type of an object can be checked with the class() function
## ------------------------------------------------------------------------
class(top_10_track_release_date)


#-------------------------------------------------------------------#
#---------------------------Data structures-------------------------#
#-------------------------------------------------------------------#

# Data frames (similar to spreadsheets from Excel or SPSS) can be created with the data.frame command.
## ------------------------------------------------------------------------
music_data <- data.frame(top10_track_streams, 
                         top10_artist_names, 
                         top10_track_explicit, 
                         top10_artist_genre, 
                         top_10_track_release_date, 
                         top10_track_explicit_1)

## ------------------------------------------------------------------------
music_data # Returns the entire data.frame

# Selecting certain values can be done with square brackets 
## ------------------------------------------------------------------------
music_data[,2:4] # all rows and columns 2,3,4
music_data[,c("top10_artist_names", "top_10_track_release_date")] # all rows and columns "top10_artist_names" and "top_10_track_release_date"
music_data[c(1:5), c("top10_artist_names", "top_10_track_release_date")] # rows 1 to 5 and columns "top10_artist_names"" and "top_10_track_release_date"

# It is also possible to use logical operators to select values 
## ------------------------------------------------------------------------
music_data[top10_track_explicit == "explicit",] # show only tracks with explicit lyrics  
music_data[top10_track_streams > 100000,] # show only tracks with more than 100,000 streams  
music_data[top10_artist_names == 'Robin Schulz',] # returns all observations from artist "Robin Schulz"
music_data[top10_track_explicit == "explicit",] # show only explicit tracks

# The same can be done via the subset() function
## ------------------------------------------------------------------------
subset(music_data,top10_track_explicit == "explicit") # selects subsets of observations in a dataframe

#creates a new data frame that only contains tracks from genre "Dance" 
music_data_dance <- subset(music_data,top10_artist_genre == "Dance") 
music_data_dance
rm(music_data_dance) # removes an object from the workspace

# Orders by genre (ascending) and streams (descending)
## ------------------------------------------------------------------------
music_data[order(top10_artist_genre,-top10_track_streams),] 

## ------------------------------------------------------------------------
head(music_data, 3) # returns the first X rows (here, the first 3 rows)
head(music_data$top10_artist_names, 4) # returns the first 4 elements of the top10_artist_names column

## ------------------------------------------------------------------------
tail(music_data, 3) # returns the last X rows (here, the last 3 rows)
tail(music_data$top10_artist_names, 4) # returns the last 4 elements of the top10_artist_names column

## ------------------------------------------------------------------------
names(music_data) # returns the names of the variables in the data frame

## ------------------------------------------------------------------------
str(music_data) # returns the structure of the data frame

## ------------------------------------------------------------------------
nrow(music_data) # returns the number of rows 
ncol(music_data) # returns the number of columns 
dim(music_data) # returns the dimensions of a data frame

## ------------------------------------------------------------------------
ls(music_data) # list all objects associated with an object

# The dollar operator can be used to access the values of one column of a data frame
## ------------------------------------------------------------------------
music_data$top10_track_streams

# It can also be used to add new columns 
## ------------------------------------------------------------------------
# Create new variable as the log of the number of streams 
music_data$log_streams <- log(music_data$top10_track_streams) 
# Create an ascending count variable to assign numbers to the observations 
music_data$obs_number <- 1:nrow(music_data)
head(music_data)

## ------------------------------------------------------------------------
music_data <- subset(music_data,select = -c(log_streams)) # deletes the variable log streams 
head(music_data)

# Renaming of variables can be done through the rename function from the plyr package
## ------------------------------------------------------------------------
library(plyr)
music_data <- plyr::rename(music_data, c(top10_artist_genre="genre",top_10_track_release_date="release_date"))
head(music_data)
# renaming could also be done in the following way
names(music_data)[names(music_data)=="genre"] <- "top10_artist_genre"
head(music_data)
# or by referring to the index directly
names(music_data)[4] <- "genre"
head(music_data) 
