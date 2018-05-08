#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Find the distribution"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("mean",
                     "Mean:",
                     min = -50,
                     max = 50,
                     value = 0),
         sliderInput("var",
                     "Variance:",
                     min = 0,
                     max = 50, 
                     value = 1)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
     set.seed(1776)
      x <- data.frame(x = rnorm(500, 20, 5))
      ggplot(x, aes(x))+
        geom_density()+
        stat_function(fun = function(y){dnorm(y, mean = input$mean, sd = sqrt(input$var) )}, geom = "line")
      
      # draw the histogram with the specified number of bins

         })
}

# Run the application 
shinyApp(ui = ui, server = server)

