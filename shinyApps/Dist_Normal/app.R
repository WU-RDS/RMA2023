library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(sliderInput("mean", 
                             "Mean", 
                             min = -20,
                             max = 20,
                             value = 0),
                 sliderInput("sd", 
                             "Standard deviation", 
                             min = 1, 
                             max = 10,
                             value = 3)
    ),
    mainPanel(
      plotOutput("distplot", height = "200"),
      plotOutput("CDFplot", height = "200")
    )
    
  )
)


server <- function(input, output) {
  
  output$distplot <- renderPlot({
    
    X <- seq(from = -40, to = 40, length.out = 1000)
    data <- data.frame(X = X, Density = dnorm(X, input$mean, input$sd)) 
    
    ggplot(data = data, aes(x = X, y = Density)) + 
      geom_line(color = "firebrick") + 
      theme_bw() +
      lims(x = c(-40,40), y = c(0,0.5)) + 
      labs(x = "X", y = "Density")
  })
  
  output$CDFplot <- renderPlot({
    
    X <- seq(from = -40, to = 40, length.out = 1000)
    data <- data.frame(X = X, Prob = pnorm(X, input$mean, input$sd)) 
    
    ggplot(data = data, aes(x = X, y = Prob)) + 
      geom_line(color = "firebrick") + 
      theme_bw() +
      lims(x = c(-40,40), y = c(0,1)) + 
      labs(x = "X", y = "Cumulative Probability")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

