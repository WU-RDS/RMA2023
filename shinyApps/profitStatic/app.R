#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(ggplot2)
#library(xtable)
library(lubridate)
set.seed(132)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Weekly Profit Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        DT::dataTableOutput('sales_time')
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        verticalLayout(
          plotOutput('profit_cdf'),
          plotOutput('profit_pdf'))
      )
      )
   )


# Define server logic required to draw a histogram
server <- function(input, output) {
  today <- now(tzone = 'Europe/Vienna')
  dates <- today - weeks(1:350)
  weeks <- as.integer(week(dates))
  years <- as.integer(year(dates))
  mu_profits <- 500
  sd_profits <- 200
  profit <- round(rnorm(length(dates), mu_profits, sd_profits),2)
  out <- DT::datatable(cbind("Year" = years, "Week" = weeks, "Profit" = profit ))
  output$sales_time <- DT::renderDT({out})
  profit_df <- data.frame(cbind("Year" = years, "Week" = weeks, "Profit" = profit ))
  output$profit_pdf <- renderPlot({ggplot(profit_df, aes(x = profit))+
      geom_histogram(aes(y=..density..), bins = 20)+
      stat_function(fun = function(x){dnorm(x, mu_profits, sd_profits)}, color = 'firebrick')+
      theme_bw()+
      labs(x = "Profit", y='Density')
    }, width = 'auto')
  
  output$profit_cdf <- renderPlot({
    plot(ecdf(profit), xlab = "Profit", ylab = "Cumulative Probability", main = "Profit")
    plot(function(x)pnorm(x, mu_profits, sd_profits), 
         add = TRUE, from = (min(profit) - 100), 
         to = (max(profit)+100), col = 'firebrick')
  },width = 'auto')
}
 
# Run the application 
shinyApp(ui = ui, server = server)

