required_libraries <- c(
  "tidyverse",
  "skimr",
  "ggstatsplot",
  "ggthemes",
  "ggExtra",
  "sur",
  "psych",
  "summarytools",
  "colorspace",
  "Rmisc"
)
installed_libraries <- installed.packages()
to_be_installed <- required_libraries[!required_libraries %in% installed_libraries]
lapply(to_be_installed, \(x) install.packages(x))