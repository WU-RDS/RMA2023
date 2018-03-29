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
   withMathJax(),
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("area",
                     "Interval",
                     min = 1,
                     max = 11,
                     value = c(4, 6),
                     step = 0.1),
         p(textOutput("dens")),
         uiOutput("pdfInteg"),
         withMathJax(helpText("$$\\mathbb{E}[X] = \\int_1^{11} x * \\frac{1}{11-1} dx =  \\frac{11+1}{2} = 6$$")),
         withMathJax(helpText("$$Var(X) = \\mathbb{E}[(X-\\mathbb{E}[X])^2] = \\mathbb{E}\\left[\\left(x- 6 \\right)^2\\right]$$")),
         withMathJax(helpText("$$ = \\int_1^{11} \\left(x-6\\right)^2 * \\frac{1}{11-1} dx = \\frac{(11-1)^2}{12} = 8.\\overline{33}$$"))
         ),
      # Show a plot of the generated distribution
   mainPanel(
         plotOutput("distPlot")
      )
   ))


# Define server logic required to draw a histogram
server <- function(input, output) {

  output$pdfInteg <- renderUI({  
    curDens <- round((input$area[2] - input$area[1]) * 0.1, 2)
    lower <- input$area[1]
    upper <- input$area[2]
    string <- paste0("$$\\int_{",lower,"}^{",upper,"}\\frac{1}{11-1}dx=", curDens,"$$")
    withMathJax(helpText(string))
  }) 
  
  output$distPlot <- renderPlot({
   ggplot(data.frame(x = c(1, 11)), aes(x)) +
      geom_rect(aes(xmin = input$area[1], xmax = input$area[2], ymin = 0, ymax = 0.1), fill = alpha("lightblue", .3)) +
      stat_function(fun = dunif, args = list(min = 1, max = 11), geom = "line", color = "darkblue") +
      labs(x = "Value", y = "Probability density", title = "PDF of the Uniform distribution w/ a = 1, b = 11") +
      theme_bw() +
      scale_x_continuous(breaks = c(1:11))+
      lims(y = c(0, 0.15))
  })
  output$dens <- renderText({
      curDens <- round((input$area[2] - input$area[1]) * 0.1, 2)
    paste("Density of selected interval:", curDens)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

