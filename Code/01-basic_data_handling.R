## --------------------------------------------------------------------------------------------------------------------------------------------------------------
x <- "hello world" #assigns the words "hello world" to the object x
#this is a comment


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
x #print the value of x to the console


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
print(x) #print the value of x to the console


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
x <- 2 #assigns the value of 2 to the object x
print(x)
x == 2  #checks whether the value of x is equal to 2
x != 3  #checks whether the value of x is NOT equal to 3
x < 3   #checks whether the value of x is less than 3
x > 3   #checks whether the value of x is greater than 3


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
y <- 5 #assigns the value of 2 to the object x
x == y #checks whether the value of x to the value of y
x*y #multiplication of x and y
x + y #adds the values of x and y together
y^2 + 3*x #adds the value of y squared and 3x the value of x together


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
y <- as.character(y)
print(y)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#Numeric:
top10_track_streams <- c(163608, 126687, 120480, 110022, 108630, 95639, 94690, 89011, 87869, 85599) 
log(top10_track_streams)
#Character:
top10_artist_names <- c("Axwell /\\ Ingrosso", "Imagine Dragons", "J. Balvin", "Robin Schulz", "Jonas Blue", "David Guetta", "French Montana", "Calvin Harris", "Liam Payne", "Lauv") # Characters have to be put in ""

#Factor variable with two categories:
top10_track_explicit <- c(0,0,0,0,0,0,1,1,0,0)
top10_track_explicit <- factor(top10_track_explicit, 
                               levels = 0:1, 
                               labels = c("not explicit", "explicit"))

# Factor variable with more than two categories:
top10_artist_genre <- c("Dance","Alternative","Latino","Dance","Dance","Dance","Hip-Hop/Rap","Dance","Pop","Pop")
top10_artist_genre <- as.factor(top10_artist_genre)

#Date:
top_10_track_release_date <- as.Date(c("2017-05-24", "2017-06-23", "2017-07-03", "2017-06-30", "2017-05-05", "2017-06-09", "2017-07-14", "2017-06-16", "2017-05-18", "2017-05-19"))

#Logical
top10_track_explicit_1 <- c(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE)  


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
top10_track_streams

## --------------------------------------------------------------------------------------------------------------------------------------------------------------
top_10_track_release_date


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
class(top_10_track_release_date)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data <- data.frame(top10_track_streams, 
                         top10_artist_names, 
                         top10_track_explicit, 
                         top10_artist_genre, 
                         top_10_track_release_date, 
                         top10_track_explicit_1)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data # Returns the entire data frame


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data[ , 2:4] # all rows and columns 2,3,4
music_data[5:7, ] # rows 5,6,7 and all columns


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
filter(music_data, top10_track_explicit == "explicit") # show only tracks with explicit lyrics  
filter(music_data, top10_track_streams > 100000) # show only tracks with more than 100,000 streams  
filter(music_data, top10_artist_names == 'Robin Schulz') # returns all observations from artist "Robin Schulz"
explicit_tracks <- filter(music_data, top10_track_explicit == "explicit") # assign a new data.frame for explicit tracs only


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
#Arrange by genre (ascending: A - Z) and streams (descending: maximum - minimum)
arrange(music_data, top10_artist_genre, desc(top10_track_streams))


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
head(music_data, 3) # returns the first X rows (here, the first 3 rows)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
tail(music_data, 3) # returns the last X rows (here, the last 3 rows)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
names(music_data) # returns the names of the variables in the data frame


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
str(music_data) # returns the structure of the data frame


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
nrow(music_data) # returns the number of rows 
ncol(music_data) # returns the number of columns 
dim(music_data) # returns the dimensions of a data frame


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
ls(music_data) # list all objects associated with an object

ls()
## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data$top10_track_streams


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
select(music_data, top10_artist_names, top10_track_streams, top10_track_explicit)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
select(music_data, -top_10_track_release_date, -top10_track_explicit_1)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create new variable as the log of the number of streams 
music_data$log_streams <- log(music_data$top10_track_streams) 
# Create an ascending count variable which might serve as an ID
music_data$obs_number <- 1:nrow(music_data)
head(music_data)


## --------------------------------------------------------------------------------------------------------------------------------------------------------------
music_data_new <- mutate(music_data, 
       sqrt_streams = sqrt(top10_track_streams),
       # "%Y" extracts the year, format returns a character
       release_year = as.integer(format(top_10_track_release_date, "%Y")) 
       ) %>%
  select(top10_artist_names, sqrt_streams, release_year)


## ---- message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------------------------------------
music_data <- dplyr::rename(music_data, genre = top10_artist_genre, release_date = top_10_track_release_date)
head(music_data)

## ---- message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------------------------------------
names(music_data)[names(music_data)=="genre"] <- "top10_artist_genre"
head(music_data)


## ---- message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------------------------------------
names(music_data)[4] <- "genre"
head(music_data)

