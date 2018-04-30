data <-read.csv("./MRDA2018/MRD_A3_Survey.csv", stringsAsFactors = FALSE)

data <- data[-c(1,2),]

library(dplyr)
library(stringr)

bla <- data %>%
  filter(Progress == 100) %>%
  mutate_at(vars(starts_with("Q63")), as.numeric) 

%>%
  mutate_at(vars(starts_with("Q63")), str_remove_all, pattern = "€") %>%
  mutate_at(paste0("Q18_1_", 1:8), str_replace_all, pattern = ",", replacement = ".") %>%
  select(paste0("Q18_1_", 1:8))


price_cols <- paste0("Q18_1_", 1:8)
numeric_trans_cols <- c(paste0("Q63_", 1:8), price_cols)

data %>%
  filter(Progress == 100) %>%
  mutate_at(price_cols, str_remove_all, pattern = "[^0-9,\\.]") %>%
  mutate_at(price_cols, str_replace_all, pattern = ",", replacement = ".") %>%
  mutate_at(numeric_trans_cols, as.numeric) 

str_split()



