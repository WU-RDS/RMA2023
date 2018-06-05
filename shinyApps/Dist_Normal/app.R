library(shiny)
library(ggplot2)
library(xtable)
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
                             value = 3),
                 tableOutput("percentiles")
    ),
    mainPanel(
      plotOutput("distplot", height = "260"),
      p(),
      plotOutput("CDFplot", height = "260")
    ) 
  )
)


server <- function(input, output) {
  output$percentiles <- renderTable({
    pcts <- round(qnorm(p = c(0.05, 0.25, 0.5, 0.75, 0.95), mean = input$mean, sd = input$sd), digits = 3)
    pctnames <- c("5th", "25th", "50th", "75th", "95th")
    pcttab <- data.frame(pctnames, pcts)
    colnames(pcttab) <- c("Percentile", "Value")
    xtable(pcttab)
  }, caption = "Values of the selected Normal Distribution at different percentiles")
 
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

