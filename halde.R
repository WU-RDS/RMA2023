install.packages('Lahman')

::: {.lc_green}
:::
  
::: {.lc_green}
Learning check
:::
  
  x <- knitr::kable(head(mtcars), "html")
column_spec(x, 1:2, width = "20em", bold = TRUE, italic = TRUE)


system('cal 2020')


::: {.infobox_orange .hint data-latex="{hint}"}
One popular R package for predictive modeling using machine learning is the [XGBoost Package](https://xgboost.readthedocs.io/en/latest/R-package/xgboostPresentation.html). We will cover predictive models later, but feel free to check out this package already if you are interested.  
:::
  
  
library(COVID19)
gmr <- "https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv"
covid_data <- covid19(
  country = "US",
  level = 2,
  start = "2020-01-01",
  gmr = gmr
)
head(covid_data)