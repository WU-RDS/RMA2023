## ----echo=FALSE, eval=FALSE------------------------------------------------------
## library(rvest)
## library(jsonlite)
## library(readxl)
## library(haven)
## library(devtools)
## #devtools::install_github('PMassicotte/gtrendsR',force=T)
## library(gtrendsR)


## ----echo=TRUE, message=FALSE, warning=FALSE-------------------------------------
readLines("https://short.wu.ac.at/ma22_musicdata", n = 3)
test_data <- read.csv("https://short.wu.ac.at/ma22_musicdata", 
                        sep = ";", 
                        header = TRUE)
head(test_data)


## ----echo=TRUE, message=FALSE, warning=FALSE-------------------------------------
test_data <- read.csv("data/music_data_fin.csv", header=TRUE, sep = ";")
head(test_data)


## ---- eval=FALSE-----------------------------------------------------------------
## 
## #import excel files
## library(readxl) #load package to import Excel files
## excel_sheets("test_data.xlsx")
## survey_data_xlsx <- read_excel("test_data.xlsx", sheet = "mrda_2016_survey") # "sheet=x"" specifies which sheet to import
## head(survey_data_xlsx)
## 
## library(haven) #load package to import SPSS files
## #import SPSS files
## survey_data_spss <- read_sav("test_data.sav")
## head(survey_data_spss)


## ----echo=TRUE, eval=TRUE, message=FALSE, warning=FALSE--------------------------
library(qualtRics)
qualtrics <- read_survey('qualtrics_survey.csv')
head(qualtrics)


## ----eval=FALSE------------------------------------------------------------------
## write.csv(music_data, "musicData.csv", row.names = FALSE) #writes to a comma-separated value file
## write_sav(music_data, "musicData.sav")


## ----message=FALSE, warning=FALSE------------------------------------------------
library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
population <- read_html(url) 
population <- html_nodes(population, "table.wikitable")
print(population)


## --------------------------------------------------------------------------------
population <- population[[1]] %>% html_table(fill = TRUE)
head(population) #checks if we scraped the desired data


## --------------------------------------------------------------------------------
class(population$Population)


## --------------------------------------------------------------------------------
library(stringr)
population$Population <- as.numeric(str_replace_all(population$Population, pattern = ",", replacement = "")) #convert to numeric
head(population) #checks if we scraped the desired data


## --------------------------------------------------------------------------------
class(population$Population)


## ----message=FALSE, warning=FALSE------------------------------------------------
library(jsonlite)
url <- "http://api.worldbank.org/v2/countries/AT/indicators/SP.POP.TOTL/?date=1960:2019&format=json&per_page=100" #specifies url
ctrydata <- fromJSON(url) #parses the data 
str(ctrydata)
head(ctrydata[[2]][,c("value","date")]) #checks if we scraped the desired data


## ----message=FALSE, warning=TRUE-------------------------------------------------
library(gtrendsR)
#specify search term, area, source and time frame
google_trends <- gtrends("data science", geo = c("US"), gprop = c("web"), time = "2012-09-01 2020-10-06")
#inspect trend over time data frame
head(google_trends$interest_over_time)


## ----message=FALSE, warning=TRUE-------------------------------------------------
# plot data
plot(google_trends$interest_over_time[,c("date","hits")],type = "b")


## ----message=FALSE, warning=FALSE------------------------------------------------
library(COVID19)
covid_data <- covid19(country = "US",level = 2,start = "2020-01-01")
head(covid_data)


## ----message=FALSE, warning=TRUE-------------------------------------------------
# plot data
plot(covid_data[covid_data$administrative_area_level_2=="New York",c("date","confirmed")],type = "l")


## ---- warning=FALSE, error=FALSE, message=FALSE, eval=F--------------------------
## student <- c('Max','Jonas','Saskia','Victoria')
## grade <- c(3,2,1,2)
## date <- as.Date(c('2020-10-06','2020-10-08','2020-10-09'))
## df <- data.frame(student,grade,date)


## ----echo=FALSE------------------------------------------------------------------
student <- c('Christian','Matthias','Max','Christina','Ines','Eddie','Janine','Victoria','Pia','Julia','Lena')
grade <- c(1,1,NA,3,2,1,2,3,1,2,3)
country <- c("AT","AT","AT","AT","DE","DE","DE","SK","US","CA",'AT')
df <- data.frame(student,grade,country)
df

