
library(tibble)
# Load in qualtRics package
library(qualtRics)
library(janitor)
library(sjlabelled)
library(kableExtra)

green_consumption <- read_survey("data/Green_Consumption.csv")
head(green_consumption)


str(green_consumption$Q8)




library(sjlabelled)
questions_green_consumption <- get_label(green_consumption)
questions_green_consumption["Q8"]



green_consumption$Q8 <- factor(green_consumption$Q8,
                               levels = 1:4, 
                               labels = c("0", "1-2", "3-4", ">4"))
head(green_consumption$Q8)



carsharing <- read_survey("data/Car_sharing.csv")
questions_carsharing <- get_label(carsharing)
questions_carsharing["Q6_1"]
questions_carsharing["Q6_2"]
questions_carsharing["Q6_3"]



head(carsharing$Q6_1)
carsharing[, startsWith(names(carsharing), "Q6")]  <- replace(carsharing[, startsWith(names(carsharing), "Q6")], 
                                                              is.na(carsharing[, startsWith(names(carsharing), "Q6")]), 0)
carsharing[, startsWith(names(carsharing), "Q6")]



share_go_shopping <- mean(carsharing$Q6_2)
share_go_shopping



questions_green_consumption["Q33"]
green_consumption$Q33[c(1,2,6,24,34,58,82,98,102,157,158)]



as.numeric(green_consumption$Q33[c(1,2)])



as.numeric(green_consumption$Q33[6])



library(stringr)
green_consumption$Q33 <- str_replace(green_consumption$Q33, ',', '.')
as.numeric(green_consumption$Q33[6])



bad_rows <- which(str_count(green_consumption$Q33, fixed('.')) > 1)
green_consumption$Q33[bad_rows]



green_consumption$Q33[bad_rows] <- str_remove(green_consumption$Q33[bad_rows], fixed('.'))
green_consumption$Q33[bad_rows]



values <- c("90.1", "12.345.000.23", "12.000.4")
bad_rows <- which(str_count(values, fixed('.')) > 1)
while(length(bad_rows) > 0){
  values[bad_rows] <-  str_remove(values[bad_rows], fixed('.'))
  bad_rows <- which(str_count(values, fixed('.')) > 1)
}
values



green_consumption$Q33 <- str_remove_all(green_consumption$Q33, regex('€|euro|eur|-', ignore_case = TRUE))
green_consumption$Q33[c(1,2,6,24,34,58,82,98,102,157,158)]



dollar_rows <- grepl("\\$|usd", green_consumption$Q33, ignore.case = TRUE)
dollar_values <- green_consumption$Q33[dollar_rows]
dollar_values



exchange_rate <- 0.9
dollar_values <- str_remove_all(dollar_values, regex("\\$|usd", ignore_case = TRUE))
green_consumption$Q33[dollar_rows] <- as.numeric(dollar_values) * exchange_rate
green_consumption$Q33[dollar_rows]



green_consumption$Q33[c(1,2,6,24,34,58,82,98,102,157,158)]



as.numeric(green_consumption$Q33[c(1,2,6,24,34,58,82,98,102,157,158)])



green_consumption$Q33 <- as.numeric(green_consumption$Q33)
str(green_consumption$Q33)



library(tidyr)
topic_selection <- read_survey("data/topic_selection.csv")
topic_selection <- pivot_longer(topic_selection, cols = starts_with("Q1"), values_to = "rank")
topic_selection



topic_selection <- topic_selection[endsWith(topic_selection$name, "RANK") & !is.na(topic_selection$rank), ]
topic_selection$topic <- as.factor(as.numeric(str_extract(topic_selection$name, "[0-9]+(?=_RANK)")))
topic_selection



rank_counts <- data.frame(table(topic_selection$rank, topic_selection$topic))
colnames(rank_counts) <- c("rank", "topic", "count")
rank_counts$rank <- factor(rank_counts$rank, 
                           levels = unique(rank_counts$rank)[order(unique(rank_counts$rank), decreasing = TRUE)])
rank_counts



q6_columns <- names(carsharing)[startsWith(names(carsharing), "Q6")]
q6_labels <- questions_carsharing[q6_columns]
q6_answers <- str_extract(q6_labels, "(?<=- ).*")
q6_answers
q6_question <- str_extract(questions_carsharing["Q6_1"], ".*(?= -)")
q6_question



