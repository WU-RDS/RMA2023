## Extract all R code files
knitr::purl("01-getting_started.Rmd", output="./Code/00-functions_packages.R")
knitr::purl("02-basic_data_handling.Rmd", output="./Code/01-basic_data_handling.R")
knitr::purl("03-data_import.Rmd", output="./Code/02-data_import.R")
knitr::purl("04-basic_statistics.Rmd", output="./Code/03-basic_statistics.R")
knitr::purl("05-visualization.Rmd", output="./Code/04-visualization.R")
knitr::purl("06-statistical_inference.Rmd", output="./Code/05-statistical_inference.R")
knitr::purl("07-hypothesis_testing.Rmd", output="./Code/06-hypothesis_testing.R")
knitr::purl("08-Anova.Rmd", output="./Code/07-anova.R")
knitr::purl("09-non_parametric_tests.Rmd", output="./Code/08-non_parametric.R")
## Files 10-Regression.Rmd and 11-Logistic_Regression.Rmd are one chapter
## Here the two files are extracted and merged into a single download
## with the separator specified in logistic_start_str
knitr::purl("10-Regression.Rmd", output="./Code/tmp_10-regression.R")
knitr::purl("11-Logistic_Regression.Rmd", output="./Code/tmp_11-logistic_regression.R")
reg_10 <- readr::read_file("./Code/tmp_10-regression.R")
logistic_reg_11 <- readr::read_file("./Code/tmp_11-logistic_regression.R")
logistic_start_str <- "
  #########################
  ## Logistic Regression ##
  #########################
"
all_reg <- paste(reg_10, logistic_start_str, logistic_reg_11, sep = '\n')
#### TODO: NOT YET IN PRODUCTION: CHANGE FILE NAME
readr::write_file(all_reg, "./Code/test_10-regression.R")
###
knitr::purl("12-factor_analysis.Rmd", output="./Code/11-pca.R")
knitr::purl("13-cluster_analysis.Rmd", output="./Code/12-cluster.R")

## Finally move code files into book folder
file.copy("Code", "_book/", recursive = TRUE)






