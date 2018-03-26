library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(sliderInput("size", 
                             "Number of trials", 
                             min = 1,
                             max = 100,
                             value = 10),
                 sliderInput("prob", 
                             "Probability of success of one trial", 
                             min = 0, 
                             max = 1,
                             value = 0.5)
    ),
    mainPanel(
      plotOutput("distplot", height = "200"),
      plotOutput("CDFplot", height = "200")
    )
    
  )
  
)


server <- function(input, output) {
  
  distplot <- reactive({
    
    data <- data.frame(X = 0:input$size, Mass = dbinom(0:input$size, input$size, input$prob))
    ylim <- ifelse(max(data$Mass) > 0.4, 1, 0.4)
    
    ggplot(data = data, aes(x = X, y = Mass)) + 
      geom_point(color = "firebrick") +
      theme_bw() +
      lims(x = c(0,100), y = c(0,ylim))}) 
  
  CDFplot <- reactive({
    y <- rbinom(1e5, input$size, input$prob)
    par(mar = c(4, 4, 0, 0.4))
    plot(NULL, xlim = c(0, 100), ylim = c(0,1), 
         ylab = "Cumulative Probability", xlab = "# of succeses", xaxt = "n")
    axis(1, at = 0:input$size)
    grid(NULL, NULL, lwd = 1, lty = 'solid', col = "gray93", equilogs = FALSE)
    lines(ecdf(y))
  })
  
  output$distplot <- renderPlot({distplot()})
  output$CDFplot <- renderPlot({CDFplot()})
}

# Run the application 
shinyApp(ui = ui, server = server)