library(colorspace)
blues <- hcl_palettes("Sequential s", palette = "Blues 2")
swatchplot(
  "Hue changed" = sequential_hcl(5, h = c(0, blues$h1), c = c(blues$c1, blues$c1), l = blues$l1), 
  "Chroma changed" = sequential_hcl(5, h = blues$h1, c = c(blues$c1,0), l = blues$l1, rev = TRUE), 
  "Luminance changed" = sequential_hcl(5, h = blues$h1, c = c(blues$c1,blues$c1), l = c(blues$l1, blues$l2),
                                       rev = TRUE, power = 1.5, fixup = TRUE)
  )



library(ggplot2)
library(colorspace)
q6_counts <- colSums(carsharing[,q6_columns])
q6_data <- data.frame(count = q6_counts, reason = q6_answers)
q6_data$reason <- factor(q6_data$reason, levels = q6_data$reason[order(q6_data$count)])
ggplot(q6_data[order(q6_data$count, decreasing = TRUE),], aes(x = count, y = reason, fill = count)) + 
  geom_bar(stat="identity", show.legend = FALSE) + 
  geom_text(aes(label = count), hjust = -.2) +
  ylab("") + 
  theme_bw() +
  theme(panel.grid.major.y = element_blank()) +
  scale_fill_continuous_sequential(palette = "Blues 2")



swatchplot(hcl.colors(nrow(q6_data), palette = "Blues 2"), cvd = TRUE)



q6_data$share <- q6_data$count / nrow(carsharing)
ggplot(q6_data[order(q6_data$share, decreasing = TRUE),], aes(x = share, y = reason, fill = share)) + 
  geom_bar(stat="identity", show.legend = FALSE) + 
  geom_text(aes(label = round(share, digits =2)), hjust = -.1) +
  ylab("") + 
  theme_bw() +
  theme(panel.grid.major.y = element_blank()) +
  scale_fill_continuous_sequential(palette = "Blues 2") +
  expand_limits(x = 0.4)



ggplot(topic_selection, aes(x = topic, y = rank, group = topic)) +
  geom_boxplot() +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor.x = element_blank()) +
  scale_y_reverse()




ggplot(rank_counts, aes(x=topic, y=count, fill=rank)) + 
  geom_bar(stat="identity") +
  theme_bw() +
  scale_y_continuous(breaks = 0:10) +
  theme(panel.grid.minor.y = element_blank(), 
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color="black")) +
  scale_fill_discrete_sequential("Inferno", alpha = 0.8) 



questions_green_consumption["Q34_1...19"]
questions_green_consumption["Q34_2"]
questions_green_consumption["Q34_3"]



shareofwallet_names <- names(green_consumption)[startsWith(names(green_consumption), "Q34")] 
shareofwallet_labels <- questions_green_consumption[shareofwallet_names[-length(shareofwallet_names)]]
shareofwallet_answers <- str_extract(shareofwallet_labels, "(?<=- ).*")
shareofwallet_answers
shareofwallet_data <- green_consumption[, shareofwallet_names[-length(shareofwallet_names)]]
shareofwallet_text <- shareofwallet_data$Q34_5_TEXT
c(na.omit(shareofwallet_text))
shareofwallet_data <- na.omit(subset(shareofwallet_data, select = -Q34_5_TEXT))
colnames(shareofwallet_data) <- shareofwallet_answers[-length(shareofwallet_answers)]
shareofwallet_data



library(ggcorrplot)
colors <- hcl.colors(3, palette = "Blue-Yellow")
ggcorrplot(cor(shareofwallet_data), lab = TRUE, colors = colors)



shareofwallet_data <- pivot_longer(shareofwallet_data, cols = everything(), names_to = "type", values_to = "points")
shareofwallet_data$type <- str_remove(shareofwallet_data$type, ":")
shareofwallet_data



shareofwallet_median <- sort(c(by(shareofwallet_data$points, shareofwallet_data$type, median)), decreasing = TRUE)
shareofwallet_data$type <- factor(shareofwallet_data$type, levels = names(shareofwallet_median))
ggplot(shareofwallet_data, aes(y = points, x=type)) +
  geom_boxplot() +
  theme_bw() +
  theme(panel.grid.major.x = element_blank())



library(wordcloud)
shareofwallet_counts <- c(by(na.omit(shareofwallet_text), na.omit(shareofwallet_text), length))
wordcloud(names(shareofwallet_counts), shareofwallet_counts)



green_consumption$gender <- factor(green_consumption$Q29, levels = c(1,2), labels = c("F", "M"))
gender_sow <- green_consumption[,c(shareofwallet_names[1:4], "gender")]
names(gender_sow)[1:4] <- shareofwallet_answers[1:4]
gender_sow



