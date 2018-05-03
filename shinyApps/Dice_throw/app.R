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


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("DiceNum",
                  "Number of dice",
                  2,
                  10,
                  2),
      sliderInput("BatchSize",
                  "Batch Size", 
                  1, 
                  100,
                  1),
      fluidRow(
        p(" "),
        p(strong("Simulation Controls")),
        actionButton(inputId = "Start", label = "Start"),
        actionButton(inputId = "Stop", label = "Stop"),
        actionButton(inputId = "Reset", label = "Reset"),
        p(" "),
        p(strong("Simulation Speed")),
        actionButton(inputId = "Fast", label = "Fast"),
        actionButton(inputId = "Standard", label = "Standard"),
        actionButton(inputId = "Slow", label = "Slow"),
        p(" "),
        tableOutput("table")
      )
    ),
    mainPanel(
      plotOutput("SumHist", height = 500)
    )
  )
)

server <- function(input, output){
 
  values <- reactiveValues()
  values$data <- data.frame(Value = integer(), Draw = integer())
  values$timer <- reactiveTimer(1000)
  values$started <- FALSE

  observeEvent(input$Start, {values$started <- TRUE})
  observeEvent(input$Stop, {values$started <- FALSE})
  
  observeEvent(input$Fast, {values$timer <- reactiveTimer(100)})
  observeEvent(input$Standard, {values$timer <- reactiveTimer(1000)})
  observeEvent(input$Slow, {values$timer <- reactiveTimer(2000)})
  
  observeEvent(input$Reset, {
    values$data <- data.frame(Value = integer(), Draw = integer())
    values$started <- FALSE
  })
  
  observeEvent(input$DiceNum, {
    values$data <- data.frame(Value = integer(), Draw = integer())
    values$started <- FALSE
  })
  
  
  observeEvent(values$timer(),{
    if(values$started){
      if(nrow(values$data) == 0){
        values$data <- data.frame(Value = replicate(input$BatchSize, sum(sample(1:6, input$DiceNum, replace = TRUE))), Draw = 1:input$BatchSize)
      } else if (nrow(values$data) < 1000) {
        values$data <- rbind(values$data, data.frame(Value = replicate(input$BatchSize, sum(sample(1:6, input$DiceNum, replace = TRUE))), Draw = (nrow(values$data) + 1):(nrow(values$data) + input$BatchSize)))
      } 
      
      values$alt_data <- data.frame(table(factor(values$data$Value, levels = input$DiceNum:(input$DiceNum*6)))/sum(table(values$data$Value)))
      names(values$alt_data) <- c("Value", "Probability")
      values$alt_data$Value <- as.numeric(as.character(values$alt_data$Value))
    }
  })
  
  
  
  output$SumHist <- renderPlot({
    if (nrow(values$data) > 0){
      # ggplot(data = values$data, aes(x = Value)) + 
      #   geom_bar(color = "black", fill = "white") + 
      #   theme_bw() +
      #   scale_x_discrete("Sum of two dice", limits=seq(from = 2, to = 12))
      
      ggplot(data = values$alt_data, aes(x = Value, y = Probability)) + 
        geom_col(color = "black", fill = "white") + 
        theme_bw() +
        scale_x_discrete("Sum of all dice", limits = seq(from = input$DiceNum, to = input$DiceNum * 6)) + 
        ylim(c(0, ifelse(max(values$alt_data$Probability) > 0.3, 1, 0.3))) + 
        ylab("Sample Probability") 
    }
    
  })
  
  output$table <- renderTable({
    tail(values$data, n = 5)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

