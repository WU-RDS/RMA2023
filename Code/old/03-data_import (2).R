#-------------------------------------------------------------------#
#----------------------Data import and export-----------------------#
#-------------------------------------------------------------------#
# The following code is taken from the third chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2018/_book/data-handling.html#data-import-and-export


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("rvest", "jsonlite", "readxl", "haven", "devtools", "curl")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
library(devtools)
devtools::install_github('PMassicotte/gtrendsR', force = TRUE)


#-------------------------------------------------------------------#
#-------------------Getting data for this course--------------------#
#-------------------------------------------------------------------#

library(openssl)
url <- "https://raw.githubusercontent.com/IMSMWU/mrda_data_pub/master/secret-music_data.rds"
download.file(url, "./data/secret_music_data.rds", method = "auto", quiet=FALSE)
encrypted_music_data <- readRDS("./data/secret_music_data.rds")
music_data <- unserialize(aes_cbc_decrypt(encrypted_music_data, key = key))


# If music_file is in your working directory, this would be the way to import it
## music_data <- read.table(music_file, header=TRUE)


#-------------------------------------------------------------------#
#----------Import data created by other software packages-----------#
#-------------------------------------------------------------------#

# Reading excel files can be done with the readxl package.
## ------------------------------------------------------------------------
#before you can read data, make sure that the file is located in your working directory
getwd() #tells you the current working directory
list.files() #lists all files in the current working directory
setwd("path/to/file") #may be used to change the working directory to the folder that contains the desired file

#import excel files
library(readxl) #load package to import Excel files
excel_sheets("music_data.xlsx")
music_data_excel <- read_excel("music_data.xlsx", sheet = "mrda_2016_survey") # "sheet = x"" specifies which sheet to import
head(music_data_excel)
 
#import SPSS files
library(haven) #load package to import SPSS files
music_data_spss <- read_sav("music_data.sav")
head(music_data_spss)


#-------------------------------------------------------------------#
#----------------------------Export data----------------------------#
#-------------------------------------------------------------------#

# Writing data to the working directory is often as easy as exchanging "read" with "write".
## ------------------------------------------------------------------------
## write.table(music_data, "musicData.dat", row.names = FALSE, sep = "\t") #writes to a tab-delimited text file
## write.table(music_data, "musicData.csv", row.names = FALSE, sep = ",") #writes to a comma-separated value file
## write_sav(music_data, "my_file.sav") #writes to a SPSS file


#-------------------------------------------------------------------#
#---------------------Import data from websites---------------------#
#-------------------------------------------------------------------#

# Web scraping can be used to quickly access online data
# Here we scrape population data from Wikipedia
## ------------------------------------------------------------------------
library(rvest)  #load package to import html files
url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
# read html content
population <- read_html(url)
# find the table
population <- html_nodes(population, "table")
# check structure
print(population)
# get the second element of the of the list and read the html table
population <- population[[2]] %>% html_table(fill = TRUE)
# check if we scraped the desired data
head(population) 
# check class of population variable
class(population$Population) 
# convert to numeric
population$Population <- as.numeric(gsub(",", "", population$Population)) #convert to numeric
# check data
head(population) 
# check if class of population variable is now numeric
class(population$Population) 


#-------------------------------------------------------------------#
#-----------------------Import data via APIs------------------------#
#-------------------------------------------------------------------#

# Many websites have APIs, with which you can directly access data
# Here population data from the World Bank is downloaded by the jsonlite package
## ------------------------------------------------------------------------
library(jsonlite)  #load package to import json files
url <- "http://api.worldbank.org/countries/AT/indicators/SP.POP.TOTL/?date=1960:2016&format=json&per_page=100" #specifies url
ctrydata <- fromJSON(url) #parses the data 
str(ctrydata)
head(ctrydata[[2]][,c("value","date")]) #checks if we scraped the desired data
ctrydata


#-------------------------------------------------------------------#
#-------------Import web data via dedicated R packages--------------#
#-------------------------------------------------------------------#

# Many R packages exist that let you scrape data from websites
# Here Google Trends data for the term "data science" is obtained using the "gtrendsR" package
library(gtrendsR) #load package to import google trends data
google_trends <- gtrends("data science", geo = c("US"), 
                         gprop = c("web"), time = "2017-09-01 2017-10-06")

ls(google_trends) # list all elements of the returned list
# check data
head(google_trends$interest_over_time)
