#-------------------------------------------------------------------#
#----------------------Data import and export-----------------------#
#-------------------------------------------------------------------#
# The following code is taken from the third chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2020/data-handling.html#data-import-and-export


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("rvest", "jsonlite", "readxl", "haven", "devtools", "curl", "qualtRics", "stringr", "COVID19")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
if(!"gtrendsR" %in% installed.packages()) {
  library(devtools)
  devtools::install_github('PMassicotte/gtrendsR', force = TRUE)
}
# Useful options setting that prevents R from using scientific notation on numeric values
options(scipen = 999, digits = 2)

#-------------------------------------------------------------------#
#-------------------Getting data for this course--------------------#
#-------------------------------------------------------------------#

# read.table can be used to read data from sites (as done here) or from local files
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/test_data.dat", 
                        sep = "\t", 
                        header = TRUE)
head(test_data)
# If test_file is in your working directory, this would be the way to import it
# test_data <- read.table(test_file, header=TRUE)


#-------------------------------------------------------------------#
#----------Import data created by other software packages-----------#
#-------------------------------------------------------------------#

# Reading excel files can be done with the readxl package.
## ------------------------------------------------------------------------
#before you can read data, make sure that the file is located in your working directory
getwd() #tells you the current working directory
list.files() #lists all files in the current working directory
#setwd("path/to/file") #may be used to change the working directory to the folder that contains the desired file

#import excel files
library(readxl) #load package to import Excel files
excel_sheets("test_data.xlsx")
test_data_excel <- read_excel("test_data.xlsx", sheet = "mrda_2016_survey") # "sheet = x"" specifies which sheet to import
head(test_data_excel)
 
#import SPSS files
library(haven) #load package to import SPSS files
test_data_spss <- read_sav("test_data.sav")
head(test_data_spss)

#import data from Qualtrics surveys
library(qualtRics)
qualtrics <- read_survey('qualtrics_survey.csv')
head(qualtrics)

#-------------------------------------------------------------------#
#----------------------------Export data----------------------------#
#-------------------------------------------------------------------#

# Writing data to the working directory is often as easy as exchanging "read" with "write".
## ------------------------------------------------------------------------
write.table(test_data, "testData.dat", row.names = FALSE, sep = "\t") #writes to a tab-delimited text file
write.table(test_data, "testData.csv", row.names = FALSE, sep = ",") #writes to a comma-separated value file
write_sav(test_data, "my_file.sav") #writes to a SPSS file


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
population <- population[[1]] %>% html_table(fill = TRUE)
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
# You can check out the API documentation here: https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-apidocumentation
## ------------------------------------------------------------------------
library(jsonlite)  #load package to import json files
url <- "http://api.worldbank.org/countries/AT/indicators/SP.POP.TOTL/?date=1960:2018&format=json&per_page=100" #specifies url
ctrydata <- fromJSON(url) #parses the data 
str(ctrydata)
head(ctrydata[[2]][,c("value","date")]) #checks if we scraped the desired data
ctrydata

#-------------------------------------------------------------------#
#-------------Import web data via dedicated R packages--------------#
#-------------------------------------------------------------------#

# Many R packages exist that let you scrape data from websites
# Here Google Trends data for the term "data science" is obtained using the "gtrendsR" package
# Check out the source page here: https://trends.google.com/trends/?geo=US
library(gtrendsR)
#specify search term, area, source and time frame
google_trends <- gtrends("data science", geo = c("US"), gprop = c("web"), time = "2012-09-01 2020-10-06")
#list contents of output
ls(google_trends)
#inspect trend over time data frame
head(google_trends$interest_over_time)
# plot data
plot(google_trends$interest_over_time[,c("date","hits")],type = "b")

# Obtain COVID19 data
library(COVID19)
covid_data <- covid19(country = "US", level = 2, start = "2020-01-01")
head(covid_data)
# plot data
plot(covid_data[covid_data$administrative_area_level_2=="New York",c("date","confirmed")],type = "l")
