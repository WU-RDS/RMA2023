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
   titlePanel("Uniform Density"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("area",
                     "Interval",
                     min = -5,
                     max = 5,
                     value = c(-2, 2),
                     step = 0.1),
         p(textOutput("dens")),
         withMathJax(),
         uiOutput("pdfInteg")
         ),
      # Show a plot of the generated distribution
   mainPanel(
         plotOutput("distPlot")
      )
   ))


# Define server logic required to draw a histogram
server <- function(input, output) {
  output$pdfInteg <- renderUI({
    lower <- input$area[1]
    upper <- input$area[2]
    string <- paste0("$$\\int_",lower,"^",upper,"$$")
    withMathJax(helpText(string))
  }) 
  
  output$distPlot <- renderPlot({
   ggplot(data.frame(x = c(-5, 5)), aes(x)) +
      geom_rect(aes(xmin = input$area[1], xmax = input$area[2], ymin = 0, ymax = 0.1), fill = alpha("lightblue", .3)) +
      stat_function(fun = dunif, args = list(min = -5, max = 5), geom = "line", color = "darkblue") +
      labs(x = "Value", y = "Probability density", title = "PDF of the Uniform distribution w/ a = -5, b = 5") +
      theme_bw() +
      
      lims(y = c(0, 0.15))
  })
  output$dens <- renderText({
    curDens <- (input$area[2] - input$area[1]) * 0.1
    paste("Density of selected interval:", curDens)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

