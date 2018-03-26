library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(sliderInput("df", 
                             "Degrees of freedom", 
                             min = 2,
                             max = 30,
                             value = 4, 
                             step = 1)
    ),
    mainPanel(
      plotOutput("distplot", height = "200"),
      plotOutput("CDFplot", height = "200")
    )
    
  )
)


server <- function(input, output) {
  
  output$distplot <- renderPlot({
    
    X <- seq(from = 0, to = 55, length.out = 1000)
    data <- data.frame(X = X, Density = dchisq(X, df = input$df))
    
    ggplot(data = data, aes(x = X, y = Density)) + 
      geom_line(color = "firebrick") + 
      theme_bw() + 
      labs(x = "X", y = "Density") + 
      ylim(c(0,0.5))
  })
  
  output$CDFplot <- renderPlot({
    
    X <- seq(from = 0, to = 55, length.out = 1000)
    data <- data.frame(X = X, Prob = pchisq(X, df = input$df))
    
    ggplot(data = data, aes(x = X, y = Prob)) + 
      geom_line(color = "firebrick") + 
      theme_bw() +  
      labs(x = "X", y = "Cumulative Probability")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

