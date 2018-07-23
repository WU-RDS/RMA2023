#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rJava)
library(venneuler)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Probability Theory"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("a",
                     'A',
                     min = 0,
                     max = 10,
                     value = 5, 
                     step = 1),
         sliderInput("b",
                     'B',
                     min = 0,
                     max = 10,
                     value = 5, 
                     step = 1),
 sliderInput("ab",
                     'A&B',
                     min = 0,
                     max = 10,
                     value = 5, 
                     step = 1)
 
      ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("venndiag")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$venndiag <- renderPlot({
      # generate bins based on input$bins from ui.R
      dat <- c(rep('A', input$a), rep('B', input$b), rep('A&B', input$ab))
      plot(venneuler(dat))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

