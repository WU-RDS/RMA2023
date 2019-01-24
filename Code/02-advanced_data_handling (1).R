#-------------------------------------------------------------------#
#---------------------Advanced data handling------------------------#
#-------------------------------------------------------------------#
# The following code is taken from the second chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2018/_book/data-handling.html#advanced-data-handling
# Please also refer to the book "R for Data Science" http://r4ds.had.co.nz/


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("dplyr")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)


#-------------------------------------------------------------------#
#-------------------------Prepare data set--------------------------#
#-------------------------------------------------------------------#

#let's create the data set from the last chapter again to make sure everyone is on the same page
top10_track_streams <- c(163608, 126687, 120480, 110022, 108630, 95639, 94690, 89011, 87869, 85599) 
top10_artist_names <- c("Axwell /\\ Ingrosso", "Imagine Dragons", "J. Balvin", "Robin Schulz", "Jonas Blue", "David Guetta", "French Montana", "Calvin Harris", "Liam Payne", "Lauv") # Characters have to be put in ""
top10_track_explicit <- c(0,0,0,0,0,0,1,1,0,0)
top10_track_explicit <- factor(top10_track_explicit, 
                               levels = c(0:1), 
                               labels = c("not explicit", "explicit"))
top10_artist_genre <- c("Dance","Alternative","Latino","Dance","Dance","Dance","Hip-Hop/Rap","Dance","Pop","Pop")
top10_artist_genre <- as.factor(top10_artist_genre)
top_10_track_release_date <- as.Date(c("2017-05-24", "2017-06-23", "2017-07-03", "2017-06-30", "2017-05-05", "2017-06-09", "2017-07-14", "2017-06-16", "2017-05-18", "2017-05-19"))
top10_track_explicit_1 <- c(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE)  

music_data <- data.frame(top10_track_streams, 
                         top10_artist_names, 
                         top10_track_explicit, 
                         top10_artist_genre, 
                         top_10_track_release_date, 
                         top10_track_explicit_1,
                         stringsAsFactors = FALSE)


#-------------------------------------------------------------------#
#------------------------The dplyr package--------------------------#
#-------------------------------------------------------------------#

# Before we continue, ensure that the ```dplyr()``` package is installed and loaded. 
library(dplyr)
 
# The ```dplyr()``` package includes six core functions:
# filter():	filter rows
# select():	select columns
# arrange():	re-order or arrange rows
# mutate():	create new columns
# summarise():	summarise values
# group_by():	allows for group operations


#-------------------------------------------------------------------#
#---------------------------Filter rows-----------------------------#
#-------------------------------------------------------------------#

# the filter() function

# select only observations where the lyrics are not explicit 
## ------------------------------------------------------------------------
filter(music_data, top10_track_explicit == "not explicit")

# select all tracks with less than 100000 streams
## ------------------------------------------------------------------------
filter(music_data, top10_track_streams < 100000)

# select all observations with less than 150000 but more than 100000 streams
## ------------------------------------------------------------------------
filter(music_data,  top10_track_streams > 100000 & top10_track_streams < 150000)

# select all observations with less than 100000 or more than 150000 streams
## ------------------------------------------------------------------------
filter(music_data,  top10_track_streams < 100000 | top10_track_streams > 150000)

# select all tracks marked as "not explicit" with less than 100000 streams
## ------------------------------------------------------------------------
filter(music_data, top10_track_explicit == "not explicit", top10_track_streams < 100000)


#-------------------------------------------------------------------#
#--------------------------Select columns---------------------------#
#-------------------------------------------------------------------#

# the select() function:

# selects the two columns "top10_track_explicit" and  "top10_track_streams" 
## ------------------------------------------------------------------------
select(music_data, top10_track_explicit, top10_track_streams)

# remove the two columns "top10_track_explicit" and  "top10_track_streams" 
## ------------------------------------------------------------------------
select(music_data, -top10_track_explicit, -top10_track_streams)

# select all columns from top10_track_explicit to top_10_track_release_date
## ------------------------------------------------------------------------
select(music_data, top10_track_explicit:top_10_track_release_date)
# this is equivalent to  
select(music_data, 3:5)


#-------------------------------------------------------------------#
#---------------------------Arrange rows----------------------------#
#-------------------------------------------------------------------#

