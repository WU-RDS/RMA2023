# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(xtable)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Tossing Coins"),
   
   # Sidebar with a slider input for number of bins 
   fluidRow(
     column(width = 6, sliderInput("n_toss", label = "Number of Coins:",
                                   min = 1, max = 20,value = 3, step = 1)),
     column(width = 4, numericInput("p_head", min = 0, max = 1, step = 0.05, value = 0.5, label = "p(h)"))),
   
   strong('Result for current toss of coins:\n'),
   tableOutput("coin_tab"),
   
   fluidRow(
     column(width = 10,  textOutput("n_head"))),
   
   tableOutput('tosses'),
   
   fluidRow(
     column(width = 2, actionButton("retoss", label = "Toss Again!")),
     column(width = 1, actionButton("reset", label = "Reset"))),
   
   fluidRow(
     column(12, plotOutput("coin_cdf")),
     column(12, plotOutput("coin_pdf"))))


# Define server logic required to draw a histogram
server <- function(input, output) {
   
  coin_tab <- reactive({
    validate(
      need(input$p_head<=1 & input$p_head>=0, 'Select a probability between 0 and 1!')
    )
    input$retoss
    mat <- matrix(
      c(1:input$n_toss, 
        sample(c("h", "t"),size = input$n_toss, replace = TRUE,prob = c(input$p_head, 1-input$p_head))),
      byrow = TRUE,
      ncol  = input$n_toss)
    rownames(mat) <- c("Coin", "Result")
    mat})
  
  n_head <- reactive({
    n_head <- sum(coin_tab()=='h')
    n_head
  })
  
  values <- reactiveValues()
  values$df <- data.frame(heads = numeric(0))
  observeEvent(input$retoss, {
    newLine <- sum(coin_tab()=='h')
    if (nrow(values$df) == 0){
      values$df <- data.frame(newLine)
    }else{
      values$df <- cbind(values$df, newLine)}
    rownames(values$df) <- "Previous\ #\ of\ h:"
  })
  
  observeEvent(input$reset, {
    values$df <- data.frame(heads = numeric(0))
  })
  
  output$tosses <- renderTable({
    xtable(values$df, caption = "test", floating = T)
  }, colnames = F, rownames = T)
  output$n_head <- renderText(paste("In the current sample there are", n_head(), "heads."))
  output$coin_tab <- renderTable({coin_tab()}, colnames = FALSE, rownames = TRUE )
 
  library(ggplot2)
  
  coin_cdf_alt <- reactive({
    validate(
      need(input$p_head<=1 & input$p_head>=0, 'Select a probability between 0 and 1!')
    )
    y <- rbinom(1e5, input$n_toss, input$p_head)
    plot(NULL, xlim=c(0, input$n_toss+1), ylim = c(0,1), 
         ylab = "Cumulative Probability", xlab = "# of h",
         xaxt = "n",
         main=NULL,
         font.main = 1,
         las = 1)
    title("Cumulative Distribution function of the coin toss", adj = 0,
          line = 0.3, font = 1, family = "sans")
    axis(1, at = 0:input$n_toss)
    grid(NULL, NULL, lwd = 1, lty = 'solid', col = "gray93",
         equilogs = FALSE)
    lines(ecdf(y))
  })
  output$coin_cdf <- renderPlot({coin_cdf_alt()})
  
  coin_pdf <- reactive({
    validate(
      need(input$p_head<=1 & input$p_head>=0, 'Select a probability between 0 and 1!')
    )
    y <- dbinom(x = 0:input$n_toss,size =  input$n_toss, input$p_head)
    ggplot(data.frame(y, x =  seq(0,input$n_toss, length.out = length(y))), aes(x = x, y = y)) +
      geom_point() +
      labs(x = "# of h", y = "Probability Mass")+
      scale_x_continuous(breaks = 0:input$n_toss)+
      ggtitle("Probability Mass Function of the coin toss")+
      theme_bw() + 
      theme(plot.title = element_text(face = "bold"))+
      expand_limits(y=0)
     
  })
  output$coin_pdf <- renderPlot({coin_pdf()})
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