gender_sow <- pivot_longer(gender_sow, cols = !last_col(), names_to = "type", values_to = "points")
gender_sow <- gender_sow[!is.na(gender_sow$gender), ]
ggplot(gender_sow, aes(x = gender, y = points, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(panel.grid.major.x = element_blank()) +
  facet_wrap(~type, scales = "free_y") +
  xlab("") +
  scale_fill_discrete_qualitative(palette = "Dynamic") 



library(ggiraphExtra)
carsharing$gender <- factor(carsharing$Q26, levels = c(1,2), labels = c("F", "M"))
car_gender <- carsharing[,c(q6_columns, "gender")]
car_gender_mean <- aggregate(. ~ gender, data = car_gender, mean)
names(car_gender_mean) <- c("gender", q6_answers)
ggRadar(car_gender_mean, aes(color = gender) ) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = c(-30,-50,-90,0,0,0,90,45,10))) +
  scale_color_discrete_qualitative(palette = "Dynamic") 



ggPair(car_gender_mean, horizontal = TRUE, aes(color = gender)) +
  ggtitle("Average response across genders") +
  theme_bw() +
  scale_color_discrete_qualitative(palette = "Dynamic") 



library(HH)
carsharing_benefits <- carsharing[, startsWith(names(carsharing), "Q13_")]
carsharing_benefits
benefit_labels <- questions_carsharing[ startsWith(names(carsharing), "Q13_")]
names(carsharing_benefits) <- str_extract(benefit_labels, "(?<=- ).*")
carsharing_benefits <- pivot_longer(carsharing_benefits, cols = everything())
carsharing_benefits
carsharing_benefits$value <- factor(carsharing_benefits$value, 
                                    levels = 1:7, 
                                    labels = c(
                                      "strongly disagree",
                                      "disagree",
                                      "somewhat disagree",
                                      "neutral",
                                      "somewhat agree",
                                      "agree", 
                                      "strongly agree"))
likert(table(carsharing_benefits), 
       main = "", ylab = "", xlab = "number of respondents", 
       col = hcl.colors(7, palette = "Blue-Red 2", rev = TRUE),
       auto.key = list(columns = 2, title= ""),     
       panel=function(...){
               panel.abline(v=seq(-100,50,by=50),col="lightgrey")
               panel.likert(...)
             }
       )



shareofwallet_median <- sort(c(by(shareofwallet_data$points, 
                                  shareofwallet_data$type, median)), 
                             decreasing = TRUE)
shareofwallet_data$type <- factor(shareofwallet_data$type, levels = names(shareofwallet_median))
ggplot(shareofwallet_data, aes(y = points, x=type)) +
  geom_boxplot() +
  theme_bw() +
  theme(panel.grid.major.x = element_blank())



library(forcats)
ggplot(shareofwallet_data, aes(y = points, x=fct_reorder(type, points, var))) +
  geom_boxplot() +
  xlab("type") +
  theme_bw() +
  theme(panel.grid.major.x = element_blank())



topic_selection$rank <- factor(topic_selection$rank, levels = 5:1)
ggplot(topic_selection, aes(x=fct_infreq(topic), fill=rank)) + 
  geom_bar(stat = "count") +
  theme_bw() +
  xlab("topic") +
  scale_y_continuous(breaks = 0:10) +
  theme(panel.grid.minor.y = element_blank(), 
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color="black")) +
  scale_fill_discrete_sequential("Inferno", alpha = 0.8) 



str(carsharing_benefits$value)

carsharing_benefits$value_collapsed <- fct_collapse(carsharing_benefits$value,
             disagree = c("strongly disagree", "disagree"),
             neutral = c("somewhat disagree", "neutral", "somewhat agree"),
             agree = c("agree", "strongly agree"))
carsharing_benefits[, c("value", "value_collapsed")]



library(dplyr)
country_questions <-  c("Q28_1", "Q28_2", "Q28_3_TEXT")
questions_green_consumption[country_questions]
green_consumption[,country_questions]
green_consumption$country <- as.factor(case_when(
  green_consumption$Q28_1 == 1 ~ "Austria",
  green_consumption$Q28_2 == 1 ~ "Germany",
  TRUE ~ green_consumption$Q28_3_TEXT
))
str(green_consumption$country)



fct_count(green_consumption$country)



green_consumption$country_other <- fct_other(green_consumption$country, 
                                             keep = c("Austria", "Germany"))
green_consumption[, c("country", "country_other")]



green_consumption$country <- tolower(green_consumption$country)
unique(green_consumption$country)



green_consumption$country <- fct_collapse(green_consumption$country,
                                          usa = c("usa", "united states"),
                                          vietnam = c("viet nam", "vietnam", "hanoi"))
unique(green_consumption$country)



green_consumption$country <- str_to_title(green_consumption$country)
green_consumption$country <- fct_recode(green_consumption$country, USA = "Usa")
unique(green_consumption$country)