# the arrange() function

# order the observations by top10_artist_genre and top10_track_streams
## ------------------------------------------------------------------------
arrange(music_data, top10_artist_genre, top10_track_streams)

# order the observations by top10_artist_genre and top10_track_streams (descending order)
## ------------------------------------------------------------------------
arrange(music_data, top10_artist_genre, desc(top10_track_streams))


#-------------------------------------------------------------------#
#-------------------Adding and changing variables-------------------#
#-------------------------------------------------------------------#

# the mutate() function

# add a new variable that adds 10 to every entry of the top10_track_streams variable 
## ------------------------------------------------------------------------
mutate(music_data, streams_plus_10 = top10_track_streams + 10)

# add a new variable by standardizing the "top10_track_streams" variable
## ------------------------------------------------------------------------
mutate(music_data, streams_standardised = (top10_track_streams - mean(top10_track_streams))/ sd(top10_track_streams))

# the same can be achieved using the scale() function:
## ------------------------------------------------------------------------
mutate(music_data, streams_standardised = scale(top10_track_streams))

# add a new variable from a different vector
## ------------------------------------------------------------------------
# generate random data with 10 rows
extra_column <- c(1,2,3,4,5,6,7,8,9,10)
mutate(music_data, new_data = extra_column) 

# edit a present variable without creating a new one using hte mutate_at() function 
# change the type of the "top10_track_explicit" variable to "character" column and not a factor
## ------------------------------------------------------------------------
mutate_at(music_data, "top10_track_explicit", as.character)

# edit multiple columns to be character vectors
## ------------------------------------------------------------------------
# specify which variables to edit
columns <- c("top10_track_explicit", "top10_artist_genre", "top10_track_explicit_1")
# using the mutate_at() function on the specified columns
mutate_at(music_data, columns, as.character)

# rename a variable without changing its content
## ------------------------------------------------------------------------
rename(music_data, explicit = top10_track_explicit, names = top10_artist_names)


#-------------------------------------------------------------------#
#---------------------Creating custom summaries---------------------#
#-------------------------------------------------------------------#

# the summarise() function

# compute the mean and standard deviation of the "top10_track_streams" variable and also count the number of observations
## ------------------------------------------------------------------------
summarise(music_data, n_observations = n(), mean_streams = mean(top10_track_streams), sd_streams = sd(top10_track_streams))


#-------------------------------------------------------------------#
#------------------------Grouping operations------------------------#
#-------------------------------------------------------------------#

# compute the mean, standard deviation, and number of observations for explicit and non-explicit songs separately 
## ------------------------------------------------------------------------
# first apply the grouping to the data set
music_data <- group_by(music_data, top10_track_explicit)
# then use the summarise() function on the grouped data set
summarise(music_data, n_observations = n(), mean_streams = mean(top10_track_streams), sd_streams = sd(top10_track_streams))
# ungroup the variable when you would like to continue without the grouping
music_data <-  ungroup(music_data)

#-------------------------------------------------------------------#
#-------------------------------Pipes-------------------------------#
#-------------------------------------------------------------------#

# the pipe operator: %>%

# combine various commands 
# first consider this example of various consecutive operations 
## ------------------------------------------------------------------------
# 1. First use select() to take only certain columns
music_data_new <- select(music_data, top10_track_explicit_1, top10_artist_names, top10_track_streams)
# 2. Now use filter() to choose only rows that fulfill certain criteria 
music_data_new <- filter(music_data_new, top10_track_streams < 100000)
# 3. Then change order with arrange()
music_data_new <- arrange(music_data_new, top10_track_streams)
# Print to console
music_data_new

# we can chain these commands together to streamline our code, while keeping it very readable. 
## ------------------------------------------------------------------------
music_data_new <- music_data %>%
                  select(top10_track_explicit_1, top10_artist_names, top10_track_streams) %>%
                  filter(top10_track_streams < 100000) %>%
                  arrange(top10_track_streams)
# print to console
music_data_new

# or you could summarise the data by group
## ------------------------------------------------------------------------
music_data %>%  group_by(top10_track_explicit) %>%
                summarise(mean = mean(top10_track_streams),
                          median = median(top10_track_streams),
                          sd = sd(top10_track_streams)) 


