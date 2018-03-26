library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(sliderInput("df", 
                             "Degrees of freedom", 
                             min = 1,
                             max = 20,
                             value = 2, 
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
    
    X <- seq(from = -20, to = 20, length.out = 1000)
    data <- data.frame(X = X, Density = dt(X, df = input$df))
    
    ggplot(data = data, aes(x = X, y = Density)) + 
      geom_line(color = "firebrick") + 
      theme_bw() + 
      labs(x = "X", y = "Density") + 
      ylim(c(0, 0.42))
  })
  
  output$CDFplot <- renderPlot({
    
    X <- seq(from = -20, to = 20, length.out = 1000)
    data <- data.frame(X = X, Prob = pt(X, df = input$df))
    
    ggplot(data = data, aes(x = X, y = Prob)) + 
      geom_line(color = "firebrick") + 
      theme_bw() +  
      labs(x = "X", y = "Cumulative Probability")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

