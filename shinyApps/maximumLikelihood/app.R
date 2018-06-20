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
library(xtable)
# Define UI for application that draws a histogram
ui <- fluidPage(
   # Application title
   titlePanel("Find the distribution"),
   
   # If you adjust these starting values, be sure to adjust them for the initial storage value as well!
   sidebarLayout(
      sidebarPanel(
         sliderInput("mean",
                     "Mean:",
                     min = 0,
                     max = 50,
                     value = 10),
         sliderInput("var",
                     "Variance:",
                     min = 0,
                     max = 50, 
                     value = 10),
         tableOutput('loglik')
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         plotOutput("loglikPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # ADJUST THESE IN CASE OF CHANGE IN START VALUE
  mean.start <- 10
  var.start <- 10
  

  set.seed(1776) # Oh say can you see
  x <- data.frame(x = rnorm(1500, 20, 5))
  
  start_loglik <- sum(dnorm(x$x, mean = mean.start, sd = sqrt(var.start), log = TRUE))
  
   output$distPlot <- renderPlot({
      ggplot(x, aes(x))+
        geom_histogram(aes(y=..density..), bins = 50)+
        stat_function(fun = function(y){dnorm(y, mean = input$mean, sd = sqrt(input$var) )}, geom = "line", color = "red") + 
        theme_bw()
         })
   output$loglik <- renderTable({
     slik <- data.frame(`Log Likelihood` = sum(dnorm(x$x, mean = input$mean, sd = sqrt(input$var), log = TRUE)), 
                        `High Score` = ifelse(is.null(loglik.stor$max),
                                              start_loglik, loglik.stor$max$loglik))
    xtable(slik)
   }, colnames = TRUE, ignoreInit = TRUE)

   # Create reactive storage to store log likelihoods for plot
   loglik.stor <- reactiveValues()
   loglik.stor$stor <- data.frame(loglik = sum(dnorm(x$x, mean = mean.start, sd = sqrt(var.start), log = TRUE)), number = 1)
    
   observeEvent(input$mean, {
    loglik.stor$stor <- rbind(loglik.stor$stor, c(sum(dnorm(x$x, mean = input$mean, sd = sqrt(input$var), log = TRUE)), (nrow(loglik.stor$stor) + 1)))
    loglik.stor$max <- loglik.stor$stor[which.max(loglik.stor$stor$loglik),]
   }, ignoreInit = TRUE)
   
   observeEvent(input$var, {
     loglik.stor$stor <- rbind(loglik.stor$stor, c(sum(dnorm(x$x, mean = input$mean, sd = sqrt(input$var), log = TRUE)), (nrow(loglik.stor$stor) + 1)))
     loglik.stor$max <- loglik.stor$stor[which.max(loglik.stor$stor$loglik),]
   }, ignoreInit = TRUE)
   
   output$loglikPlot <- renderPlot({
     current.obs.number <- loglik.stor$stor[nrow(loglik.stor$stor), "number"]
     suppressWarnings(ggplot(data = loglik.stor$stor, aes(x = number, y = loglik)) + 
       geom_point(na.rm = TRUE) +
       geom_line(na.rm = TRUE) +
       geom_hline(data = loglik.stor$max, mapping = aes(yintercept = loglik)) + 
       scale_x_continuous(limits = if(nrow(loglik.stor$stor) < 11){c(1,10)} else {c(current.obs.number -10 , current.obs.number)}) +
       theme_bw() +
       theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) + 
       xlab(label = ""))
 
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

