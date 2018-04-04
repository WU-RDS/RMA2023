data <-readr::read_csv("./MRD_A3_Survey.csv")

data <- data[-c(1,2),]

library(dplyr)
library(stringr)

bla <- data %>%
  filter(Progress == 100) %>%
  mutate_at(paste0("Q63_", 1:8), as.numeric) %>%
  mutate_at(paste0("Q18_1_", 1:8), str_remove_all, pattern = "€") %>%
  mutate_at(paste0("Q18_1_", 1:8), str_replace_all, pattern = ",", replacement = ".") %>%
  select(paste0("Q18_1_", 1:8))


data %>%
  filter(Progress == 100) %>%
  mutate_at(paste0("Q63_", 1:8), as.numeric) %>%
  mutate_at(paste0("Q18_1_", 1:8), str_remove_all, pattern = "[^0-9,\\.]") %>%
  mutate_at(paste0("Q18_1_", 1:8), str_replace_all, pattern = ",", replacement = ".") %>%
  mutate_at(paste0("Q18_1_", 1:8), as.numeric) %>%
  select(paste0("Q18_1_", 1:8)) %>%
  View()


apply(is.na(bla) == is.na(bla2), 2, function(x) (which(x == FALSE)))
