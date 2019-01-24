# Install packages
## ------------------------------------------------------------------------
req_packages <- c("ggplot2")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
options(scipen = 999) #deactivate scientific notation

#read in the data
## ------------------------------------------------------------------------
data <- read.csv2("https://raw.githubusercontent.com/IMSMWU/MRDA2018/master/data/test_survey.csv", sep = ",", fill = T, stringsAsFactors = F, header = T, quote = "\"")
#inspect data
## ------------------------------------------------------------------------
head(data)
tail(data)

#rename variables
## ------------------------------------------------------------------------
#get a list of the existing names
dput(names(data))
#rename variables
names(data) <- c("StartDate", "EndDate", "Status", "IPAddress", "Progress", 
  "Duration__in_seconds", "Finished", "RecordedDate", "ResponseId", 
  "RecipientLastName", "RecipientFirstName", "RecipientEmail", 
  "ExternalReference", "LocationLatitude", "LocationLongitude", 
  "DistributionChannel", "UserLanguage", 
  "q2_experience_yes_thesis", "q2_experience_yes_job", "q2_experience_other", "q2_experience_no", "q2_experience_other_text", 
  "q3_theory_hyp_test", "q3_theory_anova", "q3_theory_regression", "q3_theory_pca", 
  "q4_practice_hyp_test", "q4_practice_anova", "q4_practice_regression", "q4_practice_pca", 
  "q5_overall_knowledge_likert", 
  "q6_multi_item_1", "q6_multi_item_2", "q6_multi_item_3", "q6_multi_item_4", 
  "q15_overall_knowledge_100", 
  "q15_knowledge_spss", "q15_knowledge_r", "q15_knowledge_stata", "q15_knowledge_excel", "q15_knowledge_sas",
  "q6_software", "q6_text", 
  "q12_importance",
  "q14_gender",
  "q15_country",
  "q16_group",
  "q8_wtp")
#inspect if it worked correctly
## ------------------------------------------------------------------------
head(data)

#make sure variables have the correct type (e.g., numeric, factor, etc.)
## ------------------------------------------------------------------------
str(data)
#example: convert to numeric:
## ------------------------------------------------------------------------
data$LocationLatitude <- as.numeric(data$LocationLatitude)
data$LocationLongitude <- as.numeric(data$LocationLongitude)
#test if it worked
str(data)
#example: convert multiple variables in one step
#first, specifiy the numeric variables to convert:
names_convert <- c("Progress", "Duration__in_seconds")
#second, convert the variables to numeric variables
data[,names_convert] <- apply(data[,names_convert], 2, function(x) {as.numeric(x)})
#test if it worked
str(data)

#example: convert to date
## ------------------------------------------------------------------------
data$RecordedDate <- as.Date(data$RecordedDate)
#test if it worked
str(data)

#example: convert to factor
## ------------------------------------------------------------------------
data$q14_gender <- factor(data$q14_gender, levels = c(1:2), labels = c("female","male"))

#example: multiple choice questions
## ------------------------------------------------------------------------
#replacing missings with zero values
#1. specify for which variables the missings should be replaced 
variables <- c("q2_experience_yes_thesis","q2_experience_yes_job","q2_experience_other","q2_experience_no")
data[,variables][is.na(data[,variables])] <- 0

#compute percentages
perc_1 <- prop.table(table(data$q2_experience_yes_thesis))[2]*100
perc_2 <- prop.table(table(data$q2_experience_yes_job))[2]*100
perc_3 <- prop.table(table(data$q2_experience_other))[2]*100
perc_4 <- prop.table(table(data$q2_experience_no))[2]*100
#create data frame incl. percentages
percentage <- c(perc_1,perc_2,perc_3,perc_4)
response <- c("yes, thesis","yes, job","yes, other","no")
data_plot <- data.frame(response,percentage)
#plot percentages
library(ggplot2)
ggplot(data_plot,aes(x = reorder(response,percentage), y = percentage)) + 
  geom_col(fill="steelblue") + ylab("User Share") + theme_bw() + 
  geom_text(label = sprintf("%.0f%%", percentage), hjust=1.2, color="white", size = 7) +
  labs(title = "Marketing research experience",
       subtitle = "Question: \"Have you ever conducted a marketing research project?\"",
       caption = "N=XXX") +
  theme(panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),plot.margin = unit(c(1.5,1,1,1), "cm"),
        panel.grid.major.x = element_line(size = 0.5, colour = "grey"), panel.grid.minor.x = element_blank()) +
  xlab("") + coord_flip() + theme(text = element_text(size=20)) 
#save plot
ggsave("mr_exprerience.jpg",width = 13,height = 10)

#dealing with text inputs
#see e.g., here: 
#https://www.rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf
#http://uc-r.github.io/regex_syntax
## ------------------------------------------------------------------------
#inspect the input of the text field
unique(data$q8_wtp)
data$q8_wtp <- gsub(",", ".",data$q8_wtp) #replace comma with point
data$q8_wtp <- gsub(" ", "",data$q8_wtp) #delete white spaces
data$q8_wtp <- gsub("nichts", "0.00",data$q8_wtp) #replace specific words
data$q8_wtp <- gsub("vier", "4.00",data$q8_wtp) #replace specific words
data$q8_wtp <- gsub("drei", "3.00",data$q8_wtp) #replace specific words
data$q8_wtp <- gsub("zwei", "2.00",data$q8_wtp) #replace specific words
data$q8_wtp <- gsub("[^0-9\\.]", "", data$q8_wtp)  #delete everything not numeric or point
#data$q8_wtp <- gsub("^\\.", "", data$q8_wtp) #delete leading points
#data$q8_wtp <- gsub("\\.*$", "", data$q8_wtp) #delete trailing points (the * symbol means that any number of trailing points should be deleted)
#data$q8_wtp <- gsub("^\\.|\\.*$", "", data$q8_wtp) #combine the two previous steps in one line
data$q8_wtp <- as.numeric(data$q8_wtp)
data[,c("q8_wtp")][is.na(data[,c("q8_wtp")])] <- 0
hist(data$q8_wtp)

#creating subsets
## ------------------------------------------------------------------------
#example: wtp smaller than 10
data <- subset(data, q8_wtp < 10)
hist(data$q8_wtp)
#example: only finished surveys
data <- subset(data, as.numeric(data$Finished) != 0) 
#example: exclude previews
data <- subset(data, data$DistributionChannel != "preview") 
#example: only surveys with duration >60 sec.
data <- subset(data, data$Duration__in_seconds >= 60) 
